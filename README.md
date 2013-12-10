SongPickerANE
=============

A song picker/player AIR native extension for iOS and Android.

Author: Rich Lovejoy (https://github.com/richpixel)

The SongPicker Air Native Extension lets you choose a song from your music library on your iOS or Android device 
using the native media picker, and play it back using the native media player.

#Notes:#
- You must include the following lines in the Android manifest section of your app config xml file to use the picker:

	<application>
	<activity android:name="com.newpixel.songpicker.PickSongActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar"></activity>
	</application>

- You must specify the iOS SDK to build against when packaging an app for iOS. (ActionScript Build Packaging > Apple iOS > Native Extensions)

- On iOS it seems to intermittently crash if you try to init the SongPicker too soon after the app starts running. Try waiting for user interaction.

#Usage#

Include the SongPicker.ane in your project.

  import com.newpixel.air.nativeextensions.SongPicker;
	import com.newpixel.air.nativeextensions.SongPickerEvent;

  ...

	SongPicker.instance.addEventListener(SongPickerEvent.SONG_CHOSEN, songChooseHandler);
	SongPicker.instance.addEventListener(SongPickerEvent.CANCELLED_SONG_PICKER, cancelPickHandler);	
	SongPicker.instance.pickSong();


#API#

SongPicker class methods

- isNativeMediaPickerAvailable():Boolean
	Returns true if there is a native media picker on this device. This may return false on some Android devices, like the Kindle.
	
- pickSong():void
    Bring up the native media picker to allow a user to choose a song from his library. 
    Triggers the SongPickerEvent.SONG_CHOSEN or SongPickerEvent.CANCELLED_SONG_PICKER when the picker is dismissed.
  
- playSong(songId:String="", position:Number=-1):void
    Begin playing a song with the specified ID, or resume playing the current song if songId is "".
    Args:
      - songId: The persistent ID of the song to play, which is obtained after picking a song with the picker.
      - position: A playhead position in seconds, to begin playing the song. The default value -1 tells the player 
                  to begin playing at the start of the song or to resume where it left off.

  
- pauseSong():void
    Pause the current song playback.

- stopSong():void
    Stop current song playback.

- setVolume():void
	Pass a Number between 0 and 1 to set the volume of the currently playing song.
	
- getVolume():Number
	Returns a Number between 0 and 1 - the volume of the currently playing song.
	
- fadeOutSong(fadeTime:Number):void
	Fade down the song's volume to 0 in fadeTime seconds.

- fadeInSong(fadeTime:Number):void
	Fade up the song's volume from 0 in fadeTime seconds.
	
SongPickerEvent

- SONG_CHOSEN: Triggered when the user has selected a song from the media picker. The following properties will be available in the event object:
    - ID (String): persistent ID of the song. This is a 64-bit number on iOS and a URI on Android.
    - title (String): title of track.
    - artist (String): artist of track.
    - duration (int): length of the track in seconds

- CANCELLED_SONG_PICKER: User has cancelled picking a song.
- SONG_FINISHED: Playback of current song has finished.

#Examples#

  See the SongPickerExample project which can be built with FlashBuilder.

  
