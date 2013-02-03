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

#import <MediaPlayer/MediaPlayer.h>
#import "SongPickerHelper.h"

@implementation SongPickerHelper

@synthesize pickedItem = _pickedItem;

static NSString *eventSongChosen = @"songChosen";
static NSString *eventSongFinished = @"songFinished";
static NSString *eventCancelledSongPicker = @"cancelledSongPicker";

static BOOL observingMediaEvents = NO;

-(void) dealloc
{
    [_pickedItem release];
    [super dealloc];
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
        
        if (musicPlayer.playbackState != MPMusicPlaybackStateStopped)
        {
            [musicPlayer stop];
        }
        [musicPlayer setQueueWithQuery:songQuery];
        if (playbackTime > 0)
        {
            musicPlayer.currentPlaybackTime = playbackTime;
        }
        [musicPlayer play];
        
        // listen for item change
        if (!observingMediaEvents)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlaybackStateChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:musicPlayer];
            [musicPlayer beginGeneratingPlaybackNotifications];
            
            observingMediaEvents = YES;
        }
    }
    else
    {
        // just play current song
        if (playbackTime >= 0)
        {
            musicPlayer.currentPlaybackTime = playbackTime;
        }
        [musicPlayer play];
    }
}

-(void) pauseSong
{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer pause];
}

-(void) stopSong
{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer stop];
}

-(void) setContext:(FREContext)ctx
{
    _context = ctx;
}

// playback notifications
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
