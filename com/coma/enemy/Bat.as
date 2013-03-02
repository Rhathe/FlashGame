package com.coma.enemy
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.*;
 
	public class Bat extends Enemy {

		public function Bat(stageRef:Stage, target:Hero, someArray:Array, fromList:Boolean = false) : void {
			
			super(stageRef, target, someArray, fromList);
			v = 4;
			health = 30;
		}
	}
 
}
