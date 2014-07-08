package  com.uwe.ac.uk.gameControls{
	
	import flash.display.*;
	import flash.geom.Point;
	
	public class EnemyCollision {
		
		//Create Point variables containing the enemy's bounding box line positions. 
		private var leftBumpPoint:Point = new Point(-16.4, 0);
		private var rightBumpPoint:Point = new Point(16.4, 0);
		private var upBumpPoint:Point = new Point(0, -13.65);
		private var downBumpPoint:Point = new Point(0, 13.65);
		
		//A MovieClip variable to hold the backgroundObjects MovieClip.
		private var backgroundObjects:MovieClip;
		
		//Constructor.
		public function EnemyCollision(theBackgroundObjects:MovieClip) {
			this.backgroundObjects = theBackgroundObjects;
		}
		
		//Function used to detect collision between the enemy and the background obejcts.
		public function detectBackgroundCollision(theEnemy:MovieClip){
			
			//Get the global position of the enemy passed in from the function parameter.  
			var globalEnemyPos:Point = backgroundObjects.parent.localToGlobal(new Point(theEnemy.x, theEnemy.y));
			
			//Check if the enemy's left bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(globalEnemyPos.x + leftBumpPoint.x, globalEnemyPos.y + leftBumpPoint.y, true)){
				theEnemy.x += 13;
				theEnemy.y += 2;
			} 
			 
			//Check if the enemy's right bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(globalEnemyPos.x + rightBumpPoint.x, globalEnemyPos.y + rightBumpPoint.y, true)){
				theEnemy.x -= 13;
				theEnemy.y -= 2;
			}
			
			//Check if the enemy's bottom bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(globalEnemyPos.x + downBumpPoint.x, globalEnemyPos.y + downBumpPoint.y, true)){
				theEnemy.y -= 13;
				theEnemy.x -= 2;
			}
			 
			//Check if the enemy's top bounding box line is colliding with the background objects. 
			if(backgroundObjects.hitTestPoint(globalEnemyPos.x + upBumpPoint.x, globalEnemyPos.y + upBumpPoint.y, true)){
        		theEnemy.y += 13;
				theEnemy.x += 2;
			}
		}
		
		
	}
	
}
