//
//  MGCShareView.m
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/4/30.
//

#import "MGCShareView.h"
#import "MGCShareCollectionViewCell.h"
#import "MGCShareManager.h"
#import "UIView+YYAdd.h"
#import "UIViewController+parentViewController.h"

@interface MGCShareView () <UICollectionViewDelegate,UICollectionViewDataSource>
//分享按钮
@property (nonatomic, strong) NSMutableArray *shareItemsArr;
//功能按钮
@property (nonatomic, strong) NSMutableArray *functionItemsArr;
//遮罩
@property (nonatomic, strong) UIView *maskView;
//白色背景框
@property (nonatomic, strong) UIView *bgView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//线
@property (nonatomic, strong) UIView *lineView;
//分享
@property (nonatomic, strong) UICollectionView *shareCollectionView;
//功能
@property (nonatomic, strong) UICollectionView *functionCollectionView;
//取消
@property (nonatomic, strong) UIButton *cancelBtn;

//背景白色
@property (nonatomic, strong) UIView *shareImgaeView;
//分享大图
@property (nonatomic, strong) UIImageView *bigShareImageView;
//用户名称
@property (nonatomic, strong) UILabel *nameLabel;
//分享描述
@property (nonatomic, strong) UILabel *desLabel;
//二维码图片
@property (nonatomic, strong) UIImageView *QRCodeImageView;
//二维码描述
@property (nonatomic, strong) UILabel *codeDesLabel;
//logo
@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, assign) CGFloat lastTransitionY;

@end

@implementation MGCShareView

+ (MGCShareView *)showShareViewWithShareInfoModel:(MGCShareInfoModel *)shareInfoModel
                                     successBlock:(void (^)(NSDictionary *info, UMSocialPlatformType type))successBlock
                                        failBlock:(void (^)(NSDictionary *info, UMSocialPlatformType type))failBlock
                                        completed:(void (^)(BOOL isShow))completed {
    MGCShareView *shareView = [[MGCShareView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    shareView.shareInfoModel = shareInfoModel;
    [shareView prepareDefaultShareItem];
    [shareView prepareCollection];
    shareView.successBlock = successBlock;
    shareView.failBlock = failBlock;
    if (completed) {
        completed(YES);
    }
    [shareView showWithView:[UIViewController currentTopViewController].view];
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initGesture];
    }
    return self;
}

#pragma mark - init

- (void)initView {
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.shareCollectionView];
    [self.bgView addSubview:self.cancelBtn];
}


- (void)initGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.bgView addGestureRecognizer:pan];
}

#pragma mark - initData

//默认分享配置方法
- (void)prepareDefaultShareItem {
    [self.shareItemsArr removeAllObjects];
    MGCShareItemModel *faceBookModel = [[MGCShareItemModel alloc] init];
    faceBookModel.itemName = @"FaceBook";
    faceBookModel.itemType = UMSocialPlatformType_Facebook;
    faceBookModel.itemImage = @"00262_ Facebook Fill";
    
    MGCShareItemModel *whatsAppModel = [[MGCShareItemModel alloc] init];
    whatsAppModel.itemName = @"WhatsApp";
    whatsAppModel.itemType = UMSocialPlatformType_Whatsapp;
    whatsAppModel.itemImage = @"00266_ Wx Fill";
    
    MGCShareItemModel *twitterModel = [[MGCShareItemModel alloc] init];
    twitterModel.itemName = @"Twitter";
    twitterModel.itemType = UMSocialPlatformType_Twitter;
    twitterModel.itemImage = @"00263_ Twitter Fill";
    
    
    MGCShareItemModel *copyModel = [[MGCShareItemModel alloc] init];
    copyModel.itemName = @"URL";
    copyModel.itemType = UMSocialPlatformType_UserDefine_Begin;
    copyModel.itemImage = @"00103_ Connect Fill";
    
    [self.shareItemsArr addObject:faceBookModel];
    [self.shareItemsArr addObject:twitterModel];
    [self.shareItemsArr addObject:whatsAppModel];
    [self.shareItemsArr addObject:copyModel];
    
    [self.shareCollectionView reloadData];
}

