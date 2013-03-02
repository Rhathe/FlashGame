package com.coma.weapon
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.*;
	import com.coma.collision.hitLine;
	import com.coma.enemy.*;
	import flash.geom.Point;
	import com.coma.basics.*;
 
	public class Beam extends Weapon
	{
		protected var originaly:Number = height;
		public var hit:hitLine;
 
		public function Beam (stageRef:Stage, user:Object) : void
		{
			super(stageRef, user);
			stop();
			
			var p1 = new Point(x, y);
			var p2 = new Point(x, y-height);
			hit = new hitLine(p1,p2,this);
			
			damage = 5;
			
			reposition();
			checkForCollision();
		}
		
		protected override function reposition():void {
			x = user.x;
			y = user.y;
			xdest = stageRef.mouseX - x;
			ydest = stageRef.mouseY - y;
			radian = Math.atan2(ydest,xdest);
			
			rotation = radian*180/Math.PI + 90;
			
			scaleY = 2;
			hit.radius_pt2 = 2*originaly;
			hit.moveLine();
		}
		
		protected override function checkForCollision():void {
			var collisions:Array = Engine.structList;
			var wasAHit:int = -1;
			var hitObject:int = -1;
			var hitSide:int = -1;
			var collided:Array;
			var someInt:int = 0;
			
			while (someInt < 2) {
				for(var i:uint = 0; i < collisions.length; i++) {
					if (collisions[i].permeableState == 1 || collisions[i].permeableState == 2)
						continue;
						
					if (collisions[i].boxWallCircle == 0) {
						for (var j:uint = 0; j < collisions[i].hit.hitLineList.length; ++ j) {
							collided = hit.myHitTest(collisions[i].hit.hitLineList[j]);
							if(collided != null && collided[5] == 1) {
								stopSelf(hit.pt1, collided[0]);
								wasAHit = someInt;
								hitObject = i;
								hitSide = j;
							}
						}
					}
					else if (collisions[i].boxWallCircle == 1) {
						collided = hit.myHitTest(collisions[i].hit);
						if(collided != null && collided[5] == 1) {
							stopSelf(hit.pt1, collided[0]);
							wasAHit = someInt;
							hitObject = i;
						}
					}
					else {
						collided = hit.myHitTest(collisions[i]);
						if(collided != null) {
							stopSelf(hit.pt1, collided[findMinPoint(hit.pt1, collided[0], collided[1])]);
							wasAHit = someInt;
							hitObject = i;
						}
					}
				}
				
				collisions = Engine.enemyList;
				++someInt;
			}
			
			if (wasAHit == 0) {
				Engine.structList[hitObject].takeHit(damage, hitSide);
			}
			else if (wasAHit == 1) {
				Engine.enemyList[hitObject].takeHit(damage, hitSide);
			}
		}

		protected function stopSelf(A:Object, B:Object, filler:Number = 0):void {
			var dist:Number = distance(A,B);
			scaleY = dist/originaly;
			hit.radius_pt2 = dist;
			hit.moveLine();
		}
		
		protected function findMinPoint(origin:Point, check1:Point, check2:Point):Number {
			if (flash.geom.Point.distance(origin,check1) <= flash.geom.Point.distance(origin,check2))
				return 0;
			else
				return 1;
		}
 
	}
 
}
