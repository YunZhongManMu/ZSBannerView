//
//  ZSBannerCell.m
//  ZSBannerViewDemo
//
//  Created by Shaun on 2018/7/20.
//  Copyright © 2018年 Shaun. All rights reserved.
//

#import "ZSBannerCell.h"
#import "UIImageView+WebCache.h"

@interface ZSBannerCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZSBannerCell

+ (NSString *)zs_identifier {
    return NSStringFromClass(self.class);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}


- (void)configData:(id)data placeholder:(UIImage *)placeholder {
    
    if (data) {
        
        if ([data isKindOfClass:[UIImage class]]) {
            
            self.imageView.image = (UIImage *)data;
            return;
            
        } else if ([data isKindOfClass:[NSString class]]) {
            
            NSString *imageUrl = (NSString *)data;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
            return;
            
        } else if ([data isKindOfClass:[NSURL class]]) {
            
            NSURL *imageURL = (NSURL *)data;
            [self.imageView sd_setImageWithURL:imageURL placeholderImage:placeholder];
            return;
            
        }
    }
    
    if (placeholder) {
        self.imageView.image = placeholder;
    }
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

@end
