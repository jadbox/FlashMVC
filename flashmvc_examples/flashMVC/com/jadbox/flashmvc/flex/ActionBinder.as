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
package com.jadbox.flashmvc.flex
{
	import com.jadbox.flashmvc.SuperModel;
	import com.jadbox.flashmvc.SuperModelEvent;
	
	import flash.events.*;
	
	import mx.core.UIComponent;
	
	/**
	* Dispatched when the action completes
	*/	
	[Event(name="actionComplete", type="com.jadbox.flashmvc.SuperModelEvent")]
	/**
	* Dispatched when the action completes by actionHelper.fail();
	*/	
	[Event(name="actionFail", type="com.jadbox.flashmvc.SuperModelEvent")]
	/**
	* Dispatched when at least one of the actions of this name is performing
	*/	
	[Event(name="actionPerforming", type="com.jadbox.flashmvc.SuperModelEvent")]
	/**
	* Dispatched when all actions of this name are not performing
	*/	
	[Event(name="actionStoppedPerforming", type="com.jadbox.flashmvc.SuperModelEvent")]
	/**
	/**
	* Dispatched when the action completes, but only when this component performed it.
	*/	
	[Event(name="actionCompleteLocal", type="com.jadbox.flashmvc.SuperModelEvent")]
	/**
	* Dispatched when the action was added to the SuperModel
	*/	
	[Event(name="actionAdded", type="com.jadbox.flashmvc.SuperModelEvent")]
	/**
	* Dispatched when the action was removed to the SuperModel
	*/	
	[Event(name="actionRemoved", type="com.jadbox.flashmvc.SuperModelEvent")]
	/**
	* Dispatched when the action was enabled on the SuperModel
	*/	
	[Event(name="actionEnable", type="com.jadbox.flashmvc.SuperModelEvent")]
	/**
	* Dispatched when the action was disabled on the SuperModel
	*/	
	[Event(name="actionDisable", type="com.jadbox.flashmvc.SuperModelEvent")]
	[Inspectable("action"="", type="String", category="FlashMVC")]
	[Inspectable("superModel"="", type="Object", category="FlashMVC")]
	[Inspectable("onComplete"=null, type="Object", category="FlashMVC")]
	[Inspectable("onLocalComplete"=null, type="Object", category="FlashMVC")]
	/**
	 * Wraps FlashMVC SuperModel operations for a single action to a MXML component for ease of use.
	 * 
	 * @example The below code is an example usage of this within the view for a Login feature in an simple application:<br/><br/>
	 * &lt;flashMVC:ActionBinder superModel="{mySuperModel}"<br/>
	 * action="{mySuperModel.LOGIN}"<br/>
	 * id="LoginBinder"<br/>
	 * actionComplete="{trace('Login action completed')}"<br/>
	 * actionEnable="{trace('action enabled')}"<br/>
	 * actionDisable="{trace('action disabled')}"<br/>
	 * actionPerforming="{trace('working')}"<br/>
	 * actionStoppedPerforming="{trace('stopped working')}" /&gt; <br/><br/>
	 * &lt;mx:Button label="Perform Action with ActionBinder"<br/>
	 *	enabled="{LoginBinder.actionEnabled}"<br/>
	 *	click="{LoginBinder.perform(username.text,password.text)}"/&gt;<br/>
	 * &lt;mx:Button label="{LoginBinder.actionEnabled?'Disable Login':'Enable Login'}"<br/>
	 *	click="{LoginBinder.actionEnabled=LoginBinder.actionEnabled?false:true}"/&gt;<br/>	
	 * 
	*/
	public class ActionBinder extends UIComponent
	{
		private var _action:String="";
		/**
		* Sets or returns the action name to use with this utility
		*/	
		public function get action():String {
			return _action;
		}
		public function set action(actionName:String):void {
			_action = actionName;
		}
		private var _superModel:SuperModel;
		/**
		* Sets the SuperModel reference that will have the action to monitor
		*/	
		public function get superModel():SuperModel {
			return _superModel;
		}
		public function set superModel(modelReference:SuperModel):void {
			if(_superModel==modelReference && modelReference!=null) return;
			if(_superModel!=null) {
				_superModel.removeEventListener(SuperModelEvent.ACTION_COMPLETE, onCompleteHandler);
				_superModel.removeEventListener(SuperModelEvent.ACTION_ENABLED_CHANGE, onStatusHandler);
				_superModel.removeEventListener(SuperModelEvent.ACTION_ADD_REMOVE, onStatusHandler);
				_superModel.removeEventListener(SuperModelEvent.MODEL_PERFORMING, onStatusHandler);
			}
			_superModel = modelReference;
			if(modelReference==null) return;
			modelReference.addEventListener(SuperModelEvent.ACTION_COMPLETE, onCompleteHandler);
			modelReference.addEventListener(SuperModelEvent.ACTION_ENABLED_CHANGE, onStatusHandler);
			modelReference.addEventListener(SuperModelEvent.ACTION_ADD_REMOVE, onStatusHandler);
			modelReference.addEventListener(SuperModelEvent.MODEL_PERFORMING, onStatusHandler);
		}
		private function onStatusHandler(e:SuperModelEvent):void {
			var name:String;
			//trace(e.name, e.type, e.status);
			if(e.name==_action) {
				//trace(e.status, e.name, e.type);
				if(e.type == SuperModelEvent.MODEL_PERFORMING){
					
					if(e.status) name = "actionPerforming";
					else name = "actionStoppedPerforming";
				}
				else if(e.type == SuperModelEvent.ACTION_ADD_REMOVE){
					if(e.status) name = "actionAdded";
					else name = "actionRemoved";
				}
				else if(e.type == SuperModelEvent.ACTION_ENABLED_CHANGE){
					if(e.status) name = "actionEnable";
					else name = "actionDisable";
					// Update enable bindings
					dispatchEvent(new Event("enableChange"));
				} else return;
				var clone:SuperModelEvent = new SuperModelEvent(name);
				if(e.result) clone.result = e.result;
				if(e.status)  clone.status = e.status;
				dispatchEvent(clone);
			}
		}
		[Bindable(event="enableChange")]
		/**
		* Sets or returns the action enabled state on the SuperModel
		*/	
		public function get actionEnabled():Boolean {
			if(_superModel!=null && _action) return _superModel.isEnabled(_action);
			else return false;
		}
		public function set actionEnabled(enable:Boolean):void {
			if(_superModel!=null && _action) _superModel.setEnabled(_action, enable);
		}
		
		private function onCompleteHandler(e:SuperModelEvent):void {
			//if(e.name==_action) trace("onCompleteHandler: ", _action, e.result);
		//	if(e.name==_action) dispatchEvent(e);
			if(e.name==_action) {
				var clone:SuperModelEvent = new SuperModelEvent(e.status?"actionComplete":"actionFail");
				clone.result = e.result;
				clone.status = e.status;
				clone.name = e.name;
				dispatchEvent(clone);
			}
		}
		private function onLocalCompleteHandler(result:Object):void {
			var clone:SuperModelEvent = new SuperModelEvent(name);
			clone.result = result;
			clone.name = "actionCompleteLocal";
			dispatchEvent(clone);
		}
		/**
		* Performs the action on the SuperModel with the desired params
		*/
		public function perform(...rest):void {
			if(superModel==null || action=="") return;
			var applyVar:Array = rest;
			applyVar.unshift(action,onLocalCompleteHandler)
			superModel.perform.apply(superModel, applyVar);
		}
		
		public function ActionBinder()
		{
			super();
		}
		
	}
}