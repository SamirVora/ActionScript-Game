package com.uwe.ac.uk.gameControls {
	
	import flash.display.MovieClip;
	import flash.display.*;
	
	public class BossHealthBar {
		
		//Create an empty MovieClip variable to store the Boss's healthbar.
		public var bossHealthBar:MovieClip;
		
		//Set the max health and current health.
		private var bossMaxHealth:int = 500;
		public var bossCurrentHealth:int = bossMaxHealth;
		
		//Create an empty variable to store the percentage amount of the Boss's health.
		private var healthPercentage:Number;
		
		//Constructor.
		public function BossHealthBar(theBossHealthBar:MovieClip, theBackground:MovieClip){
			
			//Assign theBossHealthBar to the empty bossHealthBar.
			this.bossHealthBar = theBossHealthBar;
			
			//Add the healthbar to the background.
			theBackground.addChild(bossHealthBar);
			
			//Set the position of the healthbar.
			bossHealthBar.x = -620;
			bossHealthBar.y = -750;
		}
		
		//Function used to get the current health of the Boss.
		public function getCurrentBossHealth():int{
			return bossCurrentHealth;
		}
		
		//Function used to set the healthbar on top of the Boss.
		public function setHealthBarOnTopOfBoss(theBoss:MovieClip):void{
			bossHealthBar.x = theBoss.x - 60;
			bossHealthBar.y = theBoss.y - 30;
		}
		
		//Function used to update the healthbar of the boss based on the damage passed in within its parameter.
		public function updateBossHealthBar(Damage:int){
			bossCurrentHealth -= Damage;
			healthPercentage = bossCurrentHealth / bossMaxHealth;
			bossHealthBar.bossHealthBarColour.scaleX = healthPercentage;
		}


	}
	
}
