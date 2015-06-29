@interface CKRaiseGesture : NSObject

@property (getter=isEnabled, nonatomic) BOOL enabled;
@property (nonatomic) int gestureState;
@property (nonatomic) BOOL proximityState;
@property (getter=isRecognized, nonatomic, readonly) BOOL recognized;

+ (BOOL)isRaiseGestureEnabled;
+ (BOOL)isRaiseGestureSupported;

- (id)initWithTarget:(id)target action:(SEL)action;
- (BOOL)isRecognized;
- (void)setGestureManager:(id)arg1;
- (id)target;

@end
