//
//  SongPickerEvent.as
//  Native Extension
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
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package com.newpixel.air.nativeextensions
{
	import flash.events.Event;
	import com.adobe.serialization.json.EzJSON;
	
	public class SongPickerEvent extends Event
	{
		// events
		public static const SONG_CHOSEN:String = "songChosen";
		public static const SONG_FINISHED:String = "songFinished";
		public static const CANCELLED_SONG_PICKER:String = "cancelledSongPicker";
		
		// properties
		private var _jsonResult:String;
		
		public var ID:String;
		public var title:String;
		public var artist:String;
		public var duration:int;
		
		////////////////////////////////////////////////////////////
		// CONSTRUCTOR				
		public function SongPickerEvent(type:String, pickerResult:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			// parse out data fields
			if (type == SONG_CHOSEN)
			{
				_jsonResult = pickerResult;
				if (_jsonResult != "")
				{
					var valuePairs:Object = EzJSON.decode(_jsonResult);
					ID = valuePairs.ID;
					title = valuePairs.title;
					artist = valuePairs.artist;
					duration = valuePairs.duration;
				}
			}
		}
		
		public override function clone():Event
		{
			return new SongPickerEvent(type, _jsonResult);
		}
		
	}
}