/**
 * FLASHMVC
 * Copyright (c) 2008 Jonathan Dunlap, http://www.jadbox.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package com.jadbox.flashmvc
{
	import com.jadbox.flashmvc.utils.*;
	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	/**
	 * This is the class that your model (or model singleton) will extend from.
	 * 
	 * 
	 */	
	public class SuperModel extends EventDispatcher
	{
		
		private static var sendingLocalConnection:LocalConnection;
		private function doAction(actionName:String):void {
			trace("hit "+actionName);
		}
		/**
		 * data is a variable holder for the user. 
		 */		
		[Bindable] public var data:Object={};
		/**
		 * Used for getting the global log by SuperModel.superModel.log;
		 */		
		[Bindable] public static var superModel:SuperModel = new SuperModel();
		private var _numRunningActions:int=0;
		internal static var _runningActions:Dictionary = new Dictionary();
		private var _actionsCache:Dictionary = new Dictionary();
		private var _agents:Dictionary = new Dictionary();
		/**
		 * When debugMode is enabled (by default), the application will allow a local connection 
		 * from SuperLogger for testing.
		 */	
		public static var debugMode:Boolean = false;
		
		public function SuperModel(){
			 if(!sendingLocalConnection && debugMode) {
				sendingLocalConnection = new LocalConnection();
				sendingLocalConnection.allowDomain('*');
				sendingLocalConnection.addEventListener(StatusEvent.STATUS, function(e:StatusEvent):void { trace("SuperLogger not running."); debugMode=false; });
				
				try {
					sendingLocalConnection.client = this;
					sendingLocalConnection.connect("_flashMVC");	
				} catch(e:Error) { throw new Error(e); }
			} 
		}
		/**
		 * Used for getting the global log by SuperModel.superModel.log;
		 * Returns a global SuperModel XML log of all actions taken place within the running Flash application
		*  @example
		*  <pre lang="xml">
		*	<root>
		*		<add class="AddContact" SuperModel="SuperApp"/>
		*		<add class="DeleteContacts" SuperModel="SuperApp"/>
		*		<change class="DeleteContacts" enabled="false" SuperModel="SuperApp"/>
		*		<log class="AddContact" SuperModel="SuperApp">
		*			<params>tom,25</params>
		*		</log>
		*		<log class="AddContact" SuperModel="SuperApp">
		*  			<params>betty,22</params>
		*		</log>
		*		<change class="DeleteContacts" enabled="true" SuperModel="SuperApp"/>
		*		<log class="DeleteContacts" SuperModel="SuperApp">
		*			<params/>
		*		</log>
		*	</root>
		* </pre>
		* 
		* @return Returns an XML log with actions performed, add, remove, enable, and disable actions
		* 
		*/		
		[Bindable(event="log_updated")]
		public function get log():XML {
			return Logger.log;
		}
		/**
		 * Internal only
		 * 
		 */		
		internal static function registerPerformance(action:Object):SuperModel {
			//trace("performance "+performance);
			_runningActions[action].status="running";			
			return SuperModel(_runningActions[action].SuperModel);
		}
		/**
		 * Internal only
		 * 
		 */		
		internal function completePerformance(actionHelper:ActionHelper, result:Object, successful:Boolean=true):void {
			var meta:Performance = _runningActions[actionHelper];
			if(!meta) { throw new Error("Action command performanced more then one helper.complete() statement. Has result of: "+result.toString() ); };
			Logger.logCompleted(meta);
			bindLog();
			if(successful && meta.onComplete!==null) {
				try {
					meta.onComplete(result);
				} catch(e:Error) { throw new Error("onSuccess function needs to have a result:* parameter for the action's result."); }	
			}
			else if(meta.onFail !== null) {
				try {
					meta.onFail(result);
				} catch(e:Error) { throw new Error("onFail function needs to have a result:* parameter for the action's result."); }
			}
			
			var commandComplete:SuperModelEvent = new SuperModelEvent(SuperModelEvent.ACTION_COMPLETE);
			commandComplete.name = Performance(_runningActions[actionHelper]).name;
			commandComplete.result = result;
			commandComplete.status = successful;
			this.dispatchEvent(commandComplete);
			
			_runningActions[actionHelper].status="done";
			_runningActions[actionHelper]==null;
			delete(_runningActions[actionHelper]);
			_numRunningActions--;
			if(_numRunningActions < 1) {
				var event:SuperModelEvent = new SuperModelEvent(SuperModelEvent.MODEL_PERFORMING);
				event.status = false;
				event.name=commandComplete.name;
				//event.name = ClassUtil.typeOf(this);
				dispatchEvent(event);
			}
		}
		private function bindLog():void {
			dispatchEvent(new Event("log_updated"));
			SuperModel.superModel.dispatchEvent(new Event("log_updated"));
			if(debugMode && SuperModel.superModel.log && sendingLocalConnection) {
				sendingLocalConnection.send("_SuperLogger", "logUpdate", SuperModel.superModel.log);
			}
		}
		private var superModelName:String = ClassUtil.typeOf(this);
		/**
		 * Registers an action class to this model.
		 * @param classRef This is your performance class reference
		 * 
		 */		
		public function actionAdd(classRef:Class):void {
			var name:String = ClassUtil.typeOf(classRef);
			if(name=="" || name==null || !classRef) {throw new Error("Invalid class name added to SuperModel: "+classRef.toString()+", "+name);}
			_actionsCache[name] = {classRef:classRef, status:true};
			Logger.log.appendChild(<add class={name} SuperModel={superModelName}/>);
			bindLog();
			alertPerformanceAddRemove(name, true);
		}
		/**
		 * Removes an action from the model 
		 * @param className This is the performance class name
		 * 
		 */		
		public function actionRemove(className:String):void {
			if(className=="" || className==null) {throw new Error("Invalid class name to be removed from SuperModel: "+className);}
			if(!_actionsCache[className]) return;
			_actionsCache[className] = null;
			delete(_actionsCache[className]);
			Logger.log.appendChild(<remove class={className} SuperModel={superModelName}/>);
			bindLog();
			alertPerformanceAddRemove(className, false);
		}
		/**
		 * Retrieves if an action class is either enabled/disabled
		 * @param className
		 * @return Returns true or false if the class is enabled or disabled
		 * 
		 */		
		[Bindable(event="actionEnabledChange")] 
		public function isEnabled(className:String):Boolean {
			if(!hasAction(className)) return false;
			var cmd:Object = _actionsCache[className];
			var status:Boolean = _actionsCache[className].status;
			return status;
		}
		/**
		 * Sets an action class to be enabled or disabled 
		 * @param className This is the performance class name
		 * @param enabled true/false if you want to enable or disable
		 * 
		 */		
		public function setEnabled(className:String, enabled:Boolean=true):void {
			if( !hasAction(className) ) {trace("Can't enable action "+className+" that does not exist.");return;}
			_actionsCache[className].status = enabled;
			
			Logger.log.appendChild(<change class={className} enabled={enabled} SuperModel={superModelName}/>);
			bindLog();
			alertPerformanceEnabledDisabled(className, enabled);
		}		
		/**
		 * Returns a boolean if an action is registered to the model
		 * @param className This is the performance class name
		 * @return Returns true or false if this model has the class
		 * 
		 */		
		[Bindable(event="actionAddRemove")] 
		public function hasAction(className:String):Boolean {
			return _actionsCache[className]!=null;
		}
		/**
		 * Returns an array of String names for each action on the SuperModel
		 * 
		 */	
		public function actions():Array {
			var a:Array = new Array();
			for (var key:String in _actionsCache)
			{
				a.push(key);
			}
			return a;
		}
		private function alertPerformanceAddRemove(name:String, enabled:Boolean):void {
			var event:SuperModelEvent = new SuperModelEvent(SuperModelEvent.ACTION_ADD_REMOVE);
			event.name = name;
			event.status = enabled;
			dispatchEvent(event);
		}
		private function alertPerformanceEnabledDisabled(name:String, enabled:Boolean):void {
			var event:SuperModelEvent = new SuperModelEvent(SuperModelEvent.ACTION_ENABLED_CHANGE);
			event.name = name;
			event.status = enabled;
			dispatchEvent(event);
		}
		/* public function addAgent(callBack:Function, varName:String = null):void {
			//!default is keyword that callBack is for all events
			if(!_agents[varName]) {
				_agents[varName] = new Array();
			}
			Array(_agents[varName]).push(callBack);
		} */
		[Bindable(event="modelPerforming")] 
		/**
		 * Returns true or false if the model is currently performing any action
		 *
		 */		
		public function get isPerfoming():Boolean {
			return _numRunningActions>0;
		}
		/** 
		 * This method is feed a Performance class which details a command to be excuted by this SuperModel.
		 * @param ...params This is an optional parameter to overrite the Performance parameters.
		*/
		public function process(meta:Performance, ...params):void {
			if (params && params.length > 0) meta.params = params;
			params = meta.params;
			// Command state check
			if(_actionsCache[meta.name]==null) {
				meta.onComplete(null);
				trace("Performance called that was not added:",meta.name);
				return;
			}
			else if(_actionsCache[meta.name].status==false) {
				meta.onComplete(null);
				trace("Performance called was not enabled:",meta.name);
				return;
			}
			//
			var ref:Class = _actionsCache[meta.name].classRef as Class;
			var actionHelper:ActionHelper = new ActionHelper(this);
			_runningActions[actionHelper] = meta;
			var newPerformance:Object;
			
			_numRunningActions++;
			var event:SuperModelEvent = new SuperModelEvent(SuperModelEvent.MODEL_PERFORMING);
			event.status = true;
			event.name = meta.name;
			//event.name = ClassUtil.typeOf(this);
			dispatchEvent(event);
				
			switch(params.length) {
				case 0:
				newPerformance = new ref(actionHelper);
				break;
				case 1:
				newPerformance = new ref(actionHelper,params[0]);
				break;
				case 2:
				newPerformance = new ref(actionHelper,params[0],params[1]);
				break;
				case 3:
				newPerformance = new ref(actionHelper,params[0],params[1],params[2]);
				break;
				case 4:
				newPerformance = new ref(actionHelper,params[0],params[1],params[2],params[3],params[4]);
				break;
				case 5:
				newPerformance = new ref(actionHelper,params[0],params[1],params[2],params[3],params[3],params[4]);
				break;
				case 6:
				newPerformance = new ref(actionHelper,params[0],params[1],params[2],params[3],params[3],params[4],params[5]);
				break;
				default:
				newPerformance = new ref(actionHelper);
			}
			if(!newPerformance) throw new Error("Could not match action class params.");
		}
		/**
		 * Runs an action class that is registered to the SuperModel.
		 * @param className This is the action class name
		 * @param onComplete CallBack function on class action success. The callback needs one param of type Object for any result data from that action class.
		 * @param params The parameters that the performance class expects for its constructor.
		 * 
		 */		
		public function perform(className:String, onComplete:Function=null, ...params):void {
			var meta:Performance = new Performance();
			meta.name = className;
			meta.superModel = this;
			meta.onComplete = onComplete;
			meta.params = params;
			process(meta);
		}
		/** 
		 * This method allows you to specify a success and fail callback function for a particular action class on the supermodel. 
		 * @param action This is the action class name that you are monitoring the result of.
		 * @param success Callback function for when the action completes successfully.
		 * @param fail Callback function for when the action fails.
		*/
		public function addResultListeners(action:String, success:Function=null, fail:Function=null):void {
			var addCallback:Function = function(e:SuperModelEvent):void { 
				if(e.name==action) {
					if(e.status==true && success!==null) {
						try {
							success(e.result);
						} catch(e:Error) { throw new Error("onSuccess function needs to have a result:* parameter for the action's result."); }	
					}
					if(e.status==false && fail!==null) {
						try {
							fail(e.result);
						} catch(e:Error) { throw new Error("onFail function needs to have a result:* parameter for the action's result."); }	
					}
				}
			}
			addEventListener(SuperModelEvent.ACTION_COMPLETE, addCallback, false, 0, true);
		}
		/** 
		 * This method allows you to specify callback functions for when an action is enabled or disabled for a particular action class on the supermodel. 
		 * @param action This is the action class name that you are monitoring the result of.
		 * @param enabled Callback function for when the action is enabled.
		 * @param disabled Callback function for when the action is disabled.
		*/
		public function addStatusListeners(action:String, enabled:Function=null, disabled:Function=null):void {
			var addCallback:Function = function(e:SuperModelEvent):void { 
				if(e.name==action) {
					if(e.status==true && enabled!==null) enabled();
					if(e.status==false && disabled!==null) disabled();
				}
			}
			addEventListener(SuperModelEvent.ACTION_ENABLED_CHANGE, addCallback, false, 0, true);
		}
		/** 
		 * This method allows you to specify callback functions for when an action is added or removed on the supermodel. 
		 * @param action This is the action class name that you are monitoring the result of.
		 * @param added Callback function for when the action is added.
		 * @param removed Callback function for when the action is removed.
		*/
		public function addHasActionListeners(action:String, added:Function=null, removed:Function=null):void {
			var addCallback:Function = function(e:SuperModelEvent):void { 
				if(e.name==action) {
					if(e.status==true && added!==null) added();
					if(e.status==false && removed!==null) removed();
				}
			}
			addEventListener(SuperModelEvent.MODEL_PERFORMING, addCallback, false, 0, true);
		}
		
		
	}
}
