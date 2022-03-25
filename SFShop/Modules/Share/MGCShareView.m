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
#import "UIWindow+FFWindow.h"
#import <Social/Social.h>
#import "PosterView.h"

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

@property (nonatomic,strong) PosterView *posterView;

@end

@implementation MGCShareView

+ (MGCShareView *)showShareViewWithShareInfoModel:(MGCShareInfoModel *)shareInfoModel posterModel:(NSArray <PosterPosterModel *> *)posterModelArr
                                     successBlock:(void (^)(NSDictionary *info, MGCShareType type))successBlock
                                        failBlock:(void (^)(NSDictionary *info, MGCShareType type))failBlock
                                        completed:(void (^)(BOOL isShow))completed {
    MGCShareView *shareView = [[MGCShareView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    shareView.shareInfoModel = shareInfoModel;
    shareView.posterModelArr = posterModelArr;
    [shareView prepareDefaultShareItem];
    [shareView prepareCollection];
    shareView.successBlock = successBlock;
    shareView.failBlock = failBlock;
    if (completed) {
        completed(YES);
    }
    [shareView showWithView:[UIWindow ffGetKeyWindow]];
    return shareView;
}
+ (MGCShareView *)showPosterViewWithShareInfoModel:(MGCShareInfoModel *)shareInfoModel posterModel:(NSArray <PosterPosterModel *> *)posterModelArr productModel:(DistributorRankProductModel *)productModel
                                     successBlock:(void (^)(NSDictionary *info, MGCShareType type))successBlock
                                        failBlock:(void (^)(NSDictionary *info, MGCShareType type))failBlock
                                         completed:(void (^)(BOOL isShow))completed {
    MGCShareView *shareView = [[MGCShareView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    shareView.posterModelArr = posterModelArr;
    shareView.productModel = productModel;
    shareView.shareInfoModel = shareInfoModel;
    [shareView prepareDefaultPosterItem];
    [shareView prepareCollection];
    [shareView preparePosterView];
    shareView.successBlock = successBlock;
    shareView.failBlock = failBlock;
    if (completed) {
        completed(YES);
    }
    [shareView showWithView:[UIWindow ffGetKeyWindow]];
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
    faceBookModel.itemType = MGCShareFacebookType;
    faceBookModel.itemImage = @"00262_ Facebook Fill";
    [self.shareItemsArr addObject:faceBookModel];

    
    NSString *url = [NSString stringWithFormat:@"whatsapp://"];
    NSURL *whatsappURL = [NSURL URLWithString: url];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        MGCShareItemModel *whatsAppModel = [[MGCShareItemModel alloc] init];
        whatsAppModel.itemName = @"WhatsApp";
        whatsAppModel.itemType = MGCShareWhatsAppType;
        whatsAppModel.itemImage = @"00266_ Wx Fill";
        [self.shareItemsArr addObject:whatsAppModel];
    }
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        MGCShareItemModel *twitterModel = [[MGCShareItemModel alloc] init];
        twitterModel.itemName = @"Twitter";
        twitterModel.itemType = MGCShareTwitterType;
        twitterModel.itemImage = @"00263_ Twitter Fill";
        [self.shareItemsArr addObject:twitterModel];
    }
    
    
    
    MGCShareItemModel *copyModel = [[MGCShareItemModel alloc] init];
    copyModel.itemName = @"URL";
    copyModel.itemType = MGCShareCopyLinkType;
    copyModel.itemImage = @"00103_ Connect Fill";
    
    [self.shareItemsArr addObject:copyModel];
    if (self.posterModelArr) {
        MGCShareItemModel *posterModel = [[MGCShareItemModel alloc] init];
        posterModel.itemName = @"Save Poster";
        posterModel.itemType = MGCSharePosterType;
        posterModel.itemImage = @"00103_ Connect Fill";
        
        [self.shareItemsArr addObject:posterModel];
    }
    
    
    
    [self.shareCollectionView reloadData];
}
//默认分享配置方法
- (void)prepareDefaultPosterItem {
    [self.shareItemsArr removeAllObjects];
    
    MGCShareItemModel *posterModel = [[MGCShareItemModel alloc] init];
    posterModel.itemName = kLocalizedString(@"SAVE_POSTER");
    posterModel.itemType = MGCShareSavePosterType;
    posterModel.itemImage = @"00118_ Download-1";
    
    [self.shareItemsArr addObject:posterModel];
    
    MGCShareItemModel *allPosterModel = [[MGCShareItemModel alloc] init];
    allPosterModel.itemName = kLocalizedString(@"SAVE_ALL");
    allPosterModel.itemType = MGCShareCopyLinkType;
    allPosterModel.itemImage = @"00118_ Download_All";
    
    [self.shareItemsArr addObject:allPosterModel];
    
    MGCShareItemModel *faceBookModel = [[MGCShareItemModel alloc] init];
    faceBookModel.itemName = @"FaceBook";
    faceBookModel.itemType = MGCShareSavePosterToFacebookType;
    faceBookModel.itemImage = @"00262_ Facebook Fill";
    [self.shareItemsArr addObject:faceBookModel];

    
    NSString *url = [NSString stringWithFormat:@"whatsapp://"];
    NSURL *whatsappURL = [NSURL URLWithString: url];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        MGCShareItemModel *whatsAppModel = [[MGCShareItemModel alloc] init];
        whatsAppModel.itemName = @"WhatsApp";
        whatsAppModel.itemType = MGCShareWhatsAppType;
        whatsAppModel.itemImage = @"00266_ Wx Fill";
        [self.shareItemsArr addObject:whatsAppModel];
    }
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        MGCShareItemModel *twitterModel = [[MGCShareItemModel alloc] init];
//        twitterModel.itemName = @"Twitter";
//        twitterModel.itemType = MGCShareTwitterType;
//        twitterModel.itemImage = @"00263_ Twitter Fill";
//        [self.shareItemsArr addObject:twitterModel];
//    }
    
    
    
    
    [self.shareCollectionView reloadData];
}
- (void)preparePosterView
{
    _posterView = [[NSBundle mainBundle] loadNibNamed:@"PosterView" owner:self options:nil].firstObject;
    _posterView.frame = CGRectMake(70, 50, MainScreen_width-140, 427);
    _posterView.productModel = self.productModel;
    _posterView.posterModelArr = self.posterModelArr;
    [self addSubview:_posterView];
}

- (void)prepareCollection {
    CGFloat bgHeight = 145;
    CGFloat oneToolHeight = 121+100;
    CGFloat btnHeitght = 16+40;
    if (IS_IPHONE_X) {
        bgHeight = 145+iPhoneXBottomOffset;
        oneToolHeight = 113+100+iPhoneXBottomOffset;
        btnHeitght = 16+40+iPhoneXBottomOffset;
    }
    _bgView.frame = CGRectMake(0, self.height - oneToolHeight, self.width, oneToolHeight);
    _titleLabel.frame = CGRectMake(15, 14, self.width, 21);
    _lineView.frame = CGRectMake(15, self.titleLabel.bottom + 13, self.width-30, 1);
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
    if (itemModel.itemType == MGCShareSavePosterType) {
        UIImage *img = [self convertViewToImage:self.posterView];
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        [self cancelBtnAction];
        return;
    }else if (itemModel.itemType == MGCShareSavePosterToFacebookType){
        if (self.successBlock) {
            UIImage *img = [self convertViewToImage:self.posterView];
            self.successBlock(@{@"image":img}, itemModel.itemType);
        }
        [self cancelBtnAction];
        return;
    }
    if (self.successBlock) {
        self.successBlock(@{}, itemModel.itemType);
    }
    [self cancelBtnAction];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (error) {
        
    }   else {
        [MBProgressHUD autoDismissShowHudMsg:@"save success!"];
    }
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
- (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
    
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
    
    CGFloat height = 145;
    CGFloat oneToolHeight = 113+100;
    if (IS_IPHONE_X) {
        height = 145+iPhoneXBottomOffset;
        oneToolHeight = 113+100+iPhoneXBottomOffset;
    }
    CGFloat viewHeight = oneToolHeight;
    
    self.alpha = 0;
    self.maskView.alpha = 0;
    self.bgView.frame = CGRectMake(0, self.height, self.width, height);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.bgView.frame = CGRectMake(0, self.height - height, self.width, height);
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
    CGFloat height = 145;
    CGFloat oneToolHeight = 113+100;
    if (IS_IPHONE_X) {
        height = 145+iPhoneXBottomOffset;
        oneToolHeight = 113+100+iPhoneXBottomOffset;
    }
    CGFloat viewHeight = oneToolHeight;
    self.bgView.frame = CGRectMake(0, self.height - viewHeight, self.width, viewHeight);
}

#pragma mark - setter && getter


- (UIView *)bgView {
    if (!_bgView) {
        CGFloat height = 145;
        if (IS_IPHONE_X) {
            height = 145+iPhoneXBottomOffset;
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
        _titleLabel.font = kFontBlod(15);
        _titleLabel.text = kLocalizedString(@"Share_to");
        _titleLabel.textColor = [UIColor blackColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, self.titleLabel.bottom + 13, self.width-30, 0.5)];
        _lineView.backgroundColor = [UIColor jk_colorWithHexString:@"#eeeeee"];
    }
    return _lineView;
}
- (UICollectionView *)shareCollectionView {
    if (!_shareCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = (App_Frame_Width - 50 - 70*4)/3.0;
        flowLayout.itemSize = CGSizeMake(70, 60);
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
        _cancelBtn.titleLabel.font = kFontRegular(15);
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
