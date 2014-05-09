package com.newpixel.songpicker.functions;

import com.newpixel.songpicker.SongPickerExtension;

import com.adobe.fre.*;

import android.media.MediaPlayer;
import android.util.Log;

public class SetPlayheadTimeFunction implements FREFunction {

	public static final String TAG = "SetVolumeFunction";
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{
		// media player
		MediaPlayer mp = SongPickerExtension.songMediaPlayer;
		if (mp != null)
		{
			double playheadTime = 0.0;
			try {
				playheadTime = args[0].getAsDouble();
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			if (playheadTime >= 0)
			{
				mp.seekTo((int)(playheadTime*1000));
				Log.d(TAG, "seekTo"+playheadTime);
			}

		}
		
		
		
		
		return null;
	}

}
