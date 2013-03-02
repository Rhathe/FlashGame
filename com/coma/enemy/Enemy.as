package com.coma.enemy
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.coma.items.*;
 
	public class Enemy extends MovieClip
	{
 
		protected var stageRef:Stage;
		protected var v:Number = 6;
		protected var target:Hero;
		protected var angle:Number;
		public var vx:Number;
		public var vy:Number;
		public var scrollvx:Number = 0;
		public var scrollvy:Number = 0;
		protected var range:Number;
		public var health:Number;
		public var contactDmg:Number;
		public var radius:Number;
		protected var fromList:Boolean;
		protected var levelInfoArray:Array;
		public var boxWallCircle:Number = 2;
		protected var wasPaused:Boolean = false;
		public var permeableState:Number = 3; //If 0, can't be passed but hit,
											  //If 1, can't be passed or hit
											  //If 2, practically not there
											  //If 3, can be passed and hit
 
		public function Enemy(stageRef:Stage, target:Hero, levelInfoArray:Array, fromList:Boolean = false) : void
		{
			stop();
			this.stageRef = stageRef;
			this.target = target;
			stageRef.addChild(this);
			Engine.enemyList.push(this);
			this.fromList = fromList;
			this.levelInfoArray = levelInfoArray;
			
			this.x = levelInfoArray[1];
			this.y = levelInfoArray[2];
			vx = 0;
			vy = 0;
			radius = width/2;
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
 
		protected function loop(e:Event) : void
		{
			if (Engine.freezeEverything == true) {
				wasPaused = true;
				return;
			}
			else if (wasPaused == false) {
				wasPaused = true;
			}
			
			if (currentLabel != "destroyed") //ship isn't be destroyed
			{
				if (y < -6 || y > stageRef.stageHeight +6 || x < -6 || x > stageRef.stageWidth +6)
					;//removeSelf();
			}	
 
			if (currentLabel == "destroyedComplete") {
				removeSelf();
			}
			
			fireBullet();
			targeting();
		}
		
		protected function targeting(): void {
			if (Math.sqrt(Math.pow(target.x-x, 2) + Math.pow(target.y-y,2)) < target.radius + radius - 10 ) {
				target.takeHit(contactDmg);
				vy = 0;
				vx = 0;
			}
			else {
				angle = Math.atan2(target.y-y, target.x-x);
				vy = v*Math.sin(angle);
				vx = v*Math.cos(angle);
			}
		}
 
		public function removeSelf() : void {
			removeEventListener(Event.ENTER_FRAME, loop);
 
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
			
			if (Engine.enemyList.indexOf(this) == -1) {
				return;
			}
			if (currentLabel == "destroyedComplete" || currentLabel == "destroyed") {
				if (fromList == true) {
					var someArray:Array = Engine.myLevels.level[Engine.currLevel][Engine.currRoom][0];
					for (var i:uint = 0; i < someArray.length; ++i) {
						if (someArray[i] == levelInfoArray)
							someArray.splice(i,1);
					}
				}
			}
			
 			Engine.enemyList.splice(Engine.enemyList.indexOf(this), 1);
		}
 
		public function takeHit(damage:Number, hitSide:Number = 0) : void
		{
			health -= damage;
			if (health <= 0 && currentLabel != "destroyed" && currentLabel != "destroyedComplete") {
				dropItem();
				gotoAndPlay("destroyed");
			}
		}

		public function moveSelf():void {
			y += vy + scrollvy;
			x += vx + scrollvx;
			
			scrollvy = 0;
			scrollvx = 0;
		}
		
		public function reflect(vx:Number, vy:Number):void {
			this.vx += vx;
			this.vy += vy;
		}
		
		protected function dropItem() {
			if(Math.random() > .5) {
				new Item(stageRef, target, new Array(1, x, y), false);
			}
		}
		
		protected function fireBullet():void {
		}
		
		public function changeSpeed(val:Number, increment:Boolean):void {
			if (increment == false) {
				vx *= val/v;
				vy *= val/v;
				v = val;
			}
			else if (increment == true) {
				val += v;				
				vx *= val/v;
				vy *= val/v;
				v = val;
			}
		}
	}
 
}
