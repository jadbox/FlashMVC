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
	import flash.events.*;
	import flash.utils.*;
	/**
	 * This class is passed into the first parameter of the constructor of your action class
	 * @author jonathan.dunlap
	 * 
	 */	
	public class ActionHelper
	{
		private var _superModel:SuperModel;
		private var _superClassName:Class;
		private var _result:Object={};
		/**
		 * This is called internally as the user never creates a new PerformanceHelper manually.
		 * 
		 */		
		public function ActionHelper(type_this:SuperModel)
		{
			_superModel = type_this;
			//_classInstance = type_this;
			//_superModel = SuperModel.registerPerformance(type_this);
		}
		/**
		 * Tells the framework that the action class has completed its action
		 * and that it can be scheduled for garbage collection. 
		 * 
		 */		
		public function complete(successful:Boolean = true):void {
			_superModel.completePerformance(this, _result, successful);
		}
		/**
		 * Tells SuperModel listeners that the model has update
		 * @param varName Variable name that was updated
		 * 
		 */		
		public function mySuperModelUpdate(varName:String=null):void {
			var event:SuperModelEvent = new SuperModelEvent(SuperModelEvent.MODEL_UPATED);
			event.name = varName;
			if(varName) _superModel.dispatchEvent(event);
	 	}
		/**
		 * Returns its parent SuperModel for model changing.
		 * Be sure to call mySuperModelUpdate to let SuperModel view listeners
		 * know that the SuperModel variables have been updated.
		 * 
		 */	 	
		public function get mySuperModel():SuperModel {
			return _superModel;
		}
		/**
		 * Returns a variable value from this action's SuperModel
		 * 
		 */		
		public function getVar(varName:String):* {
			try {return _superModel[varName];}
			catch(e:Error) {trace("var not found")};
		}
		/**
		 * Sets a variable value on this action's SuperModel.
		 * 
		 */		
		public function setVar(varName:String, value:*):* {
			var event:SuperModelEvent = new SuperModelEvent(SuperModelEvent.MODEL_UPATED);
			event.name = varName;
			try {_superModel[varName] = value;}
			catch(e:Error) {trace("var "+varName+" not found. ",e.message);return null;};
			_superModel.dispatchEvent(event);
			return _superModel[varName];
		}
		/**
		 * Sets a variable value relative to its current value on this action's SuperModel.
		 * For arrays, it will push the data to the existing array.
		 */		
		public function setVarRelative(varName:String, value:*):* {
			var event:SuperModelEvent = new SuperModelEvent(SuperModelEvent.MODEL_UPATED);
			event.name = varName;
			try {
			if(_superModel[varName] is Array) _superModel[varName].push(value);
			else _superModel[varName]+=value;
			
			}
			catch(e:Error) {trace("var "+varName+" not found");return null;};
			_superModel.dispatchEvent(event);
			return _superModel[varName];
		}
		/**
		 * This variable is pushed into the onComplete result object that the view implements by the SuperModel.perform method. 
		 * Use this variable when you need to tell only the calling view a certain piece of data.
		 * 
		 */		
		public function get result():Object {
			return _result;
		}
		public function set result(obj:Object):void {
			_result=obj;
		}

	} 
}

// SuperModel:
// public var data:int; // for example
// public const GETXML:String = "GetXML";
// constuctor {
// 	addPerformance(GetXML);
// }

// Command:
// constuctor(act:Performance, param1, param2, etc) {
// 	act.tellModel.data+=1;
//  act.result.showButton = true;
// 	act.complete(fail:Boolean=false);
// }

// View:
// SuperGallery.gi.perform("GetXML", onComplete, ...data);
// or
// SuperGallery.gi.perform(SuperGallery.GETXML, onComplete, ...data);
// function onComplete(e:Object):void {
// 	trace( e.showButton );
// }
// SuperGallery.agent(callBack, "onVarName"=null)
// SuperModelAgent(SuperModel, "var");
