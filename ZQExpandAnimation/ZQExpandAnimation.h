//
//  ZQExpandAnimation.h
//  ZQExpandAnimation
//
//  Created by 张庆强 on 2017/9/11.
//  Copyright © 2017年 zhangqq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef CGRect(^collapsedViewFrameBlock)();

@interface ZQExpandAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic,copy)collapsedViewFrameBlock collapsedViewFrame;

@property(nonatomic) CGRect expandedViewFrame;

@end
