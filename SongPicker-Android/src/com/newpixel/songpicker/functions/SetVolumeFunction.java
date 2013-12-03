package com.newpixel.songpicker.functions;

import com.newpixel.songpicker.SongPickerExtension;

import com.adobe.fre.*;

import android.media.MediaPlayer;
import android.util.Log;

public class SetVolumeFunction implements FREFunction {

	public static final String TAG = "SetVolumeFunction";
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{
		// media player
		MediaPlayer mp = SongPickerExtension.songMediaPlayer;
		if (mp != null)
		{
			float vol = 1.0f;
			try {
				double argVol = args[0].getAsDouble();
				vol = (float)argVol;
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			
			Log.i(TAG, "in setVolume "+vol);
			mp.setVolume(vol, vol);
			
			SongPickerExtension.currentVolume = vol;
		}
		
		
		
		
		return null;
	}

}
