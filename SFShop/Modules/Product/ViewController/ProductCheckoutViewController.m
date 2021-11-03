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
        _dataModel.address = @"这是一个测试地址,测试地址\n 第二行是嘎时光 \n 第三行:撒发顺丰啊师傅";
        _dataModel.email = @"www.baidu.com";
        ProductCheckoutSubItemModel *item = [[ProductCheckoutSubItemModel alloc] init];
        item.productCategpry = @"HK";
        item.productTitle = @"这是标题萨法嘎嘎嘎嘎是嘎贵卅是嘎阿萨是嘎是嘎说";
        item.productTitle = @"这是标题萨法嘎嘎嘎嘎是嘎贵卅是嘎阿萨是嘎是嘎说";
        item.priceRp = @"Rp";
        item.productPrice = 1000.123;
        item.productNum = 3;
        item.productIcon = @"https://scpic.chinaz.net/Files/pic/icons128/8090/m6.png";
        item.storeName = @"storeName";
        
        _dataModel.priceRp = @"Rp";
        _dataModel.deliveryDes = @"萨嘎是个哈看就是高科技啊司空见惯黑科技";
        _dataModel.deliveryTitle = @"萨嘎了三个哈开始更健康";
        _dataModel.deliveryPrice = 144;
        
        _dataModel.vouchersReduce = 0;
        _dataModel.promoReduce = 0;
        _dataModel.availableVouchersCount = 0;
        _dataModel.productList = @[item,item,item];
        
        _dataModel.shopAvailableVouchersCount = 2;
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
    if (_dataArray == nil) {
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
    }
    return _dataArray;
}

@end
