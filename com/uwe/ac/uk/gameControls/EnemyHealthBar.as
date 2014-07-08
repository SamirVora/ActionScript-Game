package com.uwe.ac.uk.gameControls{
	import flash.display.MovieClip;
	
	public class EnemyHealthBar{
		
		private var enemyMaxHealth:int;
		public var enemyCurrentHealth:int;
		private var enemyPercentHealth:Number;
		
		private var enemyHealthBar:MovieClip;
		
		public function EnemyHealthBar(){
			enemyMaxHealth = 100;
			enemyCurrentHealth = 100;
			enemyPercentHealth = enemyCurrentHealth / enemyMaxHealth;
		}
		
		public function updateHealthBar(healthBar:MovieClip, Damage:int){
			enemyCurrentHealth -= Damage;
			enemyPercentHealth = enemyCurrentHealth / enemyMaxHealth;
			healthBar.Enemy_HealthBar_Colour.scaleX = enemyPercentHealth;
		}

	}
}