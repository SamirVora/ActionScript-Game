package com.uwe.ac.uk.gameControls{
	
	import flash.display.*;
	
	public class PlayerHealthBar extends MovieClip{
		
		//Create healthbar MovieClip variable.
		public static var healthBar:MovieClip;
		
		//Create the player's max health and current health variables.
		private static var playerMaxHealth:int = 200;
		public static var playerCurrentHealth:int = 200;
		
		//Variable to store the current percentage of the player's health.
		private static var percentHealth:Number;
		
		
		//Constructor which gets the instance of the player's healthbar from the stage and instantiates
		// the healthBar variable with it.
		public static function setPlayerHealthBar(theStage:Stage){
			healthBar = theStage.getChildByName("PlayerHealthBar") as MovieClip;
		}
		
		//Function which sets the healthbar ontop of the player.
		public static function setHealthBarOnTopOfPlayer(Player:MovieClip):void{
			healthBar.x = Player.x - 60;
			healthBar.y = Player.y - 30;
		}
		
		//Function to decrease and scale the player's health bar and current health.
		public static function decreasePlayerHealth(Damage:int){
			playerCurrentHealth -= Damage;
			percentHealth = playerCurrentHealth / playerMaxHealth;
			healthBar.barColour.scaleX = percentHealth;
		}
		
		//Function which is called when the player picks up a health plack to increase the player's health.
		public static function increasePlayerHealth(healthAmount:int){
			
			//Get the amount of health which the player might have if the health ammount is to be added onto playerCurrentHealth.
			var totalHealth:int = playerCurrentHealth + healthAmount;
			
			//If the totalHealth exceeds 200 then set the player's current health to 200.
			if(totalHealth > 200){
				
				PlayerHealthBar.playerCurrentHealth = 200;
				
			}else{
				//else add the health to the player's current health.
				playerCurrentHealth += healthAmount;
				
			}
			
			//Caluclate the percentage which the player's health has been increased by.
			percentHealth = playerCurrentHealth / playerMaxHealth;
			
			//Scale the player's healthbar to its current health.
			healthBar.barColour.scaleX = percentHealth;
		}
		
	}
}
