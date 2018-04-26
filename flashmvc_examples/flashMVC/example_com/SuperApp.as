package example_com
{
	import com.jadbox.flashmvc.*;
	import example_com.*;
	import flash.display.*;
	// @ Jonathan Dunlap 2008
	public class SuperApp extends SuperModel
	{  
		[Bindable] public var contacts:Array = [];
		public static const ADD_CONTACT:String = "AddContact";
		public static const DELETE_CONTACTS:String = "DeleteContacts";
		[Bindable] public static var gi:SuperApp = new SuperApp();
		public function SuperApp()
		{
			this.actionAdd(AddContact);
			this.actionAdd(DeleteContacts);
		}
		
	}
}