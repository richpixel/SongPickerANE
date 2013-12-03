package com.newpixel.songpicker.functions;

import com.newpixel.songpicker.SongPickerExtension;

import com.adobe.fre.*;

import android.media.MediaPlayer;
import android.util.Log;

import java.util.Timer;
import java.util.TimerTask;

public class FadeOutSongFunction implements FREFunction {

	public static final String TAG = "FadeOutSongFunction";
	
	private float fVolume;
	private float fDecrement;
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{
		// media player
		MediaPlayer mp = SongPickerExtension.songMediaPlayer;
		if (mp != null)
		{
			float fadeTime = 1.0f;
			try {
				double argFadeTime = args[0].getAsDouble();
				fadeTime = (float)argFadeTime;
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			
			Log.i(TAG, "in fadeOutSong "+fadeTime);

			// get current volume
			fVolume = SongPickerExtension.currentVolume;
			
			if (fadeTime > 0 && fVolume > 0)
			{
				final int kFadeSteps = 20;
				
				fDecrement = fVolume / kFadeSteps;
				
				final Timer timer = new Timer(true);
		        TimerTask timerTask = new TimerTask() 
		        {
		            @Override
		            public void run() 
		            {
		            	fVolume -= fDecrement;
						if (fVolume < fDecrement)
							fVolume = 0;
						
						SongPickerExtension.songMediaPlayer.setVolume(fVolume, fVolume);
						
		                if (fVolume == 0)
		                {
		                    timer.cancel();
		                    timer.purge();
		                    
		                    SongPickerExtension.songMediaPlayer.stop();
		                }
		            }
		        };

		        // calculate delay, cannot be zero, set to 1 if zero
		        long delayMs = Math.max(10, Math.round(fadeTime * 1000 / kFadeSteps));
		        timer.schedule(timerTask, delayMs, delayMs);				
				 				
				
			}
			else
			{
				mp.setVolume(0, 0);
			}
		}
		return null;
	}

}
