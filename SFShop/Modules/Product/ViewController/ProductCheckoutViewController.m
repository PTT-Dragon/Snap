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

@interface ProductCheckoutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) ProductCheckoutModel *dataModel;
@property (nonatomic, readwrite, strong) NSMutableArray<SFCellCacheModel *> *dataArray;

@end

@implementation ProductCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadsubviews];
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Loadsubviews
- (void)loadsubviews {
    [self.view addSubview:self.tableView];
}

- (void)layout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(navBarHei);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return !self.dataModel ?: 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCheckoutBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:self.dataArray[indexPath.row].cellId];
    cell.dataModel = self.dataModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCellCacheModel *model = self.dataArray[indexPath.row];
    if (!model.height) {
        if ([model.cellId isEqualToString:@"ProductCheckoutAddressCell"]) {
            CGFloat addressHeight = [self.dataModel.address calHeightWithFont:[UIFont boldSystemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width - 50 - 16 * 2, 200)];
            CGFloat mailHeight = 30;
            model.height = 45 + addressHeight + 12 + mailHeight + 16;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutGoodsCell"]) {
            model.height = 45 + 30;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutDeliveryCell"]) {
            model.height = 45 + 30;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutNoteCell"]) {
            model.height = 45 + 30;
        } else if ([model.cellId isEqualToString:@"ProductCheckoutVoucherCell"]) {
            model.height = 45 + 30;
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
    }
    return _dataModel;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:ProductCheckoutAddressCell.class forCellReuseIdentifier:@"ProductCheckoutAddressCell"];
        [_tableView registerClass:ProductCheckoutGoodsCell.class forCellReuseIdentifier:@"ProductCheckoutGoodsCell"];
        [_tableView registerClass:ProductCheckoutDeliveryCell.class forCellReuseIdentifier:@"ProductCheckoutDeliveryCell"];
        [_tableView registerClass:ProductCheckoutNoteCell.class forCellReuseIdentifier:@"ProductCheckoutNoteCell"];
        [_tableView registerClass:ProductCheckoutVoucherCell.class forCellReuseIdentifier:@"ProductCheckoutVoucherCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        NSArray *arr = @[@"ProductCheckoutAddressCell",@"ProductCheckoutGoodsCell",@"ProductCheckoutDeliveryCell",@"ProductCheckoutNoteCell"];
        for (NSString *obj in arr) {
            SFCellCacheModel *model = [SFCellCacheModel new];
            model.cellId = obj;
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

@end
