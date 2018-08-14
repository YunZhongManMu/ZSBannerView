//
//  ZSBannerConfig.h
//  ZSBannerViewDemo
//
//  Created by Shaun on 2018/8/14.
//  Copyright © 2018年 Shaun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZSBannerConfig : NSObject

/// 占位图
@property (nonatomic, strong) UIImage *placeholder;
/// 自动滚动时间
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;

/**
 *  horizontalMargin 左右两侧内容边距
 *  itemMargin cell之间的距离
 *  注: horizontalMargin必须大于itemMargin
 */
@property (nonatomic, assign) CGFloat horizontalMargin;
@property (nonatomic, assign) CGFloat itemMargin;



- (void)refreshConfig:(ZSBannerConfig *)config;

@end
