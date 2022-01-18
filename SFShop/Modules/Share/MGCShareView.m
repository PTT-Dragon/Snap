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
//当前分享的行数
@property (nonatomic, assign) MGCShareViewType shareViewType;

@property (nonatomic, assign) CGFloat lastTransitionY;

@end

@implementation MGCShareView

//五个三方分享带自定义工具栏
+ (MGCShareView *)showWithShareInfoModel:(MGCShareInfoModel *)infoModel
                       functionItemsArr:(NSMutableArray <MGCShareItemModel *> *)functionItemsArr
                                superView:(UIView *)superView
                             successBlock:(void (^)(NSDictionary *info, MGCShareItemType type))successBlock
                                failBlock:(void (^)(NSDictionary *info, MGCShareItemType type))failBlock
                                completed:(void (^)(BOOL isShow))completed{
    MGCShareView *shareView = [[MGCShareView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    shareView.shareInfoModel = infoModel;
    if (infoModel.isSharePic == YES) {
        shareView.contentType = @"Image";
    }
    [shareView prepareDefaultShareItem];
    [shareView prepareFunctionItemsWithItemsArr:functionItemsArr];
    if (functionItemsArr.count > 0) {
        [shareView prepareCollectionWithViewType:MGCShareViewTypeNormal];
    }else{
        [shareView prepareCollectionWithViewType:MGCShareViewTypeOnlyShare];
    }
    [shareView prepareShowBigShareImage];
    shareView.successBlock = successBlock;
    shareView.failBlock = failBlock;

    if (completed) {
        completed(YES);
    }
    [shareView showWithView:superView];
    return shareView;
}

+ (MGCShareView *)showWithFunctionItemsArr:(NSMutableArray <MGCShareItemModel *> *)functionItemsArr
                                 superView:(UIView *)superView
                              successBlock:(void (^)(NSDictionary *info, MGCShareItemType type))successBlock
                                 failBlock:(void (^)(NSDictionary *info, MGCShareItemType type))failBlock
                                 completed:(void (^)(BOOL isShow))completed{
    MGCShareView *shareView = [[MGCShareView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [shareView prepareFunctionItemsWithItemsArr:functionItemsArr];
    if (functionItemsArr.count > 0) {
        [shareView prepareCollectionWithViewType:MGCShareViewTypeOnlyTool];
    }else{
        //等UI图
    }
    shareView.successBlock = successBlock;
    shareView.failBlock = failBlock;
    if (completed) {
        completed(YES);
    }
    [shareView showWithView:superView];
    return shareView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initGesture];
    }
    return self;
}

#pragma mark - init

- (void)initView{
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.shareCollectionView];
    [self.bgView addSubview:self.functionCollectionView];
    [self.bgView addSubview:self.cancelBtn];
}


- (void)initGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.bgView addGestureRecognizer:pan];
}

#pragma mark - initData

- (void)prepareFunctionItemsWithItemsArr:(NSMutableArray *)itemsArr{
    [self.functionItemsArr removeAllObjects];
    [self.functionItemsArr addObjectsFromArray:itemsArr];
    [self.functionCollectionView reloadData];
}

//默认分享配置方法
- (void)prepareDefaultShareItem{
    
    [self.shareItemsArr removeAllObjects];
    
    MGCShareItemModel *wechatFriendModel = [[MGCShareItemModel alloc] init];
    wechatFriendModel.itemName = @"微信好友";
    wechatFriendModel.itemType = MGCShareItemTypeWeChatFriend;
    //qq和微信在分享帖子的时候是走小程序的 (不走小程序)
//    if (type == MGCShareScenesTypeCpost || type == MGCShareScenesTypeToMiniProgram) {
//        wechatFriendModel.itemType = MGCShareItemTypeWeChatFriendMini;
//    }
    wechatFriendModel.itemImage = @"ic_share_weixin";
    
    MGCShareItemModel *wechatCircleModel = [[MGCShareItemModel alloc] init];
    wechatCircleModel.itemName = @"朋友圈";
    wechatCircleModel.itemType = MGCShareItemTypeWeChatTimeline;
    wechatCircleModel.itemImage = @"ic_share_pengyouquan";
    
    MGCShareItemModel *qqModel = [[MGCShareItemModel alloc] init];
    qqModel.itemName = @"QQ";
    qqModel.itemType = MGCShareItemTypeQQFriend;
//    (不走小程序)
//    if (type == MGCShareScenesTypeCpost || type == MGCShareScenesTypeToMiniProgram) {
//        qqModel.itemType = MGCShareItemTypeQQFriendMini;
//    }
    qqModel.itemImage = @"ic_share_qq";
    
    
    MGCShareItemModel *qZoneModel = [[MGCShareItemModel alloc] init];
    qZoneModel.itemName = @"QQ空间";
    qZoneModel.itemType = MGCShareItemTypeQZone;
    qZoneModel.itemImage = @"ic_share_kongjian";
    
    MGCShareItemModel *weiboModel = [[MGCShareItemModel alloc] init];
    weiboModel.itemName = @"微博";
    weiboModel.itemType = MGCShareItemTypeWeibo;
    weiboModel.itemImage = @"ic_share_weibo";

    
    
    [self.shareItemsArr addObject:wechatFriendModel];
    [self.shareItemsArr addObject:wechatCircleModel];
    [self.shareItemsArr addObject:qqModel];
    [self.shareItemsArr addObject:qZoneModel];
    [self.shareItemsArr addObject:weiboModel];

    [self.shareCollectionView reloadData];
}

