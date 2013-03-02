package com.coma.structure
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
	import com.coma.enemy.*;
	
	public class EnemyGenerator extends Round
	{
		private var ourHero:Hero;
		
		public function EnemyGenerator(stageRef:Stage, ourHero:Hero, radius:Number, 
									   x:Number = 0, y:Number = 0, inner:Boolean = false) : void
		{
			this.ourHero = ourHero;
			super(stageRef, radius, x, y);
			
			boxWallCircle = 2;
			this.inner = inner;
			health = 1000;
			
			canBeDestroyed = false;
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
 
 		protected function loop(e:Event) : void {
			if (Engine.freezeEverything == true)
				return;
			
			if (Math.random() > .95)
				new Bat(stageRef, ourHero, new Array(2, x, y), false);
		}
		
		public override function removeSelf() : void {
			removeEventListener(Event.ENTER_FRAME, loop);
			
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
			
			if (Engine.structList.indexOf(this) == -1) {
				return;
			}
			
 			Engine.structList.splice(Engine.structList.indexOf(this), 1);
		}
		
		public override function takeHit(contactDmg:Number, hitSide:Number = 0):void {
			health -= contactDmg;
			
			if (health <= 0) {
				removeSelf();
			}
		}
		
		public override function reflect(target:Object):void {
		}
 
	}
 
}
