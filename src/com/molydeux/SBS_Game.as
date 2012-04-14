﻿package com.molydeux {		import Box2DAS.*;	import Box2DAS.Collision.*;	import Box2DAS.Collision.Shapes.*;	import Box2DAS.Common.*;	import Box2DAS.Dynamics.*;	import Box2DAS.Dynamics.Contacts.*;	import Box2DAS.Dynamics.Joints.*;	import cmodule.Box2D.*;	import wck.*;	import misc.*;		import flash.utils.*;	import flash.events.*;	import flash.display.*;	import flash.text.*;	import flash.geom.*;	import flash.ui.*;	//		import wck.Avatar;	//	import com.components.Hud;	import com.utils.ResizeUtil;	import com.utils.InterfaceEvent;	import com.components.DialogBox;		//	import com.utils.SoundControl;		/**	 * A base document class for WCK based Flash SWFs	 */	public class SBS_Game extends WCK {		private var _gameLoopCounter:int;				private var theDialogBox:DialogBox;		private var theHUD:Hud;		private var theSoundControl:SoundControl;				public function SBS_Game(){						// instantiate the ResizeUtil singleton and give it the reference to the stage:			ResizeUtil.setStage(stage);						titleMC.play_btn.addEventListener(MouseEvent.CLICK, removeTitleUI);		}				private function removeTitleUI(event:MouseEvent):void {						removeChild(titleMC);			//			addChild(theHUD);			//			addChild(theSoundControl);												theSoundControl.x = 180; // theHUD.x + theSoundControl.width;			theSoundControl.y = 32; // theHUD.y - theHUD.height/2;			theDialogBox = new DialogBox();			addChild(theDialogBox);			theDialogBox.displayContent("Welcome to Shake, Rattle and Glow", "You have foolishly chosen to bring your child to work on 'bring your child to work day' at the lab. A terrible accident has made your baby radioactive-- escape from the lab using the glow from your radioactive infant to light your way, destroy obstacles, but beware of creatures and hazards that feed on radiation! Use 'WASD' keys to move and jump, and 'Spacebar' to shake your baby!");			stage.focus=this;			theDialogBox.showDialog();			//theDialogBox.hideDialog(null);		}				public override function create():void {						super.create();			stage.focus = this;			/// addChild(new Stats());			_gameLoopCounter = 0;			/// listeners			stage.addEventListener(Event.ENTER_FRAME, gameLoop);			stage.addEventListener(InterfaceEvent.LOSE, doLose, false, 0, true);			stage.addEventListener(InterfaceEvent.WIN, doWin, false, 0, true);			stage.addEventListener(InterfaceEvent.PAUSE, doPause, false, 0, true);			stage.addEventListener(InterfaceEvent.UNPAUSE, unPause, false, 0, true);			stage.addEventListener(InterfaceEvent.GAMESTART, gameStart, false, 0, true);			stage.addEventListener(InterfaceEvent.RESTART, doRestart, false, 0, true);			stage.addEventListener(InterfaceEvent.REACHEDGOAL, reachedGoal, false, 0, true);			stage.addEventListener(InterfaceEvent.NEXTLEVEL, doNextLevel, false, 0, true);			stage.addEventListener(InterfaceEvent.FOUNDSECRET, doSecretFound, false, 0, true);			stage.addEventListener(InterfaceEvent.UPDATEHUD, updateHUD, false, 0, true);			stage.addEventListener(InterfaceEvent.DOSCREAM, doScream, false, 0, true);			stage.addEventListener(InterfaceEvent.SHAKEBABYSOUND, shakeBaby, false, 0, true);			stage.addEventListener(InterfaceEvent.DOEXPLOSION, doExplosion, false, 0, true);			///			theHUD = new Hud();			//addChild(theHUD);			theHUD.x = 10;			theHUD.y = 10;			//			theSoundControl = new SoundControl(); //  as MovieClip;						//			/*			theDialogBox = new DialogBox();			addChild(theDialogBox);			theDialogBox.displayContent("Welcome to Shake, Rattle and Glow", "You have foolishly chosen to bring your child to work on 'bring your child to work day' at the lab. A terrible accident has made your baby radioactive-- escape from the lab using the glow from your radioactive infant to light your way, destroy obstacles, but beware of creatures and hazards that feed on radiation!");						theDialogBox.showDialog();			*/								}							private function gameLoop(event:Event):void {			var spaceBarHit:Boolean = Input.ku(' ');						if (spaceBarHit) {				world.shake = new Point(10, 10);				dispatchEvent(new InterfaceEvent("shakeBaby"));			}									if (_gameLoopCounter%5 == 0) {								//Check mask collision with reactive objects				var lightRect:Rectangle = world.boxman.lightMask.getRect(stage);				var theAvatar:Avatar = world.boxman;				for (var i:int = 0; i < world.numChildren; i++) {					// check for reactive box					try{						if (world.getChildAt(i) is ReactiveBox) {							var objectRect:Rectangle = world.getChildAt(i).getRect(stage);														if (lightRect.intersects(objectRect)) {								ReactiveBox(world.getChildAt(i)).increaseReactivity();							}						} else						/// check for hazard						if (world.getChildAt(i) is Hazard) {							var hazardRect:Rectangle = world.getChildAt(i).getRect(stage);														if (lightRect.intersects(hazardRect)) {								Hazard(world.getChildAt(i)).increaseReactivity();							}						} else						/// check for goal						if (world.getChildAt(i) is Goal) {							var goalRect:Rectangle = world.getChildAt(i).getRect(stage);														if (lightRect.intersects(goalRect)) {								Goal(world.getChildAt(i)).increaseReactivity();							}						} else						/// check for secret						if (world.getChildAt(i) is Secret) {							var secretRect:Rectangle = world.getChildAt(i).getRect(stage);														if (lightRect.intersects(secretRect)) {								Secret(world.getChildAt(i)).increaseReactivity();							}						} else											/// check for door						if (world.getChildAt(i) is DoorDestroy) {							var doorRect:Rectangle = world.getChildAt(i).getRect(stage);														if (lightRect.intersects(doorRect)) {								DoorDestroy(world.getChildAt(i)).increaseReactivity();							}						} else						/// check for sign						if (world.getChildAt(i) is Sign) {							objectRect = world.getChildAt(i).getRect(stage);														if (lightRect.intersects(objectRect)) {								Sign(world.getChildAt(i)).increaseReactivity();							}						}										} catch (e:Error){						trace("something weird is happening with the hit state");					}									}			}						_gameLoopCounter++;		}				private function reachedGoal(e:Event):void{			PlayerModel.curLevel++;						if(PlayerModel.curLevel >= PlayerModel.totalLevel){				PlayerModel.hasWon = true;							}			doWin();					}				private function gameStart(e:Event):void{			if(GameModel.hasPlayed == false){			theSoundControl.doSoundTrackLoop(bground_audio);			}			GameModel.hasPlayed = true;			/// do dialog box game start			PlayerModel.curLevel = 1;			PlayerModel.curScore; /// current score for display			PlayerModel.hasWon == false;			//			PlayerModel.playerHealth = 5;			PlayerModel.playerSpeed = 6;			PlayerModel.playerJump = -24;						// 						PlayerModel.standPos = "left";			// boolean			PlayerModel.isWalking = false;			PlayerModel.isJumping = false;						BabyModel.babyHealth = 5;			BabyModel.babySize = 1;			BabyModel.lightSize = 1;			BabyModel.numShakes = 0;						dispatchEvent(new InterfaceEvent("updateAvatar"));									updateHUD(null);				}		private function doNextLevel(e:Event):void{			world.paused= false;			world.goalGfx.gotoAndPlay(2);			theDialogBox.hideDialog(null);			theHUD.updateDisplay();		}				private function doRestart(e:Event):void{			gameStart(null);			theHUD.updateDisplay();		}						private function doPause(e:Event):void{						world.paused= true;			/*			if(GameModel.isMuteOn == false){			theSoundControl.toggleVolume(null);			} 			*/		}						private function unPause(e:Event):void{						world.paused=false;			/*			if(GameModel.isMuteOn == true){			theSoundControl.toggleVolume(null);			} 			*/		}		private function doLose(e:Event):void{			// pause game			doPause(null);			// do dialog box game overfd			theSoundControl.playAudio("Sound/theDingoAteYourBaby.mp3", 1);			theDialogBox.displayLoseContent();			theHUD.updateDisplay();		}				private function doWin():void{			// pause game			doPause(null);			// do dialog box game overfd			theDialogBox.displayWinContent();			theHUD.updateDisplay();			theSoundControl.playAudio("Sound/Choir.mp3", 1);		}				private function doSecretFound(e:Event):void{						// pause game			doPause(null);			// do dialog box game overfd			theDialogBox.displaySecretContent();			theSoundControl.playAudio("Sound/Powerup.mp3", 1);					}						private function updateHUD(e:Event){			theHUD.updateDisplay();					}		private function doScream(e:Event):void{			theSoundControl.playAudio("Sound/wilhelm_scream_opt.mp3", 1);		}		private function doExplosion(e:Event):void{			theSoundControl.playAudio("Sound/Cannon_f-Mike-7604_hifi.mp3", 1);		}				private function shakeBaby(e:Event):void{			/// make random number to pick a baby sound			var rnd:int = Math.floor(Math.random() * 5) + 1;			var theSound:String;			trace("Random: " + rnd);			if(rnd == 1){				theSound = "Sound/baby1.mp3";			} else if (rnd ==2){				theSound = "Sound/baby2.mp3";			} else if (rnd ==3){				theSound = "Sound/baby3.mp3";			} else if (rnd ==4){				theSound = "Sound/baby4.mp3";			} else if (rnd ==5){				theSound = "Sound/baby1.mp3";			}									theSoundControl.playAudio("Sound/shaking_short.mp3", 1);			theSoundControl.playAudio(theSound, 1);		}					}}