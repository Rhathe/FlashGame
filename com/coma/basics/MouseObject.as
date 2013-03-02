package com.coma.basics {
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * The KeyObject class recreates functionality of
	 * Key.isDown of ActionScript 1 and 2
	 *
	 * Usage:
	 * var key:KeyObject = new KeyObject(stage);
	 * if (key.isDown(key.LEFT)) { ... }
	 */
	dynamic public class MouseObject extends Proxy {
		
		private static var stage:Stage;
		private static var mDown:Boolean;
		
		public function MouseObject(stage:Stage) {
			construct(stage);
		}
		
		public function construct(stage:Stage):void {
			MouseObject.stage = stage;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mousePressed);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseReleased);
		}
				
		public function isDown():Boolean {
			return mDown;
		}
		
		public function deconstruct():void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mousePressed);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseReleased);
			MouseObject.stage = null;
		}
		
		private function mousePressed(evt:MouseEvent):void {
			mDown = true;
		}
		
		private function mouseReleased(evt:MouseEvent):void {
			mDown = false;
		}
	}
}
