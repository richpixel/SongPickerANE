package com.newpixel.songpicker.functions;

import com.newpixel.songpicker.SongPickerExtension;

import com.adobe.fre.*;

import android.content.Context;
import android.media.MediaPlayer;
import android.media.AudioManager;
import android.util.Log;

public class GetVolumeFunction implements FREFunction {

	public static final String TAG = "GetVolumeFunction";
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{
		// return value
		float volume = SongPickerExtension.currentVolume;
		
		// media player
		// This code below doesn't really return the volume of the MediaPlayer, but the music volume of the device:
		// http://stackoverflow.com/questions/20231287/android-mediaplayer-get-volume
		/*
		MediaPlayer mp = SongPickerExtension.songMediaPlayer;
		if (mp != null)
		{
			Context appContext = context.getActivity().getApplicationContext();
			AudioManager am = (AudioManager) appContext.getSystemService(Context.AUDIO_SERVICE);
			int volumeLevel = am.getStreamVolume(AudioManager.STREAM_MUSIC);	
			int maxVolume = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
			Log.i(TAG, "in getVolume "+volumeLevel+" "+maxVolume);
			
			volume = (float)volumeLevel/maxVolume;
		}
		*/
		
		FREObject returnValue = null;
		try {
			returnValue = FREObject.newObject(volume);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return returnValue;
	}

}
