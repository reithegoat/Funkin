
/**
The MIT License
Copyright (c) 2013, Tronster, http://tronster.com
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
@author Tronster of Geek House Games, http://geekhousegames.com
*/

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import org.flixel.*;
	
	
	/**
	 * Flixel support for video
	 */
	public class FlxVideo extends FlxObject
	{
		private var vs				:VideoStream;
		private var framePixels 	:BitmapData;
		private var isLooping		:Boolean;
		protected var _flashRect	:Rectangle;
			
		
		/**
		 * WARNING: The origin of the sprite will default to its center.
		 * If you change this, the visuals and the collisions will likely be
		 * pretty out-of-sync if you do any rotation.
		 */
		public var origin:FlxPoint;
		/**
		 * The width of the actual graphic or image being displayed (not necessarily the game object/bounding box).
		 * NOTE: Edit at your own risk!!  This is intended to be read-only.
		 */
		public var frameWidth:uint;
		/**
		 * The height of the actual graphic or image being displayed (not necessarily the game object/bounding box).
		 * NOTE: Edit at your own risk!!  This is intended to be read-only.
		 */
		public var frameHeight:uint;
		
		/**
		* If you changed the size of your sprite object after loading or making the graphic,
		* you might need to offset the graphic away from the bound box to center it the way you want.
		*/
		public var offset:FlxPoint;

		/**
		 * Change the size of your sprite's graphic.
		 * NOTE: Scale doesn't currently affect collisions automatically,
		 * you will need to adjust the width, height and offset manually.
		 * WARNING: scaling sprites decreases rendering performance for this sprite by a factor of 10x!
		 */
		public var scale:FlxPoint;
		
		
		private var isLoaded :Boolean; 
		
		
		/**
		 * Internal, reused frequently during drawing and animating.
		 */
		protected var _flashPoint:Point;

		/**
		 * Internal tracker for opacity, used with Flash getter/setter.
		 */
		protected var _alpha:Number;
		
		/**
		 * Internal tracker for color tint, used with Flash getter/setter.
		 */
		protected var _color:uint;
		
		/**
		 * Internal, helps with animation, caching and drawing.
		 */
		protected var _colorTransform:ColorTransform;		

		/**
		 * Internal, helps with animation, caching and drawing.
		 */
		protected var _matrix:Matrix;
		
		
		/**
		 * What to mask
		 */
		protected var _mask:BitmapData;
		
		protected var _maskOffset:Point;
		
		
		
		public function FlxVideo( path:String = "", loop:Boolean = false ) 
		{
			super();

			framePixels = new BitmapData( 16, 16, true, 0x8011ff22 );
			offset 		= new FlxPoint();
			_maskOffset	= new Point();
			_flashPoint = new Point();			
			_matrix 	= new Matrix();
			origin 		= new FlxPoint();
			scale 		= new FlxPoint(1.0,1.0);
			_color 		= 0x00ffffff;
			isLoaded 	= false;
			
			if ( path != null && path != "" )
				play( path, loop );			
		}
		

		public function play( path:String, loop:Boolean = false ) :void
		{
			isLoaded = false;
			
			if ( vs != null )
			{
				vs.stop();
				vs.dispose();
			}
			
			vs = new VideoStream( path );
			vs.addEventListener( VideoStream.VIDEO_DONE, onVideoDone );
			vs.addEventListener( VideoStream.VIDEO_READY, onVideoReady );
			
			isLooping = loop;			
		}
		
		
		/// URL to video currently playing.
		public function get playing():String { return (vs != null) ? vs.path : "" }
		
		
		public function onVideoReady( e:Event ):void
		{
			if ( vs.width > 0 && vs.height > 0 )
			{			
				frameWidth = vs.width;
				frameHeight = vs.height;
				
				framePixels = new BitmapData( frameWidth, frameHeight, true, 0x0);
				_flashRect = new Rectangle( 0, 0, frameWidth, frameHeight );
				vs.play();
			}
			else
			{
				trace("Video load error! file: " + vs.path );
			}
			
			isLoaded = true;
		}
		
		
		public function onVideoDone( e:Event ):void
		{			
			//trace("Video stopped playing!");
			if ( isLooping )
				vs.play(true);
		}
		
		
		override public function draw():void
		{			
			if ( !isLoaded )
				return;
			
			framePixels.draw( vs.video );
			
			
			if(cameras == null)
				cameras = FlxG.cameras;
			var camera:FlxCamera;
			var i:uint = 0;
			var l:uint = cameras.length;
			while(i < l)
			{
				camera = cameras[i++];
				if(!onScreen(camera))
					continue;
				_point.x = x - int(camera.scroll.x*scrollFactor.x) - offset.x;
				_point.y = y - int(camera.scroll.y*scrollFactor.y) - offset.y;
				_point.x += (_point.x > 0)?0.0000001:-0.0000001;
				_point.y += (_point.y > 0)?0.0000001: -0.0000001;
								
				if ((scale.x == 1) && (scale.y == 1) )
				{	//Simple render
					_flashPoint.x = _point.x;
					_flashPoint.y = _point.y;
					if(_colorTransform != null)
						framePixels.colorTransform(_flashRect, _colorTransform);			
						
					
					camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint,_mask, _maskOffset, true);
				}
				else
				{	//Advanced render
					_matrix.identity();
					_matrix.translate(-origin.x,-origin.y);
					_matrix.scale(scale.x,scale.y);
					//if((angle != 0) && (_bakedRotation <= 0))
					//	_matrix.rotate(angle * 0.017453293);
					//_matrix.translate(_point.x+origin.x,_point.y+origin.y);	// doing translation in copyPixels so don't do it in transform

					// Transform first so mask is not scaled
					var temp:BitmapData = new BitmapData( framePixels.width, framePixels.height, true, 0x0); // 0xffffffff );
					if ( _colorTransform != null )
						temp.draw(framePixels, _matrix, _colorTransform, null, null, true);
					else
						temp.draw(framePixels, _matrix, null, null, null, true);
											
					_flashPoint.x = _point.x;
					_flashPoint.y = _point.y;					
					camera.buffer.copyPixels(temp, _flashRect, _flashPoint, _mask, _maskOffset, true);
					
					//camera.buffer.copyPixels(temp, _flashRect, _flashPoint );					
					//camera.buffer.draw(temp, _matrix, _colorTransform, null, null, true);
					//camera.buffer.draw(temp, _matrix, null, null, null, true);
				}			
				
				//camera.buffer.copyPixels(framePixels,_flashRect,_flashPoint,null,null,true);
				
				//FlxSprite._VISIBLECOUNT++;
				if(FlxG.visualDebug && !ignoreDrawDebug)
					drawDebug(camera);
			}		
			
		}
	
		/**
		 * Set <code>alpha</code> to a number between 0 and 1 to change the opacity of the sprite.
		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		
		/**
		 * @private
		 */
		public function set alpha(Alpha:Number):void
		{
			if(Alpha > 1)
				Alpha = 1;
			if(Alpha < 0)
				Alpha = 0;
			if(Alpha == _alpha)
				return;
			_alpha = Alpha;
			if((_alpha != 1) || (_color != 0x00ffffff))
				_colorTransform = new ColorTransform((_color>>16)*0.00392,(_color>>8&0xff)*0.00392,(_color&0xff)*0.00392,_alpha);
			else
				_colorTransform = null;
		}
		
		/// Area to mask oout
		public function set mask( cls:Class ):void
		{
			_mask = (new cls() as Bitmap).bitmapData;
		}
		
		
		/// Area to mask oout
		public function maskOffset( x:Number, y:Number ):void
		{
			_maskOffset.x = x;
			_maskOffset.y = y;
		}
		
		
		/**
		 * Check and see if this object is currently on screen.
		 * Differs from <code>FlxObject</code>'s implementation
		 * in that it takes the actual graphic into account,
		 * not just the hitbox or bounding box or whatever.
		 * 
		 * @param	Camera		Specify which game camera you want.  If null getScreenXY() will just grab the first global camera.
		 * 
		 * @return	Whether the object is on screen or not.
		 */
		override public function onScreen(Camera:FlxCamera=null):Boolean
		{
			if(Camera == null)
				Camera = FlxG.camera;
			getScreenXY(_point,Camera);
			_point.x = _point.x - offset.x;
			_point.y = _point.y - offset.y;
			
			return ((_point.x + frameWidth > 0) && (_point.x < Camera.width) && (_point.y + frameHeight > 0) && (_point.y < Camera.height));			
		}		
		
		
	}