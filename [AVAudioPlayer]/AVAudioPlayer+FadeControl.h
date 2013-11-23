//
//  AVAudioPlayer+FadeControl.h
//  SongPicker-iOS
//
//  Created by Richard Lovejoy on 11/10/13.
//  Copyright (c) 2013 Richard Lovejoy. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (FadeControl)

-(void)fadeOutWithDuration:(NSTimeInterval)inFadeOutTime;
-(void)fadeInWithDuration:(NSTimeInterval)inFadeOutTime;

@end
