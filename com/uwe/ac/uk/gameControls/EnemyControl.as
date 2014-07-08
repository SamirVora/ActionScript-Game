package com.uwe.ac.uk.gameControls {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	public class EnemyControl extends MovieClip{
		
		//Create class vairables.
		private var enemyAttack:EnemyAttack;
		
		//Create MovieClip variables.
		private var thePlayer:MovieClip;
		private var theEnemy:MovieClip;
		private var theBackground:MovieClip;
		
		//The array to hold all the enemies created.
		private var enemyArray:Array = new Array;
		
		//Array to hold the nearest enemies to the player.
		private var clossestEnemiesArray:Array = new Array();
		
		//An array which holds the x and y position of the all the enmies to be created. 
		// for example, 130 and 230 are the x and y coordinates for the first enemy, -530, and 140 for the second, etc.
		private var enemyCoordinates:Array = [130, 230, -530, 140, -550, 310, -480, -300, -300, -270, 200, -110, 280, -300, 580, -360, 
											  	450, -740, 90, -760, 470, -860];
		
		//Counter to handle the index positions within the array.
		private var arrayIndexCounter:int = 0;
		
		
		//Constructor. Listens for when the class has been added to the stage.
		public function EnemyControl() {
			this.addEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
		}

		//Function called when the class has been added to the stage.
		private function classAddedToStage(event:Event):void{
			
			//Remove the listener for checking when the class has been added to the stage.
			removeEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
			
			//Set focus on the stage.
			stage.focus = stage;
			
			//Get the player and the background instances from the stage.
			thePlayer = stage.getChildByName("Player") as MovieClip;
			theBackground = stage.getChildByName("theBackground") as MovieClip;
			
			//Instantiate the EnemyAttack class.
			enemyAttack = new EnemyAttack(this.stage, thePlayer, theBackground);
			
			//Call the function to create 11 enemies.
			createEnemies(11);
			
			//Add an ENTER_FRAME Listener to control variables within the class.
			stage.addEventListener(Event.ENTER_FRAME, controlEnemiesHandler);
		}

		//An ENTER_FRAME handler for controling the variables within the class.
		private function controlEnemiesHandler(event:Event){
			
			//If the stage is not scrolling and there is more than one enemy on the stage then 
			// sort the clossestEnemiesArray to the nearest enemies to the player.
			if(ScrollBackground.isScrolling == false && enemyArray.length >= 1){
				
				sortArrayByNearestEnemies(thePlayer);
				
				//If the stage is scrolling the empty out the clossestEnemiesArray.
			}else if(ScrollBackground.isScrolling == true){
				
				clossestEnemiesArray.length = 0;
				
			}
			
			//If the player's health has reached 0 then remove this function
			if(PlayerHealthBar.playerCurrentHealth == 0){
				stage.removeEventListener(Event.ENTER_FRAME, controlEnemiesHandler);
			}
		}
		
		
		//Function to manually remove controlEnemiesHandler ENTER_FRAME handler.
		// This is used when the game is reset.
		public function removeEnemiesHandler(){
			clossestEnemiesArray.length = 0;
			stage.removeEventListener(Event.ENTER_FRAME, controlEnemiesHandler);
		}
		
		
		//Function which creates enemy MovieClips and adds them to the stage.
		private function createEnemies(numberOfEnemies:Number):void {
			
			//Loop through how many enemies there are to be created.
			for(var i = 0; i < numberOfEnemies; i++){
				
				//Create a new empty object
				var enemyObject:Object;
				
				//Create a new enemy MovieClip, healthbar, and EnemyHealthBar class to be associated with each individual enemy.
				var currentEnemy:EnemyFull_Symb = new EnemyFull_Symb; 
				var enemyHealthBarSymb:Enemy_HealthBar_Symb = new Enemy_HealthBar_Symb;
				var enemyHealthBarClassObject:EnemyHealthBar = new EnemyHealthBar();
				
				//Add the enemy and its healthbar to the stage.
				theBackground.addChild(currentEnemy);
				theBackground.addChild(enemyHealthBarSymb);

				//Set the position of the enemy and its healthbar based on the array coordinates.
				currentEnemy.x = enemyCoordinates[arrayIndexCounter];
				enemyHealthBarSymb.x = enemyCoordinates[arrayIndexCounter] - 60;
				
				arrayIndexCounter++;
				
				currentEnemy.y = enemyCoordinates[arrayIndexCounter];
				enemyHealthBarSymb.y = enemyCoordinates[arrayIndexCounter] - 30;
				
				arrayIndexCounter++;
				
				//Attach the properties of the enemy MovieClip, healthbar MovieClip, healthbar class object and empty variables to
				// store the distance between it and the player to the current enemy object.
				enemyObject = {enemy:currentEnemy, enemyHealthBarClassObj:enemyHealthBarClassObject, EnemyHealthBar:enemyHealthBarSymb, 
				                 distanceTotal:0, distanceX:0, distanceY:0}
				
				//Add the enemy object to the array.
				enemyArray.push(enemyObject);
			}			
		}
		
		
		//Function which return the enemy array containing all the enemies on the stage.
		public function getEnemiesOnStageArr():Array{
			return enemyArray;
		}
		
		
		//Function which returns the nearest enemies to the player.
		public function getClosestEnemies():Array{
			return clossestEnemiesArray;
		}
		
		
		//Function which sorts the enemyArray to contain the most nearest enemy first.
		private function sortArrayByNearestEnemies(player:MovieClip):void{
			
			//Loop through each enemy within the array to sort them.
			for(var i:int = 0; i < enemyArray.length; i++){
				
				//Globalise the current enemy's position to the Stage.
				var globalEnemyPos:Point = theBackground.localToGlobal(new Point(enemyArray[i].enemy.x, enemyArray[i].enemy.y));				
				
				//Create an Object variable for the current enemy in the loop.
				var currentEnemy:Object = enemyArray[i];				

				//Set the distance between the enemy and the player.
				currentEnemy.distanceX =  globalEnemyPos.x - thePlayer.x;
				currentEnemy.distanceY =  globalEnemyPos.y - thePlayer.y;
				
				//Square root the distanceX and distanceY squared.
				currentEnemy.distanceTotal = Math.sqrt(currentEnemy.distanceX * currentEnemy.distanceX + currentEnemy.distanceY * currentEnemy.distanceY);
				
				//sort the array based on the enemy object's "distanceTotal" parameter
				//This is sorting the array four times. Ones for every time round the loop
				
				//For every iteration through the loop sort the array based on the distanceTotal property of each of the enemy within the array.
				enemyArray.sortOn("distanceTotal", Array.NUMERIC);				
				
				//Get the global position of the current enemy.
				globalEnemyPos = theBackground.localToGlobal(new Point(enemyArray[0].enemy.x, enemyArray[0].enemy.y));
				
				//Call the functions to set the enemy to follow and turn towards the player.
				setEnemyFollow(globalEnemyPos);
				setTurnEnemy(globalEnemyPos);
			}
		}

		
		//Function which enables the enemy to follow the player.
		private function setEnemyFollow(globalEnemyPos:Point){
			
			//Check if the enemy's position is within the stage boundries.
			if(isEnemyWithinStageBounds(globalEnemyPos)){
				
				//Get the absolute distance between the player and the enemy.
				var playerAndEnemyRange_X = Math.abs(thePlayer.x - globalEnemyPos.x);
				var playerAndEnemyRange_Y = Math.abs(thePlayer.y - globalEnemyPos.y);
				
				//Only enable the enemy to follow the player when within a certain range.
				if((playerAndEnemyRange_X > 200 || playerAndEnemyRange_Y > 200) && (playerAndEnemyRange_X < 300 || playerAndEnemyRange_Y < 300)){
					
					//Call a function within the EnemyAttack class to follow the player.
					enemyAttack.enemyFollowPlayer();
					
					//Set the enemy's animation to run.
					enemyAttack.setRunningAnimation(true);
				}else{
					//Set the enemy's animation to stand.
					enemyAttack.setRunningAnimation(false);
				}
			}
		}


		//Function which will enable the enemy to turn towards the player.
		private function setTurnEnemy(globalEnemyPos:Point){
			
			//Only continue if the enemy's position is within the stage boundries.
			if(isEnemyWithinStageBounds(globalEnemyPos)){

				//Only progress if the enemy and player are within a certain range.
				if(Math.abs(globalEnemyPos.x - thePlayer.x) < 300 && Math.abs(globalEnemyPos.y - thePlayer.y) < 300){
					
					//Call the function within EnemyAttack to turn towards the player.
					enemyAttack.enemyTurnToPlayer();
					
					//Add the current enemy at the first position within the clossestEnemiesArray.
					clossestEnemiesArray[0] =  new Array(enemyArray[0].enemy, enemyArray[0].EnemyHealthBar);
					
					//Check if the enemyArray contains more than one enemy.
					if(enemyArray.length > 1){
						
						var secondGlobalEnemyPos:Point = theBackground.localToGlobal(new Point(enemyArray[1].enemy.x, enemyArray[1].enemy.y));

						if(isEnemyWithinStageBounds(secondGlobalEnemyPos)){
							
							if(Math.abs(thePlayer.x - secondGlobalEnemyPos.x) < 300 && Math.abs(thePlayer.y - secondGlobalEnemyPos.y) < 300){
								
								clossestEnemiesArray[1] =  new Array(enemyArray[1].enemy, enemyArray[1].EnemyHealthBar);
								
							}else{
								clossestEnemiesArray.splice(1, 1);
							}
						}
					
					
					}else{ //If enemyArray does not contain more than one enemy then splice the array at position 1 and only insert the first enemy.
						clossestEnemiesArray.splice(1, 1);
						clossestEnemiesArray[0] =  new Array(enemyArray[0].enemy, enemyArray[0].EnemyHealthBar);
					}
					
					//Call the setNearestEnemyArray within the EnemyAttack class to set the array for the clossest enemies to the player.
					enemyAttack.setNearestEnemyArray(clossestEnemiesArray);
				}
			}
		}
			
			
		//helper function which checks if the enemy position passed in is within the stage bounds.
		private function isEnemyWithinStageBounds(enemyPosition:Point):Boolean{
			
			if(enemyPosition.x > 0 && enemyPosition.y > 0 && enemyPosition.x < 700 && enemyPosition.y < 500){
				return true;
			}else{
				return false;
			}
		}

	}
}