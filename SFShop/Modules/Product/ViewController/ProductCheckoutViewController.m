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

@interface ProductCheckoutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, readwrite, strong) ProductCheckoutBuyView *buyView;
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) ProductCheckoutModel *dataModel;
@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray<SFCellCacheModel *> *> *dataArray;
@property (nonatomic,strong) ProductCalcFeeModel *feeModel;
@property (nonatomic,strong) addressModel *addressModel;
@property (nonatomic,strong) NSArray<ProductDetailModel *> *productModels;
@property (nonatomic,strong) NSArray<NSNumber *> *productBuyCounts;
@property (nonatomic,strong) NSArray<NSNumber *> *productIds;

@end

@implementation ProductCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Check Out";
    self.view.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    [self loadsubviews];
    [self layout];
    self.buyView.dataModel = self.dataModel;
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
            addressModel: (addressModel *)addressModel
                feeModel:(ProductCalcFeeModel *)feeModel
                   count: (NSArray<NSNumber *> *)productBuyCounts
              sourceType:(NSString *)sourceType {
    // 商品详情
    _productModels = productModels;
    _productBuyCounts = productBuyCounts;
    _productIds = productIds;
    NSMutableArray *arr = [NSMutableArray array];
    [productModels enumerateObjectsUsingBlock:^(ProductDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProductCheckoutSubItemModel *item = [[ProductCheckoutSubItemModel alloc] init];
        item.storeName = obj.storeName;
        item.productCategpry = attrValues[idx];
        item.productTitle = obj.offerName;
        item.priceRp = @"Rp";
        item.productPrice = obj.salesPrice;
        item.productNum = [productBuyCounts[idx] integerValue];
        item.productIcon = SFImage([MakeH5Happy getNonNullCarouselImageOf: obj.carouselImgUrls.firstObject]);
        
        [arr addObject:item];
    }];
    self.dataModel.productList = arr;
    
    self.dataModel.sourceType = sourceType;

    // 地址
    _addressModel = addressModel;
    self.dataModel.address = addressModel.customAddress;
    self.dataModel.email = addressModel.email;

    // 费用
    _feeModel = feeModel;
        
    OrderLogisticsItem * logisticsItem = logisticsModel.logistics.firstObject;
    self.dataModel.priceRp = @"Rp";
    self.dataModel.deliveryTitle = logisticsItem.logisticsModeName;
    self.dataModel.deliveryDes = [NSString stringWithFormat:@"Est.Arrival %@-%@ Days",logisticsItem.minDeliveryDays,logisticsItem.maxDeliveryDays];
    self.dataModel.deliveryPrice = [logisticsItem.logisticsFee floatValue] * 0.001;
    /**
     结算总价这边我做了修改 测试是正常
     **/
    self.dataModel.totalPrice = ([feeModel.totalOfferPrice floatValue] + [logisticsItem.logisticsFee floatValue] - feeModel.totalDiscount.floatValue)  * 0.001;
    self.dataModel.shopAvailableVouchersCount = 0;
    
    [self.tableView reloadData];
}

