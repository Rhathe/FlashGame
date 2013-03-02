package com.coma.structure
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.Engine;
 	import flash.geom.Point;
	
	public class Structure extends MovieClip
	{
 		public var vx:int = 0;
		public var vy:int = 0;
		public var stageRef:Stage;
		public var boxWallCircle:Number;
		public var coordinates:Array = new Array();
		public var health:Number;
		public var canBeDestroyed:Boolean;
		public var canGetHit:Boolean = true;
		public var permeableState:Number = 0; //If 0, can't be passed but hit,
											  //If 1, can't be passed or hit
											  //If 2, practically not there
											  //If 3, can be passed and hit
		
 
		public function Structure(stageRef:Stage, width:Number, height:Number, x:Number = 0, y:Number = 0) : void
		{
			this.stageRef = stageRef;
			stageRef.addChild(this);
			
			if (width != 0 || height != 0) {
				//this.width = width;
				//this.height = height;
			}
			
			this.x = x;
			this.y = y;
			
			coordinates[0] = new Point(x - width/2, y - height/2);
			coordinates[1] = new Point(x + width/2, y - height/2);
			coordinates[2] = new Point(x + width/2, y + height/2);
			coordinates[3] = new Point(x - width/2, y + height/2);
			
			Engine.structList.push(this);
		}
 
		public function removeSelf() : void {
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
			
			if (Engine.structList.indexOf(this) == -1) {
				return;
			}
			
 			Engine.structList.splice(Engine.structList.indexOf(this), 1);
		}
		
		public function takeHit(contactDmg:Number, hitSide:Number = 0):void {
		}
		
		public function reflect(target:Object):void {
		}
		
		public function moveSelf(angle:Number = 0):void {
			x += vx;
			y += vy;
			vx = 0;
			vy = 0;
		}
 
	}
 
}
