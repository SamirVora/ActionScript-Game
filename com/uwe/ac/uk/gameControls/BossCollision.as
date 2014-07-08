package com.uwe.ac.uk.gameControls {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class BossCollision {
		
		//Create Point variables containing the Boss's bounding box line positions. 
		private var leftBumpPoint:Point = new Point(-16.4, 0);
		private var rightBumpPoint:Point = new Point(16.4, 0);
		private var upBumpPoint:Point = new Point(0, -13.65);
		private var downBumpPoint:Point = new Point(0, 13.65);
		
		//Create an empty MovieClip to store the background objects.
		private var backgroundObjects:MovieClip;
		
		//Constructor
		public function BossCollision(theBackgroundObjects:MovieClip) {
			//Assign the parameter passed in from constructor to the empty MovieClip.
			this.backgroundObjects = theBackgroundObjects;
		}
		
		//Function used to detect collision between the Boss and the background objects.
		public function detectBackgroundCollision(theBoss:MovieClip){
			
			//Get the global Boss's position.
			var globalBossPos:Point = backgroundObjects.parent.localToGlobal(new Point(theBoss.x, theBoss.y));
			
			//Check if the Boss's left bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(globalBossPos.x + leftBumpPoint.x, globalBossPos.y + leftBumpPoint.y, true)){
				theBoss.x += 13;
				theBoss.y += 2;
			} 
			 
			//Check if the Boss's right bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(globalBossPos.x + rightBumpPoint.x, globalBossPos.y + rightBumpPoint.y, true)){
				theBoss.x -= 13;
				theBoss.y -= 2;
			}
			
			//Check if the Boss's bottom bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(globalBossPos.x + downBumpPoint.x, globalBossPos.y + downBumpPoint.y, true)){
				theBoss.y -= 13;
				theBoss.x -= 2;
			}
			 
			//Check if the Boss's top bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(globalBossPos.x + upBumpPoint.x, globalBossPos.y + upBumpPoint.y, true)){
        		theBoss.y += 13;
				theBoss.x += 2;
			}
		}

	}
}
