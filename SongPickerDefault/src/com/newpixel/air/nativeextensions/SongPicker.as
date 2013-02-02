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
			dispatchEvent( new SongPickerEvent(SongPickerEvent.SONG_CHOSEN, "544354354<sep>If n You Leave<sep>Tan Tanner<sep>201"));
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