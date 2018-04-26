package com.jadbox.flashmvc2
{
	import flash.events.EventDispatcher;
	/**
	 * SuperEvent acts like a model for an action class and, at the same time, as a proxy to the constructor of that action class through its own constructor.
	 * @author Jonathan Dunlap @ JADBOX.com
	 * 
	 */	
	public class SuperEvent
	{
		/**
		 * The action has completed (whether successful or not) 
		 */		
		public static var COMPLETE:String = "complete";
		/**
		 * Action is working 
		 */		
		public static var BUSY:String = "busy";
		/**
		 * Action is no longer working 
		 */		
		public static var FREE:String = "free";
		/**
		 * Action is enabled 
		 */		
		public static var ENABLED:String = "enabled";
		/**
		 *  Action is disabled 
		 */		
		public static var DISABLED:String = "disabled";
		
		internal var working:Boolean;
		/**
		 * True if the command finished in a successful way. 
		 */		
		public var successful:Boolean=true;
		/**
		 * A variable to hold a generic value for non-extended SuperEvents. 
		 */		
		public var response:*;
		
		internal var __superModel:SuperModel;
		private var events:EventDispatcher=new EventDispatcher();
		
		internal var _data:Array;
		internal var actionRef:Class;
		internal var onComplete:Function;
		
		internal function get _actionRef():Class {
			return actionRef;
		}
		/**
		 * Constructor. This class should be extended for every action class. 
		 * @param REST This parameter gets passed the extended class's parameters.
		 * 
		 */		
		public function SuperEvent(...REST)
		{
			this._data = REST;
		}
		/**
		 * The action class calls this method to finish/close the class. This method must be called at the once the class is done.
		 * @param success This tells SuperAction and SuperEvent if this action was successful.
		 * 
		 */		
		public function complete(success:Boolean):void {
			this.successful = success;
			if(working) {
				onComplete(success);
			}
			else throw new Error("Only actions can call SuperEvent.complete.");
		}
		/**
		 * Reference to the SuperModel that this class is hooked to by SuperAction. Use this to set global properties.
		 * @return Returns a reference to the supermodel that called this class.
		 * 
		 */		
		public function get _superModel():SuperModel {
			return __superModel;
		}	

	}
}