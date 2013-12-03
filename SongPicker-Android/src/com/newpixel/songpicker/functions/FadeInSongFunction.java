package com.newpixel.songpicker.functions;

import java.util.Timer;
import java.util.TimerTask;

import com.newpixel.songpicker.SongPickerExtension;

import com.adobe.fre.*;

import android.media.MediaPlayer;
import android.util.Log;

import java.util.Timer;
import java.util.TimerTask;

public class FadeInSongFunction implements FREFunction {

	public static final String TAG = "FadeInSongFunction";
	
	private float fVolume;
	private float fOriginalVolume;
	private float fIncrement;
	
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
			
			Log.i(TAG, "in fadeInSong "+fadeTime);

			// start at 0
			fOriginalVolume = SongPickerExtension.currentVolume;
			fVolume = 0.0f;
			mp.setVolume(0, 0);
			
			if (fadeTime > 0 && fOriginalVolume > 0)
			{
				final int kFadeSteps = 20;
				
				fIncrement = fOriginalVolume / kFadeSteps;
				
				final Timer timer = new Timer(true);
		        TimerTask timerTask = new TimerTask() 
		        {
		            @Override
		            public void run() 
		            {
		            	fVolume += fIncrement;
						if (fVolume > fOriginalVolume)
							fVolume = fOriginalVolume;
						
						SongPickerExtension.songMediaPlayer.setVolume(fVolume, fVolume);
						
		                if (fVolume >= fOriginalVolume)
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
		}
			
		
		return null;
	}

}
