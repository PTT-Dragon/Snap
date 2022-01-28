//
//  CommunityDetailController.m
//  SFShop
//
//  Created by Jacue on 2021/9/25.
//

#import "CommunityDetailController.h"
#import "ArticleDetailModel.h"
#import "ArticleEvaluateModel.h"
#import <iCarousel/iCarousel.h>
#import "ArticleProductCell.h"
#import "ProductViewController.h"
#import <WebKit/WebKit.h>
#import "MakeH5Happy.h"
#import "CommunityEvaluateCell.h"
#import "ArticleEvaluateBottomCell.h"
//#import <SJVideoPlayer/SJVideoPlayer.h>
#import "BaseNavView.h"
#import "BaseMoreView.h"
#import "SRXGoodsImageDetailView.h"
#import "JPVideoPlayerManager.h"
#import "NSDate+Helper.h"

@interface CommunityDetailController () <iCarouselDelegate, iCarouselDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BaseNavViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;

@property(nonatomic, strong) ArticleDetailModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluateTableViewHei;
@property(nonatomic, strong) NSArray<ArticleEvaluateModel *> *evaluateArray;
@property (weak, nonatomic) IBOutlet UITableView *evaluateTableView;
@property (weak, nonatomic) IBOutlet UITextField *replyField;
@property(nonatomic, strong) UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet iCarousel *articlePictures;
@property (weak, nonatomic) IBOutlet UILabel *viewCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *usefulCntLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCntLabel;
@property (weak, nonatomic) IBOutlet UIView *productContainer;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (nonatomic, strong) WKWebView *detailWebView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollview;
@property (nonatomic,strong) ArticleEvaluateModel *selEvaluateModel;//回复
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;
@property (strong, nonatomic) SRXGoodsImageDetailView *pictureScrollView;


@end

@implementation CommunityDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([JPVideoPlayerManager sharedManager].videoPlayer.playerStatus==JPVideoPlayerStatusPlaying) {
        [[JPVideoPlayerManager sharedManager] pause];
    }
}

- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView {
    [_moreView removeFromSuperview];
    _moreView = [[BaseMoreView alloc] init];
    [self.view addSubview:_moreView];
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    _viewTop.constant = navBarHei;
    [self setUpSubViews];
    [self request];
    [self.replyField addTarget:self
                        action:@selector(textFieldChanged:)
              forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)shouldCheckLoggedIn {
    return NO;
}

- (void)dealloc {
    @try {
        [self.detailWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        NSLog(@"可能多次释放，避免crash");
    }
    [[JPVideoPlayerManager sharedManager] stopPlay];

}

- (void)setUpSubViews {
    _articlePictures.type = iCarouselTypeLinear;
    _articlePictures.bounces = NO;
    _articlePictures.pagingEnabled = YES;
    _replyField.placeholder = kLocalizedString(@"ADD_COMMENT");
    
    //    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"share"] style: UIBarButtonItemStylePlain target: self action:@selector(shareBtn:)];
    //    _headIV = [[UIImageView alloc] init];
    //    // 防止拉伸
    //    [[[_headIV widthAnchor] constraintEqualToConstant:32] setActive: YES];
    //    [[[_headIV heightAnchor] constraintEqualToConstant:32] setActive: YES];
    //    UIBarButtonItem *headItem = [[UIBarButtonItem alloc] initWithCustomView: _headIV];
    //    self.navigationItem.rightBarButtonItems = @[shareItem, headItem];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.detailWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.detailWebView.scrollView.scrollEnabled = NO;
    [self.detailWebView.scrollView addObserver:self forKeyPath:@"contentSize" options: NSKeyValueObservingOptionNew context:nil];
    [self.scrollContentView addSubview:self.detailWebView];
    [self.detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewCntLabel.mas_bottom).offset(28);
        make.left.equalTo(self.scrollContentView).offset(16);
        make.right.equalTo(self.scrollContentView).offset(-16);
        make.height.mas_equalTo(50);
    }];
    self.evaluateTableView.scrollEnabled = NO;
    [self.evaluateTableView registerClass:[CommunityEvaluateCell class] forCellReuseIdentifier:@"CommunityEvaluateCell"];
    [self.evaluateTableView registerNib:[UINib nibWithNibName:@"ArticleEvaluateBottomCell" bundle:nil] forCellReuseIdentifier:@"ArticleEvaluateBottomCell"];
}

