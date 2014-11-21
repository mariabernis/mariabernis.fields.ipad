
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MBCModalVCAnimator : NSObject <UIViewControllerAnimatedTransitioning>

// We usually have a boolean that tell us if we are presenting or dismissing
// So we can have different animations for showing and for hiding the modal.
@property (nonatomic, getter=isPresenting) BOOL presenting;

@end
