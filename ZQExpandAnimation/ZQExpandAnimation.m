//
//  ZQExpandAnimation.m
//  ZQExpandAnimation
//
//  Created by 张庆强 on 2017/9/11.
//  Copyright © 2017年 zhangqq. All rights reserved.
//

#import "ZQExpandAnimation.h"

typedef CGRect(^collapsedViewFrameBlock)();

@interface ZQExpandAnimation ()
@property (nonatomic,copy)collapsedViewFrameBlock collapsedViewFrame;

@end

@implementation ZQExpandAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL isPresention = toViewController.presentationController.presentingViewController == fromViewController;
    
    UIView *frontView = isPresention?toViewController.view:fromViewController.view;
    UIView *backgrountView = isPresention?fromViewController.view:toViewController.view;
    UIView *inView = transitionContext.containerView;
    
    [backgrountView layoutIfNeeded];
    
    CGRect collapsedFrame = self.collapsedViewFrame();
    
}
@end
