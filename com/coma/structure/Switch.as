package com.coma.structure
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import com.coma.basics.Engine;
	
	public class Switch extends Round
	{
		public var arrayPos:Number;
		
		public function Switch(stageRef:Stage, radius:Number, x:Number = 0, y:Number = 0, switchedOn:Boolean = false) : void
		{
			super(stageRef, radius, x, y, false);
			health = 50;
			
			if (switchedOn == true) {
				gotoAndStop("8");
				health = 0;
			}
			else {
				gotoAndStop("1");
			}
				
			canBeDestroyed = false;
			
			arrayPos = Engine.switchList.length;
			Engine.switchList.push(0);
		}
		
		public override function takeHit(contactDmg:Number, hitSide:Number = 0):void {
			health -= 1;
			
			if (health <= 0) {
				gotoAndStop("8");
				Engine.switchList[arrayPos] = 1;
			}
			else if (health <= 7) {
				gotoAndStop("7");
			}
			else if (health <= 14) {
				gotoAndStop("6");
			}
			else if (health <= 21) {
				gotoAndStop("5");
			}
			else if (health <= 28) {
				gotoAndStop("4");
			}
			else if (health <= 35) {
				gotoAndStop("3");
			}
			else if (health <= 42) {
				gotoAndStop("2");
			}
		}
 
	}
 
}
