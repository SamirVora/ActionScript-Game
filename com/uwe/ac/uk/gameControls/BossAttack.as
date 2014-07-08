package  com.uwe.ac.uk.gameControls{
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.Event;
	
	public class BossAttack {
		
		//Create MovieClip variables.
		private var theStage:Stage;
		private var thePlayer:MovieClip;
		private var theBoss:MovieClip;
		private var theBackground:MovieClip;
		private var bossSounds:GameSound;
		private var backgroundObjects:MovieClip;
		
		
		private var stage_Width:int;
		private var stage_Height:int;
		
		//Constructor.
		public function BossAttack(gameStage:Stage, boss:MovieClip, player:MovieClip, gameBackground:MovieClip, gameSounds:GameSound) {
			
			//Assign the paramters passed in to the empty object variables.
			this.theStage = gameStage;
			this.theBoss = boss;
			this.thePlayer = player;
			this.theBackground = gameBackground;
			this.bossSounds = gameSounds;
			this.backgroundObjects = theBackground.getChildByName("BackgroundObjects") as MovieClip;
			
			this.stage_Width = theStage.width;
			this.stage_Height = theStage.height;
		}
		
		
		//The count at which the next bullet will be fired from the Boss.
		private var attackTimer:int = 0;
		
		//The bullet load count which needs to be reached before the next bullet is fired.
		private var attackLoadTime:int = 8;
		
		
		//Function used to initiate the boss attacking.
		public function initiateBossAttack(){
			
			//Incriment the attackTimer.
			attackTimer++;
			
			//Continue if attackTimer has reached attackLoadTime and the player's health is greater than 0.
			if(attackTimer >= attackLoadTime && PlayerHealthBar.playerCurrentHealth > 0){
				
				//Play the enemy shooting sound effect.
				bossSounds.playEnemyGunShot();
				
				//Reset the attackTimer.
				attackTimer = 0;
				
				//Create a new instance of BossBullet_Symb MovieClip.
				var bullet:MovieClip = new BossBullet_Symb;
				
				//Get the global position of the Boss.
				var globalBossPos:Point = theBackground.localToGlobal(new Point(theBoss.x, theBoss.y));
				
				//Get the attack radian between the Boss and the player.
				var attackRadian = Math.atan2(thePlayer.y - globalBossPos.y, thePlayer.x - globalBossPos.x);
				
				//Rotate the bullet that has been created to correctly face the player.
				rotateBullet(bullet, thePlayer, globalBossPos);
				
				//Insert the bullet's trajectory within a custom property of the bullet MovieClip.
				bullet.trajectory_X = Math.cos(attackRadian) * 10;
				bullet.trajectory_Y = Math.sin(attackRadian) * 10;
				
				//Set the bullet's position on top of the Boss.
				bullet.x = globalBossPos.x;
				bullet.y = globalBossPos.y;
				
				//Add the bullet to the stage.
				theStage.addChild(bullet);
				
				//Set the child index of the bullet so that it does not go behind the background.
				theStage.setChildIndex(bullet, 1);
				
				//Make the bullet visible.
				bullet.visible = true;
				
				//Add an ENTER_FRAME to the bullet so that it can follow its trajectory.
				bullet.addEventListener(Event.ENTER_FRAME, attackFollowTrajectory);
			}
			
		}
		
		
		//Function to rotate the bullet.
		private function rotateBullet(theBullet:MovieClip, thePlayer:MovieClip, bossPosition:Point){
			
			//Find the radian between the Boss and the player.
			 var bulletRadian:Number = Math.atan2((bossPosition.y - thePlayer.y), (bossPosition.x - thePlayer.x));
			 
			//Convert the radians into degrees.
			 var degrees:Number = (bulletRadian * 180) / Math.PI;
			 
			//Rotate the bullet.
			theBullet.rotation = degrees;
		}
		
		
		//A handler to enable the bullet to follow its trajectory.
		private function attackFollowTrajectory(pEvent){
			
			//Get the bullet MovieClip attached to this handler.
			var bullet:MovieClip = pEvent.currentTarget;
			
			//Increment the position of the bullet to the trajectory set in its custom property.
			bullet.x += bullet.trajectory_X;
			bullet.y += bullet.trajectory_Y;
			
			//Check if the bullet is out of stage bounds, has hit player, or has hit any backround objects.
			checkIfBulletHitPlayer(theStage, thePlayer, bullet);
			checkIfBulletHitBackgroundObjects(theStage, backgroundObjects, bullet);
			checkIfBulletOutOfStageBounds(theStage, bullet);
		}
		
		
		//Function checks if the bullet has gone out of the stage bounds or not.
		private function checkIfBulletOutOfStageBounds(theStage:Stage, theBullet:MovieClip){
			
			//Only proceed if the instance of the bullet passed in exists on the stage.
			if(theStage.contains(theBullet)){
				
				//Check is the bullet has gone past the stage boundries.
				 if(theBullet.x < 0 || theBullet.y < 0 || theBullet.x > stage_Width || theBullet.y > stage_Height){
					
					//Remove the bullet from the stage.
					theStage.removeChild(theBullet);
					theBullet = null;
					
					//Assign a new instance of BossBullet_Symb to the bullet.
					theBullet = new BossBullet_Symb;
				}	
			}
		}
		
		
		//Function checks if the bullet has hit the player.
		private function checkIfBulletHitPlayer(theStage:Stage, thePlayer:MovieClip, theBullet:MovieClip){
			
			//Only continue if the player's health is greater than 0.
			if(PlayerHealthBar.playerCurrentHealth > 0){
				
				//Continue if the stage contains the passed in bullet instance.
				if(theStage.contains(theBullet)){
					
					//Check if the bullet has hit the player or not.
					if(thePlayer.hitTestPoint(theBullet.x, theBullet.y, true)){
						
						//Decrease the player's health.
						PlayerHealthBar.decreasePlayerHealth(10);
						
						//Remove the bullet from the stage.
						theStage.removeChild(theBullet);
						theBullet = null;
						
						//Assign a new instance of BossBullet_Symb to the bullet.
						theBullet = new BossBullet_Symb;
					}
				}
			}
		}
		
		
		//Function check if the bullet has hit any background objects or not.
		private function checkIfBulletHitBackgroundObjects(theStage:Stage, backgroundObjects:MovieClip, theBullet:MovieClip){
			
			//Only continue if the stage contains the passed in bullet instance.
			if(theStage.contains(theBullet)){
				
				//Check if the bullet has hit the background objects.
				if(backgroundObjects.hitTestPoint(theBullet.x, theBullet.y, true)){
					
						//Remove the bullet from the stage.
						theStage.removeChild(theBullet);
						theBullet = null;
						
						//Assign a new instance of BossBullet_Symb to the bullet.
						theBullet = new BossBullet_Symb;
				}
			}
		}


	}
	
}
