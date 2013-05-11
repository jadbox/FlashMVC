package com.jadbox.flashmvc2
{
	import com.jadbox.flashmvc2.utils.ClassUtil;
	import flash.utils.describeType;
	/**
	 *  Logs all actions that execute on SuperModels.
	 * @author Jonathan Dunlap @ JADBOX.com
	 * 
	 */	
	public class SuperLogger
	{
		public namespace true_internal;
		private static var _log:XMLList = new XMLList();
		
		/**
		 * Set this to false to disable the logger to save memory. This is enabled by default. 
		 */		
		public static var enabled:Boolean = true;
		/**
		 * Resets the log. 
		 * 
		 */		
		public static function clearAll():void {
			_log = new XMLList();
		}
		/**
		 * 
		 * @return Returns log in an XML format
		 * 
		 */		
		public static function get log():XMLList {
			return _log.copy();
		}
		/**
		 * Returns a tracable output of the log.
		 * @return String output of the global log.
		 * 
		 */		
		public static function get logString():String {
			var text:String="SuperLogger LOG OUTPUT\n";// ="Log output of "+ClassUtil.typeOf(superModel)+"\n";
			for(var i:int=0; i < _log.length(); i++) {
				text+=_log[i]+"\n";
			}
			text+="END OF LOG";
			return text;
		}
		internal static function appendRun(superEvent:SuperEvent):void {
			if(!enabled) return;
			var actionName:String = ClassUtil.typeOf(superEvent._actionRef);
			var superModelName:String = ClassUtil.typeOf(superEvent.__superModel);
			_log += <log><actionStarted><name>{actionName}</name><SuperModel>{superModelName}</SuperModel><parameters>{superEvent._data.join(", ")}</parameters></actionStarted></log>;
		}
		
		internal static function appendComplete(superEvent:*):void {
			if(!enabled) return;
			var actionName:String = ClassUtil.typeOf(superEvent._actionRef);
			var superModelName:String = ClassUtil.typeOf(superEvent.__superModel);
			
			var xml:XML = describeType(superEvent);
			var properties:XMLList = xml..variable.@name + xml..accessor.@name;
			var result:String="";
			for each (var text:String in properties) {
				if(text != "_superModel" && superEvent[text]) result += "<"+text+">" + superEvent[text] + "</"+text+">";
			}
			
			_log += <log><actionCompleted><name>{actionName}</name><SuperModel>{superModelName}</SuperModel><result>{XMLList(result)}</result></actionCompleted></log>;
		}
		internal static function appendStatus(superEvent:*):void {
			if(!enabled) return;		
		}
	}
}