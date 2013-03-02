package com.coma.structure
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.Engine;
	
	public class Round extends Structure
	{
		public var radius:Number = 0;
		public var inner:Boolean = false;
		
		public function Round(stageRef:Stage, radius:Number, x:Number = 0, y:Number = 0, inner:Boolean = false) : void
		{
			stop();
			this.radius = radius;
			super(stageRef, 2*radius, 2*radius, x, y);
			width = 2*radius;
			height = 2*radius;
			
			boxWallCircle = 2;
			this.inner = inner;
			
			canBeDestroyed = false;
		}
 
		public override function removeSelf() : void {
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
			
			if (Engine.structList.indexOf(this) == -1) {
				return;
			}
			
 			Engine.structList.splice(Engine.structList.indexOf(this), 1);
		}
		
		public override function takeHit(contactDmg:Number, hitSide:Number = 0):void {
		}
		
		public override function reflect(target:Object):void {
			var A:Number = radius + target.radius;
			var B:Number = distance(this, target);
			var C:Number = radius - target.radius;

			if (B < A && inner == false) {
				target.reflect((target.x - x)*(A-B)/A, (target.y - y)*(A-B)/A);
			}
			
			else if (B > C && inner == true) {
				target.reflect((target.x - x)*(C-B)/C, (target.y - y)*(C-B)/C);
			}
			
		}
		
		function checkForCollision():void
		{
		}
		
		protected function distance(A:Object, B:Object):Number {
			return Math.sqrt(Math.pow(A.x-B.x, 2)+Math.pow(A.y-B.y,2));
		}
 
	}
 
}
