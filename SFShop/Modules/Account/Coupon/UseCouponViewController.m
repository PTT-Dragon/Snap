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


@interface UseCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredDataLabel;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (nonatomic, readwrite, strong) CategoryRankHeadSelectorView *headSelectorView;
@property (nonatomic, readwrite, assign) CategoryRankType currentType;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@property (nonatomic, readwrite, strong) NSMutableArray *addressDataArray;
@property (nonatomic, readwrite, assign) NSInteger currentPage;
@property (nonatomic, strong) ProductSpecAttrsView *attrView;
@property (nonatomic,strong) addressModel *selAddressModel;
@property (nonatomic, strong) NSArray<ProductStockModel *> *stockModel;
@property (nonatomic,strong) ProductItemModel *selProductModel;

@end

@implementation UseCouponViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadsubviews];
}
- (void)loadsubviews {
    self.couponView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    self.couponView.layer.borderWidth = 1;
    if ([self.couponModel.discountMethod isEqualToString:@"DISC"]) {
        _couponNameLabel.text = [NSString stringWithFormat:@"Discount %@ Min.spend %@",[[NSString stringWithFormat:@"%.0f",self.couponModel.discountAmount] currency],[[NSString stringWithFormat:@"%@f",self.couponModel.thAmount] currency]];
    }else{
        _couponNameLabel.text = [NSString stringWithFormat:@"Discount %@ Without limit",[[NSString stringWithFormat:@"%.0f",self.couponModel.discountAmount] currency]];
    }
    self.expiredDataLabel.text = [NSString stringWithFormat:@"%@~%@",[[NSDate dateFromString:self.couponModel.effDate] dayMonthYear],[[NSDate dateFromString:self.couponModel.expDate] dayMonthYear]];
    [self.view addSubview:self.headSelectorView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
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
    
    [self.tableView.mj_header beginRefreshing];
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
        @"q": @"",
        @"pageIndex": @(currentPage),
        @"pageSize": @(10),
        @"sortType": [NSString stringWithFormat:@"%ld",type],
        @"offerIdList": [NSNull null],
//        @"catgIds": @(self.model.inner.catgId),//默认是外部传入的分类,如果 filter.filterParam 有该字段,会被新值覆盖
        @"couponId":self.couponModel.couponId
    }];
    [parm addEntriesFromDictionary:filter.filterParam];
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        self.dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArray addObjectsFromArray:self.dataModel.pageInfo.list];
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:error.localizedDescription];
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

#pragma mark - Event
- (void)jumpToFilterDetail {
    //加载缓存配置到数据层
    self.dataModel.filterCache = self.filterCacheModel;
    
    CategoryRankPriceModel *priceModel = [CategoryRankPriceModel new];
    priceModel.minPrice = self.filterCacheModel.minPrice;
    priceModel.maxPrice = self.filterCacheModel.maxPrice;
    self.dataModel.priceModel = priceModel;
    for (CategoryRankServiceModel *model in self.dataModel.serviceIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.serverId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankCategoryModel *model in self.dataModel.catgIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.categoryId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankBrandModel *model in self.dataModel.brandIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.brandId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankEvaluationModel *model in self.dataModel.evaluations) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.evaluationId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        if (type != CategoryRankFilterRefreshCancel) {
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
        [MBProgressHUD autoDismissShowHudMsg:@"ADD SUCCESS"];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
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
@end
