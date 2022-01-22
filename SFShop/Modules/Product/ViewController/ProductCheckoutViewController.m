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
#import "ProductCheckoutSeccessVc.h"

@interface ProductCheckoutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, readwrite, strong) ProductCheckoutBuyView *buyView;
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) ProductCheckoutModel *dataModel;
@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray<SFCellCacheModel *> *> *dataArray;
@end

@implementation ProductCheckoutViewController
- (instancetype)initWithCheckoutModel:(ProductCheckoutModel *)checkoutModel {
    if (self = [super init]) {
        _dataModel = checkoutModel;
    }
    return self;
}

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
    //刷新价格
    [self refreshCalFee];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    ProductDetailModel *detailModel = nil;
    if ([cellModel.obj isKindOfClass:ProductDetailModel.class]) {
        detailModel = cellModel.obj;
    }
    ProductCheckoutBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellId];
    __weak __typeof(self)weakSelf = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataModel = self.dataModel;
    cell.detailModel = detailModel;
    cell.cellModel = cellModel;
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
                    [MBProgressHUD showHudMsg:@""];
                    [CheckoutManager.shareInstance calfeeByStoreCouponItem:item storeId:detailModel.storeId complete:^(BOOL isSuccess, ProductCheckoutModel * _Nonnull checkoutModel) {
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
                    [MBProgressHUD showHudMsg:@""];
                    [CheckoutManager.shareInstance calfeeByAddress:model complete:^(BOOL isSuccess, ProductCheckoutModel * _Nonnull checkoutModel) {
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
    ProductDetailModel *detailModel = nil;
    if ([model.obj isKindOfClass:ProductDetailModel.class]) {
        detailModel = model.obj;
    }
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
            [MBProgressHUD showHudMsg:@""];
            [CheckoutManager.shareInstance calfeeByPltCouponItem:item complete:^(BOOL isSuccess, ProductCheckoutModel * _Nonnull checkoutModel) {
                [strongSelf refreshCalFee];
                [MBProgressHUD hideFromKeyWindow];
            }];
        };
        [self presentViewController:vc animated:YES completion:nil];
    } else if ([model.cellId isEqualToString:@"ProductCheckoutDeliveryCell"]) {
        NSMutableArray *logisticsModels = detailModel.logisticsModel.logistics.mutableCopy;
        if (!logisticsModels.count) {
            [MBProgressHUD autoDismissShowHudMsg:@"None Delivery"];
            return;
        }
        DeleveryViewController *vc = [[DeleveryViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        vc.dataArray = logisticsModels;
        vc.selectedDeleveryBlock = ^(OrderLogisticsItem * _Nullable item) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD showHudMsg:@""];
            [CheckoutManager.shareInstance calfeeByLogistic:item storeId:detailModel.storeId complete:^(BOOL isSuccess, ProductCheckoutModel * _Nonnull checkoutModel) {
                [strongSelf refreshCalFee];
                [MBProgressHUD hideFromKeyWindow];
            }];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCellCacheModel *model = self.dataArray[indexPath.section][indexPath.row];
//    if (!model.height) {
        if ([model.cellId isEqualToString:@"ProductCheckoutAddressCell"]) {
            UIFont *font = [UIFont boldSystemFontOfSize:12];
            CGFloat mailHeight = 30;
            CGSize size = CGSizeMake(MainScreen_width - 66 - 16 * 2, 400);
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0,size.width, 0)];
            textView.text = self.dataModel.addressModel.customAddress;
            textView.font = font;
            CGSize finalSize = [textView sizeThatFits:size];
            CGFloat addressHeight = finalSize.height;
            model.height = 16 + addressHeight + 12 + mailHeight + 6;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutGoodsCell"]) {
            model.height = 118;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutDeliveryCell"]) {
            model.height = 67;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutNoteCell"]) {
            model.height = 153;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutVoucherCell"]) {
            model.height = 44;
        }
//    }

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
            
            //封装商店数据
            NSMutableArray *stores = [NSMutableArray array];
            for (int i = 0; i < weakself.dataModel.productModels.count; i ++) {
                if (weakself.dataModel.feeModel.stores.count != weakself.dataModel.productModels.count) {
                    //数据错误
                    [MBProgressHUD autoDismissShowHudMsg:@"数据错误,请返回重新进入"];
                    return;
                }
                
                NSMutableDictionary *storeDict = [NSMutableDictionary dictionary];
                ProductDetailModel *detailModel = weakself.dataModel.productModels[i];
                ProductCalcFeeStoreModel *feeModel = weakself.dataModel.feeModel.stores[i];
                NSNumber *storeId = @(detailModel.storeId);
                NSString *leaveMsg = detailModel.note? detailModel.note:@"";
                NSString *logisticsModeId = detailModel.currentLogisticsItem.logisticsModeId?detailModel.currentLogisticsItem.logisticsModeId:@"";
                NSString *selUserCouponId = detailModel.currentStoreCoupon.userCouponId > 0? [NSString stringWithFormat:@"%ld",detailModel.currentStoreCoupon.userCouponId] : @"";
                NSMutableArray *products = [NSMutableArray array];
                for (int subIndex = 0; subIndex < detailModel.selectedProducts.count; subIndex ++) {
                    ProductItemModel *item = detailModel.selectedProducts[subIndex];
                    NSNumber *idN = @(item.productId);
                    NSNumber *count = @(item.currentBuyCount);
                    if (item.inCmpIdList && item.inCmpIdList.count > 0) {
                        [products addObject:@{@"productId":idN,@"offerCnt":count,@"inCmpIdList":item.inCmpIdList}];
                    } else {
                        [products addObject:@{@"productId":idN,@"offerCnt":count}];
                    }
                }
                if (detailModel.orderType.length > 0) {
                    [storeDict setObject:detailModel.orderType forKey:@"orderType"];
                }
                if (detailModel.shareBuyMode.length > 0) {
                    [storeDict setObject:detailModel.shareBuyMode forKey:@"shareBuyMode"];
                }
                if (detailModel.shareBuyOrderId.length > 0) {
                    [storeDict setObject:detailModel.shareBuyOrderId forKey:@"shareBuyOrderId"];
                }
                
                [storeDict setObject:storeId forKey:@"storeId"];
                [storeDict setObject:storeId forKey:@"storeId"];
                [storeDict setObject:leaveMsg forKey:@"leaveMsg"];
                [storeDict setObject:selUserCouponId forKey:@"selUserCouponId"];
                [storeDict setObject:logisticsModeId forKey:@"logisticsModeId"];
                [storeDict setObject:@[] forKey:@"campaignGifts"];
                [storeDict setObject:feeModel.orderPrice forKey:@"orderPrice"];
                [storeDict setObject:products forKey:@"products"];
                [stores addObject:storeDict];
            }
            
            //全包价
            NSNumber *totalPrice = [NSNumber numberWithLong:weakself.dataModel.feeModel.totalPrice.longLongValue];
            //平台优惠券id
            NSString *selUserPltCouponId = weakself.dataModel.currentPltCoupon.userCouponId > 0 ? [NSString stringWithFormat:@"%ld",weakself.dataModel.currentPltCoupon.userCouponId] : @"";
            
            //入参
            NSDictionary *params = @{
                @"billingEmail": weakself.dataModel.addressModel.email,
                @"deliveryAddressId": weakself.dataModel.addressModel.deliveryAddressId,
                @"deliveryMode": @"A",
                @"paymentMode": @"A",
                @"sourceType": weakself.dataModel.sourceType,
                @"totalPrice": totalPrice,
                @"storeSiteId":@"",
                @"selUserPltCouponId":selUserPltCouponId,
                @"stores": stores,
            };

            [MBProgressHUD showHudMsg:@""];
            [SFNetworkManager post:SFNet.order.save parameters: params success:^(NSDictionary *  _Nullable response) {
                [MBProgressHUD hideFromKeyWindow];
                NSArray *orders = (NSArray *)response[@"orders"];
                NSMutableArray *orderIds = [NSMutableArray array];
                for (NSDictionary *dic in orders) {[orderIds addObject:dic[@"orderId"]];}//订单id 数组
                NSString *totalPrice = [NSString stringWithFormat:@"%@",[response objectForKey:@"totalPrice"]];//总价
                NSString *shareBuyOrderNbr = [orders.firstObject objectForKey:@"shareBuyOrderNbr"];//分享号
                [MBProgressHUD hideFromKeyWindow];
                [CheckoutManager.shareInstance startPayWithOrderIds:orderIds shareBuyOrderNbr:shareBuyOrderNbr totalPrice:totalPrice complete:^(SFPayResult result, NSString * _Nonnull urlOrHtml) {
                    switch (result) {
                        case SFPayResultSuccess:{
                            ProductCheckoutSeccessVc *vc = [[ProductCheckoutSeccessVc alloc] init];
                            vc.infoDic = response;
                            vc.GroupBuyGroupNbr = shareBuyOrderNbr;
                            [weakself.navigationController pushViewController:vc animated:YES];
                        }
                            
//                            [SceneManager transToHome];
                            break;
                        case SFPayResultFailed:
                            break;
                        case SFPayResultJumpToWebPay: {
                            PublicWebViewController *vc = [[PublicWebViewController alloc] init];
                            vc.url = urlOrHtml;
                            vc.shouldBackToHome = YES;
                            [weakself.navigationController pushViewController:vc animated:YES];
                        }
                            break;
                        default:
                            break;
                    }
                }];
            } failed:^(NSError * _Nonnull error) {
                [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
            }];
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
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        NSMutableArray<ProductDetailModel *> *productModels = self.dataModel.productModels.mutableCopy;
        NSMutableArray *cellIds = [NSMutableArray array];
        [cellIds addObject:@"ProductCheckoutAddressCell"];
        for (int i = 0; i < productModels.count; i ++) {
            [cellIds addObject:@"ProductCheckoutGoodsCell"];
            [cellIds addObject:@"ProductCheckoutDeliveryCell"];
            [cellIds addObject:@"ProductCheckoutNoteCell"];
        }
        [cellIds addObject:@"ProductCheckoutVoucherCell"];
        NSInteger productIndex = 0;
        for (int i = 0; i < cellIds.count; i ++) {
            NSString *cellId = cellIds[i];
            ProductDetailModel *productModel = (productModels.count > productIndex)? productModels[productIndex] : nil;
            if ([cellId isEqualToString:@"ProductCheckoutGoodsCell"]) {
                NSMutableArray *pList = [NSMutableArray array];
                if (productModels.count > 0) {
                    for (ProductItemModel *item in productModel.selectedProducts) {
                        SFCellCacheModel *model = [SFCellCacheModel new];
                        model.cellId = cellId;
                        model.obj = item;
                        [pList addObject:model];
                    }
                }
                [_dataArray addObject:pList];
            }
            else if ([cellId isEqualToString:@"ProductCheckoutDeliveryCell"] || [cellId isEqualToString:@"ProductCheckoutNoteCell"]) {
                SFCellCacheModel *model = [SFCellCacheModel new];
                model.cellId = cellId;
                model.obj = productModel;
                [_dataArray addObject:[NSMutableArray arrayWithObject:model]];
                if ([cellId isEqualToString:@"ProductCheckoutNoteCell"]) {
                    productIndex ++;
                }
            }
            else {
                SFCellCacheModel *model = [SFCellCacheModel new];
                model.cellId = cellId;
                [_dataArray addObject:[NSMutableArray arrayWithObject:model]];
            }
        }
    }
    return _dataArray;
}

@end
