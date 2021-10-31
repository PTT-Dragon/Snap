//
//  ProductViewController.m
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "ProductViewController.h"
#import "ProductDetailModel.h"
#import "ProductSimilarModel.h"
#import <iCarousel/iCarousel.h>
#import <WebKit/WebKit.h>
#import "MakeH5Happy.h"
#import "ProductSpecAttrsView.h"
#import "ProductCheckoutViewController.h"

@interface ProductViewController ()
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property(nonatomic, strong) ProductDetailModel *model;
@property (weak, nonatomic) IBOutlet iCarousel *carouselImgView;
@property (weak, nonatomic) IBOutlet UILabel *salesPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheadNameLabel;
@property (weak, nonatomic) IBOutlet UIView *detailViewHeader;
@property (nonatomic, strong) WKWebView *detailWebView;
@property(nonatomic, strong) NSMutableArray<ProductSimilarModel *> *similarList;
@property (nonatomic, assign) BOOL isCheckingSaleInfo;

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Product Detail";
    self.view.backgroundColor = [UIColor whiteColor];
    [self request];
    [self requestSimilar];
    [self setupSubViews];
    [self requestProductRecord];
}

- (void)dealloc {
    @try {
        [self.detailWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        NSLog(@"可能多次释放，避免crash");
    }
}

- (void)request {
    [MBProgressHUD showHudMsg:@"加载中"];
    [SFNetworkManager get: [SFNet.offer getDetailOf: self.offerId] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSError *error;
        self.model = [[ProductDetailModel alloc] initWithDictionary: response error: &error];
        NSLog(@"get product detail success");
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
        NSLog(@"get product detail failed");
    }];
}
- (void)requestProductRecord
{
    //商品浏览记录
    [SFNetworkManager post:SFNet.offer.viewlog parameters:@{@"offerId":@(self.offerId)} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestSimilar {
    [MBProgressHUD showHudMsg:@"加载中"];
    [SFNetworkManager get: SFNet.favorite.similar parameters:@{@"offerId": [NSString stringWithFormat:@"%ld", self.offerId]} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSError *error;
        self.similarList = [ProductSimilarModel arrayOfModelsFromDictionaries: response[@"pageInfo"][@"list"] error:&error];
        NSLog(@"get similar success");
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
        NSLog(@"get similarfailed");
    }];
}


- (void)setupSubViews {
    self.cartBtn.layer.borderWidth = 0.5;
    self.cartBtn.layer.borderColor = [[UIColor jk_colorWithHexString:@"#cccccc"] CGColor];
    self.messageBtn.layer.borderWidth = 0.5;
    self.messageBtn.layer.borderColor = [[UIColor jk_colorWithHexString:@"#cccccc"] CGColor];
    self.addCartBtn.layer.borderWidth = 1;
    self.addCartBtn.layer.borderColor = [[UIColor jk_colorWithHexString:@"#ff1659"] CGColor];
    [self.buyBtn setBackgroundColor: [UIColor jk_colorWithHexString:@"#ff1659"]];
    
    _carouselImgView.type = iCarouselTypeLinear;
    _carouselImgView.bounces = NO;
    _carouselImgView.pagingEnabled = YES;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.detailWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.detailWebView.scrollView.scrollEnabled = NO;
    [self.detailWebView.scrollView addObserver:self forKeyPath:@"contentSize" options: NSKeyValueObservingOptionNew context:nil];
    [self.scrollContentView addSubview:self.detailWebView];
    [self.detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailViewHeader.mas_bottom);
        make.left.right.equalTo(self.scrollContentView);
        make.height.mas_equalTo(200);
    }];
}

- (void)setModel:(ProductDetailModel *)model {
    _model = model;
    [self.carouselImgView reloadData];
    self.salesPriceLabel.text = [NSString stringWithFormat:@"Rp %ld", model.salesPrice];
    NSMutableAttributedString *marketPriceStr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"Rp %ld", model.marketPrice]];
    [marketPriceStr addAttribute: NSStrikethroughStyleAttributeName value:@2 range: NSMakeRange(0, marketPriceStr.length)];
    self.marketPriceLabel.attributedText = marketPriceStr;
    self.offerNameLabel.text = model.offerName;
    self.subheadNameLabel.text = model.subheadName;
    [self.detailWebView loadHTMLString: [MakeH5Happy replaceHtmlSourceOfRelativeImageSource: model.goodsDetails] baseURL:nil];
}

- (void)setSimilarList:(NSMutableArray<ProductSimilarModel *> *)similarList {
    _similarList = similarList;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.detailWebView.scrollView && [keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = self.detailWebView.scrollView.contentSize.height;
        [self.detailWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailViewHeader.mas_bottom);
            make.left.right.equalTo(self.scrollContentView);
            make.height.mas_equalTo(height);
            make.bottom.lessThanOrEqualTo(self.scrollContentView).offset(-20);
        }];
    }
}

#pragma mark - Action

- (IBAction)addToCart:(UIButton *)sender {
    if (!_isCheckingSaleInfo) {
        [self showAttrsView];
    } else {
        // TODO: 添加购物车
    }
}

- (IBAction)buyNow:(UIButton *)sender {
    if (!_isCheckingSaleInfo) {
        [self showAttrsView];
    } else {
        // TODO: 跳转checkout页
        ProductCheckoutViewController *vc = [[ProductCheckoutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showAttrsView {
    _isCheckingSaleInfo = YES;
    ProductSpecAttrsView *attrView = [[ProductSpecAttrsView alloc] init];
    attrView.model = self.model;
    MPWeakSelf(self)
    MPWeakSelf(attrView)
    attrView.dismissBlock = ^{
        [weakattrView removeFromSuperview];
        weakself.isCheckingSaleInfo = NO;
    };
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [rootView addSubview:attrView];
    [attrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(rootView);
        make.bottom.equalTo(_buyBtn.mas_top).offset(-16);
    }];
}


#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _model.carouselImgUrls.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIImageView *iv = nil;
    if (view == nil) {
        iv = [[UIImageView alloc] initWithFrame:carousel.bounds];
        iv.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        iv = (UIImageView *)view;
    }
    [iv sd_setImageWithURL: [NSURL URLWithString: SFImage([MakeH5Happy getNonNullCarouselImageOf:self.model.carouselImgUrls[index]])]];
    return iv;
}

@end
