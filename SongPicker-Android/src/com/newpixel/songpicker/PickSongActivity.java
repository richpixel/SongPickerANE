//
//  PickSoungActivity.java
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
package com.newpixel.songpicker;

import android.app.Activity;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.provider.MediaStore;
import android.util.Log;
import android.os.Bundle;
import android.database.Cursor;
import android.net.Uri;

public class PickSongActivity extends Activity {

	public static final String TAG = "PickSongActivity";
		
	static final int PICK_SONG_REQUEST = 0;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) 
	{
		super.onCreate(savedInstanceState);
		
		Log.d(TAG, "PickSongActivity.onCreate");
		
		// Intent.ACTION_PICK must exist
		try {
	        Intent intent = new Intent();
	        intent.setAction(Intent.ACTION_PICK);
	        intent.setData(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI);
	        
	        startActivityForResult(intent, PICK_SONG_REQUEST);
		}
	    catch (ActivityNotFoundException activityNotFoundException)
	    {
	        activityNotFoundException.printStackTrace();
	    }
	    catch (Exception otherException)
	    {
	        otherException.printStackTrace();
	    }
        /*
		Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
		intent.setType("audio/music");
		Intent c = Intent.createChooser(intent, "Pick a song");
		*/
		
	}
		
    @Override
    public void finish()
    {
    	super.finish();
    }
	
	protected void onActivityResult(int requestCode, int resultCode, Intent data) 
	{
		Log.d(TAG, "onActivityResult "+requestCode+" "+resultCode);
        if (requestCode == PICK_SONG_REQUEST) 
        {
            if (resultCode == RESULT_OK) 
            {
                // A song was picked.  Grab the id and notify the AS3 extension.
                Log.d(TAG, "PickSongActivity.onActivityResult: "+data.getData().toString());
                
                // Grab title, artist and run length
                Uri songUri = data.getData();
                String eventPayload = "{\"ID\":\""+songUri.toString()+"\"";
                Cursor musiccursor = null;               

                try
                {
                	musiccursor = getContentResolver().query(songUri, null, null, null, null);
                    
                    if (musiccursor.moveToFirst()) 
                    {
                         
                        int titleColumn = musiccursor.getColumnIndex(MediaStore.Audio.Media.TITLE); 
                        eventPayload += ",\"title\":\""+musiccursor.getString(titleColumn)+"\"";
                        
                        int artistColumn = musiccursor.getColumnIndex(MediaStore.Audio.Media.ARTIST); 
                        eventPayload += ",\"artist\":\""+musiccursor.getString(artistColumn)+"\"";

                        int albumColumn = musiccursor.getColumnIndex(MediaStore.Audio.Media.ALBUM); 
                        eventPayload += ",\"albumTitle\":\""+musiccursor.getString(albumColumn)+"\"";
                        
                        int durationColumn = musiccursor.getColumnIndex(MediaStore.Audio.Media.DURATION);
                        eventPayload += ",\"duration\":"+Math.round(musiccursor.getInt(durationColumn)/1000);
                        
                    }                                   
                }
                finally
                {
                	if (musiccursor != null)
                	{
                		musiccursor.close();
                	}
                }
                eventPayload += "}";
                
                SongPickerExtension.extensionContext.dispatchStatusEventAsync(SongPickerExtension.SONG_CHOSEN, eventPayload);
            }
            else
            {
            	// dispatch cancelled
            	SongPickerExtension.extensionContext.dispatchStatusEventAsync(SongPickerExtension.CANCELLED_SONG_PICKER, "");
            }
        }
        finish();
    }	
}
