package com.coma.collision {

	import flash.geom.*;
	import com.coma.collision.hitLine;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;

	public class hitBox extends MovieClip{

		public var collisionPoints:	Array;		
		public var hitLineList:		Array;
		
		private var center:			Object;
		
		public function hitBox(collisionPoints:*, object:Object, stageRef:Stage) : void {
			if (collisionPoints is Array) {
				this.collisionPoints = collisionPoints;
			}
			else if(collisionPoints is Object) {
				this.collisionPoints = new Array();
				this.collisionPoints[0] = new Point(collisionPoints.getBounds(stageRef).x, 
													collisionPoints.getBounds(stageRef).y);
				this.collisionPoints[1] = new Point(this.collisionPoints[0].x + collisionPoints.width, this.collisionPoints[0].y);
				this.collisionPoints[2] = new Point(this.collisionPoints[1].x, this.collisionPoints[1].y + collisionPoints.height);
				this.collisionPoints[3] = new Point(this.collisionPoints[0].x, this.collisionPoints[2].y);
			}
			
			center = object;
			hitLineList = new Array();
			var i:uint;
			for (i = 1; i < this.collisionPoints.length; ++i) {
				hitLineList[i-1] = new hitLine(this.collisionPoints[i-1], this.collisionPoints[i], center);
			}
			
			hitLineList[i-1] = new hitLine(this.collisionPoints[i-1], this.collisionPoints[0], center);
		}
		
		public function rotateBox():void {
			for (var i:uint = 0; i < hitLineList.length; ++i) {
				var temp:Point = flash.geom.Point.polar(hitLineList[i].radius_pt1, center.rotation*Math.PI/180 + hitLineList[i].angle_pt1);
			
				collisionPoints[i].x = center.x + temp.x;
				collisionPoints[i].y = center.y + temp.y;
			}
		}
		
		public function moveBox(vx:Number, vy:Number) {
			for (var i:uint = 0; i < collisionPoints.length; ++i) {
				collisionPoints[i].x += vx;
				collisionPoints[i].y += vy;
			}
		}
		
		public function reflect(target:Object):void {
			for (var i:uint = 0; i < hitLineList.length; ++i) {
				hitLineList[i].reflect(target, target.radius);
			}
		}
		
		public function removeSelf() {
			for (var i:uint = 0; i < collisionPoints.length; ++i) {
				collisionPoints[i] = undefined;
			}
			
			for (i = 0; i < hitLineList.length; ++i) {
				hitLineList[i].removeSelf();
				hitLineList[i] = undefined;
			}
			
			collisionPoints = undefined;
			hitLineList = undefined;
		}
	}
 
}