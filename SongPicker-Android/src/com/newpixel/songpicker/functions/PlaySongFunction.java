//
//  PlaySongFunction.java
//  libSongPicker-Android
//
//  Created by Richard Lovejoy (rich@newpixel.com) on 1/15/13.
//  Copyright (c) 2013 Richard Lovejoy. All rights reserved.
//
/*
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
IN THE SOFTWARE.
*/
package com.newpixel.songpicker.functions;


import android.net.Uri;
import android.media.MediaPlayer;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.newpixel.songpicker.SongPickerExtension;


public class PlaySongFunction implements FREFunction {

	public static final String TAG = "PlaySongFunction";
	
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{
		// media player
		MediaPlayer mp = SongPickerExtension.songMediaPlayer;
		
		// get song uri
		Uri songUri;
		String songId = "";
		try {
			songId = args[0].getAsString();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		if (songId.length() > 0)
		{
			songUri = Uri.parse(songId);
			if (mp != null)
			{
				mp.release();
				mp = null;
			}
			mp = MediaPlayer.create(SongPickerExtension.appContext, songUri);
			
			SongPickerExtension.songMediaPlayer = mp;
			Log.d(TAG, "created Media Player "+songId);
		}		
		
		// check position
		int seekPosition = -1;
		try {
			seekPosition = args[1].getAsInt()*1000;
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		if (seekPosition >= 0)
		{
			mp.seekTo(seekPosition);
			Log.d(TAG, "seekTo"+seekPosition);
		}
		mp.start();
		
		
		return null;
	}
}
