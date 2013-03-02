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
 
	public class Lightning extends Weapon {
		
		private var latchOn:Array = new Array();
		protected var originaly:Number = height;
		public var hit:hitLine;
		private var heroTarget:Hero;
		
		public function Lightning(stageRef:Stage, user:Object, latchEnemy:Enemy = null, heroTarget:Hero = null) : void
		{
			stop();
			super(stageRef, user);
			
			var p1 = new Point(x, y);
			var p2 = new Point(x, y-height);
			hit = new hitLine(p1,p2,this);
			this.heroTarget = heroTarget;
			
			damage = 1;
			
			if (this.user is Hero) {
				reposition();
				checkForCollision();
			}
			else {
				if (latchEnemy != null) {
					latchOn[0] = latchEnemy;
					reposition2();
				}
			}
		}
 
		protected override function loop(e:Event) : void {
			if (Engine.freezeEverything == true)
				return;
			
			if (latchOn.length == 0) {
				reposition();
				checkForCollision();
			}
			else {
				if (latchOn[0].currentLabel != "destroyedComplete") {
					reposition2();
					checkForCollision2();
				}
				else {
					latchOn.pop();
				}
			}
		}
		
		protected override function loop2(e:Event) : void
		{
			if (Engine.freezeEverything == true)
				return;
			
			if (latchOn[0].currentLabel != "destroyedComplete") {
				reposition2();
				heroCollision();
			}
			else {
				latchOn.pop();
			}
		}
		
		protected override function reposition():void {
			x = user.x;
			y = user.y;
			xdest = stageRef.mouseX - x;
			ydest = stageRef.mouseY - y;
			radian = Math.atan2(ydest,xdest);
			
			rotation = radian*180/Math.PI + 90;
			
			var myDist:Number = distance(this, new Point(stageRef.mouseX,stageRef.mouseY));
			
			scaleY = myDist/originaly;
			hit.radius_pt2 = myDist;
			hit.moveLine();
		}
		
		private function reposition2():void {
			x = user.x;
			y = user.y;
			xdest = latchOn[0].x - x;
			ydest = latchOn[0].y - y;
			radian = Math.atan2(ydest,xdest);
			
			rotation = radian*180/Math.PI + 90;
			
			var myDist:Number = distance(this, latchOn[0]);
			
			scaleY = myDist/originaly;
			hit.radius_pt2 = myDist;
			hit.moveLine();
		}
		
		private function heroCollision() {
			var collided:Array = hit.myHitTest(heroTarget);
			
			if(collided != null) {
				heroTarget.takeHit();
			}
		}
		
		protected override function checkForCollision():void {
			var collisions:Array = Engine.structList;
			var wasAHit:int = -1;
			var hitObject:int = -1;
			var hitSide:int = -1;
			var collided:Array;
			var someInt:int = 0;
			
			while (someInt < 2) {
				for(var i:uint = 0; i < collisions.length; i++) {
					if (collisions[i].permeableState == 1 || collisions[i].permeableState == 2)
						continue;
						
					if (collisions[i].boxWallCircle == 0) {
						for (var j:uint = 0; j < collisions[i].hit.hitLineList.length; ++ j) {
							collided = hit.myHitTest(collisions[i].hit.hitLineList[j]);
							if(collided != null && collided[5] == 1) {
								stopSelf(hit.pt1, collided[0]);
								wasAHit = someInt;
								hitObject = i;
								hitSide = j;
							}
						}
					}
					else if (collisions[i].boxWallCircle == 1) {
						collided = hit.myHitTest(collisions[i].hit);
						if(collided != null && collided[5] == 1) {
							stopSelf(hit.pt1, collided[0]);
							wasAHit = someInt;
							hitObject = i;
						}
					}
					else {
						collided = hit.myHitTest(collisions[i]);
						if(collided != null) {
							stopSelf(hit.pt1, collided[findMinPoint(hit.pt1, collided[0], collided[1])]);
							wasAHit = someInt;
							hitObject = i;
						}
					}
				}
				
				collisions = Engine.enemyList;
				++someInt;
			}
			
			if (wasAHit == 0) {
				Engine.structList[hitObject].takeHit(damage, hitSide);
			}
			else if (wasAHit == 1) {
				latchOn.push(Engine.enemyList[hitObject]);
				Engine.enemyList[hitObject].takeHit(damage, hitSide);
			}
		}
		
		protected function checkForCollision2():void {
			var collisions:Array = Engine.enemyList;
			var collided:Array;
			
			for(var i:uint = 0; i < collisions.length; i++) {
				if (collisions[i].permeableState == 1 || collisions[i].permeableState == 2)
					continue;
					
				if (collisions[i].boxWallCircle == 0) {
					for (var j:uint = 0; j < collisions[i].hit.hitLineList.length; ++ j) {
						collided = hit.myHitTest(collisions[i].hit.hitLineList[j]);
						if(collided != null && collided[5] == 1)
							collisions[i].takeHit(damage, j);
					}
				}
				else if (collisions[i].boxWallCircle == 1) {
					collided = hit.myHitTest(collisions[i].hit);
					if(collided != null && collided[5] == 1)
						collisions[i].takeHit(damage, 0);
				}
				else {
					collided = hit.myHitTest(collisions[i]);
					if(collided != null)
						collisions[i].takeHit(damage, 0);
				}
			}
		}
		
		public override function removeSelf() : void {
			if (this.user is Hero)
				removeEventListener(Event.ENTER_FRAME, loop);
			else
				removeEventListener(Event.ENTER_FRAME, loop2);
 
			if (stageRef.contains(this))
					stageRef.removeChild(this);
			
			for (var i:uint = 0; i < latchOn.length; ++i) {
				latchOn.pop();
			}
		}
		
		protected function stopSelf(A:Object, B:Object, filler:Number = 0):void {
			var dist:Number = distance(A,B);
			scaleY = dist/originaly;
			hit.radius_pt2 = dist;
			hit.moveLine();
		}
		
		protected function findMinPoint(origin:Point, check1:Point, check2:Point):Number {
			if (flash.geom.Point.distance(origin,check1) <= flash.geom.Point.distance(origin,check2))
				return 0;
			else
				return 1;
		}
 
	}
 
}
