package com.coma.enemy
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.coma.items.*;
	import flash.geom.*;
	import com.coma.enemy.*;
	import com.coma.weapon.Lightning;
 
	public class Sentinal extends Bat
	{
		private var owner:Enemy;
		private var ownerArray:Array;
 
		public function Sentinal(stageRef:Stage, ourHero:Hero, levelInfoArray:Array, 
								 fromList:Boolean = false, owner:Enemy = null, ownerArray:Array = null) : void
		{
			super(stageRef, ourHero, levelInfoArray, false);
			this.owner = owner;
			this.ownerArray = ownerArray;
			angle = Math.atan2(target.y-y, target.x-x);
			v = 17;
			vy = v*Math.sin(angle);
			vx = v*Math.cos(angle);
		}
		
		protected override function targeting(): void {
			if (Math.sqrt(Math.pow(target.x-x, 2) + Math.pow(target.y-y,2)) < target.radius + radius - 10 ) {
				target.takeHit(contactDmg);
			}
			
			if (owner != null) {
				
				if (Math.sqrt(Math.pow(owner.x-x, 2) + Math.pow(owner.y-y,2)) < owner.radius + radius - 10 ) {
					angle = Math.atan2(target.y-y, target.x-x);
					vy = v*Math.sin(angle);
					vx = v*Math.cos(angle);
				}
			}
		}
		
		public override function reflect(vx:Number, vy:Number):void {
			if (owner != null) {
				angle = Math.atan2(owner.y-y, owner.x-x);
				this.vy = v*Math.sin(angle);
				this.vx = v*Math.cos(angle);
			}
			else {
				var hypot:Number = Math.sqrt(vx*vx+vy*vy);
				if (hypot != 0) {
					vx /= hypot;
					vy /= hypot;
				}
				this.vx += 2*Math.abs(this.vx)*vx;
				this.vy += 2*Math.abs(this.vy)*vy;
			}
		}
		
		public override function removeSelf() : void {
			removeEventListener(Event.ENTER_FRAME, loop);
 
 			if (owner != null) {
				for (var i:uint = 0; i < ownerArray.length; ++i) {
					if (ownerArray[i] == this) {
						ownerArray[i] = null;
						if (ownerArray[i+1] is Lightning) {
							ownerArray[i+1].removeSelf();
							ownerArray[i+1] = null;
						}
						break;
					}
				}
			}
			
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
			
			if (Engine.enemyList.indexOf(this) == -1) {
				return;
			}
			if (currentLabel == "destroyedComplete" || currentLabel == "destroyed") {
				if (fromList == true) {
					var someArray:Array = Engine.myLevels.level[Engine.currLevel][Engine.currRoom][0];
					for (i = 0; i < someArray.length; ++i) {
						if (someArray[i] == levelInfoArray)
							someArray.splice(i,1);
					}
				}
			}
			
 			Engine.enemyList.splice(Engine.enemyList.indexOf(this), 1);
		}
	}
 
}
