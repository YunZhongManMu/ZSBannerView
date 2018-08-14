//
//  ZSBannerConfig.m
//  ZSBannerViewDemo
//
//  Created by Shaun on 2018/8/14.
//  Copyright © 2018年 Shaun. All rights reserved.
//

#import "ZSBannerConfig.h"

@implementation ZSBannerConfig

- (void)refreshConfig:(ZSBannerConfig *)config {
    if (config.placeholder) {
        self.placeholder = config.placeholder;
    }
    if (config.autoScrollInterval >= 0) {
        self.autoScrollInterval = config.autoScrollInterval;
    }
    if ((config.horizontalMargin >= 0 || config.itemMargin >= 0) && config.horizontalMargin > config.itemMargin) {
        self.horizontalMargin = config.horizontalMargin;
        self.itemMargin = config.itemMargin;
    }
}

@end
