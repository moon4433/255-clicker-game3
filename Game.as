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
		var isGameWon:Boolean = false;
		/** this boolean is to check if game is lost */
		var isGameLost:Boolean = false;
		
		var isGamePlaying:Boolean = false;
		
		
        /** This variable holds just holds the top scorebar */
		var scoreBar: ScoreBar = new ScoreBar();
        /** players health */
		var playerHealth: int = 100;


		/**
		 * This is where we setup the game.
		 */
		public function Game() {

			addChild(startScreen);
			startButton.x = 275;
			startButton.y = 300;
			addChild(startButton);
			startButton.addEventListener(MouseEvent.CLICK, startHandleClick);

		}
		/**
		 * this function
		 *
		 */
		private function startHandleClick(g: MouseEvent): void {

			startButton.removeEventListener(MouseEvent.CLICK, startHandleClick);
			removeChild(startScreen);
			removeChild(startButton);

			addEventListener(Event.ENTER_FRAME, gameLoop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleClick);

			addChildAt(scoreBar, 2);

			/* this is so that the player spawns above the bullet */
			setChildIndex(player, 1);
			
			hitBox.x = player.x;
			hitBox.y = player.y;
			addChild(hitBox);
			
			isGamePlaying = true;
		}


		/**
		 * This event-handler is called every time a new frame is drawn.
		 * It's our game loop!
		 * @param e The Event that triggered this event-handler.
		 */
		private function gameLoop(e: Event): void {
			
			
			if (isGameWon == false && isGameLost == false){
			spawnSnow();
			
			player.update();
            }
			updateBullets();
            
			updateSnow();

			collisionDetection();
			
			shipCollisionDetection();

			scoreBoard.text = "Score: " + score;

			Health.text = "Player Health: " + playerHealth;
			
			

		} //  gameLoop

		private function handleClick(e: MouseEvent): void {
			spawnBullet();
		}

		private function spawnBullet(): void {

			var b: Bullet = new Bullet(player);
			addChildAt(b, 0);
			bullets.push(b);
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
				
				if(score >= 500){
					delaySpawn = (int)(Math.random() * 5 + 5);
				}
			}
		}

		private function updateSnow(): void {
			// update everything:
			for (var i = snowflakes.length - 1; i >= 0; i--) {
				snowflakes[i].update();
				if (snowflakes[i].isDead) {
					// remove it!!

					// 1. remove any event-listeners on the object



					// 2. remove the object from the scene-graph
					removeChild(snowflakes[i]);

					// 3. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					snowflakes.splice(i, 1);
				}
				if(playerHealth == 0){
				isGameLost = true;
			}
				
			} // for loop updating snow
		}
		private function updateBullets(): void {
			// update everything:
			for (var i = bullets.length - 1; i >= 0; i--) {
				bullets[i].update();
				if (bullets[i].isDead) {
					// remove it!!

					// 1. remove any event-listeners on the object

					// 2. remove the object from the scene-graph
					removeChild(bullets[i]);

					// 3. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					bullets.splice(i, 1);
				}
			} // for loop updating bullets
		}

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
				if(isGameLost == true){
			    snowflakes[i].isDead = true;
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleClick);
					// TODO: finish ending screen, and make restart button.
				isGamePlaying = false;
				}
			}
		} // end shipCollision
		

	} // class Game
} // package