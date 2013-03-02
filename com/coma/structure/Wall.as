package com.coma.structure
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.collision.hitLine;
	import com.coma.basics.Engine;
 	import flash.geom.*;
	
	public class Wall extends Structure
	{
		public var hit:hitLine;
		private var owidth:Number;
 
		public function Wall(stageRef:Stage, width:Number , x:Number = 0, y:Number = 0, rot:Number = 0) : void
		{
			super(stageRef, width, 1, x, y);
			owidth = width;
			
			var tempRec:Rectangle = this.getBounds(stageRef);
			boxWallCircle = 1;
			hit = new hitLine(new Point(tempRec.x, tempRec.y), new Point(tempRec.x + width, tempRec.y), this);
			
			canBeDestroyed = false;
			
			if (rot != 0) {
				moveSelf(rot);
			}
		}
		
		public override function reflect(target:Object):void {
			if (permeableState == 0 && permeableState == 1)
				hit.reflect(target, target.radius);
		}
		
		public function stretch(p1:Point, p2:Point) {
			var mydist:Number = flash.geom.Point.distance(p1, p2);
			var midPt = flash.geom.Point.interpolate(p1, p2, 0.5);
			rotation = 0;
			width = mydist;
			var myangle:Number = Math.atan2(p1.y-p2.y, p1.x-p2.x);
			rotation = myangle*180/Math.PI;
			x = midPt.x;
			y = midPt.y;
		}
		
		public override function moveSelf(angle:Number = 0):void {
			x += vx;
			y += vy;
			rotation = angle;
			hit.moveLine();
			vx = 0;
			vy = 0;
		}
		
		function checkForCollision():void
		{
		}
 
	}
 
}
