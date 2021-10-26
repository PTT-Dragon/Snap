//
//  OrderDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import "OrderDetailViewController.h"
#import "DeliveryInformationCell.h"
#import "DeliveryAddressCell.h"
#import "OrderPayInfoCell.h"
#import "OrderListStateCell.h"
#import "OrderListItemCell.h"
#import "OrderModel.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) OrderDetailModel *model;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Order Details";
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"DeliveryInformationCell" bundle:nil] forCellReuseIdentifier:@"DeliveryInformationCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DeliveryAddressCell" bundle:nil] forCellReuseIdentifier:@"DeliveryAddressCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderPayInfoCell" bundle:nil] forCellReuseIdentifier:@"OrderPayInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
    [self loadDatas];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DeliveryInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryInformationCell"];
        [cell setContent:self.model];
        return cell;
    }else if (indexPath.section == 1){
        DeliveryAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryAddressCell"];
        [cell setContent:self.model];
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
            return cell;
        }
        OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
        [cell setContent:self.model.orderItems[indexPath.row-1]];
        return cell;
    }
    OrderPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayInfoCell"];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;//self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1: section == 1 ? 1: section == 2 ? self.model.orderItems.count+1 : 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 112: indexPath.section == 1 ? 170: (indexPath.section == 2 && indexPath.row == 0) ? 40: indexPath.section == 2 ? 154:  30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width - 32, 10)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (void)loadDatas
{
    NSString *url = [NSString stringWithFormat:@"%@/%@",SFNet.order.list,_orderId];
    MPWeakSelf(self)
    [SFNetworkManager get:url parameters:@{} success:^(id  _Nullable response) {
        weakself.model = [[OrderDetailModel alloc] initWithDictionary:response error:nil];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
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
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
@end