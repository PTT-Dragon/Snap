//
//  RelationOrderDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/4.
//

#import "RelationOrderDetailViewController.h"
#import "DistributorModel.h"
#import "OrderModel.h"
#import "RelationOrderDetailStateCell.h"
#import "RelationOrderDetailInfoCell.h"
#import "RelationOrderDetailProductCell.h"
#import "OrderListStateCell.h"
#import "NSString+Fee.h"
#import "OrderDetailTitleCell.h"


@interface RelationOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RelationOrderDetailModel *model;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *infomationArr;
@property (nonatomic,strong) NSMutableArray *productInfoArr;
@end

@implementation RelationOrderDetailViewController

- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Order_details");
    _infomationArr = [NSMutableArray array];
    _productInfoArr = [NSMutableArray array];
    [self initUI];
    [self loadDatas];
    
}
- (void)initUI
{
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RelationOrderDetailInfoCell" bundle:nil] forCellReuseIdentifier:@"RelationOrderDetailInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RelationOrderDetailStateCell" bundle:nil] forCellReuseIdentifier:@"RelationOrderDetailStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RelationOrderDetailProductCell" bundle:nil] forCellReuseIdentifier:@"RelationOrderDetailProductCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailTitleCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailTitleCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        RelationOrderDetailStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationOrderDetailStateCell"];
        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            OrderDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTitleCell"];
            return cell;
        }
        RelationOrderDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationOrderDetailInfoCell"];
        cell.infoDic = self.infomationArr[indexPath.row-1];
        return cell;
    }else if (indexPath.row == 0){
        OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
        [cell setRelationOrderDetailContent:self.model.orderDetail];
        return cell;
    }else if (indexPath.row > self.model.orderDetail.orderItems.count){
        RelationOrderDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationOrderDetailInfoCell"];
        cell.infoDic = self.productInfoArr[indexPath.row-self.model.orderDetail.orderItems.count-1];
        return cell;
    }
    RelationOrderDetailProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationOrderDetailProductCell"];
    cell.model = self.model.orderDetail.orderItems[indexPath.row-1];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 2 ? 1: section == 0 ? self.model.orderDetail.orderItems.count+self.productInfoArr.count+1: self.infomationArr.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 2 ? 69: indexPath.section == 1 ? 33: indexPath.row == 0 ? 40: indexPath.row > self.model.orderDetail.orderItems.count ? 33: 154;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width-32, 12)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.orderDetail parameters:@{@"orderId":_orderId} success:^(id  _Nullable response) {
        weakself.model = [RelationOrderDetailModel yy_modelWithDictionary:response];
        [weakself handleDatas];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)handleDatas
{
//    [self.infomationArr addObject:@{@"title":@"Order code",@"value":self.model.orderNbr}];
//    [self.infomationArr addObject:@{@"title":@"Creation time",@"value":self.model.createdDate}];
//    [self.infomationArr addObject:@{@"title":@"Payment time",@"value":self.model.orderNbr}];
//    [self.infomationArr addObject:@{@"title":@"Order completion time",@"value":self.model.orderDetail.completionDate}];
    [self.infomationArr addObjectsFromArray:@[@{kLocalizedString(@"ORDER_CODE"):self.model.orderNbr},@{kLocalizedString(@"CREATION_TIME"):self.model.createdDate},@{kLocalizedString(@"PAYER_EMAIL"):self.model.orderDetail.billAddress.contactEmail},@{kLocalizedString(@"PAYMENT_TIME"): @"--"},@{kLocalizedString(@"COMPLETION_TIME"):self.model.orderDetail.completionDate ? self.model.orderDetail.completionDate: @"--"}]];
    [self.productInfoArr addObjectsFromArray:@[@{kLocalizedString(@"SUBTOTAL"):[self.model.orderPrice currency]},@{kLocalizedString(@"SHIPPING_FEE"):[self.model.orderDetail.logisticsFee currency]},@{[NSString stringWithFormat:@"%@:%@ %@",kLocalizedString(@"Total"),self.model.orderDetail.offerCnt,kLocalizedString(@"ITEMS")]:[self.model.orderDetail.orderPrice currency]}]];
    [self.tableView reloadData];
    
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
        _tableView.backgroundColor = RGBColorFrom16(0xf5f5f5);
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
@end
