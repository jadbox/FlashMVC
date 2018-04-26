package
{
	import com.jadbox.flashmvc.PerformanceHelper;
	import flash.utils.*;
	// @ Jonathan Dunlap 2008
	public class AddContact
	{
		public var act:PerformanceHelper;
		public function AddContact(act:PerformanceHelper,name:String,phone:int)
		{
			this.act = act;
			// Increase timeout delay to 1500 to emulate RPC
			setTimeout(onDelay, 1 ,name,phone);
		}
		public function onDelay(name:String,phone:int):void {
			// Can only do this to update the model
			//SuperApp( act.mySuperModel ).contacts.push({name:name, phone:phone});
			//act.mySuperModelUpdate('contacts');
			act.setVarRelative('contacts', {name:name, phone:phone});
			act.result="This is the object that gets passed to the 'perfom' command's callBack function";
			act.complete(); 
		}
		
	}
}