package com.jadbox.flashmvc2
{
	import com.jadbox.flashmvc2.utils.ClassUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * This class acts as a proxy to dispatch SuperEvents to your action commands. You do not extend this class for typical framework use.
	 * @author Jonathan Dunlap @ JADBOX.com
	 * 
	 */	
	public class SuperAction
	{
		
		internal var superModel:SuperModel;
		internal var actionRef:Class, eventRef:Class;
		
		private var _enabled:Boolean = true;
		private var events:EventDispatcher = new EventDispatcher();
		private var instances:Dictionary = new Dictionary(false);
		private var instancesNum:int = 0;
		
		/**
		 * The constuctor
		 * @param actionRef Class reference to the class that does an action.
		 * @param eventRef The event class reference that the action class uses for its first parameter.
		 * 
		 */		
		public function SuperAction(actionRef:Class, eventRef:Class=null)
		{
			if(!actionRef) throw new Error("No action class reference provided to SuperAction constructor.");
			if(!eventRef) eventRef = SuperEvent;
			//throw new Error("No event class reference provided to SuperAction constructor.");
			this.eventRef = eventRef;
			this.actionRef = actionRef;
		}
		/**
		 * This is a shorthand for addEventListener. It raps the Event.Complete for when the SuperEvent is successful or not.
		 * @param onSuccess OnSucces function listener
		 * @param onFail OnFail function listener
		 * 
		 */		
		public function addCompleteListener(onSuccess:Function, onFail:Function):void {
			events.addEventListener(SuperEvent.COMPLETE, function(e:SuperActionEvent):void {
				if(e.event.successful) onSuccess(e.event)
				else onFail(e.event);
			} );
		}
		/**
		 * Listener for when an action completes and other statuses (see SuperEvent).
		 * @param type The event name (like SuperEvent.COMPLETE)
		 * @param listener The listener function (the function will need a handler for SuperEvent)
		 * 
		 */		
		public function addEventListener(type:String, listener:Function):void {
			if(listener===null) throw new Error("Listener function was null");
			events.addEventListener(type, function(e:SuperActionEvent):void {
				if(e.event) listener(e.event)
			}, false, 0 , false);
		}
		/**
		 * This method will run the SuperAction with the SuperEvent as its model.
		 * @param e The SuperEvent that the view wants to run an action on.
		 * 
		 */		
		public function runEvent(e:SuperEvent=null):void {
			run(e?e:new SuperEvent());
		}
		/**
		 * Tells if an action is enabled. If an action is disabled, it will not be dispatched.
		 * @return if this action is enabled. 
		 * 
		 */		
		public function get enabled():Boolean {
			return _enabled;
		}
		/**
		 * Sets the status of the action. If an action is disabled, it will not be dispatched.
		 * 
		 */	
		public function set enabled(status:Boolean):void {
			_enabled = status;
			if(_enabled) events.dispatchEvent(new SuperActionEvent(SuperEvent.ENABLED, new SuperEvent() ));
			else events.dispatchEvent(new SuperActionEvent(SuperEvent.DISABLED, new SuperEvent() ));
		}
		/**
		 * Tells if an action of this type is currently running.
		 * @return Is this action working?
		 * 
		 */		
		public function get isBusy():Boolean {
			return instancesNum > 0;
		}
		
		private function run(e:SuperEvent):void {
			if(!e) throw new Error("Tried to run a null SuperEvent.");
			if(!_enabled) {
				trace("Command "+ClassUtil.typeOf(actionRef)+ " was called but was disabled.");
				return;
			}
			
			if(typeof(this.eventRef)==typeof(e)) {
				e.onComplete = function(success:Boolean=true):void { 	
					instancesNum--;
					if(!isBusy) events.dispatchEvent(new SuperActionEvent(SuperEvent.FREE, e));
					events.dispatchEvent(new SuperActionEvent(SuperEvent.COMPLETE, e));
					///if(success) events.dispatchEvent(new SuperActionEvent(SuperEvent.SUCCESS, e));
					///else events.dispatchEvent(new SuperActionEvent(SuperEvent.FAIL, e));
					
					delete instances[e];
					instances[e] = null;
					
				}
				
				///if(this.superModel) this.superModel.actionStarted();
				
				e.working = true;
				e.__superModel = this.superModel;
				e.actionRef = actionRef;
				
				events.dispatchEvent(new SuperActionEvent(SuperEvent.BUSY, e));
				
				switch(e._data?e._data.length:0) {
				case 0:
				instances[e] = new actionRef(e);
				break;
				case 1:
				instances[e] = new actionRef(e, e._data[0]);
				break;
				case 2:
				instances[e] = new actionRef(e, e._data[0], e._data[1]);
				break;
				case 3:
				instances[e] = new actionRef(e, e._data[0], e._data[1], e._data[2]);
				break;
				case 4:
				instances[e] = new actionRef(e, e._data[0], e._data[1], e._data[2], e._data[3]);
				break;
				case 5:
				instances[e] = new actionRef(e, e._data[0], e._data[1], e._data[2], e._data[3], e._data[4]);
				break;
				case 6:
				instances[e] = new actionRef(e, e._data[0], e._data[1], e._data[2], e._data[3], e._data[4], e._data[5]);
				break;
				case 7:
				instances[e] = new actionRef(e, e._data[0], e._data[1], e._data[2], e._data[3], e._data[4], e._data[5], e._data[6]);
				break;
				case 8:
				instances[e] = new actionRef(e, e._data[0], e._data[1], e._data[2], e._data[3], e._data[4], e._data[5], e._data[6], e._data[7]);
				case 9:
				instances[e] = new actionRef(e, e._data[0], e._data[1], e._data[2], e._data[3], e._data[4], e._data[5], e._data[6], e._data[7], e._data[8]);
				break;
				default:
				instances[e] = new actionRef(e);
			}
				instancesNum++;
			}
			else throw new Error("SuperEvent mismatch.");
		}
		
	}
}



import flash.events.Event;
import com.jadbox.flashmvc2.SuperEvent;
/**
 * Internal use only for SuperAction. This is used to proxy events. 
 * @author jonathan.dunlap
 * 
 */
class SuperActionEvent extends Event {
//	public static var SUCCESS:String = "SUCCESS";
//	public static var FAIL:String = "FAIL";
		
	public var event:SuperEvent;
	public function SuperActionEvent(name:String, event:SuperEvent):void {
		this.event = event;
		super(name);	
	}
	public override function clone():Event {
		return new SuperActionEvent(type, event);
	}
}