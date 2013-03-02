package com.coma.levels {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
	import com.coma.structure.*;
	import com.coma.items.*;
	
	public class triggerEvent extends MovieClip{
	
		private var eventTriggered:Boolean = false;
		private var condition:Array;
		private var nextEvent:Array;
		private var ourHero:Hero;
		private var stageRef:Stage;
		private var fromList:Boolean;
	
		public function triggerEvent(stageRef:Stage, ourHero:Hero, condition:Array, nextEvent:Array, fromList:Boolean = true) {
			
			this.fromList = fromList;
			this.stageRef = stageRef;
			this.ourHero = ourHero;
			this.condition = condition;
			this.nextEvent = nextEvent;
			
			Engine.eventList.push(this);
			
			switch(this.condition[0]) {
				case 1:
					addEventListener(Event.ENTER_FRAME, doAtBeginning, false, 0, true);
					break;
				case 2:
					addEventListener(Event.ENTER_FRAME, killEnemy, false, 0, true);
					break;
				case 3:
					addEventListener(Event.ENTER_FRAME, eliminateEnemies, false, 0, true);
					break;
				case 4:
					addEventListener(Event.ENTER_FRAME, moveHere, false, 0, true);
					break;
				case 5:
					addEventListener(Event.ENTER_FRAME, checkSwitches, false, 0, true);
					break;
			}
		}
		
		public function doAtBeginning(e:Event) {
			devilTrigger();
		}
		
		public function killEnemy(e:Event) {
		}
		
		public function eliminateEnemies(e:Event) {
			if (Engine.enemyList.length <= condition[1])
				devilTrigger();
		}
		
		public function checkSwitches(e:Event) {
			for(var i:uint = 1; i < condition.length; ++i) {
				if (Engine.switchList[i-1] != condition[i])
					return;
			}
			
			var someArray:Array = Engine.myLevels.level[Engine.currLevel][Engine.currRoom][1];
			for(i = 0; i < someArray.length; ++i) {
				if (someArray[i][0] == 3) {
					
					someArray[i][4] = true;
				}
			}
			
			devilTrigger();
		}
		
		public function moveHere(e:Event): void {
			if (ourHero.x >= condition[1] && ourHero.x <= condition[2] && 
				ourHero.y >= condition[3] && ourHero.y <= condition[4]) {
				
				devilTrigger();
			}
			
		}
		
		////////////////////////////////////////////////////
		
		public function devilTrigger() {
			eventTriggered = true;
			
			for (var i:uint = 0; i < nextEvent.length; ++i) {
				switch (nextEvent[i][0]) {
					case 1:
						openExit(i);
						break;
					case 2:
						closeExit(i);
						break;
					case 3:
						addPowerUp(i);
						break;
					case 4:
						changeValue(i);
						break;
					case 5:
						loadRoom(i);
						break;
					case 6:
						freezeEverything(i);
						break;
					case 7:
						lockExit(i);
						break;
					case 8:
						unfreezeEverything(i);
						break;
					case 9:
						turnOffBeam(i);
						break;
					case 10:
						turnOnBeam(i);
						break;
				}
			}
			
			removeSelf();
		}
		
		public function openExit(someNum:Number) {
			for(var i:uint = 1; i < nextEvent[someNum].length; ++i) {
				Engine.exitList[nextEvent[someNum][i]].openDoor(nextEvent[someNum][i]);
			}
		}
		
		public function closeExit(someNum:Number) {
			for(var i:uint = 1; i < nextEvent[someNum].length; ++i) {
				Engine.exitList[nextEvent[someNum][i]].closeDoor(nextEvent[someNum][i]);
			}
		}
		
		public function lockExit(someNum:Number) {
			for(var i:uint = 1; i < nextEvent[someNum].length; ++i) {
				Engine.exitList[nextEvent[someNum][i]].lockDoor(nextEvent[someNum][i]);
			}
		}
		
		public function addPowerUp(someNum:Number) {
			var temp:Array = nextEvent[someNum].slice(1,4);
			new Item(stageRef, ourHero, temp, true);
			
			Engine.myLevels.level[Engine.currLevel][Engine.currRoom][4].push(temp);
		}
		
		public function changeValue(someNum:Number) {
		}
		
		public function loadRoom(someNum:Number) {
		}
		
		public function freezeEverything(someNum:Number) {
			Engine.freezeEverything = true;
		}
		public function unfreezeEverything(someNum:Number) {
			Engine.freezeEverything = false;
		}
		
		public function turnOffBeam(someNum:Number) {
			ourHero.lockBeam(true);
		}
		
		public function turnOnBeam(someNum:Number) {
			ourHero.lockBeam(false);
		}
		
		public function removeSelf() : void {
			if (Engine.eventList.indexOf(this) == -1) {
				return;
			}
			
			if (eventTriggered == true) {
				if (fromList == true) {
					var someArray:Array = Engine.myLevels.level[Engine.currLevel][Engine.currRoom][3];
					for (var i:uint = 0; i < someArray.length; ++i) {
						if (someArray[i][0] == condition)
							someArray.splice(i,1);
					}
				}
				
 				Engine.eventList.splice(Engine.eventList.indexOf(this), 1);
			}
			
			switch(condition[0]) {
				case 1:
					removeEventListener(Event.ENTER_FRAME, doAtBeginning);
					break;
				case 2:
					removeEventListener(Event.ENTER_FRAME, killEnemy);
					break;
				case 3:
					removeEventListener(Event.ENTER_FRAME, eliminateEnemies);
					break;
				case 4:
					removeEventListener(Event.ENTER_FRAME, moveHere);
					break;
			}
 
		}
	}
}
