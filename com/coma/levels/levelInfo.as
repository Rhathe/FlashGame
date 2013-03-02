package com.coma.levels {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
	import com.coma.structure.*;
	import com.coma.enemy.*;
	import com.coma.items.*;
	import com.coma.graphics.*;
	
	public class levelInfo {
		
		public var level:Array;
		public var stageRef:Stage;
		public var ourHero:Hero;
		
		//level - room - wall/enemy/item/exit list - type/width/height/x/y/rotation or type/x/y
		//											 pos/direction/structureNum/room/nextExit/ratio/width/height
		public function levelInfo(stageRef:Stage, ourHero:Hero) {
			
			this.stageRef = stageRef;
			this.ourHero = ourHero;
			
			level = new Array();
			newLevel();
			
			//Level 0, Room 0
			level[0][0][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										  Engine.myStageDim/2, Engine.myStageDim/2, 0));
			level[0][0][1].push(new Array(1, 70, 70, Engine.myStageDim/4, Engine.myStageDim/4, 0));
			level[0][0][1].push(new Array(1, 70, 70, 3*Engine.myStageDim/4, Engine.myStageDim/4, 0));
			level[0][0][1].push(new Array(1, 70, 70, 3*Engine.myStageDim/4, 3*Engine.myStageDim/4, 0));
			level[0][0][1].push(new Array(1, 70, 70, Engine.myStageDim/4, 3*Engine.myStageDim/4, 0));
			level[0][0][2].push(new Array(1, 1, 0, 3, 0, 0.5, 2, 0, 0));
			level[0][0][2].push(new Array(4, 4, 0, 1, 0, 0.5, 0, 0, 0));
			level[0][0][2].push(new Array(2, 2, 0, 2, 0, 0.5, 0, 0, 0));
			
			//Level 0, Room 1
			level[0].push(newRoom());
			level[0][1][0][0] = new Array(2, 120, 120);
			level[0][1][0][1] = new Array(2, 320, 120);
			level[0][1][0][2] = new Array(2, 270, 400);
			level[0][1][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0))
			level[0][1][2][0] = new Array(2, 2, 0, 0, 1, 0.5, 1, 0, 0);
			level[0][1][3].push(new Array(new Array(3, 0),
										  new Array(new Array(1, 0))));
			
			//Level 0, Room 2
			level[0].push(newRoom());
			
			level[0][2][0][0] = new Array(1, 120, 120);
			level[0][2][0][1] = new Array(1, 320, 120);
			level[0][2][0][2] = new Array(1, 400, 400);
			level[0][2][0][3] = new Array(1, 220, 350);
			level[0][2][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0))
			level[0][2][1][1] = new Array(1, 50, 300, 150, Engine.myStageDim/2, 0);
			level[0][2][1][2] = new Array(1, 50, 300, Engine.myStageDim - 150, Engine.myStageDim/2, 0);
			level[0][2][2][0] = new Array(4, 4, 0, 0, 2, 0.5, 0, 0, 0);
			
			level[0][2][4][0] = new Array(3, 300,300);
			
			//Level 0, Room 3
			level[0].push(newRoom());
				//Enemies: type/x/y
			level[0][3][0].push(new Array(2, 120, 120));
				//Walls: type/width/height/x/y/rotation
			level[0][3][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
			level[0][3][1].push(new Array(2, 50, Engine.myStageDim/3, Engine.myStageDim/2, false));
			level[0][3][1].push(new Array(2, 50, 2*Engine.myStageDim/3, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][3][2].push(new Array(3, 3, 0, 0, 0, 0.5, 0, 0, 0));
			level[0][3][2].push(new Array(4, 4, 0, 5, 1, 0.5, 0, 0, 0));
			level[0][3][2].push(new Array(2, 2, 0, 4, 0, 0.5, 0, 0, 0));
				//Triggers 
			level[0][3][3].push(new Array(new Array(3, 0),
										  new Array(new Array(3, 3, 200, 200))));
				//Items
			
			//Level 0, Room 4
			level[0].push(newRoom());
				//Enemies: type/x/y
			level[0][4][0].push(new Array(2, 220, 120));
				//Walls: type/width/height/x/y/rotation
			level[0][4][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
			level[0][4][1].push(new Array(1, 70, 70, Engine.myStageDim/4, Engine.myStageDim/4, 0));
			level[0][4][1].push(new Array(1, 70, 70, 3*Engine.myStageDim/4, Engine.myStageDim/4, 0));
			level[0][4][1].push(new Array(1, 70, 70, 3*Engine.myStageDim/4, 3*Engine.myStageDim/4, 0));
			level[0][4][1].push(new Array(1, 70, 70, Engine.myStageDim/4, 3*Engine.myStageDim/4, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][4][2].push(new Array(4, 4, 0, 3, 2, 0.5, 0, 0, 0));
				//Triggers 
			level[0][4][3].push(new Array(new Array(3, 0),
										  new Array(new Array(3, 1, 200, 200))));
				//Items
				
			//Level 0, Room 5
			level[0].push(newRoom());
				//Enemies: type/x/y
			level[0][5][0].push(new Array(2, 220, 120));
				//Walls: type/width/height/x/y/rotation
			level[0][5][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
			level[0][5][1].push(new Array(1, 70, 350, Engine.myStageDim/2, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][5][2].push(new Array(1, 1, 0, 6, 0, 0.5, 0, 0, 0));
			level[0][5][2].push(new Array(2, 2, 0, 3, 1, 0.5, 0, 0, 0));
				//Triggers 
			
				//Items
				
			//Level 0, Room 6
			level[0].push(newRoom());
				//Enemies: type/x/y
			level[0][6][0].push(new Array(2, 220, 120));
				//Walls: type/width/height/x/y/rotation
			level[0][6][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
			level[0][6][1].push(new Array(3, 30, 70, 70, false));
			level[0][6][1].push(new Array(3, 30, Engine.myStageDim - 70, 70, false));
			level[0][6][1].push(new Array(3, 30, Engine.myStageDim - 70, Engine.myStageDim - 70, false));
			level[0][6][1].push(new Array(3, 30, 70, Engine.myStageDim - 70, false));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][6][2].push(new Array(3, 3, 0, 5, 0, 0.5, 0, 0, 0));
			level[0][6][2].push(new Array(4, 4, 0, 7, 0, 0.5, 1, 0, 0));
			level[0][6][2].push(new Array(2, 2, 0, 8, 0, 0.5, 0, 0, 0));
				//Triggers 
			level[0][6][3].push(new Array(new Array(5, 1, 1, 1, 1),
										  new Array(new Array(1,1))));
				//Items
				
			//Level 0, Room 7
			level[0].push(newRoom());
				//Enemies: type/x/y
				//Walls: type/width/height/x/y/rotation
			level[0][7][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][7][2].push(new Array(2, 2, 0, 6, 1, 0.5, 0, 0, 0));
				//Triggers 
				//Items
			level[0][7][4].push(new Array(1, Engine.myStageDim/2, Engine.myStageDim/2));
			
			//Level 0, Room 8
			level[0].push(newRoom());
				//Enemies: type/x/y
			level[0][8][0].push(new Array(3, Engine.myStageDim/2, 120));
				//Walls: type/width/height/x/y/rotation
			level[0][8][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][8][2].push(new Array(4, 4, 0, 6, 2, 0.5, 1, 0, 0));
			level[0][8][2].push(new Array(1, 1, 0, 9, 0, 0.5, 1, 0, 0));
			level[0][8][2].push(new Array(2, 2, 0, 12, 0, 0.5, 1, 0, 0));
				//Triggers
			level[0][8][3].push(new Array(new Array(1,0),
										  new Array(new Array(6,0))));
			level[0][8][3].push(new Array(new Array(3,0),
										  new Array(new Array(1,0,2),
													new Array(7,1))));
				//Items
			
			//Level 0, Room 9
			level[0].push(newRoom());
				//Enemies: type/x/y
				//Walls: type/width/height/x/y/rotation
			level[0][9][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][9][2].push(new Array(3, 3, 0, 8, 1, 0.5, 0, 0, 0));
			level[0][9][2].push(new Array(4, 4, 0, 10, 0, 0.5, 0, 0, 0));
				//Triggers 
				//Items
			
			//Level 0, Room 10
			level[0].push(newRoom());
				//Enemies: type/x/y
				//Walls: type/width/height/x/y/rotation
			level[0][10][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
			level[0][10][1].push(new Array(1, 30, 100, Engine.myStageDim/2 - 70, Engine.myStageDim/2, 0));
			level[0][10][1].push(new Array(1, 30, 100, Engine.myStageDim/2 + 70, Engine.myStageDim/2, 0));
			level[0][10][1].push(new Array(5, 135, Engine.myStageDim/2, Engine.myStageDim/2 + 50, 0));
			level[0][10][1].push(new Array(5, 135, Engine.myStageDim/2, Engine.myStageDim/2 + 20, 0));
			//level[0][10][1].push(new Array(5, 135, Engine.myStageDim/2, Engine.myStageDim/2 - 50, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][10][2].push(new Array(2, 2, 0, 9, 1, 0.5, 0, 0, 0));
			level[0][10][2].push(new Array(1, 3, 4, 11, 0, 0.5, 0, 0, 0));
				//Triggers 
				//Items
			
			//Level 0, Room 11
			level[0].push(newRoom());
				//Enemies: type/x/y
				//Walls: type/width/height/x/y/rotation
			level[0][11][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
			level[0][11][1].push(new Array(5, 80, Engine.myStageDim/2, Engine.myStageDim/2 - 50, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][11][2].push(new Array(3, 1, 1, 10, 1, 0.5, 0, 0, 0));
				//Triggers
				//Items
				
			//Level 0, Room 12
			level[0].push(newRoom());
				//Enemies: type/x/y
				//Walls: type/width/height/x/y/rotation
			level[0][12][1].push(new Array(1, Engine.myStageDim - 100, Engine.myStageDim - 100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][12][2].push(new Array(4, 4, 0, 8, 2, 0.5, 0, 0, 0));
			level[0][12][2].push(new Array(2, 2, 0, 13, 0, 0.5, 0, 0, 0));
				//Triggers
				//Items
			
			//Level 0, Room 13
			level[0].push(newRoom());
				//Enemies: type/x/y
			level[0][13][0].push(new Array(5, 220, 120));
				//Walls: type/width/height/x/y/rotation
			level[0][13][1].push(new Array(1, Engine.myStageDim +100, Engine.myStageDim +100, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][13][2].push(new Array(4, 4, 0, 12, 1, 0.5, 0, 0, 0));
			level[0][13][2].push(new Array(1, 1, 0, 14, 0, 0.5, 0, 0, 0));
			level[0][13][2].push(new Array(2, 2, 0, 15, 0, 0.5, 0, 0, 0));
				//Triggers
				//Items
			
			//Level 0, Room 14
			level[0].push(newRoom());
				//Enemies: type/x/y
			level[0][14][0].push(new Array(4, Engine.myStageDim/2, 120));
				//Walls: type/width/height/x/y/rotation
			level[0][14][1].push(new Array(1, Engine.myStageDim - 50, Engine.myStageDim  - 50, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][14][2].push(new Array(3, 3, 0, 13, 1, 0.5, 1, 0, 0));
				//Triggers
				//Items
				
			//Level 0, Room 15
			level[0].push(newRoom());
				//Enemies: type/x/y
				//Walls: type/width/height/x/y/rotation
			level[0][15][1].push(new Array(1, Engine.myStageDim, Engine.myStageDim, 
										 Engine.myStageDim/2, Engine.myStageDim/2, 0));
				//Exits: pos/direction/structureNum/room/nextExit/ratio/openStatus/width/height
			level[0][15][2].push(new Array(4, 4, 0, 13, 2, 0.5, 0, 0, 0));
				//Triggers
				//Items
		}
		
		public function newLevel(): void {
			var newLev:Array = new Array;
			var room:Array = newRoom();
			
			newLev.push(room);
			
			level.push(newLev);
		}
		
		public function newRoom():Array {
			var enemyList:Array = new Array();
			var wallList:Array = new Array();
			var exitList:Array = new Array();
			var triggerList:Array = new Array();
			var itemList:Array = new Array();
			var scrolling:Boolean = true;
			
			var room:Array = new Array(enemyList, wallList, exitList, triggerList, itemList, scrolling);
			
			return room;
		}
		
		public function removeLevel(removeEnemies:Boolean = true,
									removeWalls:Boolean = true,
									removeExits:Boolean = true) {
			var i:int;
			
			if (ourHero.beamOn == 1)
				ourHero.turnOffBeam();
			
			
			if (removeEnemies == true) {
				for( i = Engine.enemyList.length - 1; i >= 0; --i) {
					Engine.enemyList[i].removeSelf();
				}
			}
			
			if (removeWalls == true) {
				for( i = Engine.structList.length - 1; i >= 0; --i) {
					Engine.structList[i].removeSelf();
				}
				
			}
			
			if (removeExits == true) {
				for( i = Engine.exitList.length - 1; i >= 0; --i) {
					Engine.exitList[i].removeSelf();
				}
			}
			
			for( i = Engine.eventList.length - 1; i >= 0; --i) {
				Engine.eventList[i].removeSelf();
			}
			
			for( i = Engine.itemList.length - 1; i >= 0; --i) {
				Engine.itemList[i].removeSelf();
			}
			
			for( i = Engine.bulletList.length - 1; i >= 0; --i) {
				Engine.bulletList[i].removeSelf();
			}
			
			Engine.switchList = new Array();
		}
		
		public function loadRoom(levelNum:Number, roomNum:Number): void {
			var i:int;
			var dummy:Array;
			Engine.currLevel = levelNum;
			Engine.currRoom = roomNum;
			
			for( i = 0; i < level[levelNum][roomNum][1].length; ++i) {
				dummy = level[levelNum][roomNum][1][i];
				if (dummy[0] == 1) {
					//type/width/height/x/y/rotation
					new Box(stageRef, dummy[1], dummy[2], dummy[3], dummy[4], dummy[5]);
				}
				else if (dummy[0] == 2) {
					new Round(stageRef, dummy[1], dummy[2], dummy[3]);
				}
				else if (dummy[0] == 3) {
					new Switch(stageRef, dummy[1], dummy[2], dummy[3], dummy[4]);
				}
				else if (dummy[0] == 4) {
					new EnemyGenerator(stageRef, ourHero, dummy[1], dummy[2], dummy[3]);
				}
				else if (dummy[0] == 5) {
					new Wall(stageRef, dummy[1], dummy[2], dummy[3], dummy[4]);
				}
			}
			
			//new Graphic(stageRef, Engine.structList[0], 1, true);
			
			for( i = 0; i < level[levelNum][roomNum][0].length; ++i) {
				dummy = level[levelNum][roomNum][0][i];
				if (dummy[0] == 1) {
					new Bat(stageRef, ourHero, dummy, true);
				}
				else if (dummy[0] == 2) {
					new Bat(stageRef, ourHero, dummy, true);
				}
				else if (dummy[0] == 3) {
					new MiniBoss1(stageRef, ourHero, dummy, true);
				}
				else if (dummy[0] == 4) {
					new Boss1(stageRef, ourHero, dummy, true);
				}
				else if (dummy[0] == 5) {
					new Sentinal(stageRef, ourHero, dummy, true);
				}
			}
			
			for( i = 0; i < level[levelNum][roomNum][2].length; ++i) {
				dummy = level[levelNum][roomNum][2][i];
				var pos:String;
				var direct:String;
				
				switch(dummy[0]) {
					case 1:
						pos = "top";
						break;
					case 2:
						pos = "right";
						break;
					case 3:
						pos = "bottom";
						break;
					case 4:
						pos = "left";
						break;
				}
				
				switch(dummy[1]) {
					case 1:
						direct = "north";
						break;
					case 2:
						direct = "east";
						break;
					case 3:
						direct = "south";
						break;
					case 4:
						direct = "west";
						break;
				}
				
				//pos/direction/structureNum/room/nextExit/ratio/width/height
				
				new Exit(stageRef, Engine.structList[dummy[2]], ourHero, 
						 pos, direct, dummy[3], dummy[4], dummy[5], dummy[6]);
			}
			
			for( i = 0; i < level[levelNum][roomNum][3].length; ++i) {
				dummy = level[levelNum][roomNum][3][i];
				
				new triggerEvent(stageRef, ourHero, dummy[0], dummy[1]);
			}
			
			for( i = 0; i < level[levelNum][roomNum][4].length; ++i) {
				dummy = level[levelNum][roomNum][4][i];
				
				new Item(stageRef, ourHero, dummy, true);
			}

			if (Engine.structList[0].coordinates[2].x - Engine.structList[0].coordinates[0].x > Engine.myStageDim - 50)
				Engine.scrollingHor = true;
			else
				Engine.scrollingHor = false;
				
			if (Engine.structList[0].coordinates[2].y - Engine.structList[0].coordinates[0].y > Engine.myStageDim - 50)
				Engine.scrollingVer = true;
			else
				Engine.scrollingVer = false;
			
		
			/*trace(Engine.enemyList);
			trace(Engine.wallList);
			trace(Engine.exitList);
			trace(Engine.structList);*/
		}
	}
}
