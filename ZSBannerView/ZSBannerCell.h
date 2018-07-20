//
//  ZSBannerCell.h
//  ZSBannerViewDemo
//
//  Created by Shaun on 2018/7/20.
//  Copyright © 2018年 Shaun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSBannerCell : UICollectionViewCell

+ (NSString *)zs_identifier;

- (void)configData:(id)data placeholder:(UIImage *)placeholder;

@end
