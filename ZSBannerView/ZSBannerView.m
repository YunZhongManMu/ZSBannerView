//
//  ZSBannerView.m
//  ZSBannerViewDemo
//
//  Created by Shaun on 2018/7/20.
//  Copyright © 2018年 Shaun. All rights reserved.
//

#import "ZSBannerView.h"
#import "ZSBannerCell.h"

@interface ZSBannerConfig ()

- (void)refreshConfig:(ZSBannerConfig *)config;

@end

@interface ZSBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, strong) ZSBannerConfig *bannerConfig;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZSBannerView

// 解决当父View释放时，当前试图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self stopTimer];
    }
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self createConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self createUI];
        [self createConfig];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:ZSBannerCell.class forCellWithReuseIdentifier:ZSBannerCell.zs_identifier];
}

- (void)createConfig {
    // 用于初始化默认的配置
    ZSBannerConfig *bannerConfig = [[ZSBannerConfig alloc] init];
    bannerConfig.autoScrollInterval = 3;
    self.bannerConfig = bannerConfig;
}

#pragma mark - public
- (void)reloadData {
    if ([self.dataSource respondsToSelector:@selector(dataSourceOfBannerView:)]) {
        self.dataArray = [self.dataSource dataSourceOfBannerView:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(configOfBannerView:)]) {
        ZSBannerConfig *bannerConfig = [self.dataSource configOfBannerView:self];
        if (bannerConfig) {
            [self.bannerConfig refreshConfig:bannerConfig];
        }
    }
    
    self.totalItemsCount = self.dataArray.count * 100;
    if (self.dataArray.count > 1) {
        self.collectionView.scrollEnabled = YES;
        [self startTimer];
    } else {
        self.collectionView.scrollEnabled = NO;
        [self stopTimer];
    }
    
    [self defaultScrollItem];
    [self.collectionView reloadData];
}

#pragma mark - private
- (void)startTimer {
    if (self.bannerConfig.autoScrollInterval == 0) return;
    if (self.dataArray.count < 1) return;
    if (self.timer) [self stopTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.bannerConfig.autoScrollInterval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerAction:(NSTimer *)timer {
    if (self.bannerConfig.autoScrollInterval == 0) return;
    if (self.totalItemsCount == 0) return;
    NSInteger currentIndex = [self currentIndex] + 1;
    [self scrollToIndex:currentIndex];
}

// 找到当前的滚动的index
- (NSInteger)currentIndex {
    NSInteger index = (self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5) / self.collectionView.frame.size.width;
    return MAX(0, index);
}

// 找到当前选中的index
- (NSInteger)pageIndexWithCellIndex:(NSInteger)index {
    return (NSInteger)index % self.dataArray.count;
}

- (void)scrollToIndex:(NSInteger)index {
#warning 大于总条数时处理， 小于总条数时应该也处理
    if (index >= _totalItemsCount) {
        index = _totalItemsCount * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

// 起始始默认滚动
- (void)defaultScrollItem {
    if (self.collectionView.contentOffset.x == 0 && _totalItemsCount > 0) {
        NSInteger index = _totalItemsCount * 0.5;
        // 防止启动时，与系统动画冲突报错
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        });
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSBannerCell.zs_identifier forIndexPath:indexPath];
    
    NSInteger itemIndex = [self pageIndexWithCellIndex:indexPath.item];
    
    id data = self.dataArray[itemIndex];
    [cell configData:data placeholder:self.bannerConfig.placeholder];
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger itemIndex = [self pageIndexWithCellIndex:indexPath.item];
    id data = self.dataArray[itemIndex];
    
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectIndex:selectData:)]) {
        [self.delegate bannerView:self didSelectIndex:itemIndex selectData:data];
    }
}

// 每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

// 行间距（竖直滚动）   列间距（水平滚动）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
//        _collectionView.clipsToBounds = NO;
    }
    return _collectionView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

// 解决当timer释放后 回调scrollViewDidScroll时，访问野指针导致崩溃
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

@end

@implementation ZSBannerConfig

- (void)refreshConfig:(ZSBannerConfig *)config {
    if (config.placeholder) {
        self.placeholder = config.placeholder;
    }
    if (config.autoScrollInterval >= 0) {
        self.autoScrollInterval = config.autoScrollInterval;
    }
}

@end