- (void)shareBtn:(UIButton *)sender {
    
}

- (void)request {
    [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
    [self requestArticleDetail];
    [self requestArticleEvaluate];
}

/// 文章详情接口
- (void)requestArticleDetail {
    [SFNetworkManager get: [SFNet.article getDetailOf: _articleId] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSError *error;
        self.model = [[ArticleDetailModel alloc] initWithDictionary: response error: &error];
        NSLog(@"get article detail success");
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
        NSLog(@"get article detail failed");
    }];
}

/// 评论列表接口
- (void)requestArticleEvaluate {
    [SFNetworkManager get: [SFNet.article getEvaluateOf: _articleId] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSError *error;
        self.evaluateArray = [ArticleEvaluateModel arrayOfModelsFromDictionaries:response error:&error];
        //        self.evaluateArray = [[arr reverseObjectEnumerator] allObjects];
        self.evaluateTableViewHei.constant = [self calculateTableViewHei];
        [self.evaluateTableView reloadData];
        NSLog(@"get article evaluate success");
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
        NSLog(@"get article evaluate failed");
    }];
}

- (void)setModel:(ArticleDetailModel *)model {
    _model = model;
    self.title = self.model.publisherName;
    [_headIV sd_setImageWithURL: [NSURL URLWithString: SFImage(self.model.profilePicture)]];
    [self.detailWebView loadHTMLString: [MakeH5Happy replaceHtmlSourceOfRelativeImageSource: self.model.articleDetail] baseURL:nil];
    self.viewCntLabel.text = [NSString stringWithFormat:@"%ld", self.model.viewCnt];
    self.usefulCntLabel.text = [NSString stringWithFormat:@"%ld", self.model.usefulCnt];
    self.replyCntLabel.text = [NSString stringWithFormat:@"%ld", self.model.replyCnt];
    self.createDateLabel.text = [[NSDate dateFromString:self.model.createdDate] dayMonthYear];
    self.likeBtn.selected = [model.isUseful isEqualToString:@"Y"];
    
    if (self.model.products.count > 0) {
        [self.productContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.productContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(135 * self.model.products.count);
        }];
        MPWeakSelf(self)
        [self.model.products enumerateObjectsUsingBlock:^(ArticleProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ArticleProductCell *productCell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleProductCell" owner:nil options:nil] lastObject];
            [productCell setModel: obj];
            [productCell setBuyBlock:^(ArticleProduct *productInfo) {
                ProductViewController *productVC = [[ProductViewController alloc] init];
                productVC.offerId = productInfo.offerId;
                productVC.productId = productInfo.productId;
                [weakself.navigationController pushViewController:productVC animated:YES];
            }];
            [weakself.productContainer addSubview: productCell];
            [productCell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(130);
                make.top.equalTo(weakself.productContainer).offset(135 * idx);
                make.left.right.equalTo(weakself.productContainer);
            }];
            
        }];
    }
    [self.articlePictures reloadData];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.detailWebView.scrollView && [keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = self.detailWebView.scrollView.contentSize.height;
        [self.detailWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewCntLabel.mas_bottom).offset(28);
            make.left.equalTo(self.scrollContentView).offset(16);
            make.right.equalTo(self.scrollContentView).offset(-16);
            make.height.mas_equalTo(height);
            make.bottom.equalTo(self.productContainer.mas_top).offset(-20);
        }];
    }
}
- (IBAction)likeAction:(UIButton *)sender {
    [MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager post:[SFNet.article likeArticlesOf:self.articleId] parameters:@{@"action":[self.model.isUseful isEqualToString:@"Y"] ? @"C": @"A"} success:^(id  _Nullable response) {
        if (sender.selected) {
            weakself.model.usefulCnt = weakself.model.usefulCnt-1;
            weakself.model.isUseful = @"N";
        }else{
            weakself.model.usefulCnt = weakself.model.usefulCnt+1;
            weakself.model.isUseful = @"Y";
        }
        [weakself setModel:weakself.model];
        [MBProgressHUD hideFromKeyWindow];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)sendAction:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_selEvaluateModel) {
        [params setValue:_selEvaluateModel.model.articleEvalId forKey:@"articleEvalId"];
    }
    [params setValue:_replyField.text forKey:@"evalComments"];
    [MBProgressHUD showHudMsg:@"Send..."];
    MPWeakSelf(self)
    [SFNetworkManager post:[SFNet.article addEvaluatelOf:self.articleId] parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        [weakself.replyField resignFirstResponder];
        weakself.replyField.text = @"";
        [weakself requestArticleEvaluate];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
    }];
}

