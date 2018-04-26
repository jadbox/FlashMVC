package example_com
{
	import com.jadbox.flashmvc.ActionHelper;
	// @ Jonathan Dunlap 2008
	public class DeleteContacts
	{
		public var act:ActionHelper;
		public function DeleteContacts(act:ActionHelper)
		{
			// Can only do this to update the model
			//SuperApp( act.mySuperModel ).contacts={};
			//act.mySuperModelUpdate('contacts');
			act.setVar('contacts', []);
			act.complete(); 
		}
		
	}
}