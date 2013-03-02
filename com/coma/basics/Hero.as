package com.coma.basics {
 
	import flash.display.MovieClip;	
	import flash.display.Stage;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.events.*;
	import flash.utils.Timer;
	import com.coma.weapon.Weapon;
	import com.coma.weapon.Beam;
	import com.coma.weapon.Lightning;
 
	public class Hero extends MovieClip	{
 
		private var stageRef:Stage;
		private var key:KeyObject;
		private var mouse:MouseObject;
		public var speed:int = 10;
		public var vx:int;
		public var vy:int;
		public var health:Number = 500;
		public var maxHealth:Number = 500;
		public var beam:Weapon = null;
		public var beamOn:Number = 0; //0 off, 1 on, 2 locked
		private var movementNum:Number = 0;
		public var radius = width/2;
		private var gotHitTimer:Timer;
		private var canGetHit:Boolean = true;
		public var keysForDoor:Number = 0;
		public var weaponUpgrade:Number = 0;
		public var weapon:Number = 0;
 
		public function Hero(stageRef:Stage) {
			stop();
			this.stageRef = stageRef;
			key = new KeyObject(stageRef);
			mouse = new MouseObject(stageRef);
			
			gotHitTimer = new Timer(700, 1);
			gotHitTimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
 
	 	public function loop(e:Event) : void {
			
			vx = 0;
			vy = 0;
			
if (key.isDown(66)) 
 Engine.freezeEverything = true;
if (key.isDown(67)) 
 Engine.freezeEverything = false;
if (Engine.freezeEverything == true)
	return;

if (key.isDown(49)) {
	turnOffBeam();
	weapon = 0;
}
if (key.isDown(50)) {
	turnOffBeam();
	weapon = 1;
}
			
			if (!canGetHit) {
				if (alpha <= 0)
					alpha = 1;
				else
					alpha = 0;
			}

			if (key.isDown(65)) 
				movementNum += 1;
			else if (key.isDown(68))
				movementNum += 2;
 
			if (key.isDown(87))
				movementNum += 10;
			else if (key.isDown(83))
				movementNum += 20;
			
			switch (movementNum) {
				case 1:
					vx = -speed;
					break;
				case 2:
					vx = speed;
					break;
				case 10:
					vy = -speed;
					break;
				case 20:
					vy = speed;
					break;
				case 11:
					vx = -Math.sqrt(2)*speed/2;
					vy = -Math.sqrt(2)*speed/2;
					break;
				case 12:
					vx = Math.sqrt(2)*speed/2;
					vy = -Math.sqrt(2)*speed/2;
					break;
				case 21:
					vx = -Math.sqrt(2)*speed/2;
					vy = Math.sqrt(2)*speed/2;
					break;
				case 22:
					vx = Math.sqrt(2)*speed/2;
					vy = Math.sqrt(2)*speed/2;
			}
			
			movementNum = 0;

			if (mouse.isDown())
				fireBullet();
			else if (beamOn == 1) {
				if (beam.currentLabel == "beamStart")
					beam.play();
				else if (beam.currentLabel == "beamOff") {
					turnOffBeam();
				}
			}
			
			//stay inside screen
			/*
			if (x > stageRef.stageWidth)
				x = stageRef.stageWidth;
			else if (x < 0)
				x = 0;
 
			if (y > stageRef.stageHeight)
				y = stageRef.stageHeight;
			else if (y < 0)
				y = 0;*/
			
			var temp1:Number = stageRef.mouseY - y;
			var temp2:Number = stageRef.mouseX - x;
			
			if (vx == 0 && vy == 0) {
				if (temp1 >= 0) {
					if (temp1 > Math.abs(temp2))
						gotoAndStop("front");
					else {
						gotoAndStop("left");
						if (temp2 > 0)
							scaleX = -1;
						else
							scaleX = 1;
					}
				}
				else {
					if (Math.abs(temp2) < Math.abs(temp1))
						gotoAndStop("back");
					else {
						gotoAndStop("left");
						if (temp2 > 0)
							scaleX = -1;
						else
							scaleX = 1;
					}
				}
			}
			else if (vy == 0) {
				gotoAndStop("runLeft");
				if (temp2 >= 0)
					scaleX = -1;
				else
					scaleX = 1;
			}
			else {
				if (temp1 >= 0) {
					if (temp1 > Math.abs(temp2))
						gotoAndStop("runDown");
					else {
						gotoAndStop("runLeft");
						if (temp2 > 0)
							scaleX = -1;
						else
							scaleX = 1;
					}
				}
				else {
					if (Math.abs(temp2) < Math.abs(temp1))
						gotoAndStop("runUp");
					else {
						gotoAndStop("runLeft");
						if (temp2 > 0)
							scaleX = -1;
						else
							scaleX = 1;
					}
				}
			}
			
			

		}
		
		public function moveSelf():void {
			x += vx;
			y += vy;
		}
		
		public function lockBeam(val:Boolean) {
			if (beamOn == 1)	
				beam.removeSelf();
			
			if (val == true)
				beamOn = 2;
			else
				beamOn = 0;
		}
		
		public function fireBullet() : void {
			if (beamOn == 0) {
				switch(weapon) {
					case 0:
						beam = new Beam(stageRef, this);
						break;
					case 1:
						beam = new Lightning(stageRef, this);
				}
				beamOn = 1;
			}
			else if (beam != null) {
				if (beam.currentLabel == "beamOff")
					turnOffBeam();
			}
		}
		
		public function turnOffBeam() {
			if (beam != null)
				beam.removeSelf()
			beamOn = 0;
			beam = null;
		}
		
		public function checkCollisions():void {
		}
		
		public function reflect(vx:int, vy:int):void {
			this.vx += vx;
			this.vy += vy;
		}
		
		public function takeHit(contactDmg = 1):void {
			if (canGetHit == true) {
				alpha = 0.5;
				canGetHit = false;
				gotHitTimer.start();
			}
		}
		
		protected function timerHandler(e:TimerEvent) : void {
			canGetHit = true;
			alpha = 1;
		}
	}
 
}
