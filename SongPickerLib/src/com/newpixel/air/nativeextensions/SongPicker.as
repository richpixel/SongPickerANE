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
			
			extContext.addEventListener( StatusEvent.STATUS, onStatus );
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
			// user picks a MediaItem and the extension sends an event with an identifier
			extContext.call( "pickSong" );
		}

		/**
		 * Start playing a song based on persistent id 
		 */		
		public function playSong(songId:String="", position:Number=-1):void 
		{
			// songId is a string holding a 64-bit number, if an empty string is passed this is used to resume playing after a pause
			// position is a playhead position in seconds, -1 to resume
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