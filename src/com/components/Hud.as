package com.components{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.molydeux.PlayerModel;
	import com.molydeux.BabyModel;
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.*;
	import flash.utils.*;
	
	public class Hud extends MovieClip{

		
	
		// stage
		private var _stage:Stage;
		// init objs
		public var theHud:MovieClip;
		//// life gauge
		/// private var craneHealthGauge:MovieClip;
		
		/// 
		
		public function Hud(){
			// _stage = ResizeUtil.getInstance().stage;
			/// trace("Hello Dialog Box" + _stage.height);
			initDisplay();
			
			
		}
		private function initDisplay():void{
			
			theHud = new hud_gfx();
			addChild(theHud);
			
		}
		public function updateTime(theTime:String):void{
			
		}
		public function updateDisplay():void{
			// var theStatus = 5-BabyModel.babyHealth;
			// theHud.lifeGaugeMC = 
			theHud.babyFace.gotoAndStop(BabyModel.babyHealth);
			
			if(PlayerModel.playerHealth > 5){
				
				PlayerModel.playerHealth = 5;
			}
			TweenMax.to(theHud.lifeGaugeMC.needleMC, .25,{rotation:180-Math.round(PlayerModel.playerHealth*36)});
			TweenMax.to(theHud.lifeGaugeMC.colorStripeMC, .25,{y:PlayerModel.playerHealth * 20});
			// trace("DIAL: " + GameModel.craneLife*3.6);
			//theDisplay.scoreTxt.text = String(GameModel.totalScore);
			// theDisplay.numObjColTxt.text = String(GameModel.curPrizCol) + " / " + GameModel.numPrizLev; 
			
			
		}
		
		
		
		public function resetDisplay():void{
			
		}
		/// end constructor
	}
	//// end package
}