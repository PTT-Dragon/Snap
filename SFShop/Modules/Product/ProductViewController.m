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
#import "ProductCalcFeeModel.h"
#import "ProductEvalationCell.h"
#import "ProductEvalationTitleCell.h"
#import "PublicWebViewController.h"
#import "ProductReviewViewController.h"
#import "ProductGroupListCell.h"
#import "ProductGroupTitleCell.h"
#import "ProductionRecommendCell.h"
#import "CheckoutManager.h"
#import "ProductionRecomandView.h"
#import "SysParamsModel.h"
#import "LoginViewController.h"
#import "ChooseAreaViewController.h"
#import "ProductStockModel.h"
#import "CartChooseCouponView.h"
#import "ProductShowGroupView.h"

@interface ProductViewController ()<UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,ChooseAreaViewControllerDelegate>
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
@property (weak, nonatomic) IBOutlet UITableView *evalationTableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHie;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoCellTop;
@property (weak, nonatomic) IBOutlet UIButton *usefulBtn;
@property (weak, nonatomic) IBOutlet UIView *couponsView;

@property(nonatomic, strong) NSMutableArray<ProductEvalationModel *> *evalationArr;
@property (nonatomic, strong) WKWebView *detailWebView;
@property(nonatomic, strong) NSMutableArray<ProductSimilarModel *> *similarList;
@property (nonatomic, assign) BOOL isCheckingSaleInfo;
@property (nonatomic, strong) ProductSpecAttrsView *attrView;
@property (nonatomic,strong) addressModel *selectedAddressModel;
@property (nonatomic,strong) ProductItemModel *selProductModel;
@property (nonatomic,copy) NSNumber *allEvaCount;//评价总数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@property (weak, nonatomic) IBOutlet UILabel *flashSaleStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *flashSaleBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flashSaleProcessViewWidth;
@property (weak, nonatomic) IBOutlet UIView *groupInfoView;
@property (weak, nonatomic) IBOutlet UIView *flashSaleInfoView;
@property (nonatomic,strong) ProductCampaignsInfoModel *campaignsModel;
@property (nonatomic, strong) dispatch_source_t timer;//倒计时
@property (weak, nonatomic) IBOutlet UITableView *groupTableView;
@property (nonatomic,strong) ProductGroupModel *groupModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupTableViewHei;
@property (weak, nonatomic) IBOutlet UILabel *groupSalePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMarketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupCountLabel;
@property (strong, nonatomic) ProductionRecomandView *recommendView;
@property (weak, nonatomic) IBOutlet UILabel *cartNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@property (nonatomic, strong) AreaModel *provinceModel;
@property (nonatomic, strong) AreaModel *cityModel;
@property (nonatomic, strong) AreaModel *districtModel;
@property (nonatomic, strong) AreaModel *streetModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupTableViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponsViewHeight;

@property (nonatomic, strong) NSArray<ProductStockModel *> *stockModel;
@property (nonatomic,strong) NSMutableArray<addressModel *> *addressDataSource;

@property (nonatomic, strong) NSString *currentShareBuyOrderId;

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = kLocalizedString(@"Product_detail");
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self request];
    [self requestSimilar];
    [self setupSubViews];
    [self requestProductRecord];
    [self requestEvaluationsList];
    [self addActions];
    [self requestCampaigns];
    [self requestCartNum];
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
    
    UITapGestureRecognizer *couponTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCoupon)];
    [self.couponsView addGestureRecognizer:couponTap];
}
- (void)chooseCoupon
{
    CartChooseCouponView *view = [[NSBundle mainBundle] loadNibNamed:@"CartChooseCouponView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    view.couponDataSource = self.campaignsModel.coupons;
    [[baseTool getCurrentVC].view addSubview:view];
}
- (void)chooseAddress {
    if (self.addressDataSource.count == 0) {
        ChooseAreaViewController *vc = [[ChooseAreaViewController alloc] init];
        vc.delegate = self;
        vc.type = _streetModel ? 6 : 3;
        vc.selProvinceAreaMoel = self.provinceModel;
        vc.selCityAreaMoel = self.cityModel;
        vc.selDistrictAreaMoel = self.districtModel;
        vc.selStreetAreaMoel = self.streetModel;
        [self presentViewController:vc animated:YES completion: nil];
    }else{
        CartChooseAddressViewController *vc = [[CartChooseAddressViewController alloc] init];
        vc.addressListArr = self.addressDataSource;
        vc.view.frame = CGRectMake(0, 0, self.view.jk_width, self.view.jk_height);
        MPWeakSelf(self)
        vc.selBlock = ^(addressModel * model) {
            weakself.selectedAddressModel = model;
        };
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    }
}

- (void)setSelectedAddressModel:(addressModel *)selectedAddressModel {
    _selectedAddressModel = selectedAddressModel;
    self.addressLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@", selectedAddressModel.province, selectedAddressModel.city, selectedAddressModel.district, selectedAddressModel.postCode];
}

- (void)request {
    MBProgressHUD *hud = [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
    [SFNetworkManager get: [SFNet.offer getDetailOf: self.offerId] success:^(id  _Nullable response) {
        [hud hideAnimated:YES];
        NSError *error;
        self.model = [[ProductDetailModel alloc] initWithDictionary: response error: &error];
        [self requestAddressInfo];
        NSLog(@"get product detail success");
    } failed:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
        NSLog(@"get product detail failed");
    }];
}
- (void)requestCampaigns
{
    MBProgressHUD *hud = [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
    MPWeakSelf(self)
    [SFNetworkManager get: SFNet.offer.campaigns parameters:@{@"offerId":@(_offerId)} success:^(id  _Nullable response) {
        [hud hideAnimated:YES];
        weakself.campaignsModel = [ProductCampaignsInfoModel yy_modelWithDictionary:response];
        if (weakself.campaignsModel.cmpFlashSales.count > 0) {
            //说明是参与抢购活动
            [weakself layoutFlashSaleSubView];
        }
        if (weakself.campaignsModel.cmpShareBuys.count > 0){
            //拼团活动
            [weakself requestGroupInfo];
        }
        if (weakself.campaignsModel.coupons > 0){
            //有可使用红包
            [weakself layoutCouponSubviews];
        }
        
    } failed:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)requestGroupInfo
{
    //已经开始的团队列表
    MPWeakSelf(self)
    
    NSInteger productId = self.selProductModel.productId;
    cmpShareBuysModel *subModel = [self.campaignsModel.cmpShareBuys jk_filter:^BOOL(cmpShareBuysModel *object) {
        return [object.productId integerValue] == productId;
    }].firstObject;
    if (!subModel) {
        [self hideGroupSubViews];
        return;
    }

    [SFNetworkManager get:SFNet.groupbuy.groups parameters:@{@"offerId":@(_offerId),@"campaignId":@(subModel.campaignId),@"pageSize":@(5),@"pageIndex":@(1)} success:^(id  _Nullable response) {
        weakself.groupModel = [ProductGroupModel yy_modelWithDictionary:response];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

- (void)requestAddressInfo {
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (!model ||[model.accessToken isEqualToString:@""]) {
        //只有在登录的情况下才去请求
        return;
    }

    self.addressDataSource = [NSMutableArray array];
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.address.addressList parameters:@{} success:^(id  _Nullable response) {
        for (NSDictionary *dic in response) {
            addressModel *model = [[addressModel alloc] initWithDictionary:dic error:nil];
            if ([model.isDefault isEqualToString:@"Y"]) {
                weakself.selectedAddressModel = model;
                [self requestStock];
            }
            [weakself.addressDataSource addObject:model];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestEvaluationsList
{
    //评论列表
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.offer.evaluationList parameters:@{@"offerId":@(_offerId),@"pageIndex":@(1),@"pageSize":@(2)} success:^(id  _Nullable response) {
        weakself.evalationArr = [ProductEvalationModel arrayOfModelsFromDictionaries:response[@"list"] error:nil];
        weakself.allEvaCount = response[@"total"];
        [weakself.evalationTableview reloadData];
        weakself.tableviewHie.constant = [weakself calucateTableviewHei];
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
    MPWeakSelf(self)
    MBProgressHUD *hud = [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
    [SFNetworkManager get: SFNet.favorite.similar parameters:@{@"offerId": [NSString stringWithFormat:@"%ld", (long)self.offerId]} success:^(id  _Nullable response) {
        [hud hideAnimated:YES];
        NSError *error;
        weakself.similarList = [ProductSimilarModel arrayOfModelsFromDictionaries: response[@"pageInfo"][@"list"] error:&error];
        [weakself.recommendView configDataWithSimilarList:weakself.similarList];
        [weakself updateConstraints];
        NSLog(@"get similar success");
    } failed:^(NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        [MBProgressHUD autoDismissShowHudMsg: [NSMutableString getErrorMessage:error][@"message"]];
        NSLog(@"get similarfailed");
    }];
}
- (void)requestCartNum
{
    MPWeakSelf(self)
    //商品浏览记录
    [SFNetworkManager post:SFNet.offer.stock parameters:@{@"offerId":@(self.offerId)} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

/**
 请求库存信息
 */
- (void)requestStock {
    MPWeakSelf(self);
    NSArray *arr = [self.model.products jk_map:^id(ProductItemModel *object) {
        cmpShareBuysModel *sbModel = [weakself.campaignsModel.cmpShareBuys jk_filter:^BOOL(cmpShareBuysModel *object1) {
            return object1.productId.integerValue == object.productId;
        }].firstObject;
        NSArray *inCmpIdList = sbModel ? @[@(sbModel.campaignId)] : @[];
        return @{
            @"productId": @(object.productId),
            @"offerCnt": @1,
            @"inCmpIdList": inCmpIdList
        };
    }];
    NSDictionary *param = @{
                       @"stdAddrId": self.selectedAddressModel.contactStdId,
                       @"stores": @[
                           @{
                               @"storeId": @(self.model.storeId),
                               @"products": arr
                           }
                       ]
    };
    [SFNetworkManager post:SFNet.offer.stock parameters: param success:^(id  _Nullable response) {
        self.stockModel = [ProductStockModel arrayOfModelsFromDictionaries:response error:nil];
        [self.stockModel  enumerateObjectsUsingBlock:^(ProductStockModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            [obj1.products enumerateObjectsUsingBlock:^(SingleProductStockModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                if (obj2.productId.integerValue == weakself.productId) {
                    weakself.deliveryLabel.text = [NSString stringWithFormat:@"%@-%@day(s)", obj2.minDeliveryDays, obj2.maxDeliveryDays];
                    *stop1 = YES;
                    *stop2 = YES;
                }
            }];
        }];
    } failed:^(NSError * _Nonnull error) {
        
    }];

}

- (void)setupSubViews {
    self.addCartBtn.titleLabel.numberOfLines = 2;
    self.buyBtn.titleLabel.numberOfLines = 2;
    self.buyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.addCartBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    config.preferences = [WKPreferences new];
        
        config.preferences.minimumFontSize = 10;
        
        config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    NSString *js=@"var script = document.createElement('script');"
    
    "script.type = 'text/javascript';"
    
    "script.text = \"function ResizeImages() { "
    
    "var myimg,oldwidth;"
    
    "var maxwidth = %f;"
    
    "for(i=0;i"
    
    "myimg = document.images[i];"
    
    "if(myimg.width > maxwidth){"
    
    "oldwidth = myimg.width;"
    
    "myimg.width = %f;"
    
    "}"
    
    "}"
    
    "}\";"
    
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    js = [NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    js = [NSString stringWithFormat:@"%@%@",js,@""];
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    WKUserContentController *userController = [WKUserContentController new];
    [userController addUserScript:script];
    config.userContentController = userController;
    self.detailWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.detailWebView.scrollView.scrollEnabled = NO;
    [self.detailWebView.scrollView addObserver:self forKeyPath:@"contentSize" options: NSKeyValueObservingOptionNew context:nil];
    [self.scrollContentView addSubview:self.detailWebView];

    _evalationArr = [NSMutableArray array];
    [_evalationTableview registerNib:[UINib nibWithNibName:@"ProductEvalationCell" bundle:nil] forCellReuseIdentifier:@"ProductEvalationCell"];
    [_evalationTableview registerNib:[UINib nibWithNibName:@"ProductEvalationTitleCell" bundle:nil] forCellReuseIdentifier:@"ProductEvalationTitleCell"];
    [_groupTableView registerNib:[UINib nibWithNibName:@"ProductGroupListCell" bundle:nil] forCellReuseIdentifier:@"ProductGroupListCell"];
    [_groupTableView registerNib:[UINib nibWithNibName:@"ProductGroupTitleCell" bundle:nil] forCellReuseIdentifier:@"ProductGroupTitleCell"];
    
    [self.scrollContentView addSubview:self.recommendView];
}

- (void)updateConstraints {
    CGFloat height = self.detailWebView.scrollView.contentSize.height;
    CGFloat collectionViewHeight = ceil(self.similarList.count / 2.0) * ((MainScreen_width - 60) / 2 + 120 + 16) + 16;

    [self.detailWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailViewHeader.mas_bottom);
        make.left.right.equalTo(self.scrollContentView);
        make.height.mas_equalTo(height);
    }];

    [self.recommendView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailWebView.mas_bottom).offset(12);
        make.left.right.equalTo(self.scrollContentView);
        make.height.mas_equalTo(collectionViewHeight);
        make.bottom.lessThanOrEqualTo(self.scrollContentView).offset(-12);
    }];
}

- (void)layoutFlashSaleSubView
{
    //抢购活动UI
    self.flashSaleInfoView.hidden = NO;
    self.groupInfoView.hidden = YES;
    self.viewTop.constant = 64;
    self.addCartBtn.hidden = YES;
    FlashSaleDateModel *model = self.campaignsModel.cmpFlashSales.firstObject;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:model.now];
    NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
    
    NSDate *effDate = [formatter dateFromString:model.effDate];
    NSTimeInterval effTimeInterval = [effDate timeIntervalSince1970];
    
    NSDate *expDate = [formatter dateFromString:model.expDate];
    NSTimeInterval expTimeInterval = [expDate timeIntervalSince1970];
    if (effTimeInterval > timeInterval) {
        //未开始
        self.timeStateLabel.text = kLocalizedString(@"Star_in");
        self.flashSaleStateLabel.text = kLocalizedString(@"Star_from");
        self.flashSaleBeginTimeLabel.text = model.effDate;
    }else if (expTimeInterval > timeInterval){
        //进行中
        NSString *currency = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_DISPLAY;
        self.flashSaleStateLabel.text = [NSString stringWithFormat:@"%@ %.0f", currency, model.specialPrice];
        self.flashSaleBeginTimeLabel.text = [NSString stringWithFormat:@"%.0f%%  Sold",model.flsaleSaleQtyPercent];
        self.timeStateLabel.text = kLocalizedString(@"Ends_in");
        MPWeakSelf(self)
        __block NSInteger timeout = expTimeInterval - timeInterval; // 倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){
                
                dispatch_source_cancel(weakself.timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                NSInteger days = (int)(timeout/(3600*24));
                NSInteger hours = (int)((timeout-days*24*3600)/3600);
                NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.hourLabel.text = [NSString stringWithFormat:@"%02ld",hours+days*24];
                    weakself.minuteLabel.text = [NSString stringWithFormat:@"%02ld",minute];
                    weakself.secondLabel.text = [NSString stringWithFormat:@"%02ld",second];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }else{
        //已结束
    }
}

- (void)hideGroupSubViews {
    self.groupInfoView.hidden = YES;
    self.viewTop.constant = 0;
}

- (void)layoutGroupSubViews
{
    [self.groupTableView reloadData];
    self.groupTableViewHei.constant = [self calucateGroupTableviewHei];
    self.flashSaleInfoView.hidden = YES;
    self.groupInfoView.hidden = NO;
    self.viewTop.constant = 64;
    [self.buyBtn setTitle:[NSString stringWithFormat:@"RP%ld\n%@",(long)self.model.salesPrice,kLocalizedString(@"SHARE_BUY")] forState:0];
    [self.addCartBtn setTitle:[NSString stringWithFormat:@"RP%ld\n%@",(long)self.model.salesPrice,kLocalizedString(@"INDIVIDUAL_BUY")] forState:0];
    [self.campaignsModel.cmpShareBuys enumerateObjectsUsingBlock:^(cmpShareBuysModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.productId.integerValue == _selProductModel.productId) {
            //找到当前显示的商品
            NSString *currency = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_DISPLAY;
            self.groupDiscountLabel.text = [NSString stringWithFormat:@"%.0f%%",model.discountPercent];
            self.groupCountLabel.text = [NSString stringWithFormat:@"%ld",(long)model.shareByNum];
            self.groupSalePriceLabel.text = [NSString stringWithFormat:@"%@ %.0f", currency,model.shareBuyPrice];
            self.groupMarketPriceLabel.text = [NSString stringWithFormat:@"%ld",_selProductModel.salesPrice];
        }
    }];
}
- (void)layoutCouponSubviews
{
    self.couponsView.hidden = NO;
    self.couponsViewHeight.constant = 40;
    __block CGFloat lastRight = 0;
    [self.campaignsModel.coupons enumerateObjectsUsingBlock:^(CouponModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        label.text = obj.couponName;
        label.font = CHINESE_SYSTEM(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = RGBColorFrom16(0xFF1659);
        label.textColor = [UIColor whiteColor];
        CGFloat width = [label.text calWidthWithLabel:label];
        [self.couponsView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.couponsView.mas_left).offset(100+lastRight);
            make.centerY.equalTo(self.couponsView);
            make.width.mas_equalTo(width);
        }];
        lastRight = width+5;
    }];
}
- (void)showGroupView
{
    MPWeakSelf(self)
    ProductShowGroupView *groupView = [[ProductShowGroupView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height)];
    groupView.joinBlock = ^(ProductGroupListModel * _Nonnull model) {
        weakself.currentShareBuyOrderId = model.shareBuyOrderId;
        [weakself buyNow:nil];
    };
    groupView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    groupView.dataSource = self.groupModel.list;
    [self.view addSubview:groupView];
}

- (void)setModel:(ProductDetailModel *)model {
    _model = model;
    self.offerNameLabel.text = model.offerName;
    self.subheadNameLabel.text = model.subheadName;
    [self.detailWebView loadHTMLString: [MakeH5Happy replaceHtmlSourceOfRelativeImageSource: model.goodsDetails] baseURL:nil];
    self.selProductModel = [model.products jk_filter:^BOOL(ProductItemModel *object) {
        return object.productId == self.productId;
    }].firstObject;
    
    [self.carouselImgView reloadData];
}
- (void)setSelProductModel:(ProductItemModel *)selProductModel
{
    _selProductModel = selProductModel;
    
    NSString *currency = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_DISPLAY;
    self.salesPriceLabel.text = [NSString stringWithFormat:@"%@ %ld", currency, selProductModel.salesPrice];
    NSMutableAttributedString *marketPriceStr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@ %ld", currency, selProductModel.marketPrice]];
    [marketPriceStr addAttribute: NSStrikethroughStyleAttributeName value:@2 range: NSMakeRange(0, marketPriceStr.length)];
    self.marketPriceLabel.attributedText = marketPriceStr;
    // 规格
    NSMutableString *varString = [NSMutableString string];
    [selProductModel.prodSpcAttrs enumerateObjectsUsingBlock:^(ProdSpcAttrsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [varString appendString:obj.value];
        if (idx < selProductModel.prodSpcAttrs.count - 1) {
            [varString appendString: @","];
        }
    }];
    self.variationsLabel.text = varString;
    self.originalPriceLabel.text = [[NSString stringWithFormat:@"%ld",selProductModel.marketPrice] currency];

    self.usefulBtn.selected = [selProductModel.isCollection isEqualToString:@"1"];
    
}
- (void)setGroupModel:(ProductGroupModel *)groupModel
{
    _groupModel = groupModel;
    [self layoutGroupSubViews];
}

- (void)setSimilarList:(NSMutableArray<ProductSimilarModel *> *)similarList {
    _similarList = similarList;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.detailWebView.scrollView && [keyPath isEqualToString:@"contentSize"]) {
        [self updateConstraints];
    }
}

- (ProductItemModel *)getSelectedProductItem {
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
    __block ProductItemModel *productItem;
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
                productItem = obj1;
            }
        }];
    }];
    return productItem;
}


#pragma mark - tableview.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _evalationTableview) {
        return _evalationArr.count+1;
    }
    return self.groupModel.list.count == 0 ? 0: self.groupModel.list.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _evalationTableview) {
        if (indexPath.row == 0) {
            ProductEvalationTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductEvalationTitleCell"];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@(%@)",@"5",_allEvaCount];
            return cell;
        }
        ProductEvalationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductEvalationCell"];
        cell.model = self.evalationArr[indexPath.row-1];
        return cell;
    }
    if (indexPath.row == 0) {
        ProductGroupTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductGroupTitleCell"];
        cell.label.text = [NSString stringWithFormat:@"%ld people share buy, click to join",self.groupModel.total];
        return cell;
    }
    ProductGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductGroupListCell"];
    ProductGroupListModel *model = self.groupModel.list[indexPath.row-1];
    cell.model = model;
    MPWeakSelf(self)
    cell.joinBlock = ^{
        weakself.currentShareBuyOrderId = model.shareBuyOrderId;
        [weakself buyNow:nil];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _evalationTableview) {
        if (indexPath.row == 0) {
            return 50;
        }
        ProductEvalationModel *model = self.evalationArr[indexPath.row-1];
        return model.itemHie;
    }
    if (indexPath.row == 0) {
        return 50;
    }
    return 47;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _evalationTableview) {
        if (self.evalationArr.count == 0) {
            return;
        }
        ProductReviewViewController *vc = [[ProductReviewViewController alloc] init];
        vc.evaluationsId = [NSString stringWithFormat:@"%ld",self.model.offerId];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tableView == _groupTableView){
        if (indexPath.row == 0) {
            [self showGroupView];
        }
    }
}
- (CGFloat)calucateTableviewHei
{
    CGFloat hei = 0;
    for (ProductEvalationModel *itemModel in self.evalationArr) {
        hei += itemModel.itemHie;
    }
    return hei+50;
}
- (CGFloat)calucateGroupTableviewHei
{
    CGFloat hei = self.groupModel.list.count * 47;
    return self.groupModel.list.count == 0 ? 0: hei+50;
}


#pragma mark - Action

- (IBAction)usefulAction:(UIButton *)sender {
    MPWeakSelf(self)
    [MBProgressHUD showHudMsg:@""];
    if ([self.selProductModel.isCollection isEqualToString:@"1"]) {
        [SFNetworkManager post:SFNet.favorite.del parameters:@{@"productIdList":@[@(_selProductModel.productId)]} success:^(id  _Nullable response) {
            [MBProgressHUD hideFromKeyWindow];
            weakself.selProductModel.isCollection = @"0";
            [weakself setSelProductModel:weakself.selProductModel];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }else{
        [SFNetworkManager post:SFNet.favorite.favorite parametersArr:@[@{@"offerId":@(_model.offerId),@"productId":@(_selProductModel.productId)}] success:^(id  _Nullable response) {
            [MBProgressHUD hideFromKeyWindow];
            weakself.selProductModel.isCollection = @"1";
            [weakself setSelProductModel:weakself.selProductModel];
            [MBProgressHUD autoDismissShowHudMsg:@"ADD SUCCESS"];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }
}
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
            @"productId": @([self getSelectedProductItem].productId),
            @"storeId": @(self.model.storeId),
            @"unitPrice": @(self.model.salesPrice),
            @"contactChannel":@"3",
            @"addon":@"",
            @"isSelected":@"N"
        };
        MPWeakSelf(self)
        [SFNetworkManager post:SFNet.cart.cart parameters: params success:^(id  _Nullable response) {
            [baseTool updateCartNum];
            [weakself requestCartNum];
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Add_to_cart_success")];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Add_to_cart_failed")];
        }];
    }
}
- (IBAction)messageAction:(UIButton *)sender {
    PublicWebViewController *vc = [[PublicWebViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"http://47.243.193.90:8064/chat/A1test@A1.com"];
    vc.sysAccount = _model.uccAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)buyNow:(UIButton *)sender {
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (!model || [model.accessToken isEqualToString:@""]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        MPWeakSelf(vc)
        vc.didLoginBlock = ^{
            [weakvc.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (!_isCheckingSaleInfo) {
        [self showAttrsView];
    } else {
        //跳转checkout页
        ProductItemModel *item = self.getSelectedProductItem;
        item.storeName = self.model.storeName;
        for (cmpShareBuysModel *buyModel in self.campaignsModel.cmpShareBuys) {
            if (buyModel.productId.integerValue == item.productId) {
                item.inCmpIdList = @[@(buyModel.campaignId)];
            }
        }
        item.currentBuyCount = self.attrView.count;
        if (item.inCmpIdList) {//团购情况
            if (self.currentShareBuyOrderId.length > 0) {
                self.model.shareBuyOrderId = self.currentShareBuyOrderId;
                self.model.shareBuyMode = @"B";
            } else {
                self.model.shareBuyMode = @"A";
            }
            self.model.orderType = @"B";
        }
        self.model.selectedProducts = @[item];
        ProductCheckoutModel *checkoutModel = [ProductCheckoutModel initWithsourceType:@"LJGM" addressModel:self.selectedAddressModel productModels:@[self.model]];
        [CheckoutManager.shareInstance loadCheckoutData:checkoutModel complete:^(BOOL isSuccess, ProductCheckoutModel * _Nonnull checkoutModel) {
            if (isSuccess) {
                ProductCheckoutViewController *vc = [[ProductCheckoutViewController alloc] initWithCheckoutModel:checkoutModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}


- (void)showAttrsView {
    _isCheckingSaleInfo = YES;
    _attrView = [[ProductSpecAttrsView alloc] init];
    _attrView.campaignsModel = self.campaignsModel;
    _attrView.selProductModel = self.selProductModel;
    _attrView.stockModel = self.stockModel;
    _attrView.model = self.model;
    MPWeakSelf(self)
    MPWeakSelf(_attrView)
    _attrView.dismissBlock = ^{
        [weak_attrView removeFromSuperview];
        weakself.isCheckingSaleInfo = NO;
        weakself.currentShareBuyOrderId = nil;
    };
    _attrView.chooseAttrBlock = ^() {
        weakself.selProductModel = weakself.attrView.selProductModel;
        [weakself.carouselImgView reloadData];
        // 切换属性，可能会走团购逻辑
        [weakself requestGroupInfo];
    };
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [rootView addSubview:_attrView];
    [_attrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(rootView);
        make.bottom.equalTo(_buyBtn.mas_top).offset(-16);
    }];
}

#pragma mark - chooseAddress
- (void)chooseProvince:(AreaModel *)provinceModel city:(AreaModel *)cityModel district:(AreaModel *)districtModel street:(AreaModel *)streetModel
{
    _provinceModel = provinceModel;
    _cityModel = cityModel;
    _districtModel = districtModel;
    _streetModel = streetModel;
    _selectedAddressModel = [[addressModel alloc] init];
    _selectedAddressModel.province = _provinceModel.stdAddr;
    _selectedAddressModel.city = _cityModel.stdAddr;
    _selectedAddressModel.street = _streetModel.stdAddr;
    _selectedAddressModel.district = _districtModel.stdAddr;
    _selectedAddressModel.contactStdId = _streetModel.stdAddrId;
    _selectedAddressModel.postCode = _streetModel.zipcode;
    self.addressLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@", _selectedAddressModel.province, _selectedAddressModel.city, _selectedAddressModel.district, _selectedAddressModel.postCode];
    /**
     重新选择完地址   后续操作
     **/
    [self requestStock];
}


#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _model.carouselImgUrls.count + 1;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIImageView *iv = nil;
    if (view == nil) {
        iv = [[UIImageView alloc] initWithFrame:carousel.bounds];
        iv.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        iv = (UIImageView *)view;
    }
    [iv sd_setImageWithURL: [NSURL URLWithString: SFImage([MakeH5Happy getNonNullCarouselImageOf: (index == 0 ? self.selProductModel : self.model.carouselImgUrls[index])])]];
    return iv;
}


- (ProductionRecomandView *)recommendView {
    if (!_recommendView) {
        _recommendView = [[ProductionRecomandView alloc] init];
    }
    return _recommendView;
}
@end
