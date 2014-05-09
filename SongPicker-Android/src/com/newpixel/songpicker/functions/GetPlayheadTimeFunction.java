package com.newpixel.songpicker.functions;

import com.newpixel.songpicker.SongPickerExtension;

import com.adobe.fre.*;


import android.media.MediaPlayer;
import android.util.Log;

public class GetPlayheadTimeFunction implements FREFunction {

	public static final String TAG = "GetVolumeFunction";
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{
		// return value
		double playheadTime = 0;
		MediaPlayer mp = SongPickerExtension.songMediaPlayer;
		if (mp != null)
		{
			playheadTime = (double)mp.getCurrentPosition()/1000;
		}
		
		
		FREObject returnValue = null;
		try {
			returnValue = FREObject.newObject(playheadTime);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return returnValue;
	}

}