- (void)prepareCollectionWithViewType:(MGCShareViewType)type{
    self.shareViewType = type;
    
//    CGFloat bgHeight = 145+AutoNum(160);
//    CGFloat oneToolHeight = 121+AutoNum(100);
//    CGFloat btnHeitght = 16+AutoNum(40);
//
//    if (iPhoneX) {
//        bgHeight = 145+AutoNum(160)+iPhoneXBottomOffset;
//        oneToolHeight = 113+AutoNum(100)+iPhoneXBottomOffset;
//        btnHeitght = 16+AutoNum(40)+iPhoneXBottomOffset;
//    }
//    if (type == MGCShareViewTypeNormal) {
//        _bgView.frame = CGRectMake(0, self.height - bgHeight, self.width, bgHeight);
//        _titleLabel.frame = CGRectMake(0, 14, self.width, 21);
//        _lineView.frame = CGRectMake(0, self.titleLabel.bottom + 13, self.width, 1);
//        _shareCollectionView.frame = CGRectMake(0, self.lineView.bottom + 24, self.width, AutoNum(60));
//        _functionCollectionView.frame = CGRectMake(0, self.shareCollectionView.bottom + 32, self.width, AutoNum(60));
//        _cancelBtn.frame = CGRectMake(15, self.bgView.height - btnHeitght, self.width - 30, AutoNum(40));
//        _functionCollectionView.hidden = NO;
//        _shareCollectionView.hidden = NO;
//    }else if (type == MGCShareViewTypeOnlyShare){
//        _bgView.frame = CGRectMake(0, self.height - oneToolHeight, self.width, oneToolHeight);
//        _titleLabel.frame = CGRectMake(0, 14, self.width, 21);
//        _lineView.frame = CGRectMake(0, self.titleLabel.bottom + 13, self.width, 1);
//        _shareCollectionView.frame = CGRectMake(0, self.lineView.bottom + 24, self.width, AutoNum(60));
//        _cancelBtn.frame = CGRectMake(15, self.bgView.height - btnHeitght, self.width - 30, AutoNum(40));
//        _functionCollectionView.hidden = YES;
//        _shareCollectionView.hidden = NO;
//    }else if (type == MGCShareViewTypeOnlyTool){
//        _bgView.frame = CGRectMake(0, self.height - oneToolHeight, self.width, oneToolHeight);
//        _titleLabel.frame = CGRectMake(0, 14, self.width, 21);
//        _lineView.frame = CGRectMake(0, self.titleLabel.bottom + 13, self.width, 1);
//        _functionCollectionView.frame = CGRectMake(0, self.lineView.bottom + 24, self.width, AutoNum(60));
//        _cancelBtn.frame = CGRectMake(15, self.bgView.height - btnHeitght, self.width - 30, AutoNum(40));
//        _shareCollectionView.hidden = YES;
//        _functionCollectionView.hidden = NO;
//    }
//    [self.functionCollectionView reloadData];
//    [self.shareCollectionView reloadData];
}

- (void)prepareShowBigShareImage{
    if (self.shareInfoModel.isSharePic == YES && self.shareInfoModel.isSharePersonQRCode == NO) {
        [self addSubview:self.shareImgaeView];
        [self.shareImgaeView addSubview:self.bigShareImageView];
        self.bigShareImageView.image = self.shareInfoModel.shareImage;
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.shareCollectionView]) {
        return self.shareItemsArr.count;
    }else{
        return self.functionItemsArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.shareCollectionView]) {
        MGCShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MGCShareCollectionViewCell" forIndexPath:indexPath];
        MGCShareItemModel *itemModel = [self.shareItemsArr objectAtIndex:indexPath.item];
        [cell configDataWithItemModel:itemModel];
        return cell;
    }else{
        MGCShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MGCShareCollectionViewCell" forIndexPath:indexPath];
        MGCShareItemModel *itemModel = [self.functionItemsArr objectAtIndex:indexPath.item];
        [cell configDataWithItemModel:itemModel];
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.shareCollectionView]) {
        MGCShareItemModel *itemModel = [self.shareItemsArr objectAtIndex:indexPath.item];
//        [[MGCShareManager sharedInstance] share:itemModel.itemType shareTitle:[NSString replaceNull:self.shareInfoModel.shareTitle] shareText:[NSString replaceNull:self.shareInfoModel.shareText] shareLabel:[NSString replaceNull:self.shareInfoModel.shareLabel] weiboShareText:[NSString replaceNull:self.shareInfoModel.weiboShareText] shareLinkUrl:[NSString replaceNull:self.shareInfoModel.shareLinkUrl] shareIconUrl:[NSString replaceNull:self.shareInfoModel.shareIconUrl] contentType:self.contentType shareImage:self.shareInfoModel.shareImage successBlock:self.successBlock failBlock:self.failBlock];
    }else{
        MGCShareItemModel *itemModel = [self.functionItemsArr objectAtIndex:indexPath.item];
        if (self.successBlock) {
            self.successBlock(@{@"msg":@"成功"}, itemModel.itemType);
        }
    }
    [self cancelBtnAction];
}
#pragma makr - btnAction

- (void)cancelBtnAction{

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

- (void)showWithView:(UIView *)superView{
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
    
//    CGFloat height = 145+AutoNum(160);
//    CGFloat oneToolHeight = 113+AutoNum(100);
//    if (iPhoneX) {
//        height = 145+AutoNum(160)+iPhoneXBottomOffset;
//        oneToolHeight = 113+AutoNum(100)+iPhoneXBottomOffset;
//    }
//    CGFloat viewHeight = 0;
//    if (self.shareViewType == MGCShareViewTypeNormal) {
//        viewHeight = height;
//    }else{
//        viewHeight = oneToolHeight;
//    }
//
//    self.alpha = 0;
//    self.maskView.alpha = 0;
//    self.bgView.frame = CGRectMake(0, self.height, self.width, viewHeight);
//    [UIView animateWithDuration:0.25 animations:^{
//        self.alpha = 1;
//        self.bgView.frame = CGRectMake(0, self.height - viewHeight, self.width, viewHeight);
//        self.maskView.alpha = 1;
//    } completion:^(BOOL finished) {
//
//    }];
}


- (void)panAction:(UIPanGestureRecognizer *)sender{
//    CGPoint translationPoint = [sender translationInView:self.bgView];
//
//    CGFloat shareHeight = self.bgView.frame.size.height;
//    CGRect newFrame = CGRectMake(0, kScreenHeight - shareHeight, kScreenWidth, shareHeight);
//    newFrame.origin.y =  kScreenHeight - shareHeight + translationPoint.y;
//
//    if (newFrame.origin.y <= kScreenHeight - shareHeight) {
//        newFrame.origin.y = kScreenHeight - shareHeight;
//    }
//
//    self.bgView.frame = newFrame;
//
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        CGPoint velocity = [sender velocityInView:self.bgView];
//        // 结束时的速度>0 滑动距离> 5 且UIScrollView滑动到最顶部
//        if (velocity.y > 0 && self.lastTransitionY > 100 || shareHeight < 150) {
//            [self removeFromSuperview];
//        }else {
//            [self reSetbgFrame];
//        }
//    }
//    self.lastTransitionY = translationPoint.y;

}

- (void)reSetbgFrame{
//    CGFloat height = 145+AutoNum(160);
//    CGFloat oneToolHeight = 113+AutoNum(100);
//    if (iPhoneX) {
//        height = 145+AutoNum(160)+iPhoneXBottomOffset;
//        oneToolHeight = 113+AutoNum(100)+iPhoneXBottomOffset;
//    }
//    CGFloat viewHeight = 0;
//    if (self.shareViewType == MGCShareViewTypeNormal) {
//        viewHeight = height;
//    }else{
//        viewHeight = oneToolHeight;
//    }
//    self.bgView.frame = CGRectMake(0, self.height - viewHeight, self.width, viewHeight);
}

#pragma mark - setter && getter


- (UIView *)bgView{
    if (!_bgView) {
//        CGFloat height = 145+AutoNum(160);
//        if (iPhoneX) {
//            height = 145+AutoNum(160)+iPhoneXBottomOffset;
//        }
//        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - height, self.width, height)];
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 0)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = _bgView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        _bgView.layer.mask = maskLayer;
//        _bgView.backgroundColor = [UIColor mgcBackgroundColor1];
    }
    return _bgView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnAction)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, self.width, 21)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.text = @"分享到";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom + 13, self.width, 1)];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}
