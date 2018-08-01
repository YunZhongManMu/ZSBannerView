//
//  HVWBorderShownCardCell.m
//  ZSBannerViewDemo
//
//  Created by Shaun on 2018/7/23.
//  Copyright © 2018年 Shaun. All rights reserved.
//

#import "HVWBorderShownCardCell.h"

@interface HVWBorderShownCardCell()

@property(nonatomic, strong) UIImageView *bgImageView;

@end

@implementation HVWBorderShownCardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bgImageView.layer.cornerRadius = 4;
    _bgImageView.layer.masksToBounds = YES;
    [self addSubview:_bgImageView];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _bgImageView.image = image;
}


@end
