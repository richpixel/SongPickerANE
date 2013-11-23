//
//  SongPickerHelper.m
//  libSongPicker-iOS
//
//  Created by Richard Lovejoy (rich@newpixel.com) on 1/15/13.
//  Copyright (c) 2013 Richard Lovejoy. All rights reserved.
//
/*
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <math.h>

#import <MediaPlayer/MediaPlayer.h>
#import "SongPickerHelper.h"

#import "AVAudioPlayer+FadeControl.h"

@implementation SongPickerHelper

@synthesize pickedItem = _pickedItem;
@synthesize audioPlayer = _audioPlayer;

static NSString *eventSongChosen = @"songChosen";
static NSString *eventSongFinished = @"songFinished";
static NSString *eventCancelledSongPicker = @"cancelledSongPicker";

-(void) dealloc
{
    [_pickedItem release];
    [super dealloc];
}

-(id)init
{
	self = [super init];
	if (self)
	{
		self.volume = 1.0;
	}
	return self;
}

-(void) pickSongFromMediaLibrary
{
    // Bring up a media picker and allow user to choose 1 song
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    
    // show media picker
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:mediaPicker animated:YES completion:NULL];
    
    [mediaPicker release];
}

-(void) playSong:(NSNumber *)pid playheadPosition:(double)playbackTime
{
    
    if (pid)
    {
        NSLog(@"playSong %llu", [pid longLongValue]);
        
        MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
        [songQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:pid forProperty:MPMediaItemPropertyPersistentID]];
        
        // make sure a song was found
        if (!songQuery.items || [songQuery.items count] < 1)
        {
            NSLog(@"Can't find song.");
            return;
        }
        
        // get url of the media item
        MPMediaItem *item = [songQuery.items objectAtIndex:0];
        NSLog(@"Media Item %@", item);
        
        // Play the item using AVPlayer
        NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
        
        if (self.audioPlayer)
        {
            [self.audioPlayer stop];
            [self.audioPlayer release];
        }
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.audioPlayer.delegate = self;
        self.audioPlayer.volume = _volume;
        
        self.audioPlayer.currentTime = playbackTime;
        [self.audioPlayer play];
        NSLog(@"Playing song %@ from %f", [url absoluteString], playbackTime);
        
    }
    else
    {
        // just play current song
        self.audioPlayer.currentTime = playbackTime;
        if (self.audioPlayer && !self.audioPlayer.playing)
        {
            [self.audioPlayer play];
        }
    }
    
}

-(void) pauseSong
{
    if (self.audioPlayer)
    {
        [self.audioPlayer pause];
    }
}

-(void) stopSong
{
    if (self.audioPlayer)
    {
        [self.audioPlayer stop];
    }
    
}

-(float) volume
{
    return (self.audioPlayer) ? self.audioPlayer.volume : _volume;
}

-(void) setVolume:(float)volume
{
    _volume = fmin(1.0, fmax(0.0, volume));
    if (self.audioPlayer)
    {
        self.audioPlayer.volume = _volume;
    }
}

-(void) fadeOut:(NSTimeInterval)fadeTime
{
    if (self.audioPlayer && self.audioPlayer.volume > 0)
    {
        [self.audioPlayer fadeOutWithDuration:fadeTime];
    }
}

-(void) fadeIn:(NSTimeInterval)fadeTime
{
    if (self.audioPlayer)
    {
        [self.audioPlayer fadeInWithDuration:fadeTime];
    }
    
}

-(void) setContext:(FREContext)ctx
{
    _context = ctx;
}

// AVAudioPlayerDelegate
-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    FREDispatchStatusEventAsync(_context, (uint8_t*)[eventSongFinished UTF8String], (uint8_t*)[@"" UTF8String]);
}


// MPMediaPickerControllerDelegate
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    // store the last picked item
    self.pickedItem = [mediaItemCollection.items objectAtIndex:0];
    
    //unsigned long long parsedValue = strtoull([yourString UTF8String], NULL, 0);
    
    // send an event
    NSString *ID = [NSString stringWithFormat:@"%qi", [[self.pickedItem valueForProperty:MPMediaItemPropertyPersistentID] longLongValue]];
    NSString *title = [self.pickedItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [self.pickedItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *duration = [self.pickedItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    // Return a JSON string
    NSString *chosenSong = [NSString stringWithFormat:@"{\"ID\":\"%@\",\"title\":\"%@\",\"artist\":\"%@\",\"duration\":%d}", ID, title, artist, [duration intValue]];
 
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];

    FREDispatchStatusEventAsync(_context, (uint8_t*)[eventSongChosen UTF8String], (uint8_t*)[chosenSong UTF8String]);
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];
    
    FREDispatchStatusEventAsync(_context, (uint8_t*)[eventCancelledSongPicker UTF8String], (uint8_t*)[@"" UTF8String]);    
}

@end