- (UICollectionView *)shareCollectionView{
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

- (UICollectionView *)functionCollectionView{
    if (!_functionCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = 32;
        flowLayout.itemSize = CGSizeMake(50, 60);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
        _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.shareCollectionView.bottom + 32, self.width, 60) collectionViewLayout:flowLayout];
        _functionCollectionView.backgroundColor = [UIColor clearColor];
        _functionCollectionView.delegate = self;
        _functionCollectionView.dataSource = self;
        _functionCollectionView.scrollEnabled = YES;
        _functionCollectionView.showsHorizontalScrollIndicator = NO;
        [_functionCollectionView registerClass:[MGCShareCollectionViewCell class] forCellWithReuseIdentifier:@"MGCShareCollectionViewCell"];
    }
    return _functionCollectionView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
//        CGFloat height = 16+AutoNum(40);
//        if (iPhoneX) {
//            height = 16+AutoNum(40)+iPhoneXBottomOffset;
//        }
//        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.bgView.height - height, self.width - 30, AutoNum(40))];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:[UIColor mgcSubWordColor] forState:UIControlStateNormal];
//        _cancelBtn.titleLabel.font = [UIFont regularFontOfSize:15];
//        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_cancelBtn setBackgroundColor:[UIColor mgcAuxiliaryMatchColor3]];
//        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        _cancelBtn.layer.cornerRadius = AutoNum(20);
//        _cancelBtn.layer.masksToBounds = YES;
    }
    return _cancelBtn;
}


- (UIView *)shareImgaeView{
    if (!_shareImgaeView) {
        _shareImgaeView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 280)/2, 47, 280, 374)];
        _shareImgaeView.backgroundColor = [UIColor clearColor];
        _shareImgaeView.layer.cornerRadius = 4.0f;
        _shareImgaeView.layer.masksToBounds = YES;
    }
    return _shareImgaeView;
}

- (UIImageView *)bigShareImageView{
    if (!_bigShareImageView) {
        _bigShareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 374)];
        _bigShareImageView.backgroundColor = [UIColor clearColor];
    }
    return _bigShareImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shareImgaeView.width - 9 - 142, self.shareImgaeView.height - 64, 142, 17)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nameLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shareImgaeView.width - 9 - 126, self.shareImgaeView.height - 45, 126, 15)];
        _desLabel.textColor = [UIColor blackColor];
        _desLabel.font = [UIFont systemFontOfSize:10];
        _desLabel.textAlignment = NSTextAlignmentRight;
    }
    return _desLabel;
}

- (UIImageView *)QRCodeImageView{
    if (!_QRCodeImageView) {
        _QRCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, self.shareImgaeView.height - 5 - 33, 33, 33)];
    }
    return _QRCodeImageView;
}

- (UILabel *)codeDesLabel{
    if (!_codeDesLabel) {
        _codeDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.QRCodeImageView.right + 3, self.shareImgaeView.height - 11 - 15, 80, 11)];
        _codeDesLabel.textColor = [UIColor blackColor];
        _codeDesLabel.font = [UIFont systemFontOfSize:7];
        _codeDesLabel.text = @"长按图片识别二维码";
    }
    return _codeDesLabel;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.shareImgaeView.width - 9 - 39, self.shareImgaeView.height - 12 - 11, 39, 11)];
        _logoImageView.image = [UIImage imageNamed:@"ic_h5_migulogo"];
    }
    return _logoImageView;
}

- (NSMutableArray *)shareItemsArr{
    if (!_shareItemsArr) {
        _shareItemsArr = [NSMutableArray array];
    }
    return _shareItemsArr;
}
- (NSMutableArray *)functionItemsArr{
    if (!_functionItemsArr) {
        _functionItemsArr = [NSMutableArray array];
    }
    return _functionItemsArr;
}

- (MGCShareInfoModel *)shareInfoModel{
    if (!_shareInfoModel) {
        _shareInfoModel = [[MGCShareInfoModel alloc] init];
    }
    return _shareInfoModel;
}

