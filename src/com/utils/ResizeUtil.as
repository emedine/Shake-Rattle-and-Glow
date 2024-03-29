//ResizeUtil
package com.utils
{
    import flash.display.*;
    import flash.events.*;
    
	/**
	 * @author Jeremy Cummins
	 * 
	 * The ResizeUtil helps with stage resize events. Follows the Observer Design Pattern.
	 * All observers must implement the IResizable interface. Add observers with 'ResizeUtil.getInstance().addClient(observer);'
	 * IResizable defines the method 'onResize(e:Event)' where you can place code pertaining to stage resize positioning.
	 */
    public class ResizeUtil extends flash.events.EventDispatcher
    {
		/**
		 * This class is a Singleton -- when instantiating use this static method, i.e. 'ResizeUtil.getInstance();' 
		 * @return
		 */
        public static function getInstance():com.utils.ResizeUtil
        {
            if (!instance) 
            {
                instance = new ResizeUtil(new SingletonEnforcer());
            }
            return instance;
        }

		/**
		 * Must be called on initialization of main app where stage is available.
		 * Pass reference to the stage and the ResizeUtil will make that reference available to all observers with the 'get stage' method.
		 * @param	stageInstance
		 */
        public static function setStage(stageInstance:flash.display.Stage):void
        {
            if (getInstance()._stage == null) 
            {
                getInstance()._stage = stageInstance;
                stageInstance.addEventListener(flash.events.Event.RESIZE, instance.onStageResize, false, 0, false);
                stageInstance.align = flash.display.StageAlign.TOP_LEFT;
                stageInstance.scaleMode = flash.display.StageScaleMode.NO_SCALE;
                getInstance().forceResize();
            }
            return;
        }
		
		/**
		 * returns a reference to the stage
		 */
        public function get stage():flash.display.Stage
        {
            return this._stage;
        }

		/**
		 * public method for adding observers to resize events
		 * @param	client
		 * @param	useWeakReference
		 */
        public function addClient(client:com.utils.IResizable, useWeakReference:Boolean=true):void
        {
            addEventListener(flash.events.Event.RESIZE, client.onResize, false, 0, useWeakReference);
			return;
        }
		
		/**
		 * public method for removing observers - should be called before observer is unloaded
		 * @param	client
		 */
		public function removeClient(client:com.utils.IResizable):void
        {
            removeEventListener(flash.events.Event.RESIZE, client.onResize);
            return;
        }
		
		/**
		 * public method to force a resize event - useful when initializing the view of an observer, all positioning can be done in the observer's onResize method
		 */
        public function forceResize():void
        {
            if (this.stage) 
            {
                this.stage.dispatchEvent(new flash.events.Event(flash.events.Event.RESIZE));
            }
            return;
        }

        private function onStageResize(e:flash.events.Event):void
        {
            dispatchEvent(new flash.events.Event(flash.events.Event.RESIZE));
            return;
        }

		/**
		 * public method to resize a DisplayObject to the stage area
		 * @param	target
		 * @param	y
		 * @param	rightPadding
		 * @param	bottomPadding
		 * @param	x
		 */
        public function fillScreen(target:flash.display.DisplayObject, y:int=0, rightPadding:int=0, bottomPadding:int=0, x:int=0):void
        {
            if (target) 
            {
                target.x = x;
                target.y = y;
                target.width = this.width - rightPadding - x;
                target.height = this.height - bottomPadding - y;
            }
            return;
        }
		
		/**
		 * public method to resize a DisplayObject to the stage area without changing its aspect ratio
		 * @param	target
		 * @param	container
		 */
		public function fillScreenProportional(target:flash.display.DisplayObject, container:flash.display.DisplayObject = null):void {
			var containerW:Number = this.width;
			var containerH:Number = this.height;
			if (container) {
				containerW = container.width;
				containerH = container.height;
			}
			
			var originalW:Number = target.width / target.scaleX;
			var originalH:Number = target.height / target.scaleY;
			
			if (containerW / containerH < originalW / originalH ) {
				target.height = containerH;
				target.scaleX = target.scaleY;
			} else {
				target.width = containerW;
				target.scaleY = target.scaleX;
			}
		}

        public function scaleToFitWidth(target:flash.display.DisplayObject, w:Number=NaN):void
        {
            if (isNaN(w)) w = this.width;
            target.width = w;
            target.scaleY = target.scaleX;
            return;
        }

        public function centerY(target:flash.display.DisplayObject, container:flash.display.DisplayObject=null):void
        {
            var containerH:Number = this.height;
			var containerY:Number = 0;
            if (container) {
                containerH = container.height;
                containerY = container.y;
            }
            target.y = Math.round(containerY + (containerH - target.height) / 2);
        }

        public function centerX(target:flash.display.DisplayObject, container:flash.display.DisplayObject=null):void
        {
            var containerW:Number = this.width;
			var containerX:Number = 0;
            if (container) {
                containerW = container.width;
                containerX = container.x;
            }
            target.x = Math.round(containerX + (containerW - target.width) / 2);
        }

        public function center(target:flash.display.DisplayObject, container:flash.display.DisplayObject=null):void
        {
            this.centerX(target, container);
            this.centerY(target, container);
        }
		
		/**
		 * returns stage width / stage height
		 */
        public function get ratio():Number
        {
            return this.width / this.height;
        }
		
		/**
		 * returns stage vertical center
		 */
        public function get verticalCenter():int
        {
            return Math.round(this.height / 2);
        }

		/**
		 * returns stage horizontal center
		 */
        public function get horizontalCenter():int
        {
            return Math.round(this.width / 2);
        }

		/**
		 * returns stage.stageHeight
		 */
        public function get height():Number
        {
            return this.stage.stageHeight;
        }

		/**
		 * returns stage.stageWidth
		 */
        public function get width():Number
        {
            return this.stage.stageWidth;
        }

		/**
		 * Constructor. This class is a Singleton.
		 * SingletonEnforcer prevents this class from being instantiated with the constructor.
		 * Use 'ResizeUtil.getInstance()' instead.
		 * 
		 * @param enforcer - a SingletonEnforcer can only be created internally.
		 */
        public function ResizeUtil(enforcer:SingletonEnforcer)
        {
            super();
            return;
        }

        private static var instance:com.utils.ResizeUtil;

        private var _stage:flash.display.Stage;
    }
}

class SingletonEnforcer {}

