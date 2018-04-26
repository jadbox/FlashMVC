package example
{
	import com.jadbox.flashmvc2.SuperEvent;
	
	public class LoginEvent extends SuperEvent
	{
		public var errorWasBlank:Boolean;
		public var errorWasInvalid:Boolean;
		
		public var email:String;
		
		public function LoginEvent(email:String)
		{
			super(email);
		}

	}
}
