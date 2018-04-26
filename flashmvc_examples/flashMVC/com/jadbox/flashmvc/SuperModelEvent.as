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
	import flash.events.Event;
	/**
	 * Custom events for flashMVC. These are dispatched for you on SuperModel for your view logic.
	 * @author jonathan.dunlap
	 * 
	 */	
	public class SuperModelEvent extends Event
	{
		/**
		 * SuperModel is either performing something or not (e.status true/false) 
		 */		
		public static const MODEL_PERFORMING:String = "modelPerforming";
		/**
		 * Dispatched when a variable has been updated in the SuperModel 
		 */		
		public static const MODEL_UPATED:String = "modelUpdated";
		/**
		 * e.name is the action class name and e.status is true/false if it has been added or just removed from the SuperModel
		 * SuperModel had a variable change from a performing controller (e.name is the var name)
		 */		
		public static const ACTION_ADD_REMOVE:String = "actionAddRemove";
		/**
		 * Dispatched when a action controller is enabled or disabled
    	 * e.name is the action class name and e.status is true/false if it has been enabled or disabled
    	 * 
		 */		
		public static const ACTION_ENABLED_CHANGE:String = "actionEnabledChange";
		/**
		* Dispatched once an action on the SuperModel has finished performing and compeleted.
		 * e.name is the action class name
		 * e.result is the result object that the action class can set
		 * e.status if the command completed successfully. 0 is actionHelper.fail() and 1 is actionHelper.complete()
		*/				
		public static const ACTION_COMPLETE:String = "actionComplete";
		public var name:String;
		public var status:Boolean;
		public var result:Object;
		public function SuperModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public override function toString():String {
			return '[Event type="'+type+'" bubbles='+bubbles+' cancelable='+cancelable+' eventPhase='+eventPhase+' name='+name+' status='+status+' result='+result+']';
		}
		public override function clone():Event {
			return new SuperModelEvent(this.type, this.bubbles, this.cancelable);
		}
		
	}
}