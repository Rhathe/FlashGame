package com.coma.graphics
{
 
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.Engine;
 	import flash.geom.*;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Graphic extends MovieClip
	{
 		public var vx:Number = 0;
		public var vy:Number = 0;
		public var stageRef:Stage;
		public var myObject:Object;
		public var mySprite:Array = new Array();
		private var odoor:BitmapData = new BitmapData(50, 50);
		private var myTileset:BitmapData = new tileset(0,0);
		private var myRect:Rectangle = new Rectangle(0,0, 50, 50);
		private var newWidth:Number;
		private var newHeight:Number;
		private var distFrom:Array = new Array();
 
		public function Graphic(stageRef:Stage, myObject:Object, tile:Number, 
								newWidth:Number, newHeight:Number, inner:Boolean = false) : void
		{
			this.stageRef = stageRef;
			
			this.myObject = myObject;
			this.newWidth = newWidth;
			this.newHeight = newHeight;
			
			myRect.x = 0;
			myRect.y = 50;
			odoor.copyPixels(myTileset, myRect, Engine.Origin);
			
			top(0);
			bottom(1);
			left(2);
			right(3);
			
			myRect.x = 0;
			myRect.y = 100;
			odoor = new BitmapData(50,50);
			odoor.copyPixels(myTileset, myRect, Engine.Origin);
			corners(4);
		}
 
		public function removeSelf() : void {
			for (var i:int = 0; i < mySprite.length; ++i) {
				if (stageRef.contains(mySprite[i])) {
					stageRef.removeChild(mySprite[i]);
				}
			}
			
			if (stageRef.contains(this)) {
				stageRef.removeChild(this);
			}
		}
		
		private function top(i:int) {
			mySprite[i] = new Sprite();
			mySprite[i].graphics.beginBitmapFill(odoor);
			mySprite[i].graphics.drawRect(0, 0, 
										  newWidth, odoor.height);
			mySprite[i].graphics.endFill();
			stageRef.addChild(mySprite[i]);
			mySprite[i].x = myObject.x - newWidth/2;
			mySprite[i].y = myObject.y - newHeight/2 - odoor.height;
			
			distFrom[i] = new Array(mySprite[i].x - myObject.x, mySprite[i].y - myObject.y);
		}
		
		private function bottom(i:int) {
			mySprite[i] = new Sprite();
			mySprite[i].graphics.beginBitmapFill(odoor);
			mySprite[i].graphics.drawRect(0, 0, 
										  newWidth, odoor.height);
			mySprite[i].graphics.endFill();
			stageRef.addChild(mySprite[i]);
			mySprite[i].rotation = 180;
			mySprite[i].x = myObject.x + newWidth/2;
			mySprite[i].y = myObject.y + newHeight/2 + odoor.height;
			
			distFrom[i] = new Array(mySprite[i].x - myObject.x, mySprite[i].y - myObject.y);
		}
		
		private function right(i:int) {
			mySprite[i] = new Sprite();
			mySprite[i].graphics.beginBitmapFill(odoor);
			mySprite[i].graphics.drawRect(0, 0, 
										  newHeight, odoor.height);
			mySprite[i].graphics.endFill();
			stageRef.addChild(mySprite[i]);
			mySprite[i].rotation = 90;
			mySprite[i].x = myObject.x + newWidth/2 + odoor.height;
			mySprite[i].y = myObject.y - newHeight/2;
			
			distFrom[i] = new Array(mySprite[i].x - myObject.x, mySprite[i].y - myObject.y);
		}
		
		private function left(i:int) {
			mySprite[i] = new Sprite();
			mySprite[i].graphics.beginBitmapFill(odoor);
			mySprite[i].graphics.drawRect(0, 0, 
										  newHeight, odoor.height);
			mySprite[i].graphics.endFill();
			stageRef.addChild(mySprite[i]);
			mySprite[i].rotation = 270;			
			mySprite[i].x = myObject.x - newWidth/2 - odoor.width;
			mySprite[i].y = myObject.y + newHeight/2;
			
			distFrom[i] = new Array(mySprite[i].x - myObject.x, mySprite[i].y - myObject.y);
		}
		
		private function corners(i:int) {
			mySprite[i] = new Bitmap(odoor);
			stageRef.addChild(mySprite[i]);
			mySprite[i].x = myObject.x - newWidth/2 - odoor.width;
			mySprite[i].y = myObject.y - newHeight/2 - odoor.height;
			distFrom[i] = new Array(mySprite[i].x - myObject.x, mySprite[i].y - myObject.y);
			++i;
			
			mySprite[i] = new Bitmap(odoor);
			stageRef.addChild(mySprite[i]);
			var radAng:Number = Math.PI/2;
			mySprite[i].transform.matrix = new Matrix(Math.cos(radAng),Math.sin(radAng),
													  -Math.sin(radAng),Math.cos(radAng),0,0); 
			mySprite[i].x = myObject.x + newWidth/2 + odoor.width;
			mySprite[i].y = myObject.y - newHeight/2 - odoor.height;
			distFrom[i] = new Array(mySprite[i].x - myObject.x, mySprite[i].y - myObject.y);
			++i;
			
			mySprite[i] = new Bitmap(odoor);
			stageRef.addChild(mySprite[i]);
			radAng = Math.PI;
			mySprite[i].transform.matrix = new Matrix(Math.cos(radAng),Math.sin(radAng),
													  -Math.sin(radAng),Math.cos(radAng),0,0); 
			mySprite[i].x = myObject.x + newWidth/2 + odoor.width;
			mySprite[i].y = myObject.y + newHeight/2 + odoor.height;
			distFrom[i] = new Array(mySprite[i].x - myObject.x, mySprite[i].y - myObject.y);
			++i;
			
			mySprite[i] = new Bitmap(odoor);
			stageRef.addChild(mySprite[i]);
			radAng = 3*Math.PI/2;
			mySprite[i].transform.matrix = new Matrix(Math.cos(radAng),Math.sin(radAng),
													  -Math.sin(radAng),Math.cos(radAng),0,0);
			mySprite[i].x = myObject.x - newWidth/2 - odoor.width;
			mySprite[i].y = myObject.y + newHeight/2 + odoor.height;
			distFrom[i] = new Array(mySprite[i].x - myObject.x, mySprite[i].y - myObject.y);
		}
		
		public function moveSelf(angle:Number = 0):void {
			x += vx;
			y += vy;
			vx = 0;
			vy = 0;
		}
		
		public function readjust():void {
			for (var i:int = 0; i < mySprite.length; ++i) {
				mySprite[i].x = distFrom[i][0] + myObject.x;
				mySprite[i].y = distFrom[i][1] + myObject.y;
			}
		}
 
	}
 
}
