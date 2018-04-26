package com.actionBinderExample
{
	import com.jadbox.flashmvc.SuperModel;
	import com.actionBinderExample.Login;
	public class SuperExampleApp extends SuperModel
	{
		public const LOGIN:String = "Login";
		public static const getInstance:SuperExampleApp = new SuperExampleApp();
		[Bindable] public var loggedIn:Boolean;
		public function SuperExampleApp()
		{
			this.actionAdd(Login);
		}
		
	}
}