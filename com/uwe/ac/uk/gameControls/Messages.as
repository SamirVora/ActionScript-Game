package com.uwe.ac.uk.gameControls{
	
	import flash.events.*;
	import flash.display.*;
	
	public class Messages extends MovieClip{
		
		//Create MovieClip variables
		private var theBackground:MovieClip;
		private var keyControlMessage:MovieClip;
		
		//Constructor
		public function Messages(gameBackground:MovieClip){
			this.theBackground = gameBackground;
		}
		
		//Function used to display the message to tell users how to control the player.
		public function playKeyControlMessage():void{
			var theMessage:MovieClip = new key_control_message;
			theMessage.x = 350;
			theMessage.y = 422;
			this.theBackground.addChild(theMessage);
		}
		
		//Function used to display messages to tell users how to pick up a gun.
		public function playShootControlMessage():void{
			var theMessage:MovieClip = new PickGunUp_Message_Symb;
			theMessage.x = 350;
			theMessage.y = 422;
			this.theBackground.addChild(theMessage);
		}
		
		//function used to tell users to collect keys to open boss gate.
		public function playCollectKeysMessage():void{
			var theMessage:MovieClip = new collectKeyMessae_Symb;
			theMessage.x = 350;
			theMessage.y = 422;
			this.theBackground.parent.addChild(theMessage);
		}
		
	}
}