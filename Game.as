package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * This is the controller class for the entire Game.
	 */
	public class Game extends MovieClip {

		/** This array should only hold Snow objects. */
		var snowflakes: Array = new Array();

		/** The number frames to wait before spawning the next Snow object. */
		var delaySpawn: int = 0;
		/** The number frames to wait before spawning the next bullet object. */
		var rapidDelaySpawn: int = 0;

		/** This array holds only Bullet objects. */
		var bullets: Array = new Array();

		var hitBox: HitSphere = new HitSphere();

		/** This var holds the players score*/
		public var score: int = 0;

		/** startScreen holds a new StartScreen instance */
		var startScreen: StartScreen = new StartScreen();

		/** startButton holds a new StartButton instance */
		var startButton: StartButton = new StartButton();

		/** this boolean is to check if game is won */
		var isGameWon: Boolean = false;

		/** this boolean is to check if game is lost */
		var isGameLost: Boolean = false;

		/** this boolean is to check if game is lost */
		var isGamePlaying: Boolean = false;

		/** This variable holds just holds the top scorebar */
		var scoreBar: ScoreBar = new ScoreBar();

		/** players health */
		var playerHealth: int = 100;

		/* adds the game over screen to game */
		var gameOverText: LostText = new LostText();

		/** adds reset button to the game */
		var resetButton: ResetButton = new ResetButton();


		/** tells the game if the player does/n't have the tri shot powerup */
		public var hasTriFirePowerUp: Boolean = false;
		/** tells the game if the player does/n't have the rapid shot powerup */
		public var hasRapidFire: Boolean = false;
		/** allows the rapid fire power up to trigger */
		public var rapidFire: Boolean = false;

		public var hasChargeFire: Boolean = false;
		public var chargeFire: Boolean = false;

		var expandWidth: Number = 0;
		var expandHeight: Number = 0;

		var cPowerUps: Array = new Array();
		var rPowerUps: Array = new Array();
		var tPowerUps: Array = new Array();
		
		
			var specialSpawner:int =0;
			
			var hasCPowerUpSpawned:Boolean = false;
			var hasRPowerUpSpawned:Boolean = false;
			var hasTPowerUpSpawned:Boolean = false;
			
		


		/**
		 * This is where we setup the game.
		 */
		public function Game() {

			/** adds startScreen to the game; loads it into the game; then places it into the scene and adds a mouse event to it */
			addChild(startScreen);
			startButton.x = 275;
			startButton.y = 300;
			addChild(startButton);
			startButton.addEventListener(MouseEvent.CLICK, startHandleClick);


		}
		/**
		 * this function is set up to handle the start buttons clicked state
		 * @param g The Event that triggers the game start state
		 */
		private function startHandleClick(g: MouseEvent): void {

			startButton.removeEventListener(MouseEvent.CLICK, startHandleClick); // removes the startButtons event listener
			removeChild(startScreen); // removes the startScreen
			removeChild(startButton); // remorves the startButton

			addEventListener(Event.ENTER_FRAME, gameLoop); // adds the gameLoop to the stage and has a funtion pointed to it

			stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandleClick); // adds the event listener tp the stage and has a function poiinting to it
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandleClick);

			/** sets the score bar to the stage, and places it in front of all moving object. But it is still behind the player score and health. */
			addChildAt(scoreBar, 2);

			/* this is so that the player spawns above the bullet */
			setChildIndex(player, 1);

			hitBox.x = player.x; // sets the hitBox's x to the players x
			hitBox.y = player.y; // sets the hitBox's y to the playyers y
			addChild(hitBox); // adds the hitbox to the stage0

			isGamePlaying = true; // sets if the game is playing to true... this is more for winning and losing states
			    
		}
		
		


		/**
		 * This event-handler is called every time a new frame is drawn.
		 * It's our game loop!
		 * @param e The Event that triggered this event-handler.
		 */
		private function gameLoop(e: Event): void {


			/** this if statement tells the player to update and snow to spawn if the game is not won or lost */
			if (isGameWon == false && isGameLost == false) {
				spawnSnow(); // spawns snow

				player.update(); // updates player
			}
			
			if (score == 700){
				hasCPowerUpSpawned = true;
			}
			if (score == 800){
				hasRPowerUpSpawned = true;
				
			}
			if (score == 900){
				hasTPowerUpSpawned = true;
				
			}
			

			if (rapidFire) {
				rapidDelaySpawn--;
				if (rapidDelaySpawn <= 0) {
					spawnBullet();
					rapidDelaySpawn = 5;
				}
			}

			if (chargeFire) {
				expandWidth += .05;
				expandHeight += .05;
			}

			/** this if statement is to tell if the game is still playing... so if the player loses the game will still update  */
			if (isGamePlaying == true) {
				updateBullets();

				updateSnow();
				
				if (hasCPowerUpSpawned == true){
				updateCPowerUps();
				}
				if (hasRPowerUpSpawned == true){
				updateRPowerUps();	
				}
				if (hasTPowerUpSpawned == true){
				updateTPowerUps();
				}
				collisionDetection();

				shipCollisionDetection();

				scoreBoard.text = "Score: " + score;

				Health.text = "Player Health: " + playerHealth;

				gameLostState();
			}



		} //  gameLoop

		/**
		 * this function handles shooting(adding them into the game) the bullets when the mouse is clicked
		 * @param e The event that triggers the shooting state of the ship
		 */

		private function downHandleClick(e: MouseEvent): void {

			if (hasRapidFire == false || hasChargeFire == false) {
				spawnBullet();
			}

			if (hasRapidFire) {
				rapidFire = true;
			}

			if (hasChargeFire) {
				chargeFire = true;

			}

		}

		private function upHandleClick(f: MouseEvent): void {
			if (hasRapidFire) {
				rapidFire = false;
			}
			if (hasChargeFire) {
				var four: FourShot = new FourShot(player);
				four.scaleX += expandWidth;
				four.scaleY += expandHeight;
				addChildAt(four, 0);
				bullets.push(four);
				expandWidth = 0;
				expandHeight = 0;
				chargeFire = false;
			}

		}

		/**
		 * this function spawns(loads) bullets into the game from the bullet method
		 */

		private function spawnBullet(): void {

			var b: Bullet = new Bullet(player);
			addChildAt(b, 0);
			bullets.push(b);

			if (hasTriFirePowerUp == true) {
				var sec: SecShot = new SecShot(player);
				addChildAt(sec, 0);
				bullets.push(sec);

				var tri: TriShot = new TriShot(player);
				addChildAt(tri, 0);
				bullets.push(tri);

			}
		}

		private function updateCPowerUps(): void {
			
			var c: cPowerUp = new cPowerUp();
				cPowerUps.push(c);
				addChild(cPowerUps[0]);
			
				cPowerUps[0].update();
				if (cPowerUps[0].isDead) {
					hasCPowerUpSpawned = false;
					
					// 1. remove the object from the scene-graph
					removeChild(cPowerUps[0]);

					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					cPowerUps.splice(0, 1);
				}

			
		}

		private function updateRPowerUps(): void {

			var r: rPowerUp = new rPowerUp();
				rPowerUps.push(r);
				addChild(rPowerUps[0]);
			
			// update everything:
				rPowerUps[0].update();
				if (rPowerUps[0].isDead) {
					hasRPowerUpSpawned = false;
					// 1. remove the object from the scene-graph
					removeChild(rPowerUps[0]);

					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					rPowerUps.splice(0, 1);
				}

		}
		

		private function updateTPowerUps(): void {
			
			var t: tPowerUp = new tPowerUp();
				tPowerUps.push(t);
				addChild(tPowerUps[0]);
			
			// update everything:
				tPowerUps[0].update();
				if (tPowerUps[0].isDead) {
					hasTPowerUpSpawned = false;
					// 1. remove the object from the scene-graph
					removeChild(tPowerUps[0]);

					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					tPowerUps.splice(0, 1);
				}
		}

		/**
		 * Decrements the countdown timer, when it hits 0, it spawns a snowflake.
		 */
		private function spawnSnow(): void {
			// spawn snow:
			delaySpawn--;
			if (delaySpawn <= 0) {
				var s: Snow = new Snow();
				addChildAt(s, 2);
				snowflakes.push(s);
				delaySpawn = (int)(Math.random() * 8 + 8);

				if (score >= 500) {
					delaySpawn = (int)(Math.random() * 7 + 7);
				}
				if (score >= 1000) {
					delaySpawn = (int)(Math.random() * 6 + 6);
				}
				if (score >= 1500) {
					delaySpawn = (int)(Math.random() * 5 + 5);
				}
				if (score >= 2000) {
					delaySpawn = (int)(Math.random() * 4 + 4);
				}
				if (score >= 2500) {
					delaySpawn = (int)(Math.random() * 3 + 3);
				}
				if (score >= 3000) {
					delaySpawn = (int)(Math.random() * 2 + 2);
				}
				if (score >= 3500) {
					delaySpawn = (int)(Math.random() * 1 + 1);
				}
			}
		}

		private function updateSnow(): void {
			// update everything:
			for (var i = snowflakes.length - 1; i >= 0; i--) {
				snowflakes[i].update();
				if (snowflakes[i].isDead) {
					// remove it!!

					// 1. remove the object from the scene-graph
					removeChild(snowflakes[i]);

					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					snowflakes.splice(i, 1);
				}
				if (playerHealth == 0) {
					isGameLost = true;
				}

			} // for loop updating snow
		}
		private function updateBullets(): void {
			// update everything:
			for (var i = bullets.length - 1; i >= 0; i--) {
				bullets[i].update();
				if (bullets[i].isDead) {
					// 1. remove the object from the scene-graph
					removeChild(bullets[i]);

					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					bullets.splice(i, 1);
				}
			} // for loop updating bullets
		}

		/**
		 * this function detects whether or not there is a collision between the snowflakes
		 * and the bullets
		 */

		private function collisionDetection(): void {
			for (var i: int = 0; i < snowflakes.length; i++) {
				for (var j: int = 0; j < bullets.length; j++) {

					var dx: Number = snowflakes[i].x - bullets[j].x;
					var dy: Number = snowflakes[i].y - bullets[j].y;
					var dis: Number = Math.sqrt(dx * dx + dy * dy);
					if (dis < snowflakes[i].radius + bullets[j].radius) {
						// collision!
						snowflakes[i].isDead = true;
						bullets[j].isDead = true;
						score += 100;
					}
				}
			}
		} // end collision

		/**
		 * this function is used to detect whether or not there is collision between the snow and the ship
		 */

		private function shipCollisionDetection(): void {
			for (var i: int = 0; i < snowflakes.length; i++) {

				var sx: Number = snowflakes[i].x - hitBox.x;
				var sy: Number = snowflakes[i].y - hitBox.y;
				var sDis: Number = Math.sqrt(sx * sx + sy * sy);
				if (sDis < snowflakes[i].radius + hitBox.radius) {
					// collision!
					snowflakes[i].isDead = true;
					playerHealth -= 100;
				}
				if (isGameLost == true) {
					snowflakes[i].isDead = true;
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, downHandleClick);
					stage.removeEventListener(MouseEvent.MOUSE_UP, upHandleClick);
					isGamePlaying = false;
				}
			}
		} // end shipCollision
		
		private function chargeCollisionDetection(): void {
				for (var j: int = 0; j < bullets.length; j++) {

					var cx: Number =  bullets[j].x - cPowerUps.x;
					var cy: Number =  bullets[j].y - cPowerUps.y;
					var cDis: Number = Math.sqrt(cx * cx + cy * cy);
					if (cDis < cPowerUps.radius + bullets[j].radius) {
						// collision!
						cPowerUps.isDead = true;
						bullets[j].isDead = true;
						
					}
				}
		} // end collision
		
		private function rapidCollisionDetection(): void {
				for (var j: int = 0; j < bullets.length; j++) {

					var rx: Number = rPowerUps[0].x - bullets[j].x;
					var ry: Number = rPowerUps[0].y - bullets[j].y;
					var rDis: Number = Math.sqrt(rx * rx + ry * ry);
					if (rDis < rPowerUps[0].radius + bullets[j].radius) {
						// collision!
						rPowerUps[0].isDead = true;
						bullets[j].isDead = true;
						
					}
				}
		} // end collision
		
		private function tripleCollisionDetection(): void {
				for (var j: int = 0; j < bullets.length; j++) {

					var tx: Number = tPowerUps[0].x - bullets[j].x;
					var ty: Number = tPowerUps[0].y - bullets[j].y;
					var tDis: Number = Math.sqrt(tx * tx + ty * ty);
					if (tDis < tPowerUps[0].radius + bullets[j].radius) {
						// collision!
						tPowerUps[0].isDead = true;
						bullets[j].isDead = true;
						
					}
				}
		} // end collision

		/**
		 * this function handles for when the game is lost.
		 */

		private function gameLostState(): void {
			if (isGamePlaying == false && isGameLost == true) {
				gameOverText.x = 275;
				gameOverText.y = 200;
				addChild(gameOverText);
				scoreBoard.x = 147;
				scoreBoard.y = 225;
				addChild(scoreBoard);
				scoreBoard.text = ("Your Score Was: " + score);
				resetButton.x = 275;
				resetButton.y = 300;
				addChild(resetButton);
				resetButton.addEventListener(MouseEvent.CLICK, resetHandleClick);
			}
		}

		/**
		 * this function handles the reset button. When clicked, it resets everthing as if the game was started fresh.
		 * @param r The event that triggers the reset state of the game
		 */

		private function resetHandleClick(r: MouseEvent): void {
			resetButton.removeEventListener(MouseEvent.CLICK, resetHandleClick);
			removeChild(gameOverText);
			removeChild(resetButton);
			scoreBoard.x = 0;
			scoreBoard.y = 0;

			score = 0;
			playerHealth = 100;
			isGameLost = false;
			isGamePlaying = true;
			
		


			stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandleClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandleClick);
		}


	} // class Game
} // package