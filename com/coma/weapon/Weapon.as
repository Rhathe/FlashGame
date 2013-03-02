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
 
	public class Weapon extends MovieClip
	{
 
		protected var stageRef:Stage;
		protected var user:Object;
		protected var xdest:Number;
		protected var ydest:Number;
		public var damage = 5;
		protected var radian:Number;
 
		public function Weapon (stageRef:Stage, user:Object) : void {
			this.stageRef = stageRef;
			this.user = user;
			stageRef.addChild(this);
			
			if (this.user is Hero)
				addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			else
				addEventListener(Event.ENTER_FRAME, loop2, false, 0, true);
		}
 
		protected function loop(e:Event) : void
		{
			if (Engine.freezeEverything == true)
				return;
				
			reposition();
			checkForCollision();
		}
		
		protected function loop2(e:Event) : void {}
		
		protected function reposition():void {}
 
		public function removeSelf() : void
		{
			if (this.user is Hero)
				removeEventListener(Event.ENTER_FRAME, loop);
			else
				removeEventListener(Event.ENTER_FRAME, loop2);
 
			if (stageRef.contains(this))
					stageRef.removeChild(this);
		}
		
		protected function checkForCollision():void {}
		
		protected function distance(A:Object, B:Object):Number {
			return Math.sqrt(Math.pow(A.x-B.x, 2)+Math.pow(A.y-B.y,2));
		}
 
	}
 
}
