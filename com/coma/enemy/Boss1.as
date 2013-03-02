package com.coma.enemy
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
 	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import com.coma.structure.Wall;
	import com.coma.weapon.Lightning;

	public class Boss1 extends Enemy {
		
		private var startUp:Boolean = true;
		protected var actionTimer:Timer;
		protected var isHit:Boolean = false;
		private var roundArr:Array = new Array(0,0,0, false);
		private var corner:Number = 0;
		public var sentinals:Array = new Array();
		public var attachPt:Point;

		public function Boss1(stageRef:Stage, target:Hero, someArray:Array, fromList:Boolean = true) : void {
			
			super(stageRef, target, someArray, fromList);
			v = 1;
			health = 1;
			health = 10000;
			boxWallCircle = 2;
			gotoAndPlay(1);
			attachPt = new Point(x,y + radius);
			
			actionTimer = new Timer(300, 1);
			actionTimer.addEventListener(TimerEvent.TIMER, actionTimerHandler, false, 0, true);
		}
		
		public override function moveSelf():void {
			y += vy + scrollvy;
			x += vx + scrollvx;
			
			scrollvy = 0;
			scrollvx = 0;
		}
		
		protected function actionTimerHandler(e:TimerEvent) : void {
			roundArr[3] = true;
		}
		
		private function round0Action():void {
			if (roundArr[3] == true) {
				if (roundArr[2] == 0) {
					teleport();
					roundArr[2] = 1;
					roundArr[3] = false;
					actionTimer.delay = 100;
					actionTimer.start();
				}
				else {
					shootLightning();
					roundArr[2] = 0;
					roundArr[3] = false;
					actionTimer.delay = 600;
					actionTimer.start();
					roundArr[1]++;
				}
			}
		}
		
		private function round1Action():void {
			if (roundArr[3] == true) {
				if (roundArr[2] == 0) {
					roundArr[2] = 1;
					roundArr[3] = false;
					actionTimer.delay = 1000;
					actionTimer.start();
				}
				else if (roundArr[2] == 1) {
					sentinals[0] = new Sentinal(stageRef, target, new Array(2, x + 30, y+30), false, this, sentinals);
					sentinals[0].changeSpeed(10, false);
					sentinals[1] = new Lightning(stageRef, this, sentinals[0], target);
					
					
					roundArr[2] = 2;
					roundArr[1]++;
				}
				else {
					roundArr[1]++;
				}
			}
		}
		
		private function teleport(): void {
			function gotoCorner(i:Number) {
				var temp1:Point = Engine.structList[0].coordinates[0];
				var temp2:Point = Engine.structList[0].coordinates[2];
				
				switch(i) {
					case 0:
						x = temp1.x + 70;
						y = temp1.y + 70;
						corner = 0;
						break;
					case 1:
						x = temp2.x - 70;
						y = temp1.y + 70;
						corner = 1;
						break;
					case 2:
						x = temp2.x - 70;
						y = temp2.y - 70;
						corner = 2;
						break;
					case 3:
						x = temp1.x + 70;
						y = temp2.y - 70;;
						corner = 3;
						break;
				}
			}
			
			var ran:Number = Math.random();
			
			switch(corner) {
				case 0:
					if (ran > .25)
						gotoCorner(1);
					else
						gotoCorner(3);
					break;
				case 1:
					if (ran > .25)
						gotoCorner(2);
					else
						gotoCorner(0);
					break;
				case 2:
					if (ran > .25)
						gotoCorner(3);
					else
						gotoCorner(1);
					break;
				case 3:
					if (ran > .25)
						gotoCorner(0);
					else
						gotoCorner(2);
					break;
				case 4:
					if (ran > .5)
						gotoCorner(0);
					else
						gotoCorner(1);
					break;
			}
		}
		
		private function shootLightning() {
			var angle2:Number = Math.atan2(target.y-y, target.x-x);
			stageRef.addChild(new Bullet(stageRef, target, x, y, angle2, 15, 10));
		}
		
		protected override function loop(e:Event) : void
		{
			if (Engine.freezeEverything == true) {
				wasPaused = true;
				actionTimer.stop();
				return;
			}
			else if (wasPaused == true) {
				wasPaused = false;
				actionTimer.start();
			}
			
			if (currentLabel != "destroyed") {
				if (currentLabel == "droppingIn") {
					return;
				}
				else {
					if (startUp == true) {
						stop();
						Engine.freezeEverything = false;
						startUp = false;
						actionTimer.start();
					}
					
					if (distance(target.x, target.y, x, y) < target.radius + radius - 10 )
						target.takeHit(contactDmg);
					
					if (roundArr[0] == 0) {
						if (roundArr[1] < 5)
							round0Action();
						else {
							if ((corner == 0 || corner == 1) && roundArr[3] == true && roundArr[2] == 0) {
								roundArr[0]++;
								var temp1:Point = Engine.structList[0].coordinates[0];
								var temp2:Point = Engine.structList[0].coordinates[2];
								x = temp1.x + (temp2.x - temp1.x)/2;
								y = temp1.y + 70;
								corner = 4;
								roundArr[1] = 0;
								roundArr[2] = 0;
							}
							else
								round0Action();
						}
					}
					else if (roundArr[0] == 1) {
						attachPt.x = x;
						attachPt.y = y + radius;
						
						round1Action();
						if (roundArr[1] > 100) {
							if (sentinals[0] != null) {
								if (distance(sentinals[0].x, sentinals[0].y, x, y) < target.radius + radius)
								{
									sentinals[0].removeSelf();
									roundArr[0] = 0;
									roundArr[1] = 0;
									roundArr[2] = 0;
									roundArr[3] = false;
									actionTimer.delay = 1000;
									actionTimer.start();
								}
							}
							else {
								roundArr[0] = 0;
								roundArr[1] = 0;
								roundArr[2] = 0;
								roundArr[3] = false;
								actionTimer.delay = 1000;
								actionTimer.start();
							}
						}
					}
				}
			}
 
			if (currentLabel == "destroyedComplete") {
				removeSelf();
			}
		}
		
		function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.sqrt(Math.pow(x1-x2, 2)+Math.pow(y1-y2,2));
		}
		
		public override function takeHit(damage:Number, hitSide:Number = 0) : void
		{
			health -= damage;
			if (health <= 0 && currentLabel != "destroyed" && currentLabel != "destroyedComplete") {
				for (var i:uint = 0; i < sentinals.length; ++i) {
					if (sentinals[i] is Sentinal)
						sentinals[i].removeSelf();
				}
				gotoAndPlay("destroyed");
			}
		}
		
	}
 
}
