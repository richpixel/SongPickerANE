package com.newpixel.songpicker.functions;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.provider.MediaStore;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.newpixel.songpicker.SongPickerExtension;

import java.util.List;

public class IsNativeMediaPickerAvailableFunction implements FREFunction 
{
	public static final String TAG = "IsNativeMediaPickerAvailableFunction";
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{		
		Log.d(TAG, "IsNativeMediaPickerAvailableFunction");
		
		// Intent.ACTION_PICK must exist
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_PICK);
        intent.setData(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI);	        

		Boolean available = isCallable(intent);
		
		FREObject returnValue = null;
		try {
			returnValue = FREObject.newObject(available);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return returnValue;
		
	}

	private boolean isCallable(Intent intent) 
	{
        List<ResolveInfo> list = SongPickerExtension.appContext.getPackageManager().queryIntentActivities(intent, 
            PackageManager.MATCH_DEFAULT_ONLY);
        return list.size() > 0;
}	
}

