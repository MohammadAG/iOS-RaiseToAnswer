#import "PHCallViewController.h"
#import "TPSuperBottomBar.h"

@interface PHAudioCallViewController : PHCallViewController

@property(nonatomic) unsigned short currentState;
@property(retain) TPSuperBottomBar *bottomBar;

- (void)bottomBarActionPerformed:(int)action fromBar:(TPSuperBottomBar*)bottomBar;
- (void)answerCallFromRaiseGesture;

@end