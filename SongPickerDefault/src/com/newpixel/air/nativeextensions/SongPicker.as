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
	
	public class SongPicker extends EventDispatcher
	{
		// singleton
		private static var _instance:SongPicker;
		
		
		// ID
		private static const EXTENSION_ID:String = "com.newpixel.air.nativeextensions.SongPicker";
		
		////////////////////////////////////////////////////////////
		// CONSTRUCTOR				
		public function SongPicker(enforcer:SingletonEnforcer) 
		{
			super();			
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
		 * Brings up native media picker on the phone to allow user to choose a song 
		 */		
		public function pickSong():void 
		{
			// pick a bogus song
			var json:String = "{\"ID\":\"544354354\",\"title\":\"Sultans of Swing\",\"artist\":\"Dire Straits\",\"duration\":348}";
			dispatchEvent( new SongPickerEvent(SongPickerEvent.SONG_CHOSEN, json));
		}
				
		/**
		 * Start playing a song based on persistent id 
		 */		
		public function playSong(songId:String="", position:Number=0):void 
		{
		}
		
		/**
		 * Pause the music player 
		 */		
		public function pauseSong():void 
		{
		}
		
		/**
		 * Stop the music player 
		 */		
		public function stopSong():void 
		{
		}
		
		/**
		 * Get current player volume 
		 */		
		public function getVolume():Number 
		{
			return 1;
		}
		
		/**
		 * Set current player volume
		 */		
		public function setVolume(newVolume:Number):void 
		{
			
		}
		
		/**
		 * Fade out player volume
		 */		
		public function fadeOutSong(fadeTime:Number):void 
		{
			
		}
		
		/**
		 * Fade in player volume
		 */		
		public function fadeInSong(fadeTime:Number):void 
		{
			
		}
		
		/**
		 * Cleans up the instance of the native extension. 
		 */		
		public function dispose():void 
		{ 
		}
		
		////////////////////////////////////////////////////////////
		// EVENT HANDLERS				
		
		////////////////////////////////////////////////////////////
		// PRIVATE METHODS				
		private function init():void 
		{
		}
		
	}
}

class SingletonEnforcer 
{
	
}