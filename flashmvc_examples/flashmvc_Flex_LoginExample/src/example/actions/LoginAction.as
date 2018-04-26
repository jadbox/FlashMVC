package example.actions
{
	import com.jadbox.flashmvc2.*;
	import example.*;
	
	import flash.events.Event;
	import flash.utils.*;
	
	public class LoginAction {
		
		public var superWebsite:SuperWebsite;
		private var event:LoginEvent;
		
		public function LoginAction(event:LoginEvent, email:String)
		{
			trace("action class email "+email);
			this.event = event;
			superWebsite = event._superModel as SuperWebsite;
			
			event.errorWasBlank = !email || email=="";
			event.errorWasInvalid = email.indexOf("@") == -1 || email.indexOf(".") == -1;
			
			event.email = email;
			
			// simulate the delay of calling a server.
			setTimeout(onRPC, 1000);
		}
		private function onRPC():void {
			superWebsite.user_profile = "";
			var noError:Boolean = !event.errorWasBlank && !event.errorWasInvalid;
			if(noError) superWebsite.user_profile = "John Doe";
			event.complete(noError);
		}

	}
}