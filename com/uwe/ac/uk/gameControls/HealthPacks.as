package  com.uwe.ac.uk.gameControls{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class HealthPacks{
		
		//Create a GameSound variable.
		private var gameSound:GameSound;
		
		//Create MovieClip variables.
		private var thePlayer:MovieClip;
		private var theBackground:MovieClip;
		
		//Create an array which stores all the names of the health packs placed on the background.
		private var healthPackNames:Array = ["HEALTH_1", "HEALTH_2", "HEALTH_3", "HEALTH_4"];
		
		
		//Constructor.
		public function HealthPacks(player:MovieClip, theBackground:MovieClip) {
			
			//Instantiate the GameSound object.
			gameSound = new GameSound();
			
			//Assign the empty MovieClip variables with the variables passed in from the parameters.
			this.thePlayer = player;
			this.theBackground = theBackground;
			
			//Add an ENTER_FRAME to constantly listen if the player is on top of a health pack.
			theBackground.parent.addEventListener(Event.ENTER_FRAME, detectHealthPickup);
		}
		

		//Function used to detect if the player is on top of a health pack.
		private function detectHealthPickup(event:Event){
			
			//Loop through all the health pack names in the array.
			for(var i:int = 0; i < healthPackNames.length; i++){
				
				//Get the healthPack from theBackground with the child name of the current healthPackNames at index i.
				var healthPack:MovieClip = theBackground.getChildByName(healthPackNames[i]) as MovieClip;
				
				//Proceed if healthPack is not null an the player's health is less than 200.
				if(healthPack != null && PlayerHealthBar.playerCurrentHealth < 200){
					
					//Get the global position of the current health pack.
					var globalHealthPackPos:Point = theBackground.localToGlobal(new Point(healthPack.x, healthPack.y));
					
					//Check if the player is on top of the health pack.
					if(thePlayer.hitTestPoint(globalHealthPackPos.x, globalHealthPackPos.y, true)){
						//Play the drinking sound effect.
						gameSound.playDrinkingSound();
						
						//Increase the health of the player.
						PlayerHealthBar.increasePlayerHealth(70);
						
						//remove the current health pack.
						theBackground.removeChild(healthPack);
					}
					
				}
				
			}
			
		}

	}
}