- (void)prepareCollection {
    CGFloat bgHeight = 145+160;
    CGFloat oneToolHeight = 121+100;
    CGFloat btnHeitght = 16+40;
    if (IS_IPHONE_X) {
        bgHeight = 145+160+iPhoneXBottomOffset;
        oneToolHeight = 113+100+iPhoneXBottomOffset;
        btnHeitght = 16+40+iPhoneXBottomOffset;
    }
    _bgView.frame = CGRectMake(0, self.height - oneToolHeight, self.width, oneToolHeight);
    _titleLabel.frame = CGRectMake(0, 14, self.width, 21);
    _lineView.frame = CGRectMake(0, self.titleLabel.bottom + 13, self.width, 1);
    _shareCollectionView.frame = CGRectMake(0, self.lineView.bottom + 24, self.width, 60);
    _cancelBtn.frame = CGRectMake(15, self.bgView.height - btnHeitght, self.width - 30, 40);
    [self.shareCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shareItemsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGCShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MGCShareCollectionViewCell" forIndexPath:indexPath];
    MGCShareItemModel *itemModel = [self.shareItemsArr objectAtIndex:indexPath.item];
    [cell configDataWithItemModel:itemModel];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MGCShareItemModel *itemModel = [self.shareItemsArr objectAtIndex:indexPath.item];
    if (self.successBlock) {
        self.successBlock(@{}, itemModel.itemType);
    }
    [self cancelBtnAction];
}


#pragma makr - btnAction

- (void)cancelBtnAction {
    self.alpha = 1;
    self.maskView.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.bgView.frame = CGRectMake(0, self.height, self.width, 0);
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - show && Hide

- (void)showWithView:(UIView *)superView {
    if (!self.superview) {
        //上述判断isshow在类方法show的时候是无效的 地址都是不一样的。
        for (UIView *tempView in superView.subviews) {
            if ([tempView isKindOfClass:[MGCShareView class]]) {
                //先删除
                [tempView removeFromSuperview];
            }
        }
        //再添加 保证只有一个分享视图
        [superView addSubview:self];
    }
    
    CGFloat height = 145+160;
    CGFloat oneToolHeight = 113+100;
    if (IS_IPHONE_X) {
        height = 145+160+iPhoneXBottomOffset;
        oneToolHeight = 113+100+iPhoneXBottomOffset;
    }
    CGFloat viewHeight = oneToolHeight;
    
    self.alpha = 0;
    self.maskView.alpha = 0;
    self.bgView.frame = CGRectMake(0, self.height, self.width, viewHeight);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.bgView.frame = CGRectMake(0, self.height - viewHeight, self.width, viewHeight);
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)panAction:(UIPanGestureRecognizer *)sender {
    CGPoint translationPoint = [sender translationInView:self.bgView];
    
    CGFloat shareHeight = self.bgView.frame.size.height;
    CGRect newFrame = CGRectMake(0, MainScreen_height - shareHeight, MainScreen_width, shareHeight);
    newFrame.origin.y =  MainScreen_height - shareHeight + translationPoint.y;
    
    if (newFrame.origin.y <= MainScreen_height - shareHeight) {
        newFrame.origin.y = MainScreen_height - shareHeight;
    }
    
    self.bgView.frame = newFrame;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:self.bgView];
        // 结束时的速度>0 滑动距离> 5 且UIScrollView滑动到最顶部
        if ((velocity.y > 0 && self.lastTransitionY > 100) || shareHeight < 150) {
            [self removeFromSuperview];
        }else {
            [self reSetbgFrame];
        }
    }
    self.lastTransitionY = translationPoint.y;
}

- (void)reSetbgFrame {
    CGFloat height = 145+160;
    CGFloat oneToolHeight = 113+100;
    if (IS_IPHONE_X) {
        height = 145+160+iPhoneXBottomOffset;
        oneToolHeight = 113+100+iPhoneXBottomOffset;
    }
    CGFloat viewHeight = oneToolHeight;
    self.bgView.frame = CGRectMake(0, self.height - viewHeight, self.width, viewHeight);
}

#pragma mark - setter && getter


- (UIView *)bgView {
    if (!_bgView) {
        CGFloat height = 145+160;
        if (IS_IPHONE_X) {
            height = 145+160+iPhoneXBottomOffset;
        }
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - height, self.width, height)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, self.width, 21)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.text = kLocalizedString(@"Share_to");
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom + 13, self.width, 1)];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}
- (UICollectionView *)shareCollectionView {
    if (!_shareCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = 32;
        flowLayout.itemSize = CGSizeMake(50, 60);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
        _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.lineView.bottom + 24, self.width, 60) collectionViewLayout:flowLayout];
        _shareCollectionView.backgroundColor = [UIColor clearColor];
        _shareCollectionView.delegate = self;
        _shareCollectionView.dataSource = self;
        _shareCollectionView.scrollEnabled = YES;
        _shareCollectionView.showsHorizontalScrollIndicator = NO;
        [_shareCollectionView registerClass:[MGCShareCollectionViewCell class] forCellWithReuseIdentifier:@"MGCShareCollectionViewCell"];
    }
    return _shareCollectionView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        CGFloat height = 16+40;
        if (IS_IPHONE_X) {
            height = 16+40+iPhoneXBottomOffset;
        }
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.bgView.height - height, self.width - 30, 40)];
        [_cancelBtn setTitle:kLocalizedString(@"CANCEL") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.cornerRadius = 20;
        _cancelBtn.layer.masksToBounds = YES;
    }
    return _cancelBtn;
}

- (NSMutableArray *)shareItemsArr{
    if (!_shareItemsArr) {
        _shareItemsArr = [NSMutableArray array];
    }
    return _shareItemsArr;
}

- (MGCShareInfoModel *)shareInfoModel{
    if (!_shareInfoModel) {
        _shareInfoModel = [[MGCShareInfoModel alloc] init];
    }
    return _shareInfoModel;
}

@end
