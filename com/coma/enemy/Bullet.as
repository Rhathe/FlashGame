package com.coma.enemy
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import com.coma.basics.*;
 
	public class Bullet extends MovieClip
	{
 
		private var stageRef:Stage;
		private var target:Hero;
 
		private var v:Number = 15;
		private var angle:Number;
		private var ovx:Number;
		private var ovy:Number;
		public var vx:Number;
		public var vy:Number;
		public var contactDmg:Number = 1;
		public var radius:Number;
 
		public function Bullet(stageRef:Stage, target:Hero, x:Number, y:Number, angle:Number, 
							   speed:Number = 15, radius:Number = 8) : void
		{
			this.stageRef = stageRef;
			this.target = target;
			this.x = x;
			this.y = y;
			this.radius = radius;
			width = 2*radius;
			height = 2*radius;
			
			v = speed;

			ovy = v*Math.sin(angle);
			ovx = v*Math.cos(angle);
			
			vy = ovy;
			vx = ovx;
 
 			Engine.bulletList.push(this);
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
 
		private function loop(e:Event) : void
		{
			if (Engine.freezeEverything == true)
				return;
 
 			vx = ovx;
			vy = ovy;
			
			if (y < -500 || y > stageRef.stageHeight + 500 || x < -500 || x > stageRef.stageWidth + 500)
				removeSelf();
				
			checkForCollision();
		}
		
		public function moveSelf():void {
			x += vx;
			y += vy;
		}
		
		public function takeHit(): void {
			//stageRef.addChild(new SmallImplosion(stageRef, x, y));
			removeSelf();
		}
 
		public function removeSelf() : void
		{
			removeEventListener(Event.ENTER_FRAME, loop);
			if (stageRef.contains(this))
				stageRef.removeChild(this);
			
			if (Engine.bulletList.indexOf(this) == -1) {
				return;
			}
			
			Engine.bulletList.splice(Engine.bulletList.indexOf(this), 1);
		}
		
		function checkForCollision():void {
			var collisions:Array = Engine.structList;
			var targetPoint:Point = new Point(1,1);
			var thisPoint:Point = new Point(x,y);
			var collided:Array;
	
			for(var i:uint = 0; i < collisions.length; i++) {
				if (collisions[i].boxWallCircle == 0) {
					for (var j:uint = 0; j < collisions[i].hit.hitLineList.length; ++ j) {
						collided = collisions[i].hit.hitLineList[j].myHitTest(this);
						if(collided != null) {
							takeHit();
							return;
						}
					}
				}
				else if (collisions[i].boxWallCircle == 1) {
					collided = collisions[i].hit.myHitTest(this);
					if(collided != null) {
						takeHit();
						return;
					}
				}
				else {
					targetPoint.x = collisions[i].x;
					targetPoint.y = collisions[i].y;
					if (flash.geom.Point.distance(thisPoint,targetPoint) <= radius + collisions[i].radius) {
						takeHit();
						return;
					}
				}
			}
			
			targetPoint.x = target.x;
			targetPoint.y = target.y;
			if (flash.geom.Point.distance(thisPoint,targetPoint) <= radius + target.radius) {
				target.takeHit();
				takeHit();
				return;
			}
		}
 
	}
 
}
