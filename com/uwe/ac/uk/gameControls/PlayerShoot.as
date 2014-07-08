package  com.uwe.ac.uk.gameControls{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	
	public class PlayerShoot extends MovieClip{

		//Create class variables.
		private var gameSound:GameSound;
		private var ammunition:Ammunition;
		private var gunInteraction:PlayerGunInteraction;
		private var bossControl:BossControl;
		
		
		//Create MovieClip variables.
		private var thePlayer:MovieClip;
		private var theStage:Stage;
		private var theBullet:MovieClip = new MovieClip();
		private var theBackground:MovieClip;
		private var backgroundObjects:MovieClip;
		private var theBoss:MovieClip;
		
		
		//create variables to hold the stage's width and height.
		private var stage_Width:Number;
		private var stage_Height:Number;
		
		//Create array variables.
		private var gunArray:Array = new Array();
		private var allEnemiesArr:Array = new Array();
		private var closestEnemies:Array = new Array();
		
		//Create boolean variables.
		private var bulletFired:Boolean = false;
		private var hasPlayerClickMouse:Boolean = false;
		private var holdingGun:Boolean = false;
		
		//Create variables to manage how fast the user is able to shoot.
		private var fireTimeCount:int = 0;
		private var timeToNextShot:int = 15;
		private var gunDamage:int;
		
		
		//Constructor.
		public function PlayerShoot(GameStage:Stage, Player:MovieClip, Background:MovieClip) {
			
			//Instantiate the stage, player, and background MovieClip variables from the variables passed in.
			this.theStage = GameStage;
			this.thePlayer = Player;
			this.theBackground = Background;
			
			//set the variables to the stage's width and height.
			this.stage_Width = theStage.width;
			this.stage_Height = theStage.height;
			
			//Get the appropriate class instances from the stage and background and instantiate the correct variables.
			gameSound = theStage.getChildByName("GameSound") as GameSound;
			theBoss = theBackground.getChildByName("theBoss") as MovieClip;
			bossControl = theStage.getChildByName("BossControl") as BossControl;
			backgroundObjects = theBackground.getChildByName("BackgroundObjects") as MovieClip;
			
			//Get an instance of EnemyControl from the stage to instantiate the appropriate arrays.
			var controlEnemies:EnemyControl = theStage.getChildByName("EnemyControl") as EnemyControl;
			this.allEnemiesArr = controlEnemies.getEnemiesOnStageArr();
			this.closestEnemies = controlEnemies.getClosestEnemies();
			
			//Instantiate the ammunition and gunInteraction class.
			ammunition = new Ammunition(theBackground, thePlayer);
			gunInteraction = new PlayerGunInteraction(thePlayer, theBackground);
			
			//Get the array of guns on stage and place it within the gunArray variable.
			gunArray = gunInteraction.getGunArray();
			
			//Add a listener for when the user releases a mouse click to initiate shooting.
			this.theStage.addEventListener(MouseEvent.MOUSE_UP, initiatePlayerShoot);
		}
		
		//Manually remove the initiatePlayerShoot listener. This is used when the game is reset.
		public function removePlayerShootHandler(){
			this.theStage.removeEventListener(MouseEvent.MOUSE_UP, initiatePlayerShoot);
		}
		
		//sets wheter the player is currently holding a gun or not.
		public function setIsPlayerHoldingGun(isPlayerHoldingGun:Boolean){
			this.holdingGun = isPlayerHoldingGun;
		}
		
		//Returns holdingGun.
		public function getIsPlayerHoldingGun():Boolean{
			return this.holdingGun;
		}
		
		
		//Function which loops through each gun on the stage to check if the player is actually stading ontop of a gun.
		public function pickUpGun(){
			
			//Loop through each gun within the array.
			for(var j:int = 0; j < gunArray.length; j++){
				
				//Get the global position of the gun.
				var globalGunPos = theBackground.localToGlobal(new Point(gunArray[j][0].x, gunArray[j][0].y));
				
				//Check if the player is actually on top of a gun.
				if(thePlayer.hitTestPoint(globalGunPos.x, globalGunPos.y)){
					
					//Set holdingGun to true.
					holdingGun = true;
					
					//Set the animation of the player to holding a gun.
					thePlayer.gotoAndStop("Gun1");
					
					//Add the ammo to the player's current ammo count.
					ammunition.addAmmo();
					
					//Set the Heads Up Display to display the correct ammo amount.
					ammunition.setDisplayAmmoAmount();
					
					//Get the gun the player is standing on.
					gunDamage = gunArray[j][1];
					
					//Remove the gun from the stage.
					theBackground.removeChild(gunArray[j][0]);
					
					//Splice the gunArray by one at the position of the current gun.
					gunArray.splice(j, 1);
				}
			}
		}
		
		
		//Function to initiate the player shooting.
		private function initiatePlayerShoot(event:MouseEvent){
			
			//Remove this listener if the player's health is 0.
			if(PlayerHealthBar.playerCurrentHealth <= 0){
				theStage.removeEventListener(MouseEvent.MOUSE_UP, initiatePlayerShoot);
			}
			
			//Get the current ammo the player has.
			var currentAmmoLoaded = ammunition.getCurrentAmmoAmount();
			
			//Only progress if the player is holding a gun, has not fired a shot, and the ammo is greater than 0.
			if(holdingGun == true && bulletFired == false && currentAmmoLoaded > 0){
				
				//Decrease the ammo amount by 1.
				ammunition.decreaseAmmo();
				
				//Set the bulletFired to true and create a new symbol.
				bulletFired = true;
				theBullet = new bullet_Symb;
				
				//Set the bullet to the player's position.
				theBullet.x = thePlayer.x;
				theBullet.y = thePlayer.y;
				
				//Rotate the bullet to face the correct direction.
				rotateBullet(theBullet, thePlayer, theStage);
				
				//Create a property of the bullet to hold the radians between the mouse and the player so that
				// the bullet could then use that radian to follow the trajectory towards the player.
				theBullet.bulletRadian = Math.atan2(theStage.mouseY - thePlayer.y, theStage.mouseX - thePlayer.x);
				
				//Add the bullet to the stage.
				theStage.addChild(theBullet);
				
				//Add an ENTER_FRAME listener to enable to bullet to follow its trajectory.
				theBullet.addEventListener(Event.ENTER_FRAME, bulletFollowTrajectory);
				
				//Play the sound of the player shooting his gun.
				gameSound.playPlayerGunShot();			
				
				//If the ammo is 0 then play the out of ammo sound effect.
			}else if(currentAmmoLoaded == 0){
					gameSound.playOutOfAmmoSound();
			}
		}
		
		
		//Function to rotate the bullet
		private function rotateBullet(theBullet:MovieClip, thePlayer:MovieClip, theStage:Stage){
			
			//Find the radian between the mouse and the player.
			 var bulletRadian:Number = Math.atan2((theStage.mouseY - thePlayer.y), (theStage.mouseX - thePlayer.x));
			 
			//Convert the radians into degrees.
			 var degrees:Number = bulletRadian * 180 / Math.PI;
			 
			//Rotate the bullet.
			theBullet.rotation = degrees;
		}
		
		
		//Function to allow the bullet to follow its trajectory.
		private function bulletFollowTrajectory(pEvent){
			
			//Get the instance of the bullet attached to the listener.
			var bullet:MovieClip = pEvent.currentTarget;
			
			//Incriment the fireTimeCount
			fireTimeCount++;
			
			//If the fireTimeCount is greater than or equal to timeToNextShot, then set bulletFired to false
			// and fireTimeCount to 0, meaning the player wont be able to shoot agian instantly.
			if(fireTimeCount >= timeToNextShot){
				bulletFired = false;
				fireTimeCount = 0;
			}
			
			
			//Calculate the trajectory of the bullet from the properties set within bullet MovieClip.
			bullet.x += Math.cos(bullet.bulletRadian) * 20;
			bullet.y += Math.sin(bullet.bulletRadian) * 20;
			
			
			//Check if the bullet is out of bounds of the stage. If it is then remove the bullet from the stage
			// and remove this listener.
			if(bullet.x < 0 || bullet.y < 0 || bullet.x > stage_Width ||  bullet.y > stage_Height){
				theStage.removeChild(bullet);
				bullet.removeEventListener(Event.ENTER_FRAME, bulletFollowTrajectory);
				bulletFired = false;
			}
			
			//Check if the bullet has hit the Boss. Is it has then remove the bullet, update the Boss's health and 
			// remove this listener.
			if(theBoss.hitTestPoint(bullet.x, bullet.y, true)){
				bossControl.updateBossHealthBar(gunDamage);
				theStage.removeChild(bullet);
				bullet.removeEventListener(Event.ENTER_FRAME, bulletFollowTrajectory);
				bulletFired = false;
			}
			
			
			//Check if the bullet has hit any background objects. If it has then remove the bullet and remove
			// this listener.
			if(backgroundObjects.hitTestPoint(bullet.x, bullet.y, true)){
				theStage.removeChild(bullet);
				bullet.removeEventListener(Event.ENTER_FRAME, bulletFollowTrajectory);
				bulletFired = false;
			}
			

			//For every enemy on the stage, check if the current bullet has hit any of them.
			for(var i:int = 0; i < allEnemiesArr.length; i++){
				
				//Get the current enemy within the iteration.
				var enemy:MovieClip = allEnemiesArr[i].enemy;
				
				//Check if the bullet has hit the enemy.
				if(enemy.hitTestPoint(bullet.x, bullet.y, true)){

					//Get the enemy's current health from the enemyHealthBarClassObj within the allEnemiesArr, and
					// check if it is below or equal to 1.
					if(allEnemiesArr[i].enemyHealthBarClassObj.enemyCurrentHealth <= 1){
						
						//If the enemy's health is below or equal to 1, then remove the enemy from the background.
						theBackground.removeChild(allEnemiesArr[i].enemy);
						theBackground.removeChild(allEnemiesArr[i].EnemyHealthBar);
						
						//Splice the enemy from both the closestEnemies, and allEnemiesArr.
						allEnemiesArr.splice(i, 1);
						closestEnemies.splice(i, 1);

					}else{
						//Update the healthbar associated with the current enemy by reducing its health based on the damage
						// the current gun produces.
						allEnemiesArr[i].enemyHealthBarClassObj.updateHealthBar(allEnemiesArr[i].EnemyHealthBar, gunDamage);
					}
					
					//Remove the bullet from the stage and remove this ENTER_FRAME listener.
					theStage.removeChild(bullet);
					bullet.removeEventListener(Event.ENTER_FRAME, bulletFollowTrajectory);
					bulletFired = false;
				} 
			}
		}


	}
}
