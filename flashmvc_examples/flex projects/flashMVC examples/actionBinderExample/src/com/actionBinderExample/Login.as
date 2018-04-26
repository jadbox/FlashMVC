package com.actionBinderExample
{
	import com.jadbox.flashmvc.ActionHelper;
	
	public class Login
	{
		private var helper:ActionHelper;
		private var model:SuperExampleApp;
		public function Login(helper:ActionHelper, userName:String, password:String)
		{
			this.helper=helper;	
			model = SuperExampleApp(helper.mySuperModel);
			//Pretend this is where you send you're service to be validated
			pretendServiceHandler(userName, password); 
		}
		public function pretendServiceHandler(userName:String, password:String):void {
			if(userName=="admin" && password=="admin") model.loggedIn=true;
			helper.complete();
		}

	}
}