//
//  SongPicker.as
//  Native Extension
//
//  Created by Richard Lovejoy (rich@newpixel.com) on 1/15/13.
//  Copyright (c) 2013 Richard Lovejoy. All rights reserved.
//
/*
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package com.newpixel.air.nativeextensions
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class SongPicker extends EventDispatcher
	{
		// singleton
		private static var _instance:SongPicker;
		
		// properties
		private var extContext:ExtensionContext;
		
		// ID
		private static const EXTENSION_ID:String = "com.newpixel.air.nativeextensions.SongPicker";
		
		////////////////////////////////////////////////////////////
		// CONSTRUCTOR				
		public function SongPicker(enforcer:SingletonEnforcer) 
		{
			super();
			
			extContext = ExtensionContext.createExtensionContext( EXTENSION_ID, "" );
			
			if ( !extContext ) 
			{
				throw new Error( "SongPicker native extension is not supported on this platform." );
			}
			else
			{
				extContext.addEventListener( StatusEvent.STATUS, onStatus );
			}
		}
		
		////////////////////////////////////////////////////////////
		// PUBLIC METHODS				
		public static function get instance():SongPicker 
		{
			if ( !_instance ) 
			{
				_instance = new SongPicker( new SingletonEnforcer() );
				_instance.init();
			}
			
			return _instance;
		}

		/**
		 * Checks if native media picker is available 
		 */		
		public function isNativeMediaPickerAvailable():Boolean 
		{
			// 
			return Boolean(extContext.call( "isNativeMediaPickerAvailable" ));
		}

		/**
		 * Brings up native media picker on the phone to allow user to choose a song 
		 * downloadedSongsOnly: If false, iOS can show iCloud songs; has no effect in Android currently
		 */		
		public function pickSong(downloadedSongsOnly:Boolean=true):void 
		{
			// user picks a MediaItem and the extension sends an event with an identifier
			extContext.call( "pickSong", downloadedSongsOnly );
		}

		/**
		 * Start playing a song based on persistent id
		 * songId is a string holding a 64-bit number, if an empty string is passed this is used to resume playing after a pause
		 * position is a playhead position in seconds
		 */		
		public function playSong(songId:String="", position:Number=0):void 
		{
			extContext.call( "playSong", songId, position );
		}

		/**
		 * Pause the music player 
		 */		
		public function pauseSong():void 
		{
			extContext.call( "pauseSong" );
		}
		
		/**
		 * Stop the music player 
		 */		
		public function stopSong():void 
		{
			extContext.call( "stopSong" );
		}

		/**
		 * Get current player volume 
		 */		
		public function getVolume():Number 
		{
			return Number(extContext.call( "getVolume" ));
		}

		/**
		 * Set current player volume
		 */		
		public function setVolume(newVolume:Number):void 
		{
			extContext.call( "setVolume", newVolume );
		}

		/**
		 * Get current playhead position of playing song in seconds
		 */		
		public function getPlayheadTime():Number 
		{
			return Number(extContext.call( "getPlayheadTime" ));
		}
		
		/**
		 * Set current playhead position of playing song in seconds
		 */		
		public function setPlayheadTime(newPlayheadTime:Number):void 
		{
			extContext.call( "setPlayheadTime", newPlayheadTime );
		}

		/**
		 * Fade out player volume
		 */		
		public function fadeOutSong(fadeTime:Number):void 
		{
			extContext.call( "fadeOut", fadeTime );
		}

		/**
		 * Fade in player volume
		 */		
		public function fadeInSong(fadeTime:Number):void 
		{
			extContext.call( "fadeIn", fadeTime );
		}
		
		/**
		 * Cleans up the instance of the native extension. 
		 */		
		public function dispose():void 
		{ 
			extContext.dispose(); 
		}
		
		////////////////////////////////////////////////////////////
		// EVENT HANDLERS				
		private function onStatus( event:StatusEvent ):void 
		{
			// check event
			trace("SongPicker.onStatus", event.code, event.level);
			
			dispatchEvent( new SongPickerEvent(event.code, event.level ));
			
		}
		
		////////////////////////////////////////////////////////////
		// PRIVATE METHODS				
		private function init():void 
		{
			extContext.call( "init" );
		}
		
	}
}

class SingletonEnforcer 
{
	
}