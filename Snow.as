package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class Snow extends MovieClip {
		
		private var speed:Number;
		/** If this is true, the object is queued up to be destroyed!! */
		public var isDead:Boolean = false;
		
		public var radius:Number = 51;
		
		var minLimit:int = -3;
        var maxLimit:int = 3;
        var range:int = maxLimit - minLimit;
		var myNum:Number = Math.ceil(Math.random()*range) + minLimit;
		
		public function Snow() {
			x = Math.random() * 550;
			y = - 50;
			speed = Math.random() * 3 + 2; // 2 to 5?
			scaleX = Math.random() * .3 + .2; // .1 to .3
			scaleY = scaleX;
			radius *= scaleX;

			
		}
		public function update():void {
			// fall
			y += speed + 1;
			x += myNum;

			if(y > 400){
				isDead = true;
			}
		}
		private function handleClick(e:MouseEvent):void {
			isDead = true;
		}
		
		
		
	}
	
}