- (void)showPaymentAlert: (NSDictionary *)orderInfo {
    MPWeakSelf(self)
    NSArray *orders = (NSArray *)orderInfo[@"orders"];
    NSMutableArray *orderIds = [NSMutableArray array];
    for (NSDictionary *dic in orders) {
        [orderIds addObject:dic[@"orderId"]];
    }
//    NSString *orderId = [orders.firstObject valueForKey:@"orderId"];
    NSString *totalPrice = orderInfo[@"totalPrice"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Order Payment Processing" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *mockAction = [UIAlertAction actionWithTitle:@"Mock Pay" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHudMsg:@"Mocking pay..."];
        NSDictionary *params = @{
            @"paymentChannel": @"1",
            @"totalPrice": totalPrice,
            @"paymentMethod": @"1",
            @"orders": orderIds
        };
        [SFNetworkManager post:SFNet.order.mock parameters: params success:^(NSDictionary *  _Nullable response) {
            [MBProgressHUD autoDismissShowHudMsg: @"Mock Pay Success!"];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"Mock Pay Failed!"];
        }];
    }];
    [alert addAction:mockAction];
    UIAlertAction *onlineAction = [UIAlertAction actionWithTitle:@"Online Pay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself onlinePayWithTotalPrice:totalPrice orderId:orderIds];
    }];
    [alert addAction:onlineAction];
    UIAlertAction *cencelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cencelAction];

    [self presentViewController:alert animated:YES completion:nil];
}
- (void)onlinePayWithTotalPrice:(NSString *)totalPrice orderId:(NSArray *)orderIds
{//{"orders":["178013","178014"],"totalPrice":106000,"returnUrl":"https://www.smartfrenshop.com/paying?type=back&orderId=178013"}
    //模拟正式支付
    NSDictionary *params = @{
        @"totalPrice": totalPrice,
        @"returnUrl": [NSString stringWithFormat:@"https://www.smartfrenshop.com/paying?type=back&orderId=%@",orderIds.firstObject],
        @"orders": orderIds
    };
    [SFNetworkManager post:SFNet.h5.pay parameters:params success:^(id  _Nullable response) {
        PublicWebViewController *vc = [[PublicWebViewController alloc] init];
        vc.url = response[@"urlOrHtml"];
        [self.navigationController pushViewController:vc animated:YES];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
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
    cell.updateDataBlock = ^(ProductCheckoutModel * _Nonnull dataModel, SFCellCacheModel * _Nonnull cellModel) {
        self.addressModel.email = dataModel.email;
        //其他更新..
    };
    cell.addressBlock = ^(ProductCheckoutModel * _Nonnull dataModel, SFCellCacheModel * _Nonnull cellModel) {
        AddressViewController *vc = [[AddressViewController alloc] init];
        vc.addressBlock = ^(addressModel * _Nonnull model) {
            self.dataModel.address = model.customAddress;
            self.dataModel.email = model.email;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
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
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCellCacheModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (!model.height) {
        if ([model.cellId isEqualToString:@"ProductCheckoutAddressCell"]) {
            CGFloat addressHeight = [self.dataModel.address calHeightWithFont:[UIFont boldSystemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width - 66 - 16 * 2, 200)];
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
            
            if (!weakself.addressModel.deliveryAddressId || [weakself.addressModel.deliveryAddressId isEqualToString:@""]) {
                [MBProgressHUD autoDismissShowHudMsg:@"Please select your address"];
                return;
            }
            
            if (!weakself.addressModel.email ||  [weakself.addressModel.email isEqualToString:@""]) {
                [MBProgressHUD autoDismissShowHudMsg:@"Please enter your email"];
                return;
            }
            
            NSMutableArray *products = [NSMutableArray array];
            for (int i = 0; i < weakself.productIds.count; i ++) {
                NSNumber *idN = weakself.productIds[i];
                NSNumber *count = weakself.productBuyCounts[i];
                [products addObject:@{@"productId":idN,@"offerCnt":count,@"inCmpIdList":@[]}];
            }
            
            [MBProgressHUD showHudMsg:@"Calculating..."];
            NSNumber *totalPrice = [NSNumber numberWithLong:weakself.dataModel.totalPrice * 1000];
            NSDictionary *params = @{
                @"billingEmail": weakself.addressModel.email,
                @"deliveryAddressId": weakself.addressModel.deliveryAddressId,
                @"deliveryMode": @"A",
                @"paymentMode": @"A",
                @"sourceType": weakself.dataModel.sourceType,
                @"totalPrice": totalPrice,
                @"storeSiteId":@"",
                @"selUserPltCouponId":@"",
                @"stores": @[
                        @{
                            @"logisticsModeId": @"1",
                            @"campaignGifts":@[],
                            @"orderPrice":totalPrice,
                            @"storeId": @(weakself.productModels.firstObject.storeId),
                            @"leaveMsg": @"", // TODO: 这是备注内容
                            @"products": products
                        }
                ],
            };
            [SFNetworkManager post:SFNet.order.save parameters: params success:^(NSDictionary *  _Nullable response) {
                [MBProgressHUD autoDismissShowHudMsg: @"Save order Success!"];
                [weakself showPaymentAlert:response];
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
