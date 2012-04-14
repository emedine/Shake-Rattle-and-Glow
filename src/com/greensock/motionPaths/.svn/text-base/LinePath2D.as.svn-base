/**
 * VERSION: 0.11 (beta)
 * DATE: 2010-05-04
 * ACTIONSCRIPT VERSION: 3.0 
 * UPDATES AND DOCUMENTATION AT: http://www.GreenSock.com
 **/
package com.greensock.motionPaths {
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class LinePath2D extends MotionPath {		
		/** @private **/
		protected var _first:PathPoint;
		/** @private **/
		protected var _points:Array;
		/** @private **/
		protected var _totalLength:Number;
		/** @private **/
		protected var _hasAutoRotate:Boolean;
		/** @private **/
		protected var _prevMatrix:Matrix;
		
		/** If true, the LinePath2D will analyze every Point whenever it renders to see if any Point's x or y value has changed, thus making it possible to tween them dynamically. Setting <code>autoUpdatePoints</code> to <code>true</code> increases the CPU load due to the extra processing, so only set it to <code>true</code> if you plan to change one or more of the Points' position. **/
		public var autoUpdatePoints:Boolean;
		
		/**
		 * Constructor
		 * 
		 * @param points An array of Points that define the line
		 * @param x The x coordinate of the origin of the line
		 * @param y The y coordinate of the origin of the line
		 * @param autoUpdatePoints If true, the LinePath2D will analyze every Point whenever it renders to see if any Point's x or y value has changed, thus making it possible to tween them dynamically. Setting <code>autoUpdatePoints</code> to <code>true</code> increases the CPU load due to the extra processing, so only set it to <code>true</code> if you plan to change one or more of the Points' position.
		 */
		public function LinePath2D(points:Array=null, x:Number=0, y:Number=0, autoUpdatePoints:Boolean=false) {
			super();
			_points = [];
			_totalLength = 0;
			this.autoUpdatePoints = autoUpdatePoints;
			if (points != null) {
				insertMultiplePoints(points, 0);
			}
			super.x = x;
			super.y = y;
		}
		
		/** 
		 * Adds a Point to the end of the current LinePath2D (essentially redefining its end point).
		 * 
		 * @param point A Point describing the local coordinates through which the line should be drawn.
		 **/
		public function appendPoint(point:Point):void {
			_insertPoint(point, _points.length, false);
		}
		
		/** 
		 * Inserts a Point at a particular index value in the <code>points</code> array, similar to splice() in an array.
		 * For example, if a LinePath2D instance has 3 Points already and you want to insert a new Point right after the
		 * first one, you would do:<br /><br /><code>
		 * 
		 * var path:LinePath2D = new LinePath2D([new Point(0, 0), <br />
		 * 										 new Point(100, 50), <br />
		 * 										 new Point(200, 300)]); <br />
		 * path.insertPoint(new Point(50, 50), 1); <br /><br /></code>
		 * 
		 * @param point A Point describing the local coordinates through which the line should be drawn.
		 * @param index The index value in the <code>points</code> array at which the Point should be inserted.
		 **/
		public function insertPoint(point:Point, index:uint=0):void {
			_insertPoint(point, index, false);
		}
		
		/** @private **/
		protected function _insertPoint(point:Point, index:uint, skipOrganize:Boolean):void {
			_points.splice(index, 0, new PathPoint(point));
			if (!skipOrganize) {
				_organize();
			}
		}
		
		
		/**
		 * Appends multiple Points to the end of the <code>points</code> array. Identical to 
		 * the <code>appendPoint()</code> method, but accepts an array of Points instead of just one.
		 * 
		 * @param points An array of Points to append.
		 */
		public function appendMultiplePoints(points:Array):void {
			insertMultiplePoints(points, _points.length);
		}
		
		/**
		 * Inserts multiple Points into the <code>points</code> array at a particular index/position.
		 * Identical to the <code>insertPoint()</code> method, but accepts an array of points instead of just one.
		 * 
		 * @param points An array of Points to insert.
		 * @param index The index value in the <code>points</code> array at which the Points should be inserted.
		 */
		public function insertMultiplePoints(points:Array, index:uint=0):void {
			var l:int = points.length;
			for (var i:int = 0; i < l; i++) {
				_insertPoint(points[i], index + i, true);
			}
			_organize();
		}
		
		/**
		 * Removes a particular Point instance from the <code>points</code> array.
		 * 
		 * @param point The Point object to remove from the <code>points</code> array.
		 */
		public function removePoint(point:Point):void {
			var i:int = _points.length;
			while (--i > -1) {
				if (_points[i].point == point) {
					_points.splice(i, 1);
				}
			}
			_organize();
		}
		
		/**
		 * Removes the Point that resides at a particular index/position in the <code>points</code> array. 
		 * Just like in arrays, the index is zero-based. For example, to remove the second Point in the array, 
		 * do <code>removePointByIndex(1)</code>;
		 * 
		 * @param index The index value of the Point that should be removed from the <code>points</code> array.
		 */
		public function removePointByIndex(index:uint):void {
			_points.splice(index, 1);
			_organize();
		}
		
		/** @private **/
		protected function _organize():void {
			_totalLength = 0;
			_hasAutoRotate = false;
			var last:int = _points.length - 1;
			if (last == -1) {
				_first = null;
			} else if (last == 0) {
				_first = _points[0];
				_first.progress = _first.xChange = _first.yChange = _first.length = 0;
				return;
			}
			var pp:PathPoint;
			for (var i:int = 0; i <= last; i++) { 
				if (_points[i] != null) {
					pp = _points[i];
					pp.x = pp.point.x;
					pp.y = pp.point.y;
					if (i == last) {
						pp.length = 0;
						pp.next = null;
					} else {
						pp.next = _points[i + 1];
						pp.xChange = pp.next.x - pp.x;
						pp.yChange = pp.next.y - pp.y;
						pp.length = Math.sqrt(pp.xChange * pp.xChange + pp.yChange * pp.yChange);
						_totalLength += pp.length;
					}
				}
			}
			_first = pp = _points[0];
			var curTotal:Number = 0;
			while (pp) {
				pp.progress = curTotal / _totalLength;
				curTotal += pp.length;
				pp = pp.next;
			}
			_updateAngles();
		}
		
		/** @private **/
		protected function _updateAngles():void {
			var m:Matrix = this.transform.matrix;
			var pp:PathPoint = _first;
			while (pp) {
				pp.angle = Math.atan2(pp.xChange * m.b + pp.yChange * m.d, pp.xChange * m.a + pp.yChange * m.c) * _RAD2DEG;
				pp = pp.next;
			}
			_prevMatrix = m;
		}
		
		/** @private **/
		override protected function renderAll():void {
			if (_first == null || _points.length <= 1) {
				return;
			}
			var updatedAngles:Boolean = false;
			var px:Number, py:Number, pp:PathPoint, followerProgress:Number, pathProg:Number;
			var m:Matrix = this.transform.matrix;
			var a:Number = m.a, b:Number = m.b, c:Number = m.c, d:Number = m.d, tx:Number = m.tx, ty:Number = m.ty;
			var f:PathFollower = _rootFollower;
			
			if (autoUpdatePoints) {
				pp = _first;
				while (pp) {
					if (pp.point.x != pp.x || pp.point.y != pp.y) {
						_organize();
						_redrawLine = true;
						renderAll();
						return;
					}
					pp = pp.next;
				}
			}
			
			while (f) {
				
				followerProgress = f.cachedProgress;
				pp = _first;
				while (pp != null && pp.next.progress < followerProgress) {
					pp = pp.next;
				}
				
				if (pp != null) {
					pathProg = (followerProgress - pp.progress) / (pp.length / _totalLength);
					px = pp.x + pathProg * pp.xChange;
					py = pp.y + pathProg * pp.yChange;
					f.target.x = px * a + py * c + tx;
					f.target.y = px * b + py * d + ty;
					
					if (f.autoRotate) {
						if (!updatedAngles && (_prevMatrix.a != a || _prevMatrix.b != b || _prevMatrix.c != c || _prevMatrix.d != d)) {
							_updateAngles(); //only need to update the angles once during the render cycle
							updatedAngles = true;
						}
						f.target.rotation = pp.angle + f.rotationOffset;
					}
				}
				
				f = f.cachedNext;
			}
			if (_redrawLine && this.visible && this.parent) {
				var g:Graphics = this.graphics;
				g.clear();
				g.lineStyle(_thickness, _color, _lineAlpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
				pp = _first;
				g.moveTo(pp.x, pp.y);
				while (pp) {
					g.lineTo(pp.x, pp.y);
					pp = pp.next;
				}
				_redrawLine = false;
			}
		}
		
		/** @inheritDoc **/
		override public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean=false, rotationOffset:Number=0):void {
			if (progress > 1) {
				progress -= int(progress);
			} else if (progress < 0) {
				progress -= int(progress) - 1;
			}
			if (_first == null) {
				return;
			}
			
			var pp:PathPoint = _first;
			while (pp.next != null && pp.next.progress < progress) {
				pp = pp.next;
			}
			
			if (pp != null) {
				var pathProg:Number = (progress - pp.progress) / (pp.length / _totalLength);
				var px:Number = pp.x + pathProg * pp.xChange;
				var py:Number = pp.y + pathProg * pp.yChange;
				
				var m:Matrix = this.transform.matrix;
				target.x = px * m.a + py * m.c + m.tx;
				target.y = px * m.b + py * m.d + m.ty;
				
				if (autoRotate) {
					if (_prevMatrix.a != m.a || _prevMatrix.b != m.b || _prevMatrix.c != m.c || _prevMatrix.d != m.d) {
						_updateAngles();
					}
					target.rotation = pp.angle + rotationOffset;
				}
			}
			
		}
		
		/**
		 * Translates the progress along a particular segment of the LinePath2D to an overall <code>progress</code>
		 * value, making it easy to position an object like "halfway along the 2nd segment of the line". For example:
		 * <br /><br /><code>
		 * 
		 * path.addFollower(mc, path.getSegmentProgress(2, 0.5));
		 * 
		 * </code>
		 * 
		 * @param segment The segment number of the line. For example, a line defined by 3 Points would have two segments.
		 * @param progress The <code>progress</code> along the segment. For example, the midpoint of the second segment would be <code>getSegmentProgress(2, 0.5);</code>.
		 * @return The progress value (between 0 and 1) describing the overall progress on the entire LinePath2D.
		 */
		public function getSegmentProgress(segment:uint, progress:Number):Number {
			if (_first == null) {
				return 0;
			} else if (_points.length <= segment) {
				segment = _points.length;
			}
			var pp:PathPoint = _points[segment - 1];
			return pp.progress + ((progress * pp.length) / _totalLength);
		}
		
		/**
		 * Allows you to snap an object like a Sprite, Point, MovieClip, etc. to the LinePath2D by determining
		 * the closest position along the line to the current position of the object. It will automatically
		 * create a PathFollower instance for the target object and reposition it on the LinePath2D. 
		 * 
		 * @param target The target object that should be repositioned onto the LinePath2D.
		 * @param autoRotate When <code>autoRotate</code> is <code>true</code>, the follower will automatically be rotated so that it is oriented to the angle of the path that it is following. To offset this value (like to always add 90 degrees for example), use the <code>rotationOffset</code> property.
		 * @param rotationOffset When <code>autoRotate</code> is <code>true</code>, this value will always be added to the resulting <code>rotation</code> of the target.
		 * @return A PathFollower instance that was created for the target.
		 */
		public function snap(target:Object, autoRotate:Boolean=false, rotationOffset:Number=0):PathFollower {
			return this.addFollower(target, getClosestProgress(target), autoRotate, rotationOffset);
		}
		
		/**
		 * Finds the closest overall <code>progress</code> value on the LinePath2D based on the 
		 * target object's current position (<code>x</code> and <code>y</code> properties). For example,
		 * to position the mc object on the LinePath2D at the spot that's closest to the Point x:100, y:50, 
		 * you could do:<br /><br /><code>
		 * 
		 * path.addFollower(mc, path.getClosestProgress(new Point(100, 50)));
		 * 
		 * </code>
		 * 
		 * @param target The target object whose position (x/y property values) are analyzed for proximity to the LinePath2D.
		 * @return The overall <code>progress</code> value describing the position on the LinePath2D that is closest to the target's current position.
		 */
		public function getClosestProgress(target:Object):Number {
			if (_first == null || _points.length == 1) {
				return 0;
			}
			
			var closestPath:PathPoint;
			var closest:Number = 9999999999;
			var length:Number = 0;
			var halfPI:Number = Math.PI / 2;
			
			var xTarg:Number = target.x;
			var yTarg:Number = target.y;
			var pp:PathPoint = _first;
			var dxTarg:Number, dyTarg:Number, dxNext:Number, dyNext:Number, dTarg:Number, angle:Number, next:PathPoint, curDist:Number;
			while (pp) {
				dxTarg = xTarg - pp.x;
				dyTarg = yTarg - pp.y;
				next = (pp.next != null) ? pp.next : pp;
				dxNext = next.x - pp.x;
				dyNext = next.y - pp.y;
				dTarg = Math.sqrt(dxTarg * dxTarg + dyTarg * dyTarg);
				
				angle = Math.atan2(dyTarg, dxTarg) - Math.atan2(dyNext, dxNext);
				if (angle < 0) {
					angle = -angle;
				}
				
				if (angle > halfPI) { //obtuse
					if (dTarg < closest) {
						closest = dTarg;
						closestPath = pp;
						length = 0;
					}
				} else {
					curDist = Math.cos(angle) * dTarg;
					if (curDist < 0) {
						curDist = -curDist;
					}
					if (curDist > pp.length) {
						dxNext = xTarg - next.x;
						dyNext = yTarg - next.y;
						curDist = Math.sqrt(dxNext * dxNext + dyNext * dyNext);
						if (curDist < closest) {
							closest = curDist;
							closestPath = pp;
							length = pp.length;
						}
					} else {
						curDist = Math.sin(angle) * dTarg;
						if (curDist < closest) {
							closest = curDist;
							closestPath = pp;
							length = Math.cos(angle) * dTarg;
						}
					}
				}
				pp = pp.next;
			}
			
			return closestPath.progress + (length / _totalLength);
		}
		
		
//---- GETTERS / SETTERS ----------------------------------------------------------------------
		
		/** Total length of the LinePath2D as though it were stretched out in a straight, flat line. **/
		public function get totalLength():Number {
			return _totalLength;
		}
		
		/** The array of Points through which the LinePath2D is drawn. IMPORTANT: Changes to the array are NOT automatically applied or reflected in the LinePath2D - just like the <code>filters</code> property of a DisplayObject, you must set the <code>points</code> property of a LinePath2D directly to ensure that any changes are applied internally. **/
		public function get points():Array {
			var a:Array = [];
			var l:int = _points.length;
			for (var i:int = 0; i < l; i++) {
				a[i] = _points[i].point;
			}
			return a;
		}
		public function set points(value:Array):void {
			_points = [];
			insertMultiplePoints(value, 0);
		}
		
	}
}
import flash.geom.Point;

internal class PathPoint {
	public var x:Number;
	public var y:Number;
	public var progress:Number;
	public var xChange:Number;
	public var yChange:Number;
	public var point:Point;
	public var length:Number;
	public var angle:Number;
	
	public var next:PathPoint;
	
	public function PathPoint(point:Point) {
		this.x = point.x;
		this.y = point.y;
		this.point = point;
	}
	
}