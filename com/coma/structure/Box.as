package com.coma.structure
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.collision.hitBox;
	import com.coma.basics.Engine;
 	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.coma.graphics.*;
	
	public class Box extends Structure
	{
		public var hit:hitBox;
		private var myGraphic:Graphic;
		
		public function Box(stageRef:Stage, width:Number, height:Number, x:Number = 0, y:Number = 0, rot:Number = 0) : void
		{
			
			super(stageRef, width, height, x, y);
			boxWallCircle = 0;
			hit = new hitBox(coordinates, this, stageRef);
			
			canBeDestroyed = false;
			
			myGraphic = new Graphic(stageRef, this, 1, coordinates[2].x-coordinates[0].x, coordinates[2].y-coordinates[0].y);
			
			if (rot != 0) {
				moveSelf(rot);
			}
		}
 
		public override function removeSelf() : void {
			myGraphic.removeSelf();
			
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
			
			if (Engine.structList.indexOf(this) == -1) {
				return;
			}
			
 			Engine.structList.splice(Engine.structList.indexOf(this), 1);
 
 			hit.removeSelf();
		}
		
		public override function takeHit(contactDmg:Number, hitSide:Number = 0):void {
		}
		
		public override function reflect(target:Object):void {
			hit.reflect(target);
		}
		
		public override function moveSelf(angle:Number = 0):void {
			x += vx;
			y += vy;
			vx = 0;
			vy = 0;
			rotation = angle;
			hit.rotateBox();
			myGraphic.readjust();
		}
		
		function checkForCollision():void
		{
		}
 
	}
 
}
