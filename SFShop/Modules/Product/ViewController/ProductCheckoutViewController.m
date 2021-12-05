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
#import "NSString+Add.h"
#import "ProductCheckoutSectionHeader.h"
#import "ProductCheckoutBuyView.h"

@interface ProductCheckoutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, readwrite, strong) ProductCheckoutBuyView *buyView;
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) ProductCheckoutModel *dataModel;
@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray<SFCellCacheModel *> *> *dataArray;

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

- (void)setAddressModel:(addressModel *)addressModel {
    _addressModel = addressModel;
    self.dataModel.address = [NSString stringWithFormat:@"%@  %@\n%@ %@ %@ %@ %@ %@ %@", addressModel.contactName, addressModel.contactNbr, addressModel.postCode, addressModel.contactAddress, addressModel.street, addressModel.district, addressModel.city, addressModel.province, addressModel.country];
    self.dataModel.email = addressModel.email;
    [self.tableView reloadData];
}

- (void)setFeeModel:(ProductCalcFeeModel *)feeModel {
    _feeModel = feeModel;
        
    self.dataModel.priceRp = @"Rp";
    self.dataModel.deliveryTitle = @"Standard Delivery";
    self.dataModel.deliveryDes = @"Est.Arrival:2-14 Days";
    self.dataModel.deliveryPrice = [feeModel.stores.firstObject.logisticsFee floatValue] * 0.001;
    self.dataModel.totalPrice = [feeModel.totalPrice floatValue] * 0.001;
    self.dataModel.shopAvailableVouchersCount = 0;
    [self.tableView reloadData];
}

- (void)setProductModels:(NSArray<ProductDetailModel *> *)productModels
               attrValues:(NSArray<NSString *> *)attrValues
                   count: (NSArray<NSNumber *> *) counts {
    NSMutableArray *arr = [NSMutableArray array];
    [productModels enumerateObjectsUsingBlock:^(ProductDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProductCheckoutSubItemModel *item = [[ProductCheckoutSubItemModel alloc] init];
        item.storeName = obj.storeName;
        item.productCategpry = attrValues[idx];
        item.productTitle = obj.offerName;
        item.priceRp = @"Rp";
        item.productPrice = obj.salesPrice;
        item.productNum = [counts[idx] integerValue];
        item.productIcon = obj.storeLogoUrl;
        
        [arr addObject:item];
    }];
    self.dataModel.productList = arr;
    [self.tableView reloadData];
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
