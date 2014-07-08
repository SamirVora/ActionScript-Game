package com.uwe.ac.uk.gameControls{
	
	import flash.display.*;
	import flash.geom.Point;
	
	public class BackgroundCollision{

		//Create Point variables containing the player's bounding box line positions. 
		private var leftBumpPoint:Point = new Point(-15, 0);
		private var rightBumpPoint:Point = new Point(15, 0);
		private var upBumpPoint:Point = new Point(0, -13.5);
		private var downBumpPoint:Point = new Point(0, 13.5);
		
		//Create empty MovieClip variables.
		private var player:MovieClip;
		private var backgroundObjects:MovieClip;
		
		//Constructor.
		public function BackgroundCollision(player:MovieClip, backgroundObjects:MovieClip) {
			//Assign the MovieClips passed in from the parameters to the MovieClips created in this class.
			this.player = player;
			this.backgroundObjects = backgroundObjects;
		}
		
		//Funtion used to detect collision between the player and the background objects.
		public function detectBackgroundCollision(){
			
			//Check if the player's left bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(player.x + leftBumpPoint.x, player.y + leftBumpPoint.y, true)){
				player.x += 13;
			} 
			 
			//Check if the player's right bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(player.x + rightBumpPoint.x, player.y + rightBumpPoint.y, true)){
				player.x -= 13;
			}
			
			//Check if the player's bottom bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(player.x + downBumpPoint.x, player.y + downBumpPoint.y, true)){
				player.y -= 13;
			}
			 
			//Check if the player's top bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(player.x + upBumpPoint.x, player.y + upBumpPoint.y, true)){
        		player.y += 13;
			}
		}
		
	}
	
}
