package  com.uwe.ac.uk.gameControls{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	
	public class Ammunition{
		
		//Create GameSound class variable.
		private var gameSound:GameSound;
		
		//Create MovieClip variables.
		private var theBackground:MovieClip;
		private var headsUpDisplay:MovieClip;
		private var thePlayer:MovieClip;
		
		//Create ammo variable to hold how much ammo the player currently has.
		private var ammo:int = 0;
		
		//Create an array containing the name of all the Ammo boxes on the background.
		private var ammoBoxNames:Array = ["AMMO_1", "AMMO_2", "AMMO_3", "AMMO_4"];
		
		
		//Constructor.
		public function Ammunition(theBackground:MovieClip, player:MovieClip) {
			
			//Instantiate the GameSound variable.
			gameSound = new GameSound();
			
			//Assign the MovieClips passed from the function's prarameters to the appropriate variable.
			this.theBackground = theBackground;
			this.thePlayer = player;
			
			//Get the heads up display MovieClip from the background.
			this.headsUpDisplay = theBackground.parent.getChildByName("HeadsUpDisplay") as MovieClip;
			
			//Add an ENTER_FRAME listener to the stage to detect if the player is on top of an ammo box.
			theBackground.parent.addEventListener(Event.ENTER_FRAME, detectAmmoPickup);
		}
		
		
		//A handler which is used to loop through all the ammo box names see if the player is on top of
		// the ammo box which it represents.
		private function detectAmmoPickup(event:Event){
			
			//Loop through all the ammo box names.
			for(var i:int = 0; i < ammoBoxNames.length; i++){
				
				//Get the ammo box from theBackground with the child name of the current ammoBoxNames at index i.
				var currentAmmoBox:MovieClip = theBackground.getChildByName(ammoBoxNames[i]) as MovieClip;
				
				//Only progress if currentAmmoBox is not null.
				if(currentAmmoBox != null){
					
					//Get the global position of the ammo box.
					var globalAmmoBoxCoords:Point = theBackground.localToGlobal(new Point(currentAmmoBox.x, currentAmmoBox.y));
					
					//If the player is on top of the ammo box then remove the ammo box and increase the ammo in the ammo variable.
					if(thePlayer.hitTestPoint(globalAmmoBoxCoords.x, globalAmmoBoxCoords.y, true)){
						
						theBackground.removeChild(currentAmmoBox);
						ammo += 25;
						
						//Update the heads up display with the current ammo amount.
						headsUpDisplay.AmmoCurrentlyLoaded.text = ammo;
						
						//Play the ammo pickup sound effect.
						gameSound.playPickUpAmmoSound();
					}
					
				}
				
			}
			
		}
		
		//Function to return the current ammo amount.
		public function getCurrentAmmoAmount():int{
			return this.ammo;
		}
		
		//function to add ammo the the current ammo amount.
		public function addAmmo(){
			this.ammo += 35;
		}
		
		//Function to set the heads up display to show the correct ammo amount.
		public function setDisplayAmmoAmount(){
			headsUpDisplay.AmmoCurrentlyLoaded.text = ammo;
		}
		
		//Function to decrease the ammo from the current ammo amount.
		public function decreaseAmmo(){
			ammo -= 1;
			headsUpDisplay.AmmoCurrentlyLoaded.text = ammo;
		}
		
		

	}//class
	
}