+ (MGCShareItemModel *)reportFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"举报";
    functionModel.itemType = MGCShareItemTypeReport;
    functionModel.itemImage = @"ic_share_report";
    return functionModel;
}

+ (MGCShareItemModel *)copyLinkFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"复制链接";
    functionModel.itemType = MGCShareItemTypeCopyUrl;
    functionModel.itemImage = @"ic_share_like";
    return functionModel;
}

+ (MGCShareItemModel *)unlikeFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"不感兴趣";
    functionModel.itemType = MGCShareItemTypeUnLike;
    functionModel.itemImage = @"ic_share_dislike";
    return functionModel;
}

+ (MGCShareItemModel *)collectFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"收藏";
    functionModel.itemType = MGCShareItemTypeCollect;
    functionModel.itemImage = @"ic_share_collect";
    return functionModel;
}

+ (MGCShareItemModel *)haveCollectFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"已收藏";
    functionModel.itemType = MGCShareItemTypeHaveCollect;
    functionModel.itemImage = @"ic_share_discollect";
    return functionModel;
}

+ (MGCShareItemModel *)refreshFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"刷新";
    functionModel.itemType = MGCShareItemTypeRefresh;
    functionModel.itemImage = @"ic_share_refresh";
    return functionModel;
}

+ (MGCShareItemModel *)deleteFunctionItem {
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"删除";
    functionModel.itemType = MGCShareItemTypeDelete;
    functionModel.itemImage = @"ic_share_delete@2x";
    return functionModel;
}

+ (MGCShareItemModel *)authoritySettingFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"权限设置";
    functionModel.itemType = MGCShareItemTypeAuthoritySetting;
    functionModel.itemImage = @"ic_share_secret";
    return functionModel;
}
+ (MGCShareItemModel *)moveDeleteFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"移除";
    functionModel.itemType = MGCShareItemTypeMoveDelete;
    functionModel.itemImage = @"";
    return functionModel;
}
+ (MGCShareItemModel *)CRBTManagerFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"彩铃管理";
    functionModel.itemType = MGCShareItemTypeCRBTManager;
    functionModel.itemImage = @"";
    return functionModel;
}
+ (MGCShareItemModel *)useCommonSensFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"使用小常识";
    functionModel.itemType = MGCShareItemTypeUseCommonSense;
    functionModel.itemImage = @"";
    return functionModel;
}
+ (MGCShareItemModel *)SharePicFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"生成海报";
    functionModel.itemType = MGCShareItemTypeSharePic;
    functionModel.itemImage = @"";
    return functionModel;
}
+ (MGCShareItemModel *)TemplateFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"魔性小视频";
    functionModel.itemType = MGCShareItemTypeTemplate;
    functionModel.itemImage = @"";
    return functionModel;
}
+ (MGCShareItemModel *)colorPrintFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"设为彩印";
    functionModel.itemType = MGCShareItemTypeColorPrint;
    functionModel.itemImage = @"";
    return functionModel;
}
+ (MGCShareItemModel *)transferStorageFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"转存和彩云";
    functionModel.itemType = MGCShareItemTypeTransferStorage;
    functionModel.itemImage = @"ic_share_yun";
    return functionModel;
}

+ (MGCShareItemModel *)conentDissatisfiedFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"内容太水";
    functionModel.itemType = MGCShareItemTypeConentDissatisfied;
    functionModel.itemImage = @"";
    return functionModel;
}
+ (MGCShareItemModel *)disConentDissatisfiedFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"内容太水";
    functionModel.itemType = MGCShareItemTypeDisConentDissatisfied;
    functionModel.itemImage = @"";
    return functionModel;
}
+ (MGCShareItemModel *)ringManagerFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"彩铃管理";
    functionModel.itemType = MGCShareItemTypeCRBTManager;
    functionModel.itemImage = @"ic_videorbt_management";
    return functionModel;
}
+ (MGCShareItemModel *)shootFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"拍同款";
    functionModel.itemType = MGCShareItemTypeShoot;
    functionModel.itemImage = @"";
    return functionModel;
}

+ (MGCShareItemModel *)dowmloadFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"保存本地";
    functionModel.itemType = MGCShareItemTypeDownLoad;
    functionModel.itemImage = @"ic_share_download";
    return functionModel;
}

+ (MGCShareItemModel *)openSafariFunctionItem{
    MGCShareItemModel *functionModel = [[MGCShareItemModel alloc] init];
    functionModel.itemName = @"打开Safari";
    functionModel.itemType = MGCShareItemTypeOpenSafari;
    functionModel.itemImage = @"ic_share_browser";
    return functionModel;
}


@end
