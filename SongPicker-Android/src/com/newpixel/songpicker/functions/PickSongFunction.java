//
//  PickSongFunction.java
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

import com.newpixel.songpicker.PickSongActivity;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class PickSongFunction implements FREFunction 
{
	public static final String TAG = "PickSongFunction";
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{		
		Activity mainActivity = context.getActivity();
		
	    try
	    {
	        Intent intent = new Intent(mainActivity, PickSongActivity.class);
	        
	        mainActivity.startActivity(intent);
		    Log.d(TAG, "PickSongActivity should have started");		
	    } 
	    catch (ActivityNotFoundException activityNotFoundException)
	    {
	        activityNotFoundException.printStackTrace();
	    }
	    catch (Exception otherException)
	    {
	        otherException.printStackTrace();
	    }
		
		return null;
	}

}
