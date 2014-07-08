package com.uwe.ac.uk.gameControls{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	
	public class EnemyAttack extends MovieClip{
		
		//Create Class variables.
		private var gameSound:GameSound;
		private var enemyCollision:EnemyCollision;
		
		//Create MovieClip variables
		private var thePlayer:MovieClip;
		private var theBackground:MovieClip;
		private var theStage:Stage;
		private var backgroundObjects:MovieClip;

		//An array to store the nearest enemies to the player
		private var nearestEnemiesArray:Array = new Array();
		
		//create variables to define the stage width and height.
		private var stage_Width:int;
		private var stage_Height:int;
		
		//Boolean to check if the enemy is currently running towards the player or not.
		private var isEnemyRunning:Boolean = false;		
		
		//Counters for the shoot timings of the enemies.
		private var firstEnemyShootCount:int = 0;
		private var secondEnemyShootCount:int = 0;
		
		//The count at which the next bullet will be fired.
		private var bulletLoadTime:int = 15;		
		
		
		//The constructor for the class.
		public function EnemyAttack(theGameStage:Stage, Player:MovieClip, Background:MovieClip){
			
			//Instantiate MovieClips from parameters passed in.
			this.thePlayer = Player;
			this.theBackground = Background;
			this.theStage = theGameStage;
			
			//Instantiate the stage width and height.
			this.stage_Width = theStage.width;
			this.stage_Height = theStage.height;
			
			//Get the background objects from the stage to instantiate the backgroundObjects variable.
			this.backgroundObjects = theBackground.getChildByName("BackgroundObjects") as MovieClip;
			
			//Get the GameSound class from the stage to play and control the game's sound.
			this.gameSound = theStage.getChildByName("GameSound") as GameSound;
			
			//Instatiate the EnemyCollision class so the enemies have hit detection on background objects.
			enemyCollision = new EnemyCollision(backgroundObjects);
		}
		
		
		//Funtion which sets the nearest enemies to players.
		public function setNearestEnemyArray(nearestEnemies:Array){
			nearestEnemiesArray = nearestEnemies;
		}
	
		
		//Function sets the animation for the enemy running.
		public function setRunningAnimation(enemyRunning:Boolean){
			
			//Loop through all the nearest enemies to the player.
			for(var i:int = 0; i < nearestEnemiesArray.length; i++){
				
				//If the boolean passed from the paramter is true, then set the enemy's animation to run.
				if(enemyRunning == true){
					nearestEnemiesArray[i][0].gotoAndStop("enemy_run");
					isEnemyRunning = enemyRunning;
				}else{
					//Else set the enemy's animation to walk, and fire the bullet.
					initiateEnemyFire();
					nearestEnemiesArray[i][0].gotoAndStop("enemy_gun");
					isEnemyRunning = enemyRunning
				}
				
			}
		}
		
		
		
		//Function which enables the enemies to follow the player.
		public function enemyFollowPlayer(){
			
			//Loop through all the enemies in the array.
			for(var i:int = 0; i < nearestEnemiesArray.length; i++){
				
				//get the current enemy and its healthbar within the loop.
				var enemy:MovieClip =  nearestEnemiesArray[i][0];
				var enemyHealthBar:MovieClip = nearestEnemiesArray[i][1];
				
				//Localise the player's coordinates to the background so the radians could be calculated more easily.
				var playerLocalPos:Point = theBackground.globalToLocal(new Point(thePlayer.x, thePlayer.y));

				//Calculate the radians between the player and the enemy.
				var runRadian:Number = Math.atan2(playerLocalPos.y - enemy.y, playerLocalPos.x - enemy.x);
				
				//Move the enemy towards the player.
				enemy.x += Math.cos(runRadian) * 1;
				enemy.y += Math.sin(runRadian) * 1;
				
				//Move the enemy's healthbar with the enemy.
				enemyHealthBar.x = enemy.x - 60;
				enemyHealthBar.y = enemy.y - 30;
			}				
		}
		
		
		//Funtion which allows the enemy to turn and face the player.
		public function enemyTurnToPlayer(){
			
			//Loop through the nearest enemies to the player.
			for(var i:int = 0; i < nearestEnemiesArray.length; i++){
				
				//Get the current enemy within the loop
				var enemy:MovieClip = nearestEnemiesArray[i][0];
				
				//Get the player's local coordinates reletive to the background.
				var playerLocalPos:Point = theBackground.globalToLocal(new Point(thePlayer.x, thePlayer.y));

				//Find the radians between the player and the enemy.
				var turnRadian:Number = Math.atan2(playerLocalPos.y - enemy.y, playerLocalPos.x - enemy.x);
				
				//Convert the radians into degress to rotate the enemy with.
				var degrees:Number = 360*(turnRadian/(2*Math.PI));
				
				//rotate the enemy
				enemy.rotation = degrees;
				
				//Call the function to make the enemy shoot.
				initiateEnemyFire();
				
				//Detect collision between the background and the enemy.
				enemyCollision.detectBackgroundCollision(enemy);
			}
		}

		
		//Function which enables the enemy to shoot at the player.
		public function initiateEnemyFire(){
			
			//Only shoot when the nearestEnemiesArray is not empty.
			if(nearestEnemiesArray.length != 0){
				
				//If the array contains two enemies then make them both shoot, else if it contains just one enemy, then make it shoot.
				if(nearestEnemiesArray.length > 1){
					nearestEnemiesArray[0][0].addEventListener(Event.ENTER_FRAME, firstEnemyFire);
					nearestEnemiesArray[1][0].addEventListener(Event.ENTER_FRAME, secondEnemyFire);
				}else{
					nearestEnemiesArray[0][0].addEventListener(Event.ENTER_FRAME, firstEnemyFire);
				}
			}
		}
		
		

		//Function to make the first enemy shoot.
		public function firstEnemyFire(pEvent):void{
			
			//If the first array position is not empty, and if the enemy MovieClip is not in the array, 
			// then remove listener for this function.
			if(nearestEnemiesArray[0] != null && nearestEnemiesArray[0].indexOf(pEvent.currentTarget) == -1){
				
				pEvent.currentTarget.removeEventListener(Event.ENTER_FRAME, firstEnemyFire);
				
				//Continue if the array at position 0 is not empty, and the enemy has more than 0 health. 
			}else if(nearestEnemiesArray[0] != null && PlayerHealthBar.playerCurrentHealth > 0){
				
				//Incriment the shoot time counter for the first enemy.
				firstEnemyShootCount++;
				
				//When the counter reaches the load time then call upon the shoot function.
				if(firstEnemyShootCount >= bulletLoadTime){
					firstEnemyShootCount = 0;
					shootBullet(pEvent.currentTarget, thePlayer, theStage);
				}
			}
			
		}
		
		
		//Function to make the second enemy shoot.
		public function secondEnemyFire(pEvent):void{
			
			//If the first array position is not empty, and if the enemy MovieClip is not in the array, 
			// then remove listener for this function.
			if(nearestEnemiesArray[1] != null && nearestEnemiesArray[1].indexOf(pEvent.currentTarget) == -1){
				
				pEvent.currentTarget.removeEventListener(Event.ENTER_FRAME, secondEnemyFire);
				
				//Continue if the array at position 1 is not empty, and the enemy has more than 0 health. 
			}else if(nearestEnemiesArray[1] != null && PlayerHealthBar.playerCurrentHealth > 0){
				
				//Incriment the shoot time counter for the second enemy.
				secondEnemyShootCount++;
				
				//When the counter reaches the load time then call upon the shoot function.
				if(secondEnemyShootCount >= bulletLoadTime){
					secondEnemyShootCount = 0;
					shootBullet(pEvent.currentTarget, thePlayer, theStage);
				}
			}
		}
		
		
		//This functions creates a new bullet instance and makes it follow the trajectory between the enemy and the player.
		private function shootBullet(enemy:MovieClip, thePlayer:MovieClip, theStage:Stage){
			
			//Play the sound effect for the gun firing.
			gameSound.playEnemyGunShot();
			
			//Create a new instance of the enemyBullet_Symb.
			var theBullet:MovieClip = new enemyBullet_Symb;
			
			//Get the global position of the enmey.
			var globalEnemyPos:Point = enemy.parent.localToGlobal(new Point(enemy.x, enemy.y));
			
			//Get the radians between the player and the enemy.
			var bulletRadian = Math.atan2(thePlayer.y - globalEnemyPos.y, thePlayer.x - globalEnemyPos.x);
			
			//Rotate the bullet so that it faces the correct direction when shot.
			rotateBullet(theBullet, thePlayer, globalEnemyPos);
			
			//Store the trajectory of the bullet within their relevant properties.
			theBullet.trajectory_X = Math.cos(bulletRadian) * 10;
			theBullet.trajectory_Y = Math.sin(bulletRadian) * 10;
			
			//Set the bullet's position ontop of the enemy.
			theBullet.x = globalEnemyPos.x;
			theBullet.y = globalEnemyPos.y;
			
			//Add the bullet to the stage/
			theStage.addChild(theBullet);
			
			//Set the childIndex so the bullet does not appear under the background.
			theStage.setChildIndex(theBullet, 1);
			
			//Make the bullet visible.
			theBullet.visible = true;
			
			//Add an ENTER_FRAME Listener so each bullet will follow their own trajectory.
			theBullet.addEventListener(Event.ENTER_FRAME, bulletFollowTrajectory);
		}
		
		
		//Function to rotate the bullet.
		private function rotateBullet(theBullet:MovieClip, thePlayer:MovieClip, enemyPos:Point){
			
			//Find the radian between the enemy and the player.
			 var bulletRadian:Number = Math.atan2((enemyPos.y - thePlayer.y), (enemyPos.x - thePlayer.x));
			 
			//Convert the radians into degrees.
			 var degrees:Number = (bulletRadian * 180) / Math.PI;
			 
			//Rotate the bullet.
			theBullet.rotation = degrees;
		}
		
		
		//Function which enables the bullet to follow its trajectory.
		private function bulletFollowTrajectory(pEvent){
			
			//Create a MovieClip instance of the bullet.
			var bullet:MovieClip = pEvent.currentTarget;
			
			//Incriment the bullet's position to follow the trajectory set.
			bullet.x += bullet.trajectory_X;
			bullet.y += bullet.trajectory_Y;
			
			//Check if the bullet has hit the player.
			checkIfBulletHitPlayer(theStage, thePlayer, bullet);
			
			//Check is the bullet has hit any background obejcts.
			checkIfBulletHitBackgroundObjects(theStage, backgroundObjects, bullet);
			
			//Check is the bullet has gone out of the stage's bounds.
			checkIfBulletOutOfStageBounds(theStage, bullet);
		}
		

		//Function to check is the bullet has one out of the stage's bounds.
		private function checkIfBulletOutOfStageBounds(theStage:Stage, bullet:MovieClip){
			
			//Only progress if the bullet is on the stage.
			if(theStage.contains(bullet)){
				 
				 //Check if the bullet has gone of the stage's bound
				 if(bullet.x < 0 || bullet.y < 0 || bullet.x > stage_Width || bullet.y > stage_Height){
					
					//Remove the bullet if it has.
					theStage.removeChild(bullet);
					bullet = null;
					
					//create a new bullet MovieClip.
					bullet = new enemyBullet_Symb;
				}	
			}
		}
		
		
		//Check if the bullet has hit the player.
		private function checkIfBulletHitPlayer(theStage:Stage, thePlayer:MovieClip, bullet:MovieClip){
			
			//Only progress if the player's health is above 0.
			if(PlayerHealthBar.playerCurrentHealth > 0){
				
				//Check if the bullet is within the stage.
				if(theStage.contains(bullet)){
					
					//Check if the bullet has hit the player.
					if(thePlayer.hitTestPoint(bullet.x, bullet.y, true)){
						
						//Remove the bullet and decrease the player's health by 10.
						theStage.removeChild(bullet);
						PlayerHealthBar.decreasePlayerHealth(10);
						
						//Make the MovieClip null and create 
						bullet = null;
						bullet = new enemyBullet_Symb;
					}
				}
			}
		}
		
		
		//Check if the bullet has hit any background objects.
		private function checkIfBulletHitBackgroundObjects(theStage:Stage, backgroundObjects:MovieClip, bullet:MovieClip){
			
			//Only continue if the bullet is on the stage.
			if(theStage.contains(bullet)){
				//Check if the bullet has hit any background objects.
				if(backgroundObjects.hitTestPoint(bullet.x, bullet.y, true)){
					
					//Remove bullet from the stage and create a new bullet symbol.
					theStage.removeChild(bullet);
					bullet = null;
					bullet = new enemyBullet_Symb;
				}
			}
		}


	}//Class
}
