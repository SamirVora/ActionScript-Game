package  com.uwe.ac.uk.gameControls{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	public class BossControl extends MovieClip{
		
		//Create empty class objects.
		private var bossHealthBar:BossHealthBar;
		private var gameSound:GameSound;
		private var bossCollision:BossCollision;
		private var bossAttack:BossAttack;
		
		//Create empty MovieClip variables
		private var theStage:Stage;
		private var theBoss:MovieClip;
		private var thePlayer:MovieClip;
		private var theBackground:MovieClip;
		private var backgroundObjects:MovieClip;
		private var theBossHealthBar:MovieClip = new bossHealthBar_Symb;
		
		//Constructor.
		public function BossControl() {
			this.addEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
		}
		
		//This handler is called when this class is added to the stage.
		private function classAddedToStage(event:Event){
			
			//Remove the ADDED_TO_STAGE EventListener and set focus to the stage.
			this.removeEventListener(Event.ADDED_TO_STAGE, classAddedToStage);
			stage.focus;
			
			//set the stage instance
			this.theStage = stage;
			
			//Create a new boss MovieClip.
			this.theBoss = new boss_Symb;
			
			//Get the appropriate MovieClip instances from the stage and asign them to the correct variables.
			this.thePlayer = theStage.getChildByName("Player") as MovieClip;
			this.theBackground = theStage.getChildByName("theBackground") as MovieClip;
			this.backgroundObjects = theBackground.getChildByName("BackgroundObjects") as MovieClip;
			this.gameSound = theStage.getChildByName("GameSound") as GameSound;
			
			//Call the function to add the boss to the stage.
			addBossToBackground(theBoss, theBackground);
			
			//Instantiate the objects.
			bossHealthBar = new BossHealthBar(theBossHealthBar, theBackground);
			bossCollision = new BossCollision(backgroundObjects);
			bossAttack = new BossAttack(theStage, theBoss, thePlayer, theBackground, gameSound);
			
			//Get the GameSound class object from the stage. This is done so that all the classes which 
			// impliment the GameSound class has the same object, and so the sound could be controled 
			// more easily.
			gameSound = theStage.getChildByName("GameSound") as GameSound;
			
			//Add an ENTER_FRAME listener to update the boss.
			this.addEventListener(Event.ENTER_FRAME, updateBoss);
		}
		
		//This helper function is used to add the boss to the stage.
		private function addBossToBackground(theBoss:MovieClip, theBackground:MovieClip){
			theBoss.name = "theBoss";
			theBackground.addChild(theBoss);
			theBoss.x = -620;
			theBoss.y = -750;
		}
		
		//This is an ENTER_FRAME handler which is used to update the boss to turn towards the player, 
		// follow the player, detect collision with background objects, and set the Boss's healthbar on top of the Boss.
		private function updateBoss(event:Event){
			bossHealthBar.setHealthBarOnTopOfBoss(theBoss);
			turnTowardsPlayer(theBoss, thePlayer, theBackground);
			followPlayer(theBoss, thePlayer, theBackground);
			bossCollision.detectBackgroundCollision(theBoss);
		}
		
		//Function is used to update the Boss's healthbar.
		public function updateBossHealthBar(damage:int){
			bossHealthBar.updateBossHealthBar(damage);
		}
		
		//Function is used to get the current health of the Boss.
		public function getCurrentHealth():int{
			return bossHealthBar.getCurrentBossHealth();
		}
		
		//This function is used to manually remove the updateBoss when the game resets.
		public function removeBossHandler(){
			this.removeEventListener(Event.ENTER_FRAME, updateBoss);
		}
		
		//Function is used to enable the Boss to follow the player.
		private function followPlayer(theBoss:MovieClip, thePlayer:MovieClip, theBackground:MovieClip){
			
			//Get the player's local position in relation to the background.
			var localPlayerPos:Point = theBackground.globalToLocal(new Point(thePlayer.x, thePlayer.y));
			
			//Get the Boss's lobal position.
			var globalBossPos:Point = theBackground.localToGlobal(new Point(theBoss.x, theBoss.y));
			
			//Create variables to store the absolute range between the player and the Boss.
			var playerAndBossRange_X = Math.abs(thePlayer.x - globalBossPos.x);
			var playerAndBossRange_Y = Math.abs(thePlayer.y - globalBossPos.y);		
			
			//Only proceed if the Boss is within the stage bounds.
			if((globalBossPos.x > 0 && globalBossPos.y > 0) && (globalBossPos.x < 700 && globalBossPos.y < 500)){
				
				//Only proceed if the range between the Boss and the player is between a certain limit.
				if((playerAndBossRange_X > 200 || playerAndBossRange_Y > 200) && (playerAndBossRange_X < 300 || playerAndBossRange_Y < 300)){
					
					//Get the radian between the player and the Boss.
					var runRadian:Number = Math.atan2(localPlayerPos.y - theBoss.y, localPlayerPos.x - theBoss.x);
					
					//Incement the Boss's position based to the radians
					theBoss.x += Math.cos(runRadian) * 10;
					theBoss.y += Math.sin(runRadian) * 10;
				}
			}
		}
		
		//Function which enables the boss to turn towards the player.
		private function turnTowardsPlayer(theBoss:MovieClip, thePlayer:MovieClip, theBackground:MovieClip){
			
			//Get the global position of the Boss.
			var globalBossPos:Point = theBackground.localToGlobal(new Point(theBoss.x, theBoss.y));
			
			//Only proceed if the Boss is within the stage bounds.
			if((globalBossPos.x > 0 && globalBossPos.y > 0) && (globalBossPos.x < 700 && globalBossPos.y < 500)){
				
				//Create variables to store the absolute range between the player and the Boss.
				var playerAndBossRange_X = Math.abs(thePlayer.x - globalBossPos.x);
				var playerAndBossRange_Y = Math.abs(thePlayer.y - globalBossPos.y);						
				
				//Get the radian between the player and the Boss.
				var turnRadian:Number = Math.atan2(globalBossPos.y - thePlayer.y, globalBossPos.x - thePlayer.x);
				
				//Convert the radians into degrees.
				var degrees:Number = 360*(turnRadian/(2*Math.PI));
				
				//Use the degrees to turn the Boss.
				theBoss.rotation = degrees;
				
				//Call the fucntion to start the boss shooting.
				bossAttack.initiateBossAttack();
			}
		}
		
	}
}





