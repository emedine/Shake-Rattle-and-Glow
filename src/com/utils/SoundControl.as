package com.utils{
		
		
		import flash.display.*;
		import flash.events.*;
		import flash.media.*;
		import flash.net.URLRequest;
		import flash.utils.ByteArray;
		
		import com.molydeux.GameModel;
		//
		
		
		public class SoundControl extends MovieClip{
			
			
			public static var theSound:String;
			//
			private var myTransform:SoundTransform = new SoundTransform();
			private var myLoopTransform:SoundTransform = new SoundTransform();
			public var myChannel:SoundChannel = new SoundChannel();
			private var theLoopChannel:SoundChannel = new SoundChannel();
			private var sourceSound:Sound = new Sound();
			private var fxSound:Sound = new Sound();
			//
			private var toggleButton:MovieClip;
			
			///
			public var isSoundTrackOn:Boolean;
			
			/// sounds for soundtrack
			public var loop1:bground_audio;
			// private var loop1:CJ_PandaEx_Island_Soundtrack;
			/*		
			private var loop2:soundtrackLoop2;
			private var loop3:soundtrackLoop3;
			private var loop4:soundtrackLoop4;
			private var loop5:soundtrackLoop5;
			private var loop6:soundtrackLoop6;
			private var loop7:soundtrackLoop7;
			*/
			private var theLoop;
			
			
			
			/// public var muteDistractionVideo:Event = new Event('muteDistractionVideo'); 
			
			public function SoundControl() {

				toggleButton = new sound_toggle_gfx();
				addChild(toggleButton);
				toggleButton.gotoAndStop(1);
				/// doSoundTrackLoop(null);
				toggleButton.addEventListener(MouseEvent.CLICK, toggleVolume);
				toggleButton.buttonMode = true;
				toggleButton.mouseChildren = false;
				// toggleButton.visible = false;
			}

			
			///// this is for soundtrack loops
			
			public function doSoundTrackLoop(theSoundtrack):void{
				// trace("MUTE IS ON: " + GameModel.isMuteOn);
				/*
				if(loop1 !=null){
					theLoopChannel.stop();
				}
				*/
				/*
				theLoop = new theDingoAteYourBaby();
				theLoopChannel = theLoop.play(0,99);
				//*/
				trace("1");
				theLoop = new theSoundtrack;
				theLoopChannel = theLoop.play(0,99);
				myLoopTransform.volume = .15;
				theLoopChannel.soundTransform = myLoopTransform;
				trace("2");
				
				if(GameModel.isMuteOn == false){
					try{
					
					/// var loopObj:Sound = new Sound();
					//// myChannel = loopObj.play();  /// comment out to use up-octive
							trace("3");
					// theLoop = new theSoundtrack;
					theLoopChannel = loop1.play(0,99);
					myLoopTransform.volume = .15;
					
					trace("4");
					if (GameModel.isMuteOn == true){
						myLoopTransform.volume = 0;
					} else if(GameModel.isMuteOn == false){
						myLoopTransform.volume = .15;
					}
					
					/// soundObj.addEventListener(Event.COMPLETE, soundLoaded);  /// comment in to use up-octive
					/// sourceSound = soundObj;
					theLoopChannel.soundTransform = myLoopTransform;
					} catch (e:Error){
						trace("sound init error");
					}
				}
			}
			
			//// mute soundtrack between levels, after game, etc
			public function muteSoundTrack():void{
				trace("Muting soundtrack");
				myLoopTransform.volume = 0;
				theLoopChannel.soundTransform = myLoopTransform;
				
			}
			public function unMuteSoundTrack():void{
				if(GameModel.isMuteOn == false){
					myLoopTransform.volume = .15;
					theLoopChannel.soundTransform = myLoopTransform;
				}
				
			}
			
			///// sound FX
			
			public function playAudio(theSound:String, theVolume:int):void{
				// trace("PLaying Audio");
				if(GameModel.isMuteOn == false){
					var soundObj:Sound = new Sound();
					var url:String = theSound;
					
					var urlRequest:URLRequest = new URLRequest(url);
					
					soundObj.load(urlRequest);
					
					myChannel = soundObj.play();  
					
					if (GameModel.isMuteOn == true){
						myTransform.volume = 0;
					} else if(GameModel.isMuteOn == false){
						myTransform.volume = theVolume;
					}
					myChannel.soundTransform = myTransform;
					
					
				}
				
			}
			public function stopAudio():void{
				trace("Stop sound");
				/// myTransform.stop();
				myChannel.stop();
				theLoopChannel.stop();
				
			}
			/// pitch shift /// doesn't work but it's really cool
			/*		var bytes:ByteArray = new ByteArray(); 
			position += srcSound.extract(bytes, 4096, position); 
			event.data.writeBytes(shiftBytes(bytes));
			
			private function shiftBytes(bytes:ByteArray):ByteArray{
			var skipCount:Number = 0; 
			var skipRate:Number = 1 + (1 / (pitchShiftFactor - 1)); 
			var returnBytes:ByteArray = new ByteArray(); 
			bytes.position = 0; 
			while(bytes.bytesAvailable & gt; 0){
			skipCount++; 
			if (skipCount &lt;= skipRate) { 
			returnBytes.writeFloat(bytes.readFloat()); 
			returnBytes.writeFloat(bytes.readFloat()); 
			} else { 
			bytes.position += 8; skipCount = skipCount - skipRate; 
			} 
			
			}
			return returnBytes; 
			}*/
			
			//// up an octive
			/// this works!
			/*function soundLoaded(event:Event):void{ 
			fxSound.addEventListener(SampleDataEvent.SAMPLE_DATA, processSound); 
			fxSound.play(); 
			}
			function processSound(event:SampleDataEvent):void { 
			var bytes:ByteArray = new ByteArray(); 
			sourceSound.extract(bytes, 8192); 
			event.data.writeBytes(upOctave(bytes)); 
			} 
			function upOctave(bytes:ByteArray):ByteArray 
			{ 
			var returnBytes:ByteArray = new ByteArray(); 
			bytes.position = 0; 
			while(bytes.bytesAvailable > 0) 
			{ 
			returnBytes.writeFloat(bytes.readFloat()); 
			returnBytes.writeFloat(bytes.readFloat()); 
			if (bytes.bytesAvailable > 0) 
			{ 
			bytes.position += 8; 
			} 
			} 
			return returnBytes; 
			}*/
			
			///// toggle and mute
			public function toggleVolume(e:Event):void{
				if(GameModel.isMuteOn == false){
					//// turn mute on 
					GameModel.isMuteOn = true;
					myTransform.volume = 0;
					toggleButton.gotoAndStop(2);
					// dispatchEvent(muteDistractionVideo);
					
				} else if (GameModel.isMuteOn ===true){
					/// turn mute off
					GameModel.isMuteOn = false;
					// dispatchEvent(muteDistractionVideo);
					myTransform.volume = 1;
					toggleButton.gotoAndStop(1);
				}
				
				myChannel.soundTransform = myTransform;
				theLoopChannel.soundTransform = myTransform; /// 
				
			}
			
			///// end class
		}
		//// end package
		
	}
