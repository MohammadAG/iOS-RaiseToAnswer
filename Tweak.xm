#import <substrate.h>

@interface PHAudioCallViewController : UIViewController
@property(retain) id bottomBar;
- (void)bottomBarActionPerformed:(long long)arg1 fromBar:(id)arg3;
- (void)bottomBarActionPerformed:(long long)arg1 withCompletionState:(long long)arg2 fromBar:(id)arg3;
- (void)answerCallFromRaiseGesture;
@end

@interface TUCallCenter : NSObject
@property (nonatomic,readonly) id incomingCall; 
@property (nonatomic,readonly) id incomingVideoCall;
+ (id)sharedInstance;
- (void)answerCall:(id)arg1;
@end

@interface CKRaiseGesture : NSObject
@property (getter=isEnabled, nonatomic) BOOL enabled;
+ (BOOL)isRaiseGestureSupported;
- (id)initWithTarget:(id)target action:(SEL)action;
- (id)target;
@end

static CKRaiseGesture *_raiseGesture = nil;

%hook PHAudioCallViewController
- (void)viewDidAppear:(BOOL)animated
{
	%orig;    
    if(%c(CKRaiseGesture)!=nil && ![%c(CKRaiseGesture) isRaiseGestureSupported]) {
        return;
    }
    _raiseGesture = [[%c(CKRaiseGesture) alloc] initWithTarget:self action:@selector(answerCallFromRaiseGesture)];
    _raiseGesture.enabled = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (_raiseGesture) {
        _raiseGesture.enabled = NO;
        [_raiseGesture release];
        _raiseGesture = nil;
    }
    %orig;
}
%new
- (void)answerCallFromRaiseGesture
{    
    _raiseGesture.enabled = NO;
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		if([self respondsToSelector:@selector(bottomBar)]) {
			if([self respondsToSelector:@selector(bottomBarActionPerformed:withCompletionState:fromBar:)]) {
				[self bottomBarActionPerformed:1 withCompletionState:1 fromBar:self.bottomBar];
				return;
			} else if([self respondsToSelector:@selector(bottomBarActionPerformed:fromBar:)]) {
				[self bottomBarActionPerformed:1 fromBar:self.bottomBar];
				return;
			}
		}
		TUCallCenter* shard = [%c(TUCallCenter) sharedInstance];
		if([shard incomingCall]!=nil) {
			[shard answerCall:[shard incomingCall]];
		}
	});
}
%end

%hook CKRaiseGesture
- (void)setGestureState:(int)state
{
    %orig;
	@try {
		PHAudioCallViewController *controller = (PHAudioCallViewController*)self.target;
		if(controller) {
			[controller answerCallFromRaiseGesture];
		}
	} @catch(NSException* ex) {
	}
}
+ (BOOL)isRaiseGestureEnabled
{
    return YES;
}
%end

%ctor
{
	dlopen("/System/Library/PrivateFrameworks/TelephonyUtilities.framework/TelephonyUtilities", RTLD_LAZY);
}
