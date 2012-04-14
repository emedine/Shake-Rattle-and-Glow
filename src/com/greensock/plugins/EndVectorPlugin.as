/**
 * VERSION: 0.9
 * DATE: 10/22/2009
 * ACTIONSCRIPT VERSION: 3.0 
 * UPDATES AND DOCUMENTATION AT: http://blog.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.*;
	
	import flash.display.*;

	public class EndVectorPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _v:Vector.<Number>;
		/** @private **/
		protected var _info:Vector.<VectorInfo> = new Vector.<VectorInfo>();
		
		/** @private **/
		public function EndVectorPlugin() {
			super();
			this.propName = "endVector"; //name of the special property that the plugin should intercept/manage
			this.overwriteProps = ["endVector"];
		}
		
		/** @private **/
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(target is Vector.<Number>) || !(value is Vector.<Number>)) {
				return false;
			}
			init(target as Vector.<Number>, value as Vector.<Number>);
			return true;
		}
		
		/** @private **/
		public function init(start:Vector.<Number>, end:Vector.<Number>):void {
			_v = start;
			var i:int = end.length, cnt:uint = 0;
			while (i--) {
				if (_v[i] != end[i]) {
					_info[cnt++] = new VectorInfo(i, _v[i], end[i] - _v[i]);
				}
			}
		}
		
		/** @private **/
		override public function set changeFactor(n:Number):void {
			var i:int = _info.length, vi:VectorInfo;
			if (this.round) {
				var val:Number;
				while (i--) {
					vi = _info[i];
					val = vi.start + (vi.change * n);
					_v[vi.index] = (val > 0) ? int(val + 0.5) : int(val - 0.5); //4 times as fast as Math.round()
				}
			} else {
				while (i--) {
					vi = _info[i];
					_v[vi.index] = vi.start + (vi.change * n);
				}
			}
		}
		
	}
}

internal class VectorInfo {
	public var index:uint;
	public var start:Number;
	public var change:Number;
	
	public function VectorInfo(index:uint, start:Number, change:Number) {
		this.index = index;
		this.start = start;
		this.change = change;
	}
}