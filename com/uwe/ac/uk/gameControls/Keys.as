package com.uwe.ac.uk.gameControls{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	
	public class Keys extends MovieClip{
		
		//Create class variables
		private var gameSound:GameSound;
		
		//Create MovieClip variables
		private var thePlayer:MovieClip;
		private var theBackground:MovieClip;
		private var backgroundObjects:MovieClip;
		private var headsUpDisplay:MovieClip;
		
		//Create an array containing the name of the keys on the background.
		private var keyNameArr:Array = ["KEY_1", "KEY_2", "KEY_3", "KEY_4"];
		
		//Create a variable to hold the counter for the keys collected.
		private var keysCollected:int = 0;
		
		//Constructor.
		public function Keys(){
			this.addEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
		}
		
		
		//Function called when the class has been added to the stage.
		private function classAddedToStage(event:Event){
			
			//remove the ADDED_TO_STAGE listener and focus on the stage.
			this.removeEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
			stage.focus = stage;
			
			//Instanciate the gameSound variable.
			gameSound = new GameSound();
			
			//Get the appropriate MovieClips from the stage.
			thePlayer = stage.getChildByName("Player") as MovieClip;
			theBackground = stage.getChildByName("theBackground") as MovieClip;
			backgroundObjects = theBackground.getChildByName("BackgroundObjects") as MovieClip;
			headsUpDisplay = stage.getChildByName("HeadsUpDisplay") as MovieClip;
			
			//Add an ENTER_FRAME handler to detect if the player is on top of a key or not.
			stage.addEventListener(Event.ENTER_FRAME, keyHitDetectHandler);
		}
		
		//A handler to detect if the player is on top of a key.
		private function keyHitDetectHandler(event:Event):void{
			
			//Loop through all the names of the keys.
			for(var i:int = 0; i < keyNameArr.length; i++){
				
				//Get the key from theBackground with the child name of the current keyNameArr at index i.
				var currentKey:MovieClip = theBackground.getChildByName(keyNameArr[i]) as MovieClip;
				
				//Only progress if currentKey is not null. 
				if(currentKey != null){
					
					//Get the global position of the currentKey.
					var globalKeyCoordinates:Point = theBackground.localToGlobal(new Point(currentKey.x, currentKey.y));
					
					//Check if the player is on top of the currentKey.
					if(thePlayer.hitTestPoint(globalKeyCoordinates.x, globalKeyCoordinates.y, true)){
						//Remove the key from the background.
						theBackground.removeChild(currentKey);
						
						//Increment the keysCollected variable.
						keysCollected++;
						
						//update the heads up display to show the current keys collected.
						headsUpDisplay.keysCollectedText.text = keysCollected;
						
						//Play the key pickup  sound effect.
						gameSound.playKeyPickUpSound();
					}
					
				}
			}
			
			//If the keysCollected is 4 then remove the boss gate, play the gate opening sound effect, and remove the keyHitDetectHandler listenr.
			if(keysCollected == 4){
				var theGate:MovieClip = backgroundObjects.getChildByName("gate") as MovieClip;
				gameSound.playGateOpenSound();
				backgroundObjects.removeChild(theGate);
				stage.removeEventListener(Event.ENTER_FRAME, keyHitDetectHandler);
			}
		}


	}
}
