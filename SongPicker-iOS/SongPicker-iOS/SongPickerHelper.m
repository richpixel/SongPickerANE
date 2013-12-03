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

@implementation SongPickerHelper

@synthesize avAudioPlayer = _avAudioPlayer;

static NSString *eventSongChosen = @"songChosen";
static NSString *eventSongFinished = @"songFinished";
static NSString *eventCancelledSongPicker = @"cancelledSongPicker";

static BOOL observingMediaEvents = NO;

-(void) dealloc
{
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
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    musicPlayer.shuffleMode = MPMusicShuffleModeOff;
    
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
        
        // stop playing
        if (self.avAudioPlayer)
        {
            [self.avAudioPlayer stop];
            [self.avAudioPlayer release];
            self.avAudioPlayer = nil;
        }
        
        if (musicPlayer.playbackState != MPMusicPlaybackStateStopped)
        {
            [musicPlayer stop];
        }
        
        // The volume property has been deprecated in MPMusicPlayerController as of iOS 7
        // Therefore, use the AVAudioPlayer where possible. However AVAudioPlayer will fail for DRM protected conent.
        // Fallback to MPMusicPlayerController in that case and hope it works
        NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
        if (url)
        {
            self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            self.avAudioPlayer.delegate = self;
            self.avAudioPlayer.volume = _volume;
            
            self.avAudioPlayer.currentTime = playbackTime;
            [self.avAudioPlayer play];
            NSLog(@"Playing song %@ from %f with AVAudioPlayer", [url absoluteString], playbackTime);
        }
        else
        {
            [musicPlayer setQueueWithQuery:songQuery];
            if (playbackTime > 0)
            {
                musicPlayer.currentPlaybackTime = playbackTime;
            }
            [musicPlayer play];
            NSLog(@"Playing song %@ from %f with MPMusicPlayer", [url absoluteString], playbackTime);
            
            // listen for item change
            if (!observingMediaEvents)
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlaybackStateChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:musicPlayer];
                [musicPlayer beginGeneratingPlaybackNotifications];
                
                observingMediaEvents = YES;
            }
        }
    }
    else
    {
        // just play current song
        if (self.avAudioPlayer)
        {
            self.avAudioPlayer.currentTime = playbackTime;
            if (!self.avAudioPlayer.playing)
            {
                [self.avAudioPlayer play];
            }
            
        }
        else
        {
            if (playbackTime >= 0)
            {
                musicPlayer.currentPlaybackTime = playbackTime;
            }
            [musicPlayer play];
        
        }
    }
    
}

-(void) pauseSong
{
    if (self.avAudioPlayer)
    {
        [self.avAudioPlayer pause];
    }
}

-(void) stopSong
{
    if (self.avAudioPlayer)
    {
        [self.avAudioPlayer stop];
    }
    
}

-(float) volume
{
    if (self.avAudioPlayer)
    {
        return self.avAudioPlayer.volume;
    }
    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    return musicPlayer.volume;
    
}

-(void) setVolume:(float)volume
{
    _volume = fmin(1.0, fmax(0.0, volume));
    if (self.avAudioPlayer)
    {
        self.avAudioPlayer.volume = _volume;
    }
    else
    {
        // This causes system volume to change, so don't
        /*
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        musicPlayer.volume = _volume;
        */
    }
}

#define     kFadeSteps  20.0
-(void) fadeOut:(NSTimeInterval)fadeTime
{

    float originalVolume = self.volume;
    if (originalVolume == 0)
        return;
    
    NSTimeInterval fireInterval = fadeTime/kFadeSteps;
    float volumeDecrement = originalVolume/kFadeSteps;
    
    self.volume = originalVolume - volumeDecrement;
    
    [NSTimer scheduledTimerWithTimeInterval:fireInterval target:self selector:@selector(fadeOutTimerMethod:) userInfo:[NSNumber numberWithFloat:originalVolume] repeats:YES];
    
}

- (void)fadeOutTimerMethod:(NSTimer*)theTimer
{
    float originalVolume = [(NSNumber*)[theTimer userInfo] floatValue];
    float volumeDecrement = originalVolume/kFadeSteps;
    
    if (self.volume > volumeDecrement)
    {
        self.volume = self.volume - volumeDecrement;
    }
    else if ( [theTimer isValid] )
    {
        [self stopSong];
        
        self.volume = originalVolume;
        
        [theTimer invalidate];
    }
    
    
}

-(void) fadeIn:(NSTimeInterval)fadeTime
{
    NSTimeInterval fireInterval = fadeTime/kFadeSteps;
    float originalVolume = self.volume;
    
    self.volume = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:fireInterval target:self selector:@selector(fadeInTimerMethod:) userInfo:[NSNumber numberWithFloat:originalVolume] repeats:YES];
    
}

- (void)fadeInTimerMethod:(NSTimer*)theTimer
{
    float originalVolume = [(NSNumber*)[theTimer userInfo] floatValue];
    float volumeIncrement = originalVolume/kFadeSteps;
    
    if (self.volume < originalVolume)
    {
        self.volume = self.volume + volumeIncrement;
    }
    else if ( [theTimer isValid] )
    {
        self.volume = originalVolume;
        
        [theTimer invalidate];
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

// playback notifications for MPMusicPlayerController
-(void) handlePlaybackStateChanged:(NSNotification *)notification
{
    MPMusicPlayerController *musicPlayer = notification.object;
    
    // fire an event if indexOfNowPlayingItem is not 0 - since we only have 1 song in the queue, any value
    // other than 0 indicates the song has finished
    if (musicPlayer.playbackState == MPMusicPlaybackStateStopped && musicPlayer.indexOfNowPlayingItem != 0)
    {
        NSString *indexStr = [NSString stringWithFormat:@"%d", musicPlayer.indexOfNowPlayingItem];
        FREDispatchStatusEventAsync(_context, (uint8_t*)[eventSongFinished UTF8String], (uint8_t*)[indexStr UTF8String]);
    }
    
}

// MPMediaPickerControllerDelegate
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    // get the last picked item
    MPMediaItem *pickedItem = [mediaItemCollection.items objectAtIndex:0];
    
    //unsigned long long parsedValue = strtoull([yourString UTF8String], NULL, 0);
    
    // send an event
    NSString *ID = [NSString stringWithFormat:@"%qi", [[pickedItem valueForProperty:MPMediaItemPropertyPersistentID] longLongValue]];
    NSString *title = [pickedItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [pickedItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber *duration = [pickedItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
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
