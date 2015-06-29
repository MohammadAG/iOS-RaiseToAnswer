#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioServices.h>

#import "CKRaiseGesture.h"
#import "PHAudioCallViewController.h"

static CKRaiseGesture *_raiseGesture = nil;

%hook PHAudioCallViewController

%new
- (void)answerCallFromRaiseGesture {
    if (self.currentState != 0) {
        if (_raiseGesture)
            _raiseGesture.enabled = NO;
        return;
    }
    
    _raiseGesture.enabled = NO;
    [self bottomBarActionPerformed:1 fromBar:self.bottomBar];
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    if (![%c(CKRaiseGesture) isRaiseGestureSupported]) {
        NSLog(@"Raise gesture not supported, bailing out");
        return;
    }
    
    _raiseGesture = [[%c(CKRaiseGesture) alloc] initWithTarget:self action:@selector(answerCallFromRaiseGesture)];
    _raiseGesture.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    if (_raiseGesture) {
        _raiseGesture.enabled = NO;
        [_raiseGesture release];
        _raiseGesture = nil;
    }
    
    %orig;
}

- (void)setCurrentState:(unsigned short)state animated:(BOOL)animated {
    %orig;
    
    if (_raiseGesture)
        _raiseGesture.enabled = state == 0;
}

%end

// Since we're in InCallService and no other class uses it...
%hook CKRaiseGesture

- (void)setGestureState:(int)state {
    %orig;
    
    PHAudioCallViewController *controller = (PHAudioCallViewController*)self.target;
    if (controller)
        [controller answerCallFromRaiseGesture];
}

+ (BOOL)isRaiseGestureEnabled {
    return YES;
}

%end