#pragma mark - tableview.delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.evaluateArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ArticleEvaluateModel *model = self.evaluateArray[section];
    return model.showAll ? model.children.count+2: (model.children.count>0 ? 1:0) +1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleEvaluateModel *model = self.evaluateArray[indexPath.section];
    if (indexPath.row == 0) {
        CommunityEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityEvaluateCell"];
        cell.model = model.model;
        cell.type = 1;
        return cell;
    }
    if (model.showAll) {
        if (indexPath.row == model.children.count+1) {
            ArticleEvaluateBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleEvaluateBottomCell"];
            [cell setContent:model.children.count showAll:model.showAll];
            return cell;
        }
        CommunityEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityEvaluateCell"];
        cell.model = model.children[indexPath.row-1].model;
        cell.type = 2;
        return cell;
    }
    ArticleEvaluateBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleEvaluateBottomCell"];
    [cell setContent:model.children.count showAll:model.showAll];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleEvaluateModel *model = self.evaluateArray[indexPath.section];
    if (indexPath.row == 0) {
        return [model.model.evalComments calHeightWithFont:CHINESE_SYSTEM(12) lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width-66, MAXFLOAT)]+39;
    }
    if (model.showAll) {
        if (indexPath.row == model.children.count+1) {
            return 32;
        }
        return [[model.children[indexPath.row-1].model evalComments] calHeightWithFont:CHINESE_SYSTEM(12) lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width-94, MAXFLOAT)]+39;
    }
    return 32;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        _selEvaluateModel = self.evaluateArray[indexPath.section];
        [self.replyField becomeFirstResponder];
        return;
    }
    ArticleEvaluateModel *model = self.evaluateArray[indexPath.section];
    if (model.showAll) {
        if (indexPath.row == model.children.count+1) {
            model.showAll = NO;
            [self.evaluateTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            //            [self.replyField becomeFirstResponder];
        }
    }else{
        model.showAll = YES;
        [self.evaluateTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (CGFloat)calculateTableViewHei
{
    __block CGFloat hei = 0;
    [self.evaluateArray enumerateObjectsUsingBlock:^(ArticleEvaluateModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        hei += ([obj.model.evalComments calHeightWithFont:CHINESE_SYSTEM(12) lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width-66, MAXFLOAT)]+39);
        if (obj.showAll) {
            [obj.children enumerateObjectsUsingBlock:^(ArticleEvaluateModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                hei += ([obj.model.evalComments calHeightWithFont:CHINESE_SYSTEM(12) lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width-66, MAXFLOAT)]+39);
            }];
        }
        if (obj.children.count > 0) {
            hei += 32;
        }
    }];
    return hei;
}

#pragma mark - textfiled.delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _selEvaluateModel = nil;
}

- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.length > 500) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 500)];
    }
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _model.articlePictures.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    //    ArticleImageModel *imgModel = self.model.imgs[index];
    //    if ([imgModel.type isEqual:@"C"]) {
    //        SJVideoPlayerURLAsset *asset = [SJVideoPlayerURLAsset.alloc initWithURL: [NSURL URLWithString: SFImage(self.model.imgs[index].url)] startPosition:10];
    //        SJVideoPlayer *player = SJVideoPlayer.player;
    //        player.URLAsset = asset;
    //        return player.view;
    //    }
//    UIImageView *iv = nil;
//    if (view == nil) {
//        iv = [[UIImageView alloc] initWithFrame:carousel.bounds];
//        iv.contentMode = UIViewContentModeScaleAspectFit;
//    } else {
//        iv = (UIImageView *)view;
//    }
//    [iv sd_setImageWithURL: [NSURL URLWithString: SFImage(self.model.articlePictures[index])]];
//    return iv;
    
    self.pictureScrollView = [[SRXGoodsImageDetailView alloc] initWithFrame:carousel.bounds];    
    [self.pictureScrollView.shufflingArray removeAllObjects];
    
    [self.pictureScrollView.shufflingArray addObjectsFromArray:self.model.imgs];
    [self.pictureScrollView updateView];

    return self.pictureScrollView;
}

@end
