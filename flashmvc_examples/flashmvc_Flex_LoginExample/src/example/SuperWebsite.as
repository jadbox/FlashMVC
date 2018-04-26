package example
{
	import com.jadbox.flashmvc2.SuperAction;
	import com.jadbox.flashmvc2.SuperModel;
	
	import example.actions.*;
	
	public class SuperWebsite extends SuperModel
	{
		public static const gi:SuperWebsite = new SuperWebsite();
		
		public var user_profile:String;
		public var email:String;
		
		public function SuperWebsite()
		{
			super();
			actionLogin.bindVars("email");
		}
		public var actionLogin:SuperAction = new SuperAction(LoginAction, LoginEvent);
		public var actionInit:SuperAction = new SuperAction(InitAction);
	}
}