//
//  ProductCheckoutViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutViewController.h"
#import "ProductCheckoutAddressCell.h"
#import "ProductCheckoutGoodsCell.h"
#import "ProductCheckoutDeliveryCell.h"
#import "ProductCheckoutNoteCell.h"
#import "ProductCheckoutVoucherCell.h"
#import "ProductCheckoutModel.h"
#import "SFCellCacheModel.h"
#import "ProductCheckoutSectionHeader.h"
#import "ProductCheckoutBuyView.h"
#import "MakeH5Happy.h"
#import "PublicWebViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AddressViewController.h"
#import "CouponsViewController.h"
#import "DeleveryViewController.h"
#import "CheckoutManager.h"
#import "SceneManager.h"

@interface ProductCheckoutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, readwrite, strong) ProductCheckoutBuyView *buyView;
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) ProductCheckoutModel *dataModel;
@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray<SFCellCacheModel *> *> *dataArray;
@end

@implementation ProductCheckoutViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizedString(@"Check_out");
    self.view.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    [self loadsubviews];
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Setter
- (void)setProductModels:(NSArray<ProductDetailModel *> *)productModels
               attrValues:(NSArray<NSString *> *)attrValues
               productIds:(NSArray<NSNumber *> *) productIds
          logisticsModel:(OrderLogisticsModel *)logisticsModel
             couponModel:(CouponsAvailableModel *)couponModel
            addressModel: (addressModel *)addressModel
                feeModel:(ProductCalcFeeModel *)feeModel
                   count: (NSArray<NSNumber *> *)productBuyCounts
            inCmpIdLists:(nullable NSArray<NSNumber *> *)inCmpIdLists
            deliveryMode:(NSString *)deliveryMode
                currency:(NSString *)currency
              sourceType:(NSString *)sourceType {
    // 商品详情
    NSMutableArray *arr = [NSMutableArray array];
    [productModels enumerateObjectsUsingBlock:^(ProductDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProductCheckoutSubItemModel *item = [[ProductCheckoutSubItemModel alloc] init];
        item.storeName = obj.storeName;
        item.productCategpry = attrValues[idx];
        item.productTitle = obj.offerName;
        item.priceRp = kLocalizedString(@"Rp");
        item.productPrice = obj.salesPrice;
        item.productNum = [productBuyCounts[idx] integerValue];
        item.productIcon = SFImage([MakeH5Happy getNonNullCarouselImageOf: obj.carouselImgUrls.firstObject]);
        [arr addObject:item];
    }];
    
    //商品列表
    self.dataModel.productList = arr;
    
    //类型
    self.dataModel.sourceType = sourceType;
    
    //配送类型
    self.dataModel.deliveryMode = deliveryMode;
    
    //商品数量
    self.dataModel.productBuyCounts = productBuyCounts;
    
    //商品ids
    self.dataModel.productIds = productIds;
    
    //商品models
    self.dataModel.productModels = productModels;
    
    //货币
    self.dataModel.currency = currency;
    
    //优惠券
    self.dataModel.couponsModel = couponModel;

    //地址
    self.dataModel.addressModel = addressModel;
    
    //配送
    self.dataModel.logisticsModel = logisticsModel;

    //费用
    self.dataModel.feeModel = feeModel;

    //刷新价格
    [self refreshCalFee];
}

//刷新价格
- (void)refreshCalFee {
    self.buyView.dataModel = self.dataModel;
    [self.tableView reloadData];
}

- (void)showPaymentAlert:(NSDictionary *)orderInfo methods:(NSArray *)methodsResponse {
    MPWeakSelf(self)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kLocalizedString(@"Order_payment_processing") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *method in methodsResponse) {
        NSString *paymentChannelCode = [method objectForKey:@"paymentChannelCode"];
        NSArray *list = [method objectForKey:@"paymentMethodList"];
        for (NSDictionary *payment in list) {
            NSString *paymentMethodCode = [payment objectForKey:@"paymentMethodCode"];
            NSString *paymentMethodName = [payment objectForKey:@"paymentMethodName"];
            UIAlertAction *action = [UIAlertAction actionWithTitle:paymentMethodName style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [weakself pay:orderInfo paymentChannel:paymentChannelCode paymentMethod:paymentMethodCode];
            }];
            [alert addAction:action];
        }
    }

    UIAlertAction *cencelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cencelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pay:(NSDictionary *)orderInfo  paymentChannel:(NSString *)paymentChannel paymentMethod:(NSString *)paymentMethod {
    //{"orders":["178013","178014"],"totalPrice":106000,"returnUrl":"https://www.smartfrenshop.com/paying?type=back&orderId=178013"}
    NSArray *orders = (NSArray *)orderInfo[@"orders"];
    NSMutableArray *orderIds = [NSMutableArray array];
    for (NSDictionary *dic in orders) {[orderIds addObject:dic[@"orderId"]];}//订单id 数组
    NSString *shareBuyOrderNbr = [orders.firstObject objectForKey:@"shareBuyOrderNbr"];//sharebuy
    NSString *returnUrl = nil;
    if (![shareBuyOrderNbr isKindOfClass:[NSNull class]] && shareBuyOrderNbr.length > 0) {
        returnUrl = [NSString stringWithFormat:@"%@?type=back&orderId=%@&shareBuyOrderNbr=%@",Host,orderIds.firstObject,shareBuyOrderNbr];
    } else {
        returnUrl = [NSString stringWithFormat:@"%@?type=back&orderId=%@",Host,orderIds.firstObject];
    }
    NSString *totalPrice = orderInfo[@"totalPrice"];//总价
    NSDictionary *params = @{
        @"paymentMethod":paymentMethod?paymentMethod:@"-1",
        @"paymentChannel":paymentChannel?paymentChannel:@"-1",
        @"totalPrice": totalPrice,
        @"returnUrl": returnUrl,
        @"orders": orderIds
    };
    [MBProgressHUD showHudMsg:@""];
    [SFNetworkManager post:SFNet.h5.pay parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSString *urlOrHtml = response[@"urlOrHtml"];
        if (![urlOrHtml isKindOfClass:[NSNull class]] && urlOrHtml.length > 0) {
            PublicWebViewController *vc = [[PublicWebViewController alloc] init];
            vc.url = urlOrHtml;
            vc.shouldBackToHome = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self confirmPay:orderIds];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

- (void)confirmPay:(NSArray *)orderIds {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kLocalizedString(@"Order_payment_processing") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kLocalizedString(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHudMsg:@""];
        [SFNetworkManager post:SFNet.order.confirm parametersArr:orderIds success:^(id  _Nullable response) {
            [MBProgressHUD autoDismissShowHudMsg:@"支付成功"];
            [SceneManager transToHome];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
        }];
    }];
    [alert addAction:okAction];
    UIAlertAction *calcelAction = [UIAlertAction actionWithTitle:kLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD autoDismissShowHudMsg:@"支付失败"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SceneManager transToHome];
//        });
    }];
    [alert addAction:calcelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Loadsubviews
- (void)loadsubviews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buyView];
}

- (void)layout {
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(78);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.buyView.mas_top);
        make.top.mas_equalTo(navBarHei);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCellCacheModel *cellModel = self.dataArray[indexPath.section][indexPath.row];
    ProductCheckoutBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellId];
    __weak __typeof(self)weakSelf = self;
    cell.eventBlock = ^(ProductCheckoutModel * _Nonnull dataModel, SFCellCacheModel * _Nonnull cellModel, ProductCheckoutCellEvent event) {
        switch (event) {
            case ProductCheckoutCellEvent_GotoStoreVoucher: {
                CouponsViewController *vc = [[CouponsViewController alloc] init];
                NSMutableArray *availableCoupons = self.dataModel.couponsModel.storeAvailableCoupons.firstObject.availableCoupons.mutableCopy;
                if (!availableCoupons.count) {
                    [MBProgressHUD autoDismissShowHudMsg:@"None Coupons"];
                    return;
                }
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
                vc.dataArray = availableCoupons;
                vc.selectedCouponBlock = ^(CouponItem * _Nullable item) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    strongSelf.dataModel.currentStoreCoupon = item;
                    NSString *userCouponId = nil;
                    if (item.userCouponId > 0) {
                        userCouponId = [NSString stringWithFormat:@"%ld",item.userCouponId];
                    }
                    [MBProgressHUD showHudMsg:@""];
                    [CheckoutManager.shareInstance calfeeBySelUserCouponId:userCouponId complete:^(ProductCalcFeeModel * _Nonnull feeModel) {
                        strongSelf.dataModel.feeModel = feeModel;
                        [strongSelf refreshCalFee];
                        [MBProgressHUD hideFromKeyWindow];
                    }];
                };
                [self presentViewController:vc animated:YES completion:nil];
            }
                break;
            case ProductCheckoutCellEvent_GotoAddress: {
                AddressViewController *vc = [[AddressViewController alloc] init];
                vc.addressBlock = ^(addressModel * _Nonnull model) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    strongSelf.dataModel.addressModel = model;
                    [MBProgressHUD showHudMsg:@""];
                    [CheckoutManager.shareInstance calfeeByAddress:model.deliveryAddressId complete:^(ProductCalcFeeModel * _Nonnull feeModel, OrderLogisticsModel * _Nullable logisticsModel) {
                        strongSelf.dataModel.logisticsModel = logisticsModel;
                        strongSelf.dataModel.feeModel = feeModel;
                        [strongSelf refreshCalFee];
                        [MBProgressHUD hideFromKeyWindow];
                    }];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;

            default:
                break;
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataModel = self.dataModel;
    cell.cellModel = cellModel;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SFCellCacheModel *cellModel = self.dataArray[section].firstObject;
    if ([cellModel.cellId isEqualToString:@"ProductCheckoutAddressCell"] ||
        [cellModel.cellId isEqualToString:@"ProductCheckoutGoodsCell"] ||
        [cellModel.cellId isEqualToString:@"ProductCheckoutDeliveryCell"]) {
        ProductCheckoutSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ProductCheckoutSectionHeader"];
        header.cellModel = cellModel;
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    footer.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SFCellCacheModel *cellModel = self.dataArray[section].firstObject;
    if ([cellModel.cellId isEqualToString:@"ProductCheckoutAddressCell"] ||
        [cellModel.cellId isEqualToString:@"ProductCheckoutGoodsCell"] ||
        [cellModel.cellId isEqualToString:@"ProductCheckoutDeliveryCell"]) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SFCellCacheModel *cellModel = self.dataArray[section].firstObject;
    if ([cellModel.cellId isEqualToString:@"ProductCheckoutAddressCell"] ||
        [cellModel.cellId isEqualToString:@"ProductCheckoutNoteCell"]) {
        return 12;
    } else if ([cellModel.cellId isEqualToString:@"ProductCheckoutVoucherCell"]) {
        return 25;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCellCacheModel *model = self.dataArray[indexPath.section][indexPath.row];
    __weak __typeof(self)weakSelf = self;
    if ([model.cellId isEqualToString:@"ProductCheckoutVoucherCell"]) {
        NSMutableArray *pltAvailableCoupons = self.dataModel.couponsModel.pltAvailableCoupons.mutableCopy;
        if (!pltAvailableCoupons.count) {
            [MBProgressHUD autoDismissShowHudMsg:@"None Vouchers"];
            return;
        }
        CouponsViewController *vc = [[CouponsViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        vc.dataArray = pltAvailableCoupons;
        vc.selectedCouponBlock = ^(CouponItem * _Nullable item) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.dataModel.currentPltCoupon = item;
            NSString *userCouponId = nil;
            if (item.userCouponId > 0) {
                userCouponId = [NSString stringWithFormat:@"%ld",item.userCouponId];
            }
            [MBProgressHUD showHudMsg:@""];
            [CheckoutManager.shareInstance calfeeBySelUserPltCouponId:userCouponId complete:^(ProductCalcFeeModel * _Nonnull feeModel) {
                strongSelf.dataModel.feeModel = feeModel;
                [strongSelf refreshCalFee];
                [MBProgressHUD hideFromKeyWindow];
            }];
        };
        [self presentViewController:vc animated:YES completion:nil];
    } else if ([model.cellId isEqualToString:@"ProductCheckoutDeliveryCell"]) {
        NSMutableArray *logisticsModel = self.dataModel.logisticsModel.logistics.mutableCopy;
        if (!logisticsModel.count) {
            [MBProgressHUD autoDismissShowHudMsg:@"None Delivery"];
            return;
        }
        DeleveryViewController *vc = [[DeleveryViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        vc.dataArray = logisticsModel;
        vc.selectedDeleveryBlock = ^(OrderLogisticsItem * _Nullable item) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.dataModel.currentLogisticsItem = item;
            [MBProgressHUD showHudMsg:@""];
            [CheckoutManager.shareInstance calfeeByLogistic:item.logisticsModeId complete:^(ProductCalcFeeModel * _Nonnull feeModel) {
                strongSelf.dataModel.feeModel = feeModel;
                [strongSelf refreshCalFee];
                [MBProgressHUD hideFromKeyWindow];
            }];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCellCacheModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (!model.height) {
        if ([model.cellId isEqualToString:@"ProductCheckoutAddressCell"]) {
            CGFloat addressHeight = [self.dataModel.addressModel.customAddress calHeightWithFont:[UIFont boldSystemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width - 66 - 16 * 2, 200)];
            CGFloat mailHeight = 30;
            model.height = 21 + addressHeight + 12 + mailHeight + 16;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutGoodsCell"]) {
            model.height = 118;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutDeliveryCell"]) {
            model.height = 67;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutNoteCell"]) {
            model.height = 153;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutVoucherCell"]) {
            model.height = 44;
        }
    }

    return  model.height;
}

#pragma mark - Getter & Setter
- (ProductCheckoutModel *)dataModel {
    if (_dataModel == nil) {
        _dataModel = ProductCheckoutModel.new;
    }
    return _dataModel;
}

- (ProductCheckoutBuyView *)buyView {
    if (_buyView == nil) {
        _buyView = [[ProductCheckoutBuyView alloc] init];
        _buyView.backgroundColor = [UIColor whiteColor];
        MPWeakSelf(self)
        _buyView.buyBlock = ^{
            
            if (!weakself.dataModel.addressModel.deliveryAddressId || [weakself.dataModel.addressModel.deliveryAddressId isEqualToString:@""]) {
                [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Please_select_your_address")];
                return;
            }
            
            if (!weakself.dataModel.addressModel.email ||  [weakself.dataModel.addressModel.email isEqualToString:@""]) {
                [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Please_enter_your_email")];
                return;
            }
            
            NSMutableArray *products = [NSMutableArray array];
            for (int i = 0; i < weakself.dataModel.productIds.count; i ++) {
                NSNumber *idN = weakself.dataModel.productIds[i];
                NSNumber *count = weakself.dataModel.productBuyCounts[i];
                if (weakself.dataModel.inCmpIdList.count > i && weakself.dataModel.inCmpIdList[i].intValue > 0) {
                    NSNumber *inCmpIdList = weakself.dataModel.inCmpIdList[i];
                    [products addObject:@{@"productId":idN,@"offerCnt":count,@"inCmpIdList":@[inCmpIdList]}];
                } else {
                    [products addObject:@{@"productId":idN,@"offerCnt":count}];
                }
            }
            
            NSString *leaveMsg = weakself.dataModel.notes?weakself.dataModel.notes:@"";
            NSNumber *storeId = @(weakself.dataModel.productModels.firstObject.storeId);
            NSNumber *totalPrice = [NSNumber numberWithLong:weakself.dataModel.feeModel.totalPrice.longLongValue];
            NSString *logisticsModeId = weakself.dataModel.currentLogisticsItem.logisticsModeId?weakself.dataModel.currentLogisticsItem.logisticsModeId:@"";
            NSString *selUserPltCouponId = @"";
            if (weakself.dataModel.currentPltCoupon.userCouponId > 0) {
                selUserPltCouponId = [NSString stringWithFormat:@"%ld",weakself.dataModel.currentPltCoupon.userCouponId];
            }
            NSString *selUserCouponId = @"";
            if (weakself.dataModel.currentStoreCoupon.userCouponId > 0) {
                selUserCouponId = [NSString stringWithFormat:@"%ld",weakself.dataModel.currentStoreCoupon.userCouponId];
            }
            
            [MBProgressHUD showHudMsg:kLocalizedString(@"Calculating")];
            NSDictionary *params = @{
                @"billingEmail": weakself.dataModel.addressModel.email,
                @"deliveryAddressId": weakself.dataModel.addressModel.deliveryAddressId,
                @"deliveryMode": @"A",//weakself.dataModel.deliveryMode,
                @"paymentMode": @"A",
                @"sourceType": weakself.dataModel.sourceType,
                @"totalPrice": totalPrice,
                @"storeSiteId":@"",
                @"selUserPltCouponId":selUserPltCouponId,
                @"stores": @[
                        @{
                            @"selUserCouponId":selUserCouponId,
                            @"logisticsModeId":logisticsModeId,
                            @"campaignGifts":@[],
                            @"orderPrice":totalPrice,
                            @"storeId": storeId,
                            @"leaveMsg": leaveMsg,
                            @"products": products
                        }
                ],
            };
            
            __block BOOL isShowPayChannel = NO;
            __block NSArray *methods = nil;
            __block NSDictionary *orderInfo = nil;
            dispatch_group_t group = dispatch_group_create();

            //获取支付渠道
            dispatch_group_enter(group);
            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                [SFNetworkManager get:SFNet.order.method success:^(id  _Nullable response) {
                    methods = (NSArray *)response;
                    isShowPayChannel = methods.count > 1;
                    dispatch_group_leave(group);
                } failed:^(NSError * _Nonnull error) {
                    [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
                    dispatch_group_leave(group);
                }];
            });
            
            //下单
            dispatch_group_enter(group);
            dispatch_group_async(group, dispatch_get_main_queue(), ^{
                [SFNetworkManager post:SFNet.order.save parameters: params success:^(NSDictionary *  _Nullable response) {
                    [MBProgressHUD hideFromKeyWindow];
                    orderInfo = response;
                    dispatch_group_leave(group);
                } failed:^(NSError * _Nonnull error) {
                    [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
                    dispatch_group_leave(group);
                }];
            });
            
            //接口回调
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if (!orderInfo) {return;}
                if (!methods || !methods.count) {return;}

                if (isShowPayChannel) {
                    [weakself showPaymentAlert:orderInfo methods:methods];
                } else {
                    NSDictionary *method = methods.firstObject;
                    NSArray *list = [method objectForKey:@"paymentMethodList"];
                    NSString *paymentChannelCode = [method objectForKey:@"paymentChannelCode"];
                    NSString *paymentMethodCode = [list.firstObject objectForKey:@"paymentMethodCode"];
                    [weakself pay:orderInfo paymentChannel:paymentChannelCode paymentMethod:paymentMethodCode];
                }
            });
        };
    }
    return _buyView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        _tableView.backgroundView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:ProductCheckoutAddressCell.class forCellReuseIdentifier:@"ProductCheckoutAddressCell"];
        [_tableView registerClass:ProductCheckoutGoodsCell.class forCellReuseIdentifier:@"ProductCheckoutGoodsCell"];
        [_tableView registerClass:ProductCheckoutDeliveryCell.class forCellReuseIdentifier:@"ProductCheckoutDeliveryCell"];
        [_tableView registerClass:ProductCheckoutNoteCell.class forCellReuseIdentifier:@"ProductCheckoutNoteCell"];
        [_tableView registerClass:ProductCheckoutVoucherCell.class forCellReuseIdentifier:@"ProductCheckoutVoucherCell"];
        [_tableView registerClass:ProductCheckoutSectionHeader.class forHeaderFooterViewReuseIdentifier:@"ProductCheckoutSectionHeader"];
        [_tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];

    }
    return _tableView;
}

- (NSMutableArray<NSMutableArray<SFCellCacheModel *> *> *)dataArray {
//    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        NSArray *arr = @[@"ProductCheckoutAddressCell",@"ProductCheckoutGoodsCell",@"ProductCheckoutDeliveryCell",@"ProductCheckoutNoteCell",@"ProductCheckoutVoucherCell"];
        for (NSString *obj in arr) {
            if ([obj isEqualToString:@"ProductCheckoutGoodsCell"]) {
                NSMutableArray *pList = [NSMutableArray array];
                for (ProductCheckoutSubItemModel *item in self.dataModel.productList) {
                    SFCellCacheModel *model = [SFCellCacheModel new];
                    model.cellId = obj;
                    model.obj = item;
                    [pList addObject:model];
                }
                [_dataArray addObject:pList];
            } else {
                SFCellCacheModel *model = [SFCellCacheModel new];
                model.cellId = obj;
                [_dataArray addObject:[NSMutableArray arrayWithObject:model]];
            }
        }
//    }
    return _dataArray;
}

@end
