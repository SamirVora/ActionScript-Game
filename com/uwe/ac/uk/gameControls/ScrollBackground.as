package  com.uwe.ac.uk.gameControls{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class ScrollBackground extends MovieClip{
		
		//Create class variables
		private var helpMessages:Messages;
		
		//Create MovieClip variables
		private var thePlayer:MovieClip;
		private var theBackground:MovieClip;
		private var backgroundObjects:MovieClip;
		
		//Create a static variable which will be called on ControlPlayer to check if the stage
		// is currently scrolling or not.
		public static var isScrolling:Boolean = false;
		
		//Create a variable to count the amount that the background has currently scrolled for.
		public var backgroundScrollCount:int = 0;
		
		//Create an array index counter.
		private var arrayIndexCounter = 0;
		
		//Create an array containing the x and y coordinates for where the boxs will be placed at.
		private var scrollBoxesCoordinates:Array = [20, 235, -24, 235, -353, 20, -353, -27, -25, -270, 22, -270, 380, -480, 380, -530, 23, -757];
		
		//Create an array containing all the names of the boxes.
		private var boxNameArr:Array = ["scroll_left_bott", "scroll_right_bott", "scroll_up_bott", "scroll_down_mid", "scroll_right_mid", 
										"scroll_left_mid", "scroll_up_mid", "scroll_down_top", "scroll_left_top"];
		
		
		//Constructor.
		public function ScrollBackground(){
			this.addEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
		}

		//Function called when the class has been added to the stage.
		private function classAddedToStage(event:Event){
			
			//Remove the listener for when the class is added to stage, and set focus to the stage.
			removeEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
			stage.focus = stage;
			
			//Instantiate variables by getting the appropriate variables from the stage and background.
			thePlayer = stage.getChildByName("Player") as MovieClip;
			theBackground = stage.getChildByName("theBackground") as MovieClip;
			backgroundObjects = theBackground.getChildByName("BackgroundObjects") as MovieClip;
			
			//Create a new instant of the Message class
			helpMessages = new Messages(theBackground);
			
			//Call a helper function to place the scroll boxes on the background.
			placeScrollBoxesOnBackground(9);
			
			//Add an ENTER_FRAME listener to see if player is hitting a scroll box and to scroll the
			// background appropriately
			stage.addEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
		}
		

		//A handler for scrolling the background
		private function scrollBackgroundHandler(event:Event){
			
			//Loop through each scroll box created.
			for(var i:int = 0; i < boxNameArr.length; i++){
				
				//Get the scroll box from the background.
				var tempBox:MovieClip = theBackground.getChildByName(boxNameArr[i]) as MovieClip;
				
				//Get the global position of the scroll box.
				var boxGlobalPoints:Point = theBackground.localToGlobal(new Point(tempBox.x, tempBox.y));
				
				//Switch statement checks the name of the current scroll box in the loop, and if the player
				// is hitting it. If they are then add am ENTER_FRAME to  the background and scroll it appropriately.
				switch(tempBox.name){
					case "scroll_left_bott":
						//This hitTestPoint checks if the player is on top of the first left scroll box.
						// If they are then show the message to collect keys.
						if(thePlayer.hitTestPoint(boxGlobalPoints.x, boxGlobalPoints.y, true)){
							helpMessages.playCollectKeysMessage();
						}
					case "scroll_left_mid":
					case "scroll_left_top":
						if(thePlayer.hitTestPoint(boxGlobalPoints.x, boxGlobalPoints.y, true)){
							theBackground.addEventListener(Event.ENTER_FRAME, moveBackgroundLeft);
						}
						break;
					case "scroll_right_bott":
					case "scroll_right_mid":
						if(thePlayer.hitTestPoint(boxGlobalPoints.x, boxGlobalPoints.y, true)){
							theBackground.addEventListener(Event.ENTER_FRAME, moveBackgroundRight);
						}
						break;
					case "scroll_up_bott":
					case "scroll_up_mid":
						if(thePlayer.hitTestPoint(boxGlobalPoints.x, boxGlobalPoints.y , true)){
							theBackground.addEventListener(Event.ENTER_FRAME, moveBackgroundUp);
						}
						break;
					case "scroll_down_mid":
					case "scroll_down_top":
						if(thePlayer.hitTestPoint(boxGlobalPoints.x, boxGlobalPoints.y , true)){
							theBackground.addEventListener(Event.ENTER_FRAME, moveBackgroundDown);
						}
						break;
				}
			}
		}
		
		
		//Function to scroll background to the left.
		private function moveBackgroundLeft(pEvent){
			
			//Temporarily remove the scrollBackgroundHandler.
			stage.removeEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
			
			//Get the background instance attached to this handler.
			var theBK:MovieClip = pEvent.currentTarget;
			
			//Check if backgroundScrollCount does not exceed the width of the stage.
			if(backgroundScrollCount <= 700){
				
				//increment the x position of the background by 7
				theBK.x += 7;
				
				//increment the player's x position so that it follows the background.
				thePlayer.x += 6;
				
				//increment the backgroundScrollCount by the amount the background has scrolled.
				backgroundScrollCount += 7;
				
				//Set isScrolling to true since the background is scrolling.
				isScrolling = true;
				
				//If the background has reached or exceeded the stage width, then remove this handler, and add 
				// the set the ENTER_FRAME for scrollBackgroundHandler on the stage.
			}else if(backgroundScrollCount >= 700){
				isScrolling = false;
				backgroundScrollCount = 0;
				stage.addEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
				theBackground.removeEventListener(Event.ENTER_FRAME, moveBackgroundLeft);
			}
			
		}
		
		
		//Function to scroll background to the up.
		private function moveBackgroundUp(pEvent){
			
			//Temporarily remove the scrollBackgroundHandler.
			stage.removeEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
			
			//Get the background instance attached to this handler.
			var theBK:MovieClip = pEvent.currentTarget;
			
			//Check if backgroundScrollCount does not exceed the height of the stage.
			if(backgroundScrollCount <= 500){
				
				//increment the y position of the background by 5.
				theBK.y += 5;
				
				//increment the player's y position so that it follows the background.
				thePlayer.y += 4;
				
				//increment the backgroundScrollCount by the amount the background has scrolled.
				backgroundScrollCount += 5;
				
				//Set isScrolling to true since the background is scrolling.
				isScrolling = true;
				
				//If the background has reached or exceeded the stage height, then remove this handler, and add 
				// the set the ENTER_FRAME for scrollBackgroundHandler on the stage.
			}else if(backgroundScrollCount >= 500){
				isScrolling = false;
				backgroundScrollCount = 0;
				stage.addEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
				theBackground.removeEventListener(Event.ENTER_FRAME, moveBackgroundUp);
			}
			
		}
		
		
		//Function to scroll background to the right.
		private function moveBackgroundRight(pEvent){
			
			//Temporarily remove the scrollBackgroundHandler.
			stage.removeEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
			
			//Get the background instance attached to this handler.
			var theBK:MovieClip = pEvent.currentTarget;
			
			//Check if backgroundScrollCount does not exceed the width of the stage.
			if(backgroundScrollCount <= 700){
				
				//Decrement the x position of the background by 7.
				theBK.x -= 7;
				
				//Decrement the player's x position so that it follows the background.
				thePlayer.x -= 6;
				
				//increment the backgroundScrollCount by the amount the background has scrolled.
				backgroundScrollCount += 7;
				
				//Set isScrolling to true since the background is scrolling.
				isScrolling = true;
				
				//If the background has reached or exceeded the stage width, then remove this handler, and add 
				// the set the ENTER_FRAME for scrollBackgroundHandler on the stage.
			}else if(backgroundScrollCount >= 700){
				isScrolling = false;
				backgroundScrollCount = 0;
				stage.addEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
				theBK.removeEventListener(Event.ENTER_FRAME, moveBackgroundRight);
			}
			
		}
		
		
		//Function to scroll background to the down.
		private function moveBackgroundDown(pEvent){
			
			//Temporarily remove the scrollBackgroundHandler.
			stage.removeEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
			
			//Get the background instance attached to this handler.
			var theBK:MovieClip = pEvent.currentTarget;
			
			//Check if backgroundScrollCount does not exceed the height of the stage.
			if(backgroundScrollCount <= 500){
				
				//Decrement the y position of the background by 5.
				theBK.y -= 5;
				
				//Decrement the player's y position so that it follows the background.
				thePlayer.y -= 4;
				
				//increment the backgroundScrollCount by the amount the background has scrolled.
				backgroundScrollCount += 5;
				
				//Set isScrolling to true since the background is scrolling.
				isScrolling = true;
				
				//If the background has reached or exceeded the stage height, then remove this handler, and add 
				// the set the ENTER_FRAME for scrollBackgroundHandler on the stage.
			}else if(backgroundScrollCount >= 500){
				isScrolling = false;
				backgroundScrollCount = 0;
				stage.addEventListener(Event.ENTER_FRAME, scrollBackgroundHandler);
				theBK.removeEventListener(Event.ENTER_FRAME, moveBackgroundDown);
			}
			
		}

		
		//Helper function which places the scroll boxes on teh backround.
		private function placeScrollBoxesOnBackground(numberOfScrollBoxes:int){
			
			//loop through for how many times the number of scroll boxes is to be created.
			for(var i:int = 0; i < numberOfScrollBoxes; i++){
				
				//Create a new instance of a ScrollBox_Symb MovieClip.
				var tempScrollBox:MovieClip = new ScrollBox_Symb;
				
				//Assign the name name at index i to the scroll box/
				tempScrollBox.name = boxNameArr[i];
				
				//Add the scroll box to the backround.
				theBackground.addChild(tempScrollBox);
				
				//Set the scroll box's x position to the position in scrollBoxesCoordinates at index i.
				tempScrollBox.x = scrollBoxesCoordinates[arrayIndexCounter];
				
				arrayIndexCounter++;
				
				//Set the scroll box's y position to the position in scrollBoxesCoordinates at index i.
				tempScrollBox.y = scrollBoxesCoordinates[arrayIndexCounter];
				
				arrayIndexCounter++;
			}
			
		}

	}
	
}
