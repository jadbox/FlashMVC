package
{
	import com.jadbox.flashmvc.*;
	
	import flash.display.*;
	// @ Jonathan Dunlap 2008
	public class SuperApp extends SuperModel
	{  
		[Bindable] public var contacts:Array = [];
		public static const ADD_CONTACT:String = "AddContact";
		public static const DELETE_CONTACTS:String = "DeleteContacts";
		public static const gi:SuperApp = new SuperApp();
		public function SuperApp()
		{
			this.performanceAdd(AddContact);
			this.performanceAdd(DeleteContacts);
		}
		
	}
}