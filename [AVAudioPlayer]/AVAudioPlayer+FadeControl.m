//
//  AVAudioPlayer+FadeControl.m
//  SongPicker-iOS
//
//  Created by Richard Lovejoy on 11/10/13.
//  Copyright (c) 2013 Richard Lovejoy. All rights reserved.
//

#import "AVAudioPlayer+FadeControl.h"

#define     kFadeSteps  20.0

// From:
// http://stackoverflow.com/questions/13872707/add-fading-effect-in-songs-playlist-using-avaudioplayer-and-mpmusicplayercontrol
@implementation AVAudioPlayer (FadeControl)

// fade out
-(void)fadeOutWithDuration:(NSTimeInterval)inFadeOutTime
{
    NSTimeInterval fireInterval = inFadeOutTime/kFadeSteps;
    float originalVolume = self.volume;
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
        [self stop];
        
        self.volume = originalVolume;
        
        [theTimer invalidate];
    }
    
    
}

// fade in
-(void)fadeInWithDuration:(NSTimeInterval)inFadeOutTime
{
    NSTimeInterval fireInterval = inFadeOutTime/kFadeSteps;
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

@end
