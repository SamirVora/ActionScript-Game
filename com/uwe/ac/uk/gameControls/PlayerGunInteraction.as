package com.uwe.ac.uk.gameControls{
	
	import flash.display.Stage;
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PlayerGunInteraction extends MovieClip{
		
		//Create an empty Message object variable.
		private var messages:Messages;
		
		//Create MovieClip variables.
		private var thePlayer:MovieClip;
		private var theBackground:MovieClip;
		
		//Create an array to store the guns on the stage.
		private var gunArray:Array = new Array();
		
		//Create an array of the names of the guns on the stage.
		private var gunNameArray:Array = ["GUN_1", "GUN_2", "GUN_3", "GUN_4", "GUN_5"];
		
		//Create an array of the damage each gun does.
		private var gunDamageArr:Array = [10, 10, 20, 20, 25];
		
		//Constructor.
		public function PlayerGunInteraction(Player:MovieClip, gameBackground:MovieClip){
			
			//Assign the obejcts passed in from the paramters to their appropriate objects in this class.
			this.theBackground = gameBackground;
			this.thePlayer = Player;
			
			//Instantiate a new Message object.
			this.messages = new Messages(gameBackground);
			
			//Call a helper function populate the gunArray array with all the guns and their damage.
			populateGunArray(5);
		}
		
		//Function used to set the display of the ammo when the player picks up a gun.
		private function setAmmoDisplay(){
			var headsUpDisplay:MovieClip = theBackground.parent.getChildByName("HeadsUpDisplay") as MovieClip;
			headsUpDisplay.AmmoCurrentlyLoaded.text = 25;
		}
		
		//Function used to populate gunArray with all the guns on the stage and thier damage. 
		private function populateGunArray(gunsOnStage:int){
			
			
			//Iterate through the loop for how ever many guns their are currently on the stage.
			for(var i:int = 0; i < gunsOnStage; i++){
				
				//Get the current gun from the background.
				var gun:MovieClip = theBackground.getChildByName(gunNameArray[i]) as MovieClip;
				
				//Assign an array contining the gun and its damage within the current position in the gunArray array.
				gunArray[i] =  new Array(gun, gunDamageArr[i]);
			}
			
			//Add an event listener to the first gun in the array to show a message to tell the users how to pick
			// up a gun.
			gunArray[0][0].addEventListener(Event.ENTER_FRAME, showPickupMessage);
		}
		
		//Function used to show users a message of how to pick up a gun.
		private function showPickupMessage(pEvent):void{
			
			//Get the gun that has this handler attached to it.
			var theFirstGun:MovieClip = pEvent.currentTarget;
			
			//Proceed only if the player is on top of the first gun.
			if(thePlayer.hitTestPoint(theFirstGun.x, theFirstGun.y)){
				
				//Show the messae, and remove the ENTER_FRAME handler.
				messages.playShootControlMessage();
				theFirstGun.removeEventListener(Event.ENTER_FRAME, showPickupMessage);
			}

		}
		
		//Function used to return the array contianing all the guns on the stage and their damage.
		public function getGunArray():Array{
			return gunArray;
		}
		

	}
}