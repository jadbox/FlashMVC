package com.jadbox.flashmvc2
{
	import com.jadbox.flashmvc2.utils.ClassUtil;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	
	/**
	 * This class acts as a singleton to hold global values for a feature. It also holds property references to SuperAction(s) for the view to run them. 
	 * @author Jonathan Dunlap @ JADBOX.com
	 * 
	 */	
	public class SuperModel extends EventDispatcher
	{
		/**
		 * An action of any type is running on the SuperModel 
		 */		
		public static var BUSY:String = "busy";
		/**
		 * There are no actinos running on the SuperModel 
		 */		
		public static var FREE:String = "free";
		
		private var numWorkingActions:int=0;
		/**
		 * Simple Constructor. It will search for properties on itself that are SuperActions to monitor.
		 * 
		 */		
		public function SuperModel()
		{
			super();
			trace("start");
			monitor(superActions);
		}
		private function get superActions():Array {
			var array:Array;
			var xml:XML = describeType(this);
			var properties:XMLList = xml..variable.@name + xml..accessor.@name;
			for each(var i:String in properties) {
				if(this[i] is SuperAction) {
					array=array?array:[];
					array.push(i);
				}
			}
			return array;
		}
		/**
		 * This method will search all SuperActions that accept the SuperEvent type and run it. 
		 * @param e The SuperEvent that the view wants to run an action on.
		 * 
		 */	
		public function runEvent(e:SuperEvent=null):void {
			if(!e) e = new SuperEvent();
			var actions:Array = superActions;
			var action:SuperAction;
			for each(var actionName:String in actions) {
				action = this[actionName];
				if(ClassUtil.typeOf(action.eventRef)==ClassUtil.typeOf(e)) action.runEvent(e);
			}
		}
		
		/**
		 * The constuctor of SuperModel will automatically monitor default properties of type SuperAction.
		 * @param REST The list of SuperAction properties on this supermodel; 
		 * 
		 */		
		protected function monitor(...REST):void {
			if(REST[0] is Array) REST = REST[0];
			var ref:SuperAction;
			for(var i:int=0; i < REST.length; i++) {
				ref = this[REST[i]];
				SuperAction(ref).superModel = this;
				SuperAction(ref).addEventListener(SuperEvent.BUSY, actionStarted);
				SuperAction(ref).addEventListener(SuperEvent.FREE, actionCompleted);
			}
		}
		internal function actionStarted(e:SuperEvent):void {
			numWorkingActions++;
			SuperLogger.appendRun(e);
			dispatchEvent(new Event(SuperModel.BUSY));
		}
		internal function actionCompleted(e:SuperEvent):void {
			numWorkingActions--;
			SuperLogger.appendComplete(e);
			if(!isBusy) dispatchEvent(new Event(SuperModel.FREE));
		}
		/**
		 * Returns true if any actions are running on this SuperModel.
		 * @return Is any actions running
		 * 
		 */		
		public function get isBusy():Boolean {
			return numWorkingActions > 0;
		}
	}
}