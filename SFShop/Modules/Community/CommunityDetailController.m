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
//#import <SJVideoPlayer/SJVideoPlayer.h>

@interface CommunityDetailController () <iCarouselDelegate, iCarouselDataSource,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) ArticleDetailModel *model;
@property(nonatomic, strong) NSMutableArray<ArticleEvaluateModel *> *evaluateArray;
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

@end

@implementation CommunityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpSubViews];
    [self request];
}

- (BOOL)shouldCheckLoggedIn {
    return YES;
}

- (void)dealloc {
    @try {
        [self.detailWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        NSLog(@"可能多次释放，避免crash");
    }
}

- (void)setUpSubViews {
    _articlePictures.type = iCarouselTypeLinear;
    _articlePictures.bounces = NO;
    _articlePictures.pagingEnabled = YES;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"share"] style: UIBarButtonItemStylePlain target: nil action: nil];
    _headIV = [[UIImageView alloc] init];
    // 防止拉伸
    [[[_headIV widthAnchor] constraintEqualToConstant:32] setActive: YES];
    [[[_headIV heightAnchor] constraintEqualToConstant:32] setActive: YES];
    UIBarButtonItem *headItem = [[UIBarButtonItem alloc] initWithCustomView: _headIV];
    self.navigationItem.rightBarButtonItems = @[shareItem, headItem];
    
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
    [_evaluateTableView registerClass:[CommunityEvaluateCell class] forCellReuseIdentifier:@"CommunityEvaluateCell"];
}

- (void)request {
    [MBProgressHUD showHudMsg:@"加载中"];
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
    self.createDateLabel.text = self.model.createdDate;
    
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
            [productCell setBuyBlock:^(NSInteger offerId) {
                ProductViewController *productVC = [[ProductViewController alloc] init];
                productVC.offerId = offerId;
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
- (IBAction)sendAction:(UIButton *)sender {
    [MBProgressHUD showHudMsg:@"Send..."];
    [SFNetworkManager post:[SFNet.article addEvaluatelOf:self.articleId] parameters:@{@"evalComments":_replyField.text} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
    }];
}

#pragma mark - tableview.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityEvaluateCell"];
    return cell;
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
    UIImageView *iv = nil;
    if (view == nil) {
        iv = [[UIImageView alloc] initWithFrame:carousel.bounds];
        iv.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        iv = (UIImageView *)view;
    }
    [iv sd_setImageWithURL: [NSURL URLWithString: SFImage(self.model.articlePictures[index])]];
    return iv;
}

@end
