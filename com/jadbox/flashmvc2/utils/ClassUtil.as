package com.jadbox.flashmvc2.utils
{
	import flash.utils.ByteArray;
	import flash.utils.*;
	import flash.utils.getQualifiedSuperclassName;
	// @ Jonathan Dunlap 2008
	public class ClassUtil
	{
		public static function cloneObject(source:Object):* {
         var copier:ByteArray = new ByteArray();
         copier.writeObject(source);
         copier.position = 0;
         return(copier.readObject());
		}
		public static function typeOf(obj:Object):String{
			var desc:String = flash.utils.getQualifiedClassName(obj);
			var a:Array = desc.split(/::/);
			return a[a.length-1];
			return getQualifiedClassName(obj);
		}
		public static function typeSubclassedFrom(obj:Object, derivedFrom:String):Boolean{
			var desc:String = flash.utils.getQualifiedSuperclassName(obj);
			var search:RegExp = new RegExp(derivedFrom);
			return search.test(desc);
		}
	}
}