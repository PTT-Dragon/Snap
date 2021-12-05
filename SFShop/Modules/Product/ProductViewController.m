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
#import "addressModel.h"
#import "CartChooseAddressViewController.h"
#import "CartViewController.h"

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
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
// TODO:暂时写死，后面估计会根据deliveryMode存在映射关系？
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *variationsLabel;

@property (nonatomic, strong) WKWebView *detailWebView;
@property(nonatomic, strong) NSMutableArray<ProductSimilarModel *> *similarList;
@property (nonatomic, assign) BOOL isCheckingSaleInfo;
@property (nonatomic, strong) ProductSpecAttrsView *attrView;
@property (nonatomic,strong) NSMutableArray<addressModel *> *addressDataSource;


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
    [self requestAddressInfo];
    [self addActions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.attrView && self.attrView.superview != nil) {
        [self.attrView removeFromSuperview];
        self.isCheckingSaleInfo = NO;
    }
}

- (void)dealloc {
    @try {
        [self.detailWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        NSLog(@"可能多次释放，避免crash");
    }
}

- (void)addActions {
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAddress)];
    [self.addressLabel addGestureRecognizer:addressTap];
    
    UITapGestureRecognizer *variationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAttrsView)];
    [self.variationsLabel addGestureRecognizer:variationTap];
}

- (void)chooseAddress {
    CartChooseAddressViewController *vc = [[CartChooseAddressViewController alloc] init];
    vc.addressListArr = self.addressDataSource;
    vc.view.frame = CGRectMake(0, 0, self.view.jk_width, self.view.jk_height);
    MPWeakSelf(self)
    vc.selBlock = ^(addressModel * model) {
        weakself.addressLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@", model.province, model.city, model.district, model.postCode];
    };
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
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

- (void)requestAddressInfo {
    self.addressDataSource = [NSMutableArray array];
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.address.addressList parameters:@{} success:^(id  _Nullable response) {
        for (NSDictionary *dic in response) {
            addressModel *model = [[addressModel alloc] initWithDictionary:dic error:nil];
            if ([model.isDefault isEqualToString:@"Y"]) {
                weakself.addressLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@", model.province, model.city, model.district, model.postCode];
            }
            [weakself.addressDataSource addObject:model];
        }
    } failed:^(NSError * _Nonnull error) {
        
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
    self.variationsLabel.text = [self getVariationsString];
    [self.detailWebView loadHTMLString: [MakeH5Happy replaceHtmlSourceOfRelativeImageSource: model.goodsDetails] baseURL:nil];
}

- (NSString *)getVariationsString {
    __block NSString *result = @"";
    [_model.offerSpecAttrs enumerateObjectsUsingBlock:^(ProductAttrModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.attrName isEqualToString:@"Color"]) {
            result = obj.attrValues.firstObject.value;
        }
    }];
    return result;
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

- (NSInteger)getSelectedProductId {
    NSMutableArray *selectedAttrs = [NSMutableArray array];
    MPWeakSelf(self)
    [self.model.offerSpecAttrs enumerateObjectsUsingBlock:^(ProductAttrModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *attrId = obj.attrId;
        NSString *attrName = obj.attrName;
        NSUInteger index = weakself.attrView.selectedAttrValue[idx].integerValue;
        ProductAttrValueModel *attrValueModel = obj.attrValues[index];
        NSString *value = attrValueModel.value;
        [selectedAttrs addObject:@{
            @"attrId": attrId, @"attrName": attrName, @"value": value
        }];
    }];
    __block NSInteger productId;
    [self.model.products enumerateObjectsUsingBlock:^(ProductItemModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        [selectedAttrs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            NSArray *arr = [obj1.prodSpcAttrs jk_filter:^BOOL(ProdSpcAttrsModel *obj3) {
                return [obj3.attrId isEqualToString: [obj2 jk_stringForKey: @"attrId"]] &&
                [obj3.attrName isEqualToString: [obj2 jk_stringForKey: @"attrName"]] &&
                [obj3.value isEqualToString: [obj2 jk_stringForKey: @"value"]];
            }];
            if (arr.count == 0) {
                *stop2 = YES;
                return;
            }
            // 遍历完最后一个，说明找到满足条件的商品了
            if (idx2 == selectedAttrs.count - 1) {
                productId = obj1.productId;
            }
        }];
    }];
    return productId;
}

#pragma mark - Action

- (IBAction)goToCart:(UIButton *)sender {
    CartViewController *cartVC = [[CartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (IBAction)addToCart:(UIButton *)sender {
    if (!_isCheckingSaleInfo) {
        [self showAttrsView];
    } else {
        // TODO: 添加购物车
        NSDictionary *params =
        @{
            @"campaignId":@"3",
            @"num": @(self.attrView.count),
            @"offerId": @(self.model.offerId),
            @"productId": @([self getSelectedProductId]),
            @"storeId": @(self.model.storeId),
            @"unitPrice": @(self.model.salesPrice),
            @"contactChannel":@"3",
            @"addon":@"",
            @"isSelected":@"N"
        };
        MPWeakSelf(self)
        [SFNetworkManager post:SFNet.cart.cart parameters: params success:^(id  _Nullable response) {
            [MBProgressHUD autoDismissShowHudMsg: @"Add to cart Success!"];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"Add to cart failed!"];
        }];
    }
}

- (IBAction)buyNow:(UIButton *)sender {
    if (!_isCheckingSaleInfo) {
        [self showAttrsView];
    } else {
        // TODO: 跳转checkout页
        [self.attrView removeFromSuperview];
        self.isCheckingSaleInfo = NO;
        ProductCheckoutViewController *vc = [[ProductCheckoutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showAttrsView {
    _isCheckingSaleInfo = YES;
    _attrView = [[ProductSpecAttrsView alloc] init];
    _attrView.model = self.model;
    MPWeakSelf(self)
    MPWeakSelf(_attrView)
    _attrView.dismissBlock = ^{
        [weak_attrView removeFromSuperview];
        weakself.isCheckingSaleInfo = NO;
    };
    _attrView.chooseAttrBlock = ^() {
        [weakself.model.offerSpecAttrs enumerateObjectsUsingBlock:^(ProductAttrModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // TODO: 此处暂时仅处理颜色的属性，因为没找到有其他属性的测试数据
            if ([obj.attrName isEqualToString:@"Color"]) {
                NSInteger selectedColorIndex = weakself.attrView.selectedAttrValue[idx].integerValue;
                weakself.variationsLabel.text = obj.attrValues[selectedColorIndex].value;
            }
        }];
    };
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [rootView addSubview:_attrView];
    [_attrView mas_makeConstraints:^(MASConstraintMaker *make) {
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
