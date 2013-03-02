package com.coma.basics
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.*;
	import com.coma.structure.*;
	import com.coma.levels.levelInfo;
	import flash.geom.*;
	import com.coma.graphics.*;
 
	public class Engine extends MovieClip
	{
		public static var enemyList:			Array = new Array();
		public static var bulletList:			Array = new Array();

		public static var exitList:				Array = new Array();
		public static var structList:			Array = new Array();
		public static var eventList:			Array = new Array();
		public static var itemList:				Array = new Array();
		public static var switchList:			Array = new Array();
		public static var graphicList:			Array = new Array();
		public static var myStageDim:			Number = 600;
		public static var Origin:				Point = new Point(0,0);
		
		public var ourHero:						Hero;
		private var test:						Box;
		private var test2:						Exit;
		public static var currLevel:			Number = 0;
		public static var currRoom:				Number = 0;
		public static var scrollingHor:			Boolean = true;
		public static var scrollingVer:			Boolean = true;
		public static var myLevels:				levelInfo;
		public static var freezeEverything:		Boolean = false;
		public static var bounds:				int = 50;
		var backGroundSprite:					MovieClip = new MovieClip();

		public function Engine() : void {
			//removed the var ourHero:Hero because we declared it above.
			ourHero = new Hero(stage);
			stage.addChild(ourHero);
 
			ourHero.x = stage.stageWidth / 2;
			ourHero.y = stage.stageHeight / 2;
			
			var odoor = new door(0,0);
			var owidth = odoor.width;
			var oheight = odoor.height;
			
			backGroundSprite.graphics.beginBitmapFill(new tile1(0, 0));
			backGroundSprite.graphics.drawRect(-owidth/2, -oheight/2, myStageDim + owidth, myStageDim + oheight);
			backGroundSprite.graphics.endFill();
			addChild(backGroundSprite);
			
			myLevels = new levelInfo(stage, ourHero);
			
			myLevels.loadRoom(0,13);
			
			//running a loop now.... so we can keep creating enemies randomly.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			addEventListener(Event.ENTER_FRAME, manageViewStack, false, 0, true);
		}
		
		private function manageViewStack( evt : Event ) : void {
			stage.setChildIndex( ourHero, stage.numChildren - 1 );
		}
 
		//our loop function
		private function loop(e:Event) : void {
			if (freezeEverything == true)
				return;
			
			checkExit();
			reflectEverything();
			
			scrollEverything(ourHero.vx, ourHero.vy);
			
			moveEverything(true, true);
		}

		function checkExit():void {
			var direct:String;
			var room:Number;
			var nextExit:Number;
			
			for( var i:int = 0; i < exitList.length; ++i) {
				if (exitList[i].hitBox.hitTestPoint(ourHero.x,ourHero.y) == true) {
					if (exitList[i].moveOut(i) == true) {
						room = exitList[i].room;
						nextExit = exitList[i].nextExit;
						
						myLevels.removeLevel();
						myLevels.loadRoom(currLevel, room);
						
						var tempPt:Point = exitList[nextExit].hitBox.localToGlobal(new Point(0,0));
						ourHero.x = tempPt.x;
						ourHero.y = tempPt.y;
						
						var temp1:Point = structList[0].coordinates[0];
						var temp2:Point = structList[0].coordinates[2];
						
						if (scrollingHor == true) {
							if (temp1.x < bounds && ourHero.x < temp1.x + myStageDim/2) {
								scrollEverythingHor(temp1.x - bounds);
								moveEverything(true,true);
								ourHero.vx = 0;
								ourHero.vy = 0;
							}
							else if (temp2.x > myStageDim - bounds && ourHero.x > temp2.x - myStageDim/2) {
								scrollEverythingHor(bounds - myStageDim + temp2.x);
								moveEverything(true,true);
								ourHero.vx = 0;
								ourHero.vy = 0;
							}
						}
						
						if (scrollingVer == true) {
							if (temp1.y < bounds && ourHero.y < temp1.y + myStageDim/2) {
								scrollEverythingVer(temp1.y - bounds);
								moveEverything(true,true);
								ourHero.vx = 0;
								ourHero.vy = 0;
							}
							else if (temp2.y > myStageDim - bounds && ourHero.y > temp2.y - myStageDim/2) {
								scrollEverythingVer(bounds -myStageDim + temp2.y);
								moveEverything(true,true);
								ourHero.vx = 0;
								ourHero.vy = 0;
							}
						}
						
						break;
					}
				}
			}
		}
		
		function reflectEverything() {
			for( var i:int = 0; i < structList.length; ++i) {
				structList[i].reflect(ourHero);
				
				for(var j:int = 0; j < enemyList.length; ++j) {
					structList[i].reflect(enemyList[j]);
				}
			}
		}
		
		function scrollEverythingHor(vx:int):void {
			for(var j:int = 0; j < enemyList.length; ++j) {
				enemyList[j].scrollvx = -vx;
			}
			
			for(j = 0; j < structList.length; ++j) {
				structList[j].vx -= vx;
			}
			for(j = 0; j < exitList.length; ++j) {
				exitList[j].vx -= vx;
			}
			
			for(j = 0; j < bulletList.length; ++j) {
				bulletList[j].vx -= vx;
			}
			
			for(j = 0; j < itemList.length; ++j) {
				itemList[j].vx -= vx;
			}
			
			ourHero.vx -= vx;
		}
		
		function scrollEverythingVer(vy:int):void {
			for(var j:int = 0; j < enemyList.length; ++j) {
				enemyList[j].scrollvy = -vy;
			}
			
			for(j = 0; j < structList.length; ++j) {
				structList[j].vy -= vy;
			}
			for(j = 0; j < exitList.length; ++j) {
				exitList[j].vy -= vy;
			}
			
			for(j = 0; j < bulletList.length; ++j) {
				bulletList[j].vy -= vy;
			}
			
			for(j = 0; j < itemList.length; ++j) {
				itemList[j].vy -= vy;
			}
			
			ourHero.vy -= vy;
		}
		
		function scrollEverything(vx:Number, vy:Number) {
			var temp1:Point = structList[0].coordinates[0];
			var temp2:Point = structList[0].coordinates[2];
			
			if (scrollingHor == true) {
				if (temp1.x < bounds && temp2.x > myStageDim - bounds) {
					if (temp1.x - ourHero.vx > bounds)
						scrollEverythingHor(temp1.x - bounds);
					else if (temp2.x - ourHero.vx < myStageDim - bounds)
						scrollEverythingHor(temp2.x - (myStageDim - bounds));
					else 
						scrollEverythingHor(ourHero.vx);
				}
				else if (temp1.x >= bounds) {
					if (temp2.x < myStageDim - bounds)
						;
					else if (ourHero.vx > 0 && ourHero.x > myStageDim/2)
						scrollEverythingHor(ourHero.vx);
				}
				else if (temp2.x <= myStageDim - bounds) {
					if (ourHero.vx < 0 && ourHero.x < myStageDim/2)
						scrollEverythingHor(ourHero.vx);
				}
			}
			
			if (scrollingVer == true) {
				if (temp1.y < bounds && temp2.y > myStageDim - bounds) {
					if (temp1.y - ourHero.vy > bounds)
						scrollEverythingVer(temp1.y-bounds);
					else if (temp2.y - ourHero.vy < myStageDim - bounds)
						scrollEverythingVer(temp2.y - (myStageDim - bounds));
					else 
						scrollEverythingVer(ourHero.vy);
				}
				else if (temp1.y >= bounds) {
					if (temp2.y < myStageDim - bounds)
						;
					else if (ourHero.vy > 0 && ourHero.y > myStageDim/2)
						scrollEverythingVer(ourHero.vy);
				}
				else if (temp2.y <= myStageDim - bounds) {
					if (ourHero.vy < 0 && ourHero.y < myStageDim/2)
						scrollEverythingVer(ourHero.vy);
				}
			}
		}
		
		function moveEverything(moveHero:Boolean = true, moveStructures:Boolean = false) {
			if (moveHero == true)
				ourHero.moveSelf();
				
			for(var j:int = 0; j < enemyList.length; ++j) {
				enemyList[j].moveSelf();
			}
			
			for(j = 0; j < bulletList.length; ++j) {
				bulletList[j].moveSelf();
			}
			
			for(j = 0; j < itemList.length; ++j) {
				itemList[j].moveSelf();
			}
			
			if (moveStructures == true) {
				var tempvx:int = structList[0].vx;
				var tempvy:int = structList[0].vy;
				
				backGroundSprite.x += tempvx;
				backGroundSprite.y += tempvy;
				
				if (backGroundSprite.x > 25)
					backGroundSprite.x -= 50;
				else if (backGroundSprite.x < - 25)
					backGroundSprite.x += 50;
				
				if (backGroundSprite.y > 25)
					backGroundSprite.y -= 50;
				else if (backGroundSprite.y < - 25)
					backGroundSprite.y += 50;
				
				for(j = 0; j < structList.length; ++j) {
					structList[j].moveSelf();
				}
				for(j = 0; j < exitList.length; ++j) {
					exitList[j].readjust();
				}
			}
		}
 
	}
 
}
