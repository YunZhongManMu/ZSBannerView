//
//  ZSBannerView.h
//  ZSBannerViewDemo
//
//  Created by Shaun on 2018/7/20.
//  Copyright © 2018年 Shaun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSBannerView, ZSBannerConfig;

@protocol ZSBannerViewDataSource <NSObject>

@required
- (NSArray *)dataSourceOfBannerView:(ZSBannerView *)bannerView;

@optional
- (ZSBannerConfig *)configOfBannerView:(ZSBannerView *)bannerView;

@end

@protocol ZSBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(ZSBannerView *)bannerView didSelectIndex:(NSInteger)selectIndex selectData:(id)selectData;

@end

@interface ZSBannerConfig : NSObject

@property (nonatomic, strong) UIImage *placeholder;

@property (nonatomic, assign) NSTimeInterval autoScrollInterval;

@end

@interface ZSBannerView : UIView

@property (nonatomic, weak) id<ZSBannerViewDelegate> delegate;
@property (nonatomic, weak) id<ZSBannerViewDataSource> dataSource;

- (void)reloadData;

@end
