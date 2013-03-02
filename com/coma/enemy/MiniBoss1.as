package com.coma.enemy
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
 	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.coma.collision.*;
 
	public class MiniBoss1 extends Enemy {
		
		public var hit:hitBox;
		protected var canFire = false;
		protected var fireTimer:Timer;
		protected var isHit:Boolean = false;
		private var round:Number = 0;
		private var round1:Number = 0;
		private var round2:Number = 0;
		private var round3:Number = 0;

		public function MiniBoss1(stageRef:Stage, target:Hero, someArray:Array, fromList:Boolean = true) : void {
			
			super(stageRef, target, someArray, fromList);
			v = 1;
			
			health = 1;
			//health = 7000;
			
			boxWallCircle = 0;
			gotoAndPlay(1);
			target.lockBeam(true);
			hit = null;
			
			fireTimer = new Timer(1000, 1);
			fireTimer.addEventListener(TimerEvent.TIMER, fireTimerHandler, false, 0, true);
		}
		
		public override function moveSelf():void {
			y += vy + scrollvy;
			x += vx + scrollvx;
			
			scrollvy = 0;
			scrollvx = 0;
			
			if (hit != null)
				hit.rotateBox();
		}
		
		public function moveBox(somex:Number = 0, somey:Number = 0, angle:Number = 0):void {
			x = somex;
			y = somey;
			rotation = angle;
			hit.rotateBox();
		}
		
		protected function fireTimerHandler(e:TimerEvent) : void {
			canFire = true;
		}
		
		protected override function loop(e:Event) : void
		{
			
			if (currentLabel != "destroyed") //ship isn't be destroyed
			{
				if (y < - 500 || y > stageRef.stageHeight +500 || x < -500 || x > stageRef.stageWidth +500)
					removeSelf();
					
				if (currentLabel == "droppingIn") {
					//Engine.freezeEverything = true;
					return;
				}
				else {
					if (hit == null) {
						stop();
						Engine.freezeEverything = false;
						hit = new hitBox(this, this, stageRef);
						target.lockBeam(false);
						fireTimer.start();
					}
				}
			}
			
			if (Engine.freezeEverything == true) {
				wasPaused = true;
				fireTimer.stop();
				return;
			}
			else if (wasPaused = true) {
				wasPaused = false;
				fireTimer.start();
			}
 
			if (currentLabel == "destroyedComplete") {
				removeSelf();
			}
			
			fireBullet();
			targeting();
		}
		
		protected override function targeting(): void {
			if (round == 0) {
				v = 1;
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
			else if (round == 1) {
				if (round2 == 0) {
					vy *= 7;
					vx *= 7;
					round2++;
				}
			}
			else {
				v = 2;
				if ( distance(Engine.structList[0].x, Engine.structList[0].y, x,y) > 10) {
					angle = Math.atan2(Engine.structList[0].y-y, Engine.structList[0].x-x);
					vy = v*Math.sin(angle);
					vx = v*Math.cos(angle);
				}
				else {
					vx = 0;
					vy = 0;
				}
			}
		}
		
		public override function reflect(vx:Number, vy:Number):void {
			var hypot:Number = Math.sqrt(vx*vx+vy*vy);
			if (hypot != 0) {
				vx /= hypot;
				vy /= hypot;
			}
			this.vx += 2*Math.abs(this.vx)*vx;
			this.vy += 2*Math.abs(this.vy)*vy;
		}
		
		function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.sqrt(Math.pow(x1-x2, 2)+Math.pow(y1-y2,2));
		}
		
		protected override function fireBullet() : void {
			if (canFire == true) {
				
				if (round == 0) {
					var j:int = 0;
					for(var i:int = 0; i < 13; ++ i) {
						stageRef.addChild(new Bullet(stageRef, target, x, y, j*6.28/13, 8));
						j++;
					}
					fireTimer.delay = 800;
					round1++;
					round3 = 0;
					
					if (round1 > 5)
						++round;
				}
				else if (round == 1) {
					var angle2:Number = Math.atan2(target.y-y, target.x-x);
					stageRef.addChild(new Bullet(stageRef, target, x, y, angle2, 12, 13));
					fireTimer.delay = 400;
					round2++;
					round1 = 0;
					
					if (round2 > 10)
						++round;
				}
				else {
					if ( distance(Engine.structList[0].x, Engine.structList[0].y, x,y) <= 10) {
						fireTimer.delay = 10;
						round3++;
						round2 = 0;
						stageRef.addChild(new Bullet(stageRef, target, x, y, round3/25, 12));
						stageRef.addChild(new Bullet(stageRef, target, x, y, round3/25 + Math.PI/2, 12));
						stageRef.addChild(new Bullet(stageRef, target, x, y, round3/25 + Math.PI, 12));
						stageRef.addChild(new Bullet(stageRef, target, x, y, round3/25 - Math.PI/2, 12));
						
						if (round3 > 400)
							round = 0;
					}
				}
				
				canFire = false;
				fireTimer.start();
			}
		}
	}
 
}
