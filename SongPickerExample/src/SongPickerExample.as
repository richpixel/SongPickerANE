//
//  SongPickerExample.as
//  Native Extension Test
//
//  Created by Richard Lovejoy (rich@newpixel.com) on 2/2/13.
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
/*
	The SongPicker Air Native Extension lets you choose a song from your music library on your iOS or Android device, and play it back.
	The extension uses the native media picker of the device to allow the song to be picked.

	Notes:
		- You must include the following line in the Android manifest section of your app config xml file:
<application>
<activity android:name="com.newpixel.songpicker.PickSongActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar"></activity>
</application>			    			    

		- You must specify the iOS SDK to build against when packaging an app for iOS. (ActionScript Build Packaging > Apple iOS > Native Extensions)

		- On iOS it seems to intermittently crash if you try to init the SongPicker too soon after the app starts running. Try waiting for user interaction.

*/
package
{
	import com.newpixel.air.nativeextensions.SongPicker;
	import com.newpixel.air.nativeextensions.SongPickerEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SongPickerExample extends Sprite
	{
		private var _buttons:ControlButtons;
		private var _chosenSongID:String;
		
		public function SongPickerExample()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			
			
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			// setup ui
			_buttons = new ControlButtons();
			_buttons.x = 20;
			_buttons.y = 20;
			
			_buttons.pickSong.btn.addEventListener(MouseEvent.CLICK, pickSongButtonHandler);
			_buttons.playSong.btn.addEventListener(MouseEvent.CLICK, playSongButtonHandler);
			_buttons.stopSong.btn.addEventListener(MouseEvent.CLICK, stopSongButtonHandler);
			
			_buttons.info.text = "Pick a song on your iOS or Android device...";
			_buttons.playSong.visible = false;
			_buttons.stopSong.visible = false;
			
			addChild(_buttons);
						
		}
				
		protected function playSongButtonHandler(event:MouseEvent):void
		{
			SongPicker.instance.addEventListener(SongPickerEvent.SONG_FINISHED, songFinishedHandler);
			SongPicker.instance.playSong(_chosenSongID);
			
			_buttons.playSong.visible = false;
			_buttons.stopSong.visible = true;
		}

		protected function stopSongButtonHandler(event:MouseEvent):void
		{
			SongPicker.instance.removeEventListener(SongPickerEvent.SONG_FINISHED, songFinishedHandler);
			SongPicker.instance.stopSong();
			
			_buttons.playSong.visible = true;
			_buttons.stopSong.visible = false;
		}

		protected function pickSongButtonHandler(event:MouseEvent):void
		{
			// setup song picker - initializing the native extension is sometimes tempermental so it's best to do this
			// some time after the app has started running
			SongPicker.instance.addEventListener(SongPickerEvent.SONG_CHOSEN, songChooseHandler);
			SongPicker.instance.addEventListener(SongPickerEvent.CANCELLED_SONG_PICKER, cancelPickHandler);
			
			
			SongPicker.instance.pickSong();
			
		}
				
		// SongPicker event handlers
		protected function songChooseHandler(event:SongPickerEvent):void
		{
			// show song info
			var duration:Number = event.duration;
			var minutes:int = duration / 60;
			var seconds:int = duration % 60;
			
			var msg:String = "id: "+event.ID+"\n"+"title: "+event.title+"\n"+"artist: "+event.artist+"\n"+"duration: ("+minutes+":"+((seconds < 10) ? "0"+seconds : seconds)+")";
			
			_buttons.info.text = msg; 
			_chosenSongID = event.ID;
			
			_buttons.playSong.visible = true;
			
			removeHandlers();
		}
		
		protected function cancelPickHandler(event:Event):void
		{
			removeHandlers();		
		}
		
		protected function songFinishedHandler(event:Event):void
		{
			SongPicker.instance.removeEventListener(SongPickerEvent.SONG_FINISHED, songFinishedHandler);
		
			_buttons.playSong.visible = true;
			_buttons.stopSong.visible = false;
			
		}
		
		private function removeHandlers():void
		{
			SongPicker.instance.removeEventListener(SongPickerEvent.SONG_CHOSEN, songChooseHandler);
			SongPicker.instance.removeEventListener(SongPickerEvent.CANCELLED_SONG_PICKER, cancelPickHandler);
		}
	}
}