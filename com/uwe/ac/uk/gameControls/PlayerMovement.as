package com.uwe.ac.uk.gameControls {
	
	import flash.display.MovieClip;
	
	public class PlayerMovement {
		
		//Variable is used to store the player's movement speed.
		private var momentum:Number;
		
		//Constructor.
		public function PlayerMovement(gameBackground:MovieClip) {
			//Player's movement speed is set to 13.
			momentum = 13;
			
			//Create a new Message class obejct to display the message of how to control the player.
			var movementMessage:Messages = new Messages(gameBackground);
			movementMessage.playKeyControlMessage();
		}
		
		//Function used to get the player's current movement speed.
		public function getPlayerMomentum():Number{
			return momentum;
		}
		
		//Function used to set the player's movement speed.
		public function setPlayerMomentum(momentum:Number):void{
			this.momentum = momentum;
		}
		
		//Function used to move the player left.
		public function moveLeft(player:MovieClip):void{
			player.x -= momentum;
		}
		
		//Function used to move the player right.
		public function moveRight(player:MovieClip):void{
			player.x += momentum;
		}
		
		//Function used to move the player up.
		public function moveUp(player:MovieClip):void{
			player.y -= momentum;
		}
		
		//Function used to move the player down.
		public function moveDown(player:MovieClip):void{
			player.y += momentum;
		}

	}
	
}
