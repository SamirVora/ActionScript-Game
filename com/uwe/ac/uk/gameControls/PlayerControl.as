package com.uwe.ac.uk.gameControls {
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import com.uwe.ac.uk.gameControls.*;
	
	public class PlayerControl extends MovieClip{
		
		
		//Create class variables
		private var movePlayer:PlayerMovement;
		private var playerShoot:PlayerShoot;
		private var backgroundCollision:BackgroundCollision;
		private var playerGunInteraction:PlayerGunInteraction;
		private var gameSound:GameSound;
		private var healthPacks:HealthPacks;
		
		//Create MovieClip variables
		private var thePlayer:MovieClip;
		private var theEnemy:MovieClip;
		private var backgroundObjects:MovieClip;
		
		//Create variables to hold the boolean values of which button the user has pressed.
		private var up:Boolean = false;
		private var down:Boolean = false;
		private var left:Boolean = false;
		private var right:Boolean = false;
		private var spaceBar:Boolean = false;
		
		//A boolean value to tell if the player is holding a gun or not.
		public var holdingGun:Boolean = false;
		
		//The name of the frames to be set when the player either walks or stands.
		public var playerWalkAnimation:String = "walk";
		public var playerStandAnimation:String = "stand";
		
		//Variables to hold the radian and degrees between the player MovieClip and the mouse.
		private var mouseToPlayerRadians:Number;
		private var degrees:Number;
		
		
		//The constructor listens for when the class has been added to the stage.
		public function PlayerControl() {
			this.addEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
		}
		
		
		//This function is called when this class has been added to the stage.
		private function classAddedToStage(event:Event):void{
			
			//Remove the ADDED_TO_STAGE listener and focus on the stage.
			removeEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
			stage.focus = stage;
			
			//Get the player MovieClip instance from the stage.
			thePlayer = stage.getChildByName("Player") as MovieClip;
			
			//Get the background MovieClip instance from the stage.
			var theBackground:MovieClip = stage.getChildByName("theBackground") as MovieClip;
			
			//Get the backgroundObjects MovieClips instance from the Background.
			backgroundObjects = theBackground.getChildByName("BackgroundObjects") as MovieClip;
			
			//set the player's healthbar on top of the player.
			PlayerHealthBar.setPlayerHealthBar(stage);
			
			//Instantiate the relevant classes to give functionality to the player.
			movePlayer = new PlayerMovement(theBackground);
			gameSound = new GameSound();
			playerShoot = new PlayerShoot(this.stage, thePlayer, theBackground);
			backgroundCollision = new BackgroundCollision(thePlayer, backgroundObjects);
			healthPacks = new HealthPacks(thePlayer, theBackground);
			
			//Add listeners for when the user presses and releases the correct buttons to control the player.
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		    stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			//Add ENTER_FRAME listener to handle the interactivity between the user and the player MovieClip.
			stage.addEventListener(Event.ENTER_FRAME, playerControlHandler);
		}

		
		//Handler to enable interactivity between the user and the player MovieClip.
		private function playerControlHandler(event:Event):void{
			
			//Turn the player towards which ever way the mouse is facing.
			turnPlayerTowardsMouse(this.stage, thePlayer);
			
			//Set the player's healthbar on top of the player.
			PlayerHealthBar.setHealthBarOnTopOfPlayer(thePlayer);
			
			//Call the function to detect if the player is colliding with the background objects.
			backgroundCollision.detectBackgroundCollision();
			
			/*
			* The following If statements move the player in the appropriate direction based on what key the
			* user is pressing. It also sets the run animation for the player.
			*/
		   if(up == true && ScrollBackground.isScrolling == false){
				movePlayer.moveUp(thePlayer);
				thePlayer.gotoAndStop(playerWalkAnimation);
			}
			
			if(down == true && ScrollBackground.isScrolling == false){
				movePlayer.moveDown(thePlayer);
				thePlayer.gotoAndStop(playerWalkAnimation);
			}
			
			if(left == true && ScrollBackground.isScrolling == false){
				movePlayer.moveLeft(thePlayer);
				thePlayer.gotoAndStop(playerWalkAnimation);
			}
			
			if(right == true && ScrollBackground.isScrolling == false){
				movePlayer.moveRight(thePlayer);
				thePlayer.gotoAndStop(playerWalkAnimation);
			}
			
			//If the player is not holding a gun and the user has pressed the space bar then call a function 
			// to pick up the gun which the player might be ontop of. The check to see if the player is actually
			// on top of a gun is handled within the PlayerShoot class.
			if(spaceBar == true && holdingGun == false){
				playerShoot.pickUpGun();
				holdingGun = playerShoot.getIsPlayerHoldingGun();
			}
			
			//If holdingGun is true then set the current animation to the player MovieClip holding the gun.
			if(holdingGun == true){
				playerStandAnimation = "Gun1";
				playerWalkAnimation = "Gun1";
			}
			
			//If the player's health has reached 0 then remove this listenr.
			if(PlayerHealthBar.playerCurrentHealth == 0){
				stage.removeEventListener(Event.ENTER_FRAME, playerControlHandler);
			}
		}

		
		//Function to manually remove the playerControlHandler handler. This is used to reset the game.
		public function removePlayerControl(){
			//Call removePlayerShootHandler to remove its handler.
			playerShoot.removePlayerShootHandler();
			stage.removeEventListener(Event.ENTER_FRAME, playerControlHandler);
		}
		
		
		//The handler to detect which keyboard key has been pressed by the user. 
		private function keyDownHandler(event:KeyboardEvent):void{

			switch(event.keyCode){
				case 87:
					up = true;
					break;
				case 83:
					down = true;
					break;
				case 65:
					left = true;
					break;
				case 68:
					right = true;
					break;
				case 32:
					spaceBar = true;
					//Set the player's animation without the gun.
					playerStandAnimation = "stand";
					playerWalkAnimation = "walk";
					thePlayer.gotoAndStop("stand");
					holdingGun = false;
					playerShoot.setIsPlayerHoldingGun(false);
					break;
			}
			
		}
		
		
		//The handler to detect which keyboard key has been released by the user. 
		private function keyUpHandler(event:KeyboardEvent):void{
			
			switch(event.keyCode){
					case 87:
						up = false;
						thePlayer.gotoAndStop(playerStandAnimation);
						break;
					case 83:
						down = false;
						thePlayer.gotoAndStop(playerStandAnimation);
						break;
					case 65:
						left = false;
						thePlayer.gotoAndStop(playerStandAnimation);
						break;
					case 68:
						right = false;
						thePlayer.gotoAndStop(playerStandAnimation);
						break;
					case 32:
						spaceBar = false;
						break;
			}
		}
		
		//Function to enable the player to rotate towards when the mouse cursor is pointing.
		private function turnPlayerTowardsMouse(stageMouse:DisplayObject, player:MovieClip):void{
			
			//Get the radians between the player and the mouse.
			 mouseToPlayerRadians = Math.atan2((stageMouse.mouseY - player.y), (stageMouse.mouseX - player.x));
			 
			//Convert the radians to degrees.
			 degrees = mouseToPlayerRadians * 180 / Math.PI;
			 
			//Rotate the player to the degrees set.
			player.rotation = degrees;
		}

		
	}//Class
}