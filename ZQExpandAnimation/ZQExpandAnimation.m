//
//  ZQExpandAnimation.m
//  ZQExpandAnimation
//
//  Created by 张庆强 on 2017/9/11.
//  Copyright © 2017年 zhangqq. All rights reserved.
//

#import "ZQExpandAnimation.h"


@interface ZQExpandAnimation ()
//上部过度视图
@property (nonatomic,strong)UIView* topSlidingView;
//下部过度视图
@property (nonatomic,strong)UIView* bottomSlidingView;

@end

@implementation ZQExpandAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL isPresention = toViewController.presentationController.presentingViewController == fromViewController;
    
    UIView *frontView = isPresention?toViewController.view:fromViewController.view;
    UIView *backgrountView = isPresention?fromViewController.view:toViewController.view;
    UIView *inView = transitionContext.containerView;
    
    [backgrountView layoutIfNeeded];
    
    //获取动画起始位置
    CGRect collapsedFrame  = CGRectZero;
    if (_collapsedViewFrame) {
        collapsedFrame = self.collapsedViewFrame();
    } else {
        collapsedFrame = CGRectMake(backgrountView.bounds.origin.x,backgrountView.bounds.origin.y, CGRectGetWidth(backgrountView.bounds), 0);
    }
    
    if (CGRectGetMaxY(collapsedFrame) < backgrountView.bounds.origin.y) {
        collapsedFrame.origin.y = backgrountView.bounds.origin.y - collapsedFrame.size.height;
    }
    
    if (collapsedFrame.origin.y > CGRectGetMaxY(backgrountView.bounds)) {
        collapsedFrame.origin.y = CGRectGetMaxY(backgrountView.bounds);
    }
    CGRect expandedFrame;
    if (self.expandedViewFrame.size.height != 0) {
        expandedFrame = self.expandedViewFrame;
    } else {
        expandedFrame = inView.bounds;
    }
    
    CGRect topSlidingViewFrame = CGRectMake(backgrountView.bounds.origin.x, backgrountView.bounds.origin.y, backgrountView.bounds.size.width, collapsedFrame.origin.y);
    
    UIView *topsView = [backgrountView resizableSnapshotViewFromRect:topSlidingViewFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    _topSlidingView = topsView?:_topSlidingView;
    _topSlidingView.frame = topSlidingViewFrame;
    
    CGFloat bottomSlidingViewOriginY = CGRectGetMaxY(collapsedFrame);
    CGRect bottomSlidingViewFrame = CGRectMake(backgrountView.bounds.origin.x,bottomSlidingViewOriginY, backgrountView.bounds.size.width, CGRectGetMaxY(backgrountView.bounds) - bottomSlidingViewOriginY);
    
    UIView *bottomsView = [backgrountView resizableSnapshotViewFromRect:bottomSlidingViewFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    _bottomSlidingView = bottomsView?:_bottomSlidingView;
    _bottomSlidingView.frame = bottomSlidingViewFrame;
    
    CGFloat topSlidingDistance = collapsedFrame.origin.y - backgrountView.bounds.origin.y;
    CGFloat bottomSlidingDistance = CGRectGetMaxY(backgrountView.bounds) - CGRectGetMaxY(collapsedFrame);
    
    //返回时计算过度视图位置
    if (!isPresention) {
        CGPoint center = _topSlidingView.center;
        center.y -= topSlidingDistance;
        _topSlidingView.center = center;
        
        center = _bottomSlidingView.center;
        center.y += bottomSlidingDistance;
        _bottomSlidingView.center = center;
    }
    
    _topSlidingView.frame = [backgrountView convertRect:_topSlidingView.frame toView:inView];
    _bottomSlidingView.frame = [backgrountView convertRect:_bottomSlidingView.frame toView:inView];
    
    if (_topSlidingView && _bottomSlidingView) {
        [inView addSubview:_topSlidingView];
        [inView addSubview:_bottomSlidingView];
    }
    
    [inView addSubview:frontView];
    collapsedFrame = [backgrountView convertRect:collapsedFrame toView:inView];
    if (isPresention) {
        frontView.frame = collapsedFrame;
    }
    
    //执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (isPresention) {
            CGPoint  center = _topSlidingView.center;
            center.y -= topSlidingDistance;
            _topSlidingView.center = center;
            
            center = _bottomSlidingView.center;
            center.y += bottomSlidingDistance;
            _bottomSlidingView.center = center;
            
            frontView.frame = expandedFrame;
            [frontView layoutIfNeeded];
        }else {
            CGPoint center = _topSlidingView.center;
            center.y += topSlidingDistance;
            _topSlidingView.center = center;
            
            center = _bottomSlidingView.center;
            center.y -= bottomSlidingDistance;
            _bottomSlidingView.center = center;
            
            frontView.frame = collapsedFrame;

        }
    } completion:^(BOOL finished) {
        
        [_topSlidingView removeFromSuperview];
        [_bottomSlidingView removeFromSuperview];
        
        if (!isPresention) {
            [frontView removeFromSuperview];
        }
        [transitionContext completeTransition:YES];
    }];
    
}

@end
