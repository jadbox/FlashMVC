package example.actions
{
	import com.jadbox.flashmvc2.SuperEvent;
	
	public class InitAction
	{
		public function InitAction(model:SuperEvent)
		{
			model.complete(true);
		}

	}
}