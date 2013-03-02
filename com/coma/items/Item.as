package com.coma.items
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
	import flash.geom.*;
	
	public class Item extends MovieClip
	{
 
		private var stageRef:Stage;
		private var ourHero:Hero;
		private var type:Number;
		private var levelInfoArray:Array;
		private var fromList:Boolean;
		public var vx:Number = 0;
		public var vy:Number = 0;
 
		public function Item(stageRef:Stage, ourHero:Hero, levelInfoArray:Array, fromList:Boolean = false) : void
		{
			this.stageRef = stageRef;
			stageRef.addChild(this);
			
			
			this.levelInfoArray = levelInfoArray;
			this.ourHero = ourHero;
			this.x = levelInfoArray[1];
			this.y = levelInfoArray[2];
			this.type = levelInfoArray[0];
			this.fromList = fromList;
			
			gotoAndStop(type);
			
			Engine.itemList.push(this);
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		
		protected function loop(e:Event) : void {
			
			if (Math.sqrt(Math.pow(ourHero.x-x, 2) + Math.pow(ourHero.y-y,2)) < this.width/2 + ourHero.radius) {
				givePowerUp();
				
				if (fromList == true) {
					var someArray:Array = Engine.myLevels.level[Engine.currLevel][Engine.currRoom][4];
					for (var i:uint = 0; i < someArray.length; ++i) {
						if (someArray[i] == levelInfoArray)
							someArray.splice(i,1);
					}
				}
				
				removeSelf();
			}
		}
		
		public function moveSelf() {
			x += vx;
			y += vy;
			vx = 0;
			vy = 0;
		}
		
		public function givePowerUp() {
			switch(type) {
				case 1:
					ourHero.health += 50;
					if (ourHero.health > ourHero.maxHealth)
						ourHero.health = ourHero.maxHealth;
					break;
				case 2:
					ourHero.maxHealth += 100;
					ourHero.health = ourHero.maxHealth;
					break;
				case 3:
					++ourHero.keysForDoor;
					break;
				case 4:
					if (ourHero.weaponUpgrade < 3)
						++ourHero.weaponUpgrade;
					else {
						ourHero.health += 50;
						if (ourHero.health > ourHero.maxHealth)
							ourHero.health = ourHero.maxHealth;
					}
					break;
			}
		}
		
		public function removeSelf() : void {
			removeEventListener(Event.ENTER_FRAME, loop);
			
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
			
			if (Engine.itemList.indexOf(this) == -1) {
				return;
			}
			
 			Engine.itemList.splice(Engine.itemList.indexOf(this), 1);
 
		}
		
	}
 
}
