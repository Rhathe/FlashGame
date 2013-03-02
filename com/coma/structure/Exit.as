package com.coma.structure
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.Engine;
	import com.coma.basics.Hero;
	import flash.geom.*;
	
	public class Exit extends MovieClip
	{
 
		private var stageRef:Stage;
		private var ourHero:Hero;
		private var structure:Object;
		public var direct:String;
		public var pos:String;
		public var room:Number;
		public var nextExit:Number;
		public var isDoorOpen:Number = 0;
		public var vx:int = 0;
		public var vy:int = 0;
		public var distFrom:Array;
 
		public function Exit(stageRef:Stage, structure:Object, ourHero:Hero, pos:String, direct:String, 
							 room:Number, nextExit:Number, ratio:Number = 0.5, isDoorOpen:Number = 0) : void
		{
			this.stageRef = stageRef;
			stageRef.addChild(this);
			
			this.ourHero = ourHero;
			this.direct = direct;
			this.pos = pos;
			this.structure = structure;
			this.room = room;
			this.nextExit = nextExit;
			this.isDoorOpen = isDoorOpen;
			
			if (isDoorOpen == 1) {
				var colorTransform:ColorTransform = transform.colorTransform;
				colorTransform.color = 0xFFFF00;
				transform.colorTransform = colorTransform;
			}
			
			if (isDoorOpen == 2) {
				colorTransform = transform.colorTransform;
				colorTransform.color = 0x00FFFF;
				transform.colorTransform = colorTransform;
			}
			
			hitBox.height = ourHero.radius + 5;
			
			setExit(ratio);
			Engine.exitList.push(this);
		}
		
		public function setExit(ratio:Number): void {
			if (pos == "top") {
				x = ratio*(structure.coordinates[2].x - structure.coordinates[0].x)
					+ structure.coordinates[0].x;
				y = structure.coordinates[0].y;
			}
			else if (pos == "bottom") {
				x = ratio*(structure.coordinates[2].x - structure.coordinates[0].x)
					+ structure.coordinates[0].x;
				y = structure.coordinates[2].y;
			}
			else if (pos == "right") {
				y = ratio*(structure.coordinates[2].y - structure.coordinates[0].y)
					+ structure.coordinates[0].y;
				x = structure.coordinates[2].x;
			}
			else if (pos == "left") {
				y = ratio*(structure.coordinates[2].y - structure.coordinates[0].y)
					+ structure.coordinates[0].y;
				x = structure.coordinates[0].x;
			}
			
			if (direct == "north")
				y -= Engine.bounds/2;
			else if (direct == "south") {
				y += Engine.bounds/2;
				rotation = 180;
			}
			else if (direct == "east") {
				x += Engine.bounds/2;
				rotation = 90;
			}
			else if (direct == "west") {
				x -= Engine.bounds/2;
				rotation = 270;
			}
				
			distFrom = new Array(x - structure.x, y - structure.y);
		}
		
		public function moveOut(someNum:Number): Boolean {
			if (isDoorOpen == 1) 
				return false;
			else if (isDoorOpen == 2) {
				if (ourHero.keysForDoor > 0 && checkDoorStatus() == true) {
					--ourHero.keysForDoor;
					openDoor(someNum);
					return true;
				}
				return false;
			}
			else {
				return checkDoorStatus();
			}
		}
		
		private function checkDoorStatus():Boolean {
			if (direct == "north" && ourHero.vy < 0) {
				return true;
			}
			else if (direct == "south" && ourHero.vy > 0) {
				return true;
			}
			else if (direct == "east" && ourHero.vx > 0) {
				return true;
			}
			else if (direct == "west" && ourHero.vx < 0) {
				return true;
			}
			else
				return false;
		}
		
		public function openDoor(someNum:Number) {
			var colorTransform:ColorTransform = transform.colorTransform;
			colorTransform.color = 0xFF0000;
			transform.colorTransform = colorTransform;
			
			isDoorOpen = 0;
			Engine.myLevels.level[Engine.currLevel][Engine.currRoom][2][someNum][6] = 0;
		}
		
		public function closeDoor(someNum:Number) {
			var colorTransform:ColorTransform = transform.colorTransform;
			colorTransform.color = 0xFFFF00;
			transform.colorTransform = colorTransform;
			
			isDoorOpen = 1;
			Engine.myLevels.level[Engine.currLevel][Engine.currRoom][2][someNum][6] = 1;
		}
		
		public function lockDoor(someNum:Number) {
			var colorTransform:ColorTransform = transform.colorTransform;
			colorTransform.color = 0x00FFFF;
			transform.colorTransform = colorTransform;
			
			isDoorOpen = 2;
			Engine.myLevels.level[Engine.currLevel][Engine.currRoom][2][someNum][6] = 2;
		}
		
		public function moveSelf():void {
			x += vx;
			y += vy;
			vx = 0;
			vy = 0;
		}
		
		public function readjust():void {
			x = distFrom[0] + structure.x;
			y = distFrom[1] + structure.y;
			vx = 0;
			vy = 0;
		}
		
		public function removeSelf() : void {
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
			
			if (Engine.exitList.indexOf(this) == -1) {
				return;
			}
			
 			Engine.exitList.splice(Engine.exitList.indexOf(this), 1);
 
		}
		
	}
 
}
