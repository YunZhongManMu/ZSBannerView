//
//  ViewController.m
//  ZSBannerViewDemo
//
//  Created by Shaun on 2018/7/20.
//  Copyright © 2018年 Shaun. All rights reserved.
//
//  https://www.jianshu.com/p/50837fa99466

#import "ViewController.h"
#import "ZSBannerView.h"

@interface ViewController ()<ZSBannerViewDelegate, ZSBannerViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat padding = 0;

    CGFloat width = [UIScreen mainScreen].bounds.size.width - padding * 2;
    CGFloat height = width / 3.0 * 2;

    ZSBannerView *bannerView = [[ZSBannerView alloc] initWithFrame:CGRectMake(padding, 50, width, height)];
    bannerView.delegate = self;
    bannerView.dataSource = self;
    [self.view addSubview:bannerView];

    // 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bannerView reloadData];
    });
}

#pragma mark - <ZSBannerViewDelegate, ZSBannerViewDataSource>
- (NSArray *)dataSourceOfBannerView:(ZSBannerView *)bannerView {
    return @[
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532088373042&di=35bdffe89e4c2a1abb12eecb29d07f69&imgtype=0&src=http%3A%2F%2Fi.shangc.net%2F2017%2F1127%2F20171127044522308.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532088395937&di=d009b19fef79d858c2ff0aecbf0245b6&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170904%2Fcb86bfe23dc04515a5829423401bd8bf_th.jpg",
             @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1532088414359&di=fa7aea774d3c9bb3e8e77953ede436ee&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fdbb44aed2e738bd4841e5f8ca38b87d6277ff954.jpg"
             ];
}

- (ZSBannerConfig *)configOfBannerView:(ZSBannerView *)bannerView {
    ZSBannerConfig *config = [[ZSBannerConfig alloc] init];
    config.autoScrollInterval = 2;
    config.placeholder = [UIImage imageNamed:@"placeholder"];
    config.horizontalMargin = 40;
    config.itemMargin = 15;
    return config;
}

- (void)bannerView:(ZSBannerView *)bannerView didSelectIndex:(NSInteger)selectIndex selectData:(id)selectData {
    NSLog(@"----%ld----", selectIndex);
}


@end
