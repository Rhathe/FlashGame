package com.coma.collision {

	import flash.geom.*;
	import com.coma.basics.*;

	public class hitLine {
		
		public var pt1: 				Point;
		public var pt2: 				Point;
		public var center:				Object;
		public var radius_pt1:			Number;
		public var radius_pt2:			Number;
		public var angle_pt1:			Number;
		public var angle_pt2:			Number;
		
		public function hitLine(pt1:Point, pt2:Point, center:Object) : void {
			this.pt1 = pt1;
			this.pt2 = pt2;
			this.center = center;
			var centerPoint:Point = new Point(center.x,center.y);
			angle_pt1 = Math.atan2(pt1.y-center.y, pt1.x-center.x);
			angle_pt2 = Math.atan2(pt2.y-center.y, pt2.x-center.x);
			radius_pt1 = flash.geom.Point.distance(pt1,centerPoint);
			radius_pt2 = flash.geom.Point.distance(pt2,centerPoint);
			centerPoint = undefined;
		}
		
		public function intersectLines(other:hitLine):Array {
			var v1_x:Number = pt2.x - pt1.x;
			var v1_y:Number = pt2.y - pt1.y;
			var v2_x:Number = other.pt2.x - other.pt1.x;
			var v2_y:Number = other.pt2.y - other.pt1.y;

    		var s1:Number = (-v2_x * v1_y + v1_x * v2_y);
			var t1:Number = (-v2_x * v1_y + v1_x * v2_y);
			
			
			if (s1 != 0 && t1 != 0) {
    			var s:Number = (-v1_y * (pt1.x - other.pt1.x) + v1_x * (pt1.y - other.pt1.y)) / s1;
    			var t:Number = ( v2_x * (pt1.y - other.pt1.y) - v2_y * (pt1.x - other.pt1.x)) / t1;
			}
			else
				return null;
			
			var v3:Point = new Point(v1_x*t, v1_y*t);
			
			var myArray:Array = new Array();
			
			myArray[0] = pt1.add(v3);
			myArray[1] = s;
			myArray[2] = t;
			
			if (myArray[2] >= 0)
				myArray[5] = 1;
			else
				myArray[5] = -1;
			
			return myArray;
				
		}
		
		public function intersectSegments(other:Array):Array {
			var myArray:Array = other;
			
			if (myArray == null)
				return null;
			else if (myArray[1] >= 0 && myArray[1] <= 1) {
				if (myArray[2] >= 0 && myArray[2] <= 1) {
					return myArray;
				}
				else if (myArray[2] <= 0 && myArray[2] >= -1) {
					return myArray;
				}
				else {
					return null;
				}
			}
			else {
				return null;
			}
		}
		
		public function myHitTest(other:*):Array {
			var myArray:Array;
			
			if (other is hitLine) {
				myArray = intersectLines(other);
			
				myArray = intersectSegments(myArray);
				
				return myArray;
			}
			
			else if (other is Object) {
				myArray = intersectCircle(other, other.radius);
				return myArray;
			}
			
			return null;
		}
		
		public function pointToLine(someObject:Object, radius:Number):Array {
			var somePoint:Point = new Point(someObject.x,someObject.y);
			
			var v1:Point = new Point(pt1.y-pt2.y, pt2.x-pt1.x);
			v1.normalize(radius);
			var v2:Point = v1.add(somePoint);
			var other:hitLine = new hitLine(somePoint, v2, somePoint);
			//gives a 90 degree positive angle'd line
			
			
			var inter:Array = other.intersectLines(this);
			
			if (inter == null)
				return null;
			
			inter[3] = flash.geom.Point.distance(somePoint,inter[0]);
			v1.normalize(1);
			inter[4] = v1;
			
			v2 = undefined;
			other = undefined;
			return inter;
			
		}
		
		public function reflect(someObject:Object, radius:Number): void {
			var interNow:Array = pointToLine(someObject, radius);
			var someObjectFut:Point = new Point(someObject.x+someObject.vx,someObject.y+someObject.vy);
			var interFut:Array = pointToLine(someObjectFut,radius);
			var myCase:Number = 0;
			
			if (interNow == null || interFut == null)
				return;
				
			if (interNow[5]*interFut[5] < 0)
				myCase = 1;
			else if (interFut[3] < radius)
				myCase = 2;
			else
				return;
			
			
			interFut = intersectSegments(interFut);
			
			if (interFut == null)
				return;

			if (myCase == 1)
				var num:uint = Math.abs(radius + interFut[3]);
			else
				num = Math.abs(radius - interFut[3]);
		
			someObject.reflect(-interNow[5]*(num)*interNow[4].x, -interNow[5]*(num)*interNow[4].y);
			
			interNow = undefined;
			interFut = undefined;
		}
		
		public function translateLine(vx:Number, vy:Number): void {
			pt1.x += vx;
			pt1.y += vy;
			pt2.x += vx;
			pt2.y += vy;
		}
		
		public function moveLine():void {
			var temp1:Point = flash.geom.Point.polar(radius_pt1, center.rotation*Math.PI/180 + angle_pt1);
			var temp2:Point = flash.geom.Point.polar(radius_pt2, center.rotation*Math.PI/180 + angle_pt2);
			
			pt1.x = center.x + temp1.x;
			pt1.y = center.y + temp1.y;
			pt2.x = center.x + temp2.x;
			pt2.y = center.y + temp2.y;
		}
		
		public function intersectCircle(sc:Object, r:Number):Array {
			var sect:Array = new Array();
			var a:Number;
			var b:Number;
			var c:Number;
			var bb4ac:Number;
			var mu1:Number;
			var mu2:Number;
			var dp:Point;
			
			dp = pt2.subtract(pt1);
			
			a = dp.x * dp.x + dp.y * dp.y;
			b = 2 * (dp.x * (pt1.x - sc.x) + dp.y * (pt1.y - sc.y));
			c = sc.x * sc.x + sc.y * sc.y;
			c += pt1.x * pt1.x + pt1.y * pt1.y;
			c -= 2 * (sc.x * pt1.x + sc.y * pt1.y);
			c -= r * r;
			bb4ac = b * b - 4 * a * c;
			
			if( bb4ac < 0) {
				return null;
			}
			
			mu1 = (-b + Math.sqrt(bb4ac)) / (2 * a);
			mu2 = (-b - Math.sqrt(bb4ac)) / (2 * a);
			
			
			// no intersection
			if((mu1 < 0 || mu1 > 1) && (mu2 < 0 || mu2 > 1)) {
				return null;
			}

			// one point on mu1
			else if(mu1 > 0 && mu1 < 1 && (mu2 < 0 || mu2 > 1)) {
				sect[0] = new Point(pt1.x + ((pt2.x - pt1.x) * mu1), pt1.y + ((pt2.y - pt1.y) * mu1));
				sect[1] = sect[0];
			}
			// one point on mu2
			else if(mu2 > 0 && mu2 < 1 && (mu1 < 0 || mu1 > 1)) {
				sect[0] = new Point(pt1.x + ((pt2.x - pt1.x) * mu2), pt1.y + ((pt2.y - pt1.y) * mu2));
				sect[1] = sect[0];
			}
			//  one or two points
			else if(mu1 > 0 && mu1 < 1 && mu2 > 0 && mu2 < 1) {
				//  tangential
				if(mu1 == mu2) {
					sect[0] = new Point(pt1.x + ((pt2.x - pt1.x) * mu1), pt1.y + ((pt2.y - pt1.y) * mu1));
					sect[1] = sect[0];
				}
				// two points
				else {
					sect[0] = new Point(pt1.x + ((pt2.x - pt1.x) * mu1), pt1.y + ((pt2.y - pt1.y) * mu1));
					sect[1] = new Point(pt1.x + ((pt2.x - pt1.x) * mu2), pt1.y + ((pt2.y - pt1.y) * mu2));
				}
			}
			else {
				//  should NEVER get here
				return null;
			}
			
			
			return sect;
		}
		
		public function removeSelf() {
			
		}
		
		public function takeHit() {}
	}
 
}
