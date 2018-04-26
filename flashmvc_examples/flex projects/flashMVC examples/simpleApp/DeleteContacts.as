package
{
	import com.jadbox.flashmvc.PerformanceHelper;
	// @ Jonathan Dunlap 2008
	public class DeleteContacts
	{
		public var act:PerformanceHelper;
		public function DeleteContacts(act:PerformanceHelper)
		{
			// Can only do this to update the model
			//SuperApp( act.mySuperModel ).contacts={};
			//act.mySuperModelUpdate('contacts');
			act.setVar('contacts', []);
			act.complete(); 
		}
		
	}
}