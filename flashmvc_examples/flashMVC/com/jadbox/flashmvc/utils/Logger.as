package com.jadbox.flashmvc.utils
{
	import com.jadbox.flashmvc.Performance;
	public class Logger {
	
		public static var log:XML = <root></root>;
		public function Logger() {}
		public static function logCompleted(p:Performance):void {
			var superName:String = ClassUtil.typeOf(p.superModel);
			log.appendChild(<log class={p.name} SuperModel={superName}><params>{p.params.toString()}</params></log>);
		}
		public function logPerformceStart(p:Performance):void {}
	}
}