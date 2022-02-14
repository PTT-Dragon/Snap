//
//  UseCouponViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/29.
//

#import "UseCouponViewController.h"
#import "CategoryRankHeadSelectorView.h"
#import "CategoryRankFilterViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "UseCouponProductCell.h"
#import "ProductViewController.h"
#import "ProductSpecAttrsView.h"
#import "addressModel.h"
#import "NSDate+Helper.h"
#import "CartViewController.h"
#import "SFSearchNav.h"
#import "BaseNavView.h"
#import "BaseMoreView.h"
#import "CategoryRankViewController.h"
#import "EmptyView.h"

@interface UseCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredDataLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (nonatomic, readwrite, strong) CategoryRankHeadSelectorView *headSelectorView;
@property (nonatomic, readwrite, assign) CategoryRankType currentType;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;
@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@property (nonatomic, readwrite, strong) NSMutableArray *addressDataArray;
@property (nonatomic, readwrite, assign) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UIView *bottomVie;
@property (nonatomic, strong) ProductSpecAttrsView *attrView;
@property (nonatomic,strong) addressModel *selAddressModel;
@property (nonatomic, strong) NSArray<ProductStockModel *> *stockModel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (nonatomic,strong) ProductItemModel *selProductModel;
@property (nonatomic,strong) CouponOrifeeModel *orifeeModel;
@property (weak, nonatomic) IBOutlet UILabel *expiryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountTitleLabel;
@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@property (nonatomic, readwrite, strong) BaseMoreView *moreView;
@property (nonatomic,copy) NSString *searchText;
//@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@property (nonatomic,strong) EmptyView *emptyView;

@end

@implementation UseCouponViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadsubviews];
}
- (void)loadsubviews {
    [self.view addSubview:self.navSearchView];
    _searchText = @"";
    self.discountTitleLabel.text = kLocalizedString(@"DISCOUNT");
    self.expiryTitleLabel.text = kLocalizedString(@"EXPIRY_DATE");
    self.couponView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    self.couponView.layer.borderWidth = 1;
    self.cartBtn.titleLabel.numberOfLines = 2;
    self.cartBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (_couponModel) {
        _couponNameLabel.text = self.couponModel.couponName;
        if (_couponModel.isGet) {
            _expiredDataLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:_couponModel.userCouponEffDate] dayMonthYear],[[NSDate dateFromString:_couponModel.userCouponExpDate] dayMonthYear]];
        }else{
            if (_couponModel.getOffsetExp) {
                _expiredDataLabel.text = [NSString stringWithFormat:@"Valid within %@ days",_couponModel.getOffsetExp];
            }else{
                _expiredDataLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:_couponModel.effDate] dayMonthYear],[[NSDate dateFromString:_couponModel.expDate] dayMonthYear]];
            }
        }
    }else if (_buygetnInfoModel){
        _expiredDataLabel.text = [NSString stringWithFormat:@"%@ - %@",[[NSDate dateFromString:_buygetnInfoModel.effDate] dayMonthYear],[[NSDate dateFromString:_buygetnInfoModel.expDate] dayMonthYear]];
        _couponNameLabel.text = @"";
    }
    [self.view addSubview:self.headSelectorView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomVie.mas_top);
        make.top.mas_equalTo(self.headSelectorView.mas_bottom).offset(12);
    }];
    self.currentType = CategoryRankTypePopularity;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadDatas:self.currentPage sortType:self.currentType filter:self.filterCacheModel];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage += 1;
        [self loadDatas:self.currentPage sortType:self.currentType filter:self.filterCacheModel];
    }];
    [self loadAddressDatas];
    [self loadFeeDatas];
    [self.tableView.mj_header beginRefreshing];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_top).offset(90);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UseCouponProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UseCouponProductCell"];
    [cell setContent:self.dataArray[indexPath.section]];
    cell.block = ^(CategoryRankPageInfoListModel * _Nonnull model) {
        [self loadProductInfoWithModel:model];
//        [self showAttrsViewWithAttrType:cartType model:model];
    };
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryRankPageInfoListModel *model = self.dataArray[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = model.offerId;
    vc.productId = model.productId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadDatas:(NSInteger)currentPage sortType:(CategoryRankType)type filter:(CategoryRankFilterCacheModel *)filter {
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
        @"q": _searchText,
        @"pageIndex": @(currentPage),
        @"pageSize": @(10),
        @"sortType": [NSString stringWithFormat:@"%ld",type],
        @"offerIdList": [NSNull null],
//        @"catgIds": @(self.model.inner.catgId),//默认是外部传入的分类,如果 filter.filterParam 有该字段,会被新值覆盖
        @"couponId": self.couponModel ? self.couponModel.couponId : [NSNull null],
        @"campaignId":self.buygetnInfoModel ? self.buygetnInfoModel.campaignId : [NSNull null],
    }];
    [parm addEntriesFromDictionary:filter.filterParam];
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        CategoryRankModel *model = [CategoryRankModel yy_modelWithDictionary:response];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:@[]];
        [model.pageInfo.list enumerateObjectsUsingBlock:^(CategoryRankPageInfoListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.sppType && ![obj.offerType isEqualToString:@"V"] && ![obj.offerType isEqualToString:@"E"]) {
                [arr addObject:obj];
            }
        }];
        model.pageInfo.list = arr;
        self.dataModel = model;
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArray addObjectsFromArray:self.dataModel.pageInfo.list];
        [self.tableView reloadData];
        if (self.dataArray.count==0) {
            self.emptyView.hidden = NO;
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.emptyView.hidden = YES;
            self.tableView.mj_footer.hidden = NO;
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:error.localizedDescription];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
- (void)loadAddressDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.address.addressList parameters:@{@"pageIndex":@(1),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [weakself.addressDataArray removeAllObjects];
        for (NSDictionary *dic in response) {
            addressModel *model = [[addressModel alloc] initWithDictionary:dic error:nil];
            if ([model.isDefault isEqualToString:@"Y"]) {
                weakself.selAddressModel = model;
            }
            [weakself.addressDataArray addObject:model];
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadFeeDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.cart.orifee parameters:@{@"couponId":_couponModel ? _couponModel.couponId : _buygetnInfoModel ? _buygetnInfoModel.campaignId: @""} success:^(id  _Nullable response) {
        weakself.orifeeModel = [[CouponOrifeeModel alloc] initWithDictionary:response error:nil];
        [weakself updateBottomView];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)updateBottomView
{
    _label1.text = kLocalizedString(@"Total");
    _amountLabel.text = [self.orifeeModel.totalPrice currency];
    _explainLabel.text = [self.orifeeModel.totalPrice isEqualToString:@"0"] ? kLocalizedString(@"BUY_MORE_TO_ENJOY_DISCOUNT"): [NSString stringWithFormat:@"%@%@",kLocalizedString(@"N_DISCOUNT_APPLIED_AT_CHECKOUT"),[[NSString stringWithFormat:@"%f",self.orifeeModel.couponInfo.discountAmount] currency]];
    [_cartBtn setTitle:[NSString stringWithFormat:@"   %@   ",kLocalizedString(@"SHOPPING_CART")] forState:0];
}
- (IBAction)cartAction:(UIButton *)sender {
    CartViewController *vc = [[CartViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Event
- (void)jumpToFilterDetail {
    //加载缓存配置到数据层
    self.dataModel.filterCache = self.filterCacheModel;
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    MPWeakSelf(self)
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        if (type != CategoryRankFilterRefreshCancel) {
            weakself.dataModel = model;
            weakself.filterCacheModel = weakself.dataModel.filterCache;
            [self.tableView.mj_header beginRefreshing];
        }
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}

- (CategoryRankHeadSelectorView *)headSelectorView {
    if (_headSelectorView == nil) {
        _headSelectorView = [[CategoryRankHeadSelectorView alloc] initWithFrame:CGRectMake(0, 130+navBarHei, MainScreen_width, KScale(64)) type:CategoryRankTypePopularity];
        __weak __typeof(self)weakSelf = self;
        _headSelectorView.clickFilterBlock = ^(CategoryRankType type) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            switch (type) {
                case CategoryRankTypePopularity:
                case CategoryRankTypeSales:
                case CategoryRankTypePriceDescending:
                case CategoryRankTypePriceAscending: {
                    [MBProgressHUD showHudMsg:@"加载中"];
                    strongSelf.currentType = type;
                    [strongSelf.tableView.mj_header beginRefreshing];
                }
                    break;
                case CategoryRankTypeDetail:
                    [strongSelf jumpToFilterDetail];
                    break;
                default:
                    break;
            }
        };
    }
    return _headSelectorView;
}
- (void)loadProductInfoWithModel:(CategoryRankPageInfoListModel *)model
{
    [SFNetworkManager get:[SFNet.offer getDetailOf: model.offerId] parameters:@{} success:^(id  _Nullable response) {
        ProductDetailModel *detailModel = [[ProductDetailModel alloc] initWithDictionary: response error: nil];
        [self requestStockWithDetailModel:detailModel model:model];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
/**
 请求库存信息
 */
- (void)requestStockWithDetailModel:(ProductDetailModel *)detailModel model:(CategoryRankPageInfoListModel *)model {
    NSArray *arr = [detailModel.products jk_map:^id(ProductItemModel *object) {
        cmpShareBuysModel *sbModel = [model.campaigns.cmpShareBuys jk_filter:^BOOL(cmpShareBuysModel *object1) {
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
        @"stdAddrId": self.selAddressModel ? self.selAddressModel.contactStdId : @"1488",
                       @"stores": @[
                           @{
                               @"storeId": @(model.storeId),
                               @"products": arr
                           }
                       ]
    };
    [SFNetworkManager post:SFNet.offer.stock parameters: param success:^(id  _Nullable response) {
        self.stockModel = [ProductStockModel arrayOfModelsFromDictionaries:response error:nil];
        [self showAttrsViewWithAttrType:cartType model:model productModel:detailModel stockModel:self.stockModel];
//        [self.stockModel  enumerateObjectsUsingBlock:^(ProductStockModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
//            [obj1.products enumerateObjectsUsingBlock:^(SingleProductStockModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
//                if (obj2.productId.integerValue == weakself.productId) {
//                    weakself.deliveryLabel.text = [NSString stringWithFormat:@"%@-%@day(s)", obj2.minDeliveryDays, obj2.maxDeliveryDays];
//                    *stop1 = YES;
//                    *stop2 = YES;
//                }
//            }];
//        }];
    } failed:^(NSError * _Nonnull error) {
        
    }];

}

- (void)showAttrsViewWithAttrType:(ProductSpecAttrsType)type model:(CategoryRankPageInfoListModel *)model productModel:(ProductDetailModel *)productDetailModel stockModel:(NSArray<ProductStockModel *> *)stockModel{
    self.selProductModel = [productDetailModel.products jk_filter:^BOOL(ProductItemModel *object) {
        return object.productId == model.productId.integerValue;
    }].firstObject;
    _attrView = [[ProductSpecAttrsView alloc] init];
    _attrView.attrsType = type;
    _attrView.campaignsModel = model.campaigns;
    _attrView.selProductModel = self.selProductModel;
    _attrView.stockModel = stockModel;
    _attrView.model = productDetailModel;
    MPWeakSelf(self)
    MPWeakSelf(_attrView)
    _attrView.buyOrCartBlock = ^(ProductSpecAttrsType type) {
        switch (type) {
            case cartType:// 加入购物车
            {
                [weakself addToCartWithModel:model productModel:productDetailModel];
            }
                break;
            case buyType://购买
//            case groupSingleBuyType://团购活动单人购买
//            case groupBuyType://团购
//            {
//                
//            }
                break;
            default:
                break;
        }
        weak_attrView.dismissBlock();
    };
    _attrView.dismissBlock = ^{
        [weak_attrView removeFromSuperview];
        
        
    };
    _attrView.chooseAttrBlock = ^() {
        weakself.selProductModel = weakself.attrView.selProductModel;
    };
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [rootView addSubview:_attrView];
    [_attrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(rootView);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
}
- (void)addToCartWithModel:(CategoryRankPageInfoListModel *)model productModel:(ProductDetailModel *)productDetailModel
{
    [SFNetworkManager post:SFNet.cart.cart parameters:@{@"isSelected":@"N",@"contactChannel":@"3",@"addon":@"",@"productId":_selProductModel.productId?@(_selProductModel.productId):@"",@"storeId":@(model.storeId),@"offerId":@(model.offerId),@"num":@(self.attrView.count),@"unitPrice":@(_selProductModel.salesPrice)} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"ADD_TO_CART_SUCCESS")];
        [self loadFeeDatas];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage: error.localizedDescription];
    }];
}


- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)addressDataArray {
    if (_addressDataArray == nil) {
        _addressDataArray = [NSMutableArray array];
    }
    return _addressDataArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = RGBColorFrom16(0xffffff);
        [_tableView registerNib:[UINib nibWithNibName:@"UseCouponProductCell" bundle:nil] forCellReuseIdentifier:@"UseCouponProductCell"];
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
- (SFSearchNav *)navSearchView {
    if (_navSearchView == nil) {
        SFSearchItem *backItem = [SFSearchItem new];
        backItem.icon = @"nav_back";
        backItem.itemActionBlock = ^(SFSearchState state, SFSearchModel *model,BOOL isSelected) {
            if (state == SFSearchStateInUnActive || state == SFSearchStateInFocuActive) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        SFSearchItem *rightItem = [SFSearchItem new];
        rightItem.icon = @"more-horizontal";
        rightItem.selectedIcon = @"more-vertical";
        rightItem.itemActionBlock = ^(SFSearchState state, SFSearchModel * _Nullable model,BOOL isSelected) {
            if (isSelected) {
                [self.moreView removeFromSuperview];
                self.moreView = [[BaseMoreView alloc] init];
                [self.tabBarController.view addSubview:self.moreView];
                [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(0);
                    make.top.mas_equalTo(self.navSearchView.mas_bottom);
                }];
            }else{
                [self.moreView removeFromSuperview];
            }
            
        };
        __weak __typeof(self)weakSelf = self;
        _navSearchView = [[SFSearchNav alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, navBarHei + 10) backItme:backItem rightItem:rightItem searchBlock:^(NSString * _Nonnull qs) {
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.searchText = qs;
            [strongSelf.tableView.mj_header beginRefreshing];
        }];
//        _navSearchView.fakeTouchBock = ^{
//            __weak __typeof(weakSelf)strongSelf = weakSelf;
//            //TODO: 搜索未完成
//            CategoryRankViewController *vc = [[CategoryRankViewController alloc] init];
//            vc.shouldBackToHome = YES;
//            [strongSelf.navigationController pushViewController:vc animated:YES];
//        };
//        _navSearchView.searchType = SFSearchTypeFake;
    }
    return _navSearchView;
}

- (BaseMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[BaseMoreView alloc] initWithFrame:CGRectMake(0, self.navSearchView.bottom, MainScreen_width, self.view.height)];
    }
    return _moreView;
}

- (CategoryRankFilterCacheModel *)filterCacheModel {
    if (_filterCacheModel == nil) {
        _filterCacheModel = [[CategoryRankFilterCacheModel alloc] init];
        _filterCacheModel.minPrice = -1;//初始化为-1,传参时,传入@""表示没有指定min价格
        _filterCacheModel.maxPrice = -1;//初始化为-1,传参时,传入@""表示没有指定max价格
    }
    return _filterCacheModel;
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoProductType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
