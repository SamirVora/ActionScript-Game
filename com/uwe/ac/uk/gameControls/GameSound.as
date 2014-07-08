package com.uwe.ac.uk.gameControls{
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	
	public class GameSound extends MovieClip{

		//Create the sound variables for all the sound/music clips that will be used.
		private var gameMusic:Sound;
		private var enemyGunshot:Sound;
		private var playerGunshot:Sound;
		private var keyPickUpSound:Sound
		private var gateOpenSound:Sound;
		private var ammoPickUpSound:Sound;
		private var outOfAmmoSound:Sound;
		private var mouseHoverSound:Sound;
		private var typeWriterSound:Sound;
		private var gameTitleMusic:Sound;
		private var winningMusic:Sound;
		private var healthDrink:Sound;
		
		//Create SoundChannel variables for all the sound/music clips to be used.
		private var mainMusicChan:SoundChannel = new SoundChannel();
		private var playerShootChan:SoundChannel = new SoundChannel();
		private var enemyShootChan:SoundChannel = new SoundChannel();
		private var keyPickUpChan:SoundChannel = new SoundChannel();
		private var gateOpenChan:SoundChannel = new SoundChannel();
		private var ammoPickUpChan:SoundChannel = new SoundChannel();
		private var outOfAmmoChan:SoundChannel = new SoundChannel();
		private var mouseHoverChan:SoundChannel = new SoundChannel();
		private var typeWriterChan:SoundChannel = new SoundChannel();
		private var gameTitleChan:SoundChannel = new SoundChannel();
		private var winningMusChan:SoundChannel = new SoundChannel();
		private var healthDrinkChan:SoundChannel = new SoundChannel();
		
		//Create variables to hold the sound levels of each individual sound/music clip.
		private var gameSoundVol:Number = 0.2;
		private var keyPickUpVol:Number = 0.15;
		private var enemyGunFireVol:Number = 0.06;
		private var playerGunFireVol:Number = 0.15;
		private var ammoPickUpVol:Number = 0.18;
		private var outOfAmmoVol:Number = 0.08;
		private var gateOpenVol:Number = 0.3;
		private var drinkVol:Number = 0.18;
		private var buttHoverVol:Number = 0.1;
		private var typeWriterVol:Number = 0.4;
		private var winMusicVol:Number = 0.1;
		
		
		//Boolean to signify if the sound has been muted or not.
		public var isSoundMute:Boolean = false;
		
		//Constructor.
		public function GameSound(){
			
			//Instantiate new Sound variables
			gameMusic = new Sound();
			enemyGunshot = new Sound();
			playerGunshot = new Sound();
			keyPickUpSound = new Sound();
			gateOpenSound = new Sound();
			ammoPickUpSound = new Sound();
			outOfAmmoSound = new Sound();
			mouseHoverSound = new Sound();
			typeWriterSound = new Sound();
			gameTitleMusic = new Sound();
			winningMusic = new Sound();
			healthDrink = new Sound();
			
			//Load audio files of sound files into the Sound variables
			gameMusic.load(new URLRequest("sounds/GameMusic.mp3"));
			enemyGunshot.load(new URLRequest("sounds/Gun Rifle Shot 3.mp3"));
			playerGunshot.load(new URLRequest("sounds/Gun Rifle Shot 4.mp3"));
			keyPickUpSound.load(new URLRequest("sounds/Ding.mp3"));
			gateOpenSound.load(new URLRequest("sounds/GateOpenSound.mp3"));
			ammoPickUpSound.load(new URLRequest("sounds/AmmoPickUpSound.mp3"));
			outOfAmmoSound.load(new URLRequest("sounds/OutOFAmmoSound.mp3"));
			mouseHoverSound.load(new URLRequest("sounds/MouseRollover.mp3"));
			typeWriterSound.load(new URLRequest("sounds/typewriter.mp3"));
			gameTitleMusic.load(new URLRequest("sounds/GameTitleMusic.mp3"));
			winningMusic.load(new URLRequest("sounds/winninMusic.mp3"));
			healthDrink.load(new URLRequest("sounds/drinking.mp3"));
		}
		
		//Function which mutes all the SoundChannel of all the Sound objects.
		public function muteGameSounds(){
			
			isSoundMute = true;
			
			gameSoundVol = 0;
			keyPickUpVol = 0;
			enemyGunFireVol = 0;
			playerGunFireVol = 0;
			ammoPickUpVol = 0;
			outOfAmmoVol = 0;
			gateOpenVol = 0;
			buttHoverVol = 0;
			typeWriterVol = 0;
			winMusicVol = 0;
			drinkVol = 0;
			
			setVolume(mainMusicChan, gameSoundVol);
			setVolume(playerShootChan, playerGunFireVol);
			setVolume(enemyShootChan, enemyGunFireVol);
			setVolume(keyPickUpChan, keyPickUpVol);
			setVolume(gateOpenChan, gateOpenVol);
			setVolume(ammoPickUpChan, ammoPickUpVol);
			setVolume(outOfAmmoChan, outOfAmmoVol);
			setVolume(mouseHoverChan, buttHoverVol);
			setVolume(typeWriterChan, typeWriterVol);
			setVolume(winningMusChan, winMusicVol);
			setVolume(healthDrinkChan, drinkVol);
		}
		
		//Function which un-mutes all the SoundChanels and sets the sound volumes back to original.
		public function playGameSounds(){
			
			isSoundMute = false;
			
			gameSoundVol = 0.2;
			keyPickUpVol = 0.15;
			enemyGunFireVol = 0.08;
			playerGunFireVol = 0.15;
			ammoPickUpVol = 0.18;
			outOfAmmoVol = 0.06;
			gateOpenVol = 0.3;
			buttHoverVol = 0.1;
			typeWriterVol = 0.4;
			winMusicVol = 0.1;
			drinkVol = 0.18;
			
			setVolume(mainMusicChan, gameSoundVol);
			setVolume(playerShootChan, playerGunFireVol);
			setVolume(enemyShootChan, enemyGunFireVol);
			setVolume(keyPickUpChan, keyPickUpVol);
			setVolume(gateOpenChan, gateOpenVol);
			setVolume(ammoPickUpChan, ammoPickUpVol);
			setVolume(outOfAmmoChan, outOfAmmoVol);
			setVolume(mouseHoverChan, buttHoverVol);
			setVolume(typeWriterChan, typeWriterVol);
			setVolume(winningMusChan, winMusicVol);
			setVolume(healthDrinkChan, drinkVol);
		}

		//A helper function used to set the volume of all the SoundChanels.
		private function setVolume(soundChannel:SoundChannel, soundVolume:Number){
				var soundTrans:SoundTransform = soundChannel.soundTransform;
				soundTrans.volume = soundVolume;
				soundChannel.soundTransform = soundTrans;
		}		
		
		//Function is used to stop all the SoundChanels from playing music/sound clips.
		public function stopAllMusic(){
			mainMusicChan.stop();
			winningMusChan.stop();
			playerShootChan.stop();
			enemyShootChan.stop();
			keyPickUpChan.stop();
			ammoPickUpChan.stop();
			outOfAmmoChan.stop();
		}
		
		//Function return whether the sound is currently mute or not.
		public function getIsSoundMute():Boolean{
			return isSoundMute;
		}
		
		//Function is used to play the game title appearing music.
		public function playGameTitleMusic(){
			gameTitleChan = gameTitleMusic.play();
			var titleMusicTrans:SoundTransform = gameTitleChan.soundTransform;
			titleMusicTrans.volume = 0.2;
			gameTitleChan.soundTransform = titleMusicTrans;	
			gameTitleChan.addEventListener(Event.SOUND_COMPLETE, playGameMusic);
		}
		
		//Function is used to play the main game music.
		public function playGameMusic(event:Event):void{
			mainMusicChan = gameMusic.play(0, 50);
			var mainMusicSoundTrans:SoundTransform = mainMusicChan.soundTransform;
			mainMusicSoundTrans.volume = gameSoundVol;
			mainMusicChan.soundTransform = mainMusicSoundTrans;
		}
		
		//Function is used to play the player gun fire sound.s
		public function playPlayerGunShot(){
			playerShootChan = playerGunshot.play();
			var playerGunSoundTrans:SoundTransform = playerShootChan.soundTransform;
			playerGunSoundTrans.volume = playerGunFireVol;
			playerShootChan.soundTransform = playerGunSoundTrans;				
		}
		
		//Function is used to play the enemy gun fire sound.
		public function playEnemyGunShot(){
			enemyShootChan = enemyGunshot.play();
			var enemyGunSoundTrans:SoundTransform = enemyShootChan.soundTransform;
			enemyGunSoundTrans.volume = enemyGunFireVol;
			enemyShootChan.soundTransform = enemyGunSoundTrans;
		}
		
		//Funtion is used to play the key pick up sound.
		public function playKeyPickUpSound(){
			keyPickUpChan = keyPickUpSound.play();
			var keyPickUpSoundTrans:SoundTransform = keyPickUpChan.soundTransform;
			keyPickUpSoundTrans.volume = keyPickUpVol;
			keyPickUpChan.soundTransform = keyPickUpSoundTrans;				
		}
		
		//Function is used to play the game opening sound.
		public function playGateOpenSound(){
			gateOpenChan = gateOpenSound.play();
			var gateOpenSoundTrans:SoundTransform = gateOpenChan.soundTransform;
			gateOpenSoundTrans.volume = gateOpenVol;
			gateOpenChan.soundTransform = gateOpenSoundTrans;				
		}
		
		//Function is used to play the ammo pick up sound.
		public function playPickUpAmmoSound(){
			ammoPickUpChan = ammoPickUpSound.play();
			var ammoPickUpSoundTrans:SoundTransform = ammoPickUpChan.soundTransform;
			ammoPickUpSoundTrans.volume = ammoPickUpVol;
			ammoPickUpChan.soundTransform = ammoPickUpSoundTrans;	
		}
		
		//Function is used to play the out of ammo out effect.
		public function playOutOfAmmoSound(){
			outOfAmmoChan = outOfAmmoSound.play();
			var outOfAmmoChanSoundTrans:SoundTransform = outOfAmmoChan.soundTransform;
			outOfAmmoChanSoundTrans.volume = outOfAmmoVol;
			outOfAmmoChan.soundTransform = outOfAmmoChanSoundTrans;				
		}
		
		//Function is used to play the sound effect for hovering over a button.
		public function playButtonHoverSound(){
			mouseHoverChan = mouseHoverSound.play();
			var buttonHoverTrans:SoundTransform = mouseHoverChan.soundTransform;
			buttonHoverTrans.volume = buttHoverVol;
			mouseHoverChan.soundTransform = buttonHoverTrans;				
		}

		//Function is used to play the sound effect of the typewriter.
		public function playTypewriterSound(){
			typeWriterChan = typeWriterSound.play(0, 4);
			var typewriterTrans:SoundTransform = typeWriterChan.soundTransform;
			typewriterTrans.volume = typeWriterVol;
			typeWriterChan.soundTransform = typewriterTrans;				
		}
		
		//Function is used to play the winning game music.
		public function playWinningMusic(){
			winningMusChan = winningMusic.play(0, 2);
			var winMusicTrans:SoundTransform = winningMusChan.soundTransform;
			winMusicTrans.volume = winMusicVol;
			winningMusChan.soundTransform = winMusicTrans;				
		}
		
		//Function is used to play the drinking sound effect for when the player picks up a health pack.
		public function playDrinkingSound(){
			healthDrinkChan = healthDrink.play();
			var drinkSoundTrans:SoundTransform = healthDrinkChan.soundTransform;
			drinkSoundTrans.volume = drinkVol;
			healthDrinkChan.soundTransform = drinkSoundTrans;				
		}

	}
}