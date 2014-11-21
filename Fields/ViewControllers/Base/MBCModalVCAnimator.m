
#import "MBCModalVCAnimator.h"

@interface MBCModalVCAnimator ()
@property (nonatomic, strong) UIDynamicAnimator *dynamics;
@end

@implementation MBCModalVCAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.isPresenting ? 0.75f : 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    self.dynamics = [[UIDynamicAnimator alloc] initWithReferenceView:[transitionContext containerView]]; // Our reference SIZE is the whole context contentainer size.
    
    if (self.isPresenting) {
        // We need to "paint" everything we need in the context
        [transitionContext.containerView addSubview:fromVC.view];
        [transitionContext.containerView addSubview:toVC.view];
        
        fromVC.view.userInteractionEnabled = NO;
        
        CGFloat xOffset = 300;
        CGFloat yOffset = 80;
        toVC.view.frame = CGRectMake(0, 0, 600, 400);
        toVC.view.center = CGPointMake(CGRectGetWidth(fromVC.view.frame) + xOffset,
                                       CGRectGetHeight(fromVC.view.frame)/2 - yOffset);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:3
                            options:0
                         animations:^{
                             fromVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
        
        CGPoint snapPoint = CGPointMake(fromVC.view.center.x, fromVC.view.center.y - yOffset);
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:toVC.view
                                                        snapToPoint:snapPoint];
        snap.damping = 0.5;
        [self.dynamics addBehavior:snap];
        
        [self performSelector:@selector(completeTransitionWithContext:)
                   withObject:transitionContext
                   afterDelay:0.75];
        
    } else {
        // We need to "paint" everything we need in the context
        [transitionContext.containerView addSubview:toVC.view];
        [transitionContext.containerView addSubview:fromVC.view];
        
        // now our fromVC var is the ToViewController
        // now our toVC var is the FromViewController
        
        // We'll do this gravity
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toVC.view.transform = CGAffineTransformIdentity;
                             toVC.view.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        } completion:^(BOOL finished) {
            toVC.view.userInteractionEnabled = YES;
            // iOS8 Bug
            [[UIApplication sharedApplication].keyWindow addSubview:toVC.view];
            // iOS8 Bug
            
            [transitionContext completeTransition:YES];
            
        }];
        
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[fromVC.view]];
        gravity.magnitude = 3; // points / seconds potencia 2
        //        dynamics.delegate = self;
        [self.dynamics addBehavior:gravity];
        //

        UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[fromVC.view]];
        CGFloat wallPositionY = CGRectGetHeight(toVC.view.frame)/2 + CGRectGetHeight(fromVC.view.frame)/2 +1;
        [collision addBoundaryWithIdentifier:@"boundary1"
                                   fromPoint:CGPointMake(0,
                                                         wallPositionY)
                                     toPoint:CGPointMake(CGRectGetWidth(toVC.view.frame)/2 - CGRectGetWidth(fromVC.view.frame)/4 - 10,
                                                         wallPositionY)];
        [self.dynamics addBehavior:collision];
        
        
    }
}

- (void)completeTransitionWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [transitionContext completeTransition:YES];
}


@end
