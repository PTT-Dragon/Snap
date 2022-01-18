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
#import "OrderDetailGroupBuyCell.h"
#import "ChooseRefundViewController.h"
#import "NSString+Fee.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *orderInfoDataSource;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (nonatomic,strong) OrderDetailModel *model;
@property (nonatomic,strong) OrderGroupModel *groupModel;
@end

@implementation OrderDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Order_details");
    _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn2.layer.borderWidth = 1;
    _dataSource = [NSMutableArray array];
    _orderInfoDataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"DeliveryInformationCell" bundle:nil] forCellReuseIdentifier:@"DeliveryInformationCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DeliveryAddressCell" bundle:nil] forCellReuseIdentifier:@"DeliveryAddressCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderPayInfoCell" bundle:nil] forCellReuseIdentifier:@"OrderPayInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailGroupBuyCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailGroupBuyCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
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
        OrderDetailGroupBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailGroupBuyCell"];
        cell.model = self.groupModel;
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
            [cell setOrderDetailContent:self.model];
            return cell;
        }else if (indexPath.row > self.model.orderItems.count){
            OrderPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayInfoCell"];
            [cell setContent:self.orderInfoDataSource[indexPath.row-self.model.orderItems.count-1]];
            return cell;
        }
        OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
        [cell setOrderContent:self.model.orderItems[indexPath.row-1] state:self.model.state];
        cell.block = ^{
            ChooseRefundViewController *vc = [[ChooseRefundViewController alloc] init];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    OrderPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayInfoCell"];
    [cell setContent:self.dataSource[indexPath.row]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;//self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.model.deliverys.count == 0 ? 0: 1: section == 2 ? self.groupModel ? 1:0: section == 1 ? 1: section == 3 ? self.model.orderItems.count+1+self.orderInfoDataSource.count : self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 112: indexPath.section == 2 ? 156: indexPath.section == 1 ? 170: (indexPath.section == 3 && indexPath.row == 0) ? 40: (indexPath.section == 3 && indexPath.row>self.model.orderItems.count) ? 30: indexPath.section == 3 ? [self.model.state isEqualToString:@"D"] ? 170: 154:  30;
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
        [weakself handleDatas];
        if (weakself.model.shareBuyOrderId) {
            //需要加载团购信息
            [weakself loadGroupDatas];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
//团购数据
- (void)loadGroupDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.groupbuy getGroupBuyGroupNbr:_model.shareBuyOrderNbr] parameters:@{} success:^(id  _Nullable response) {
        weakself.groupModel = [OrderGroupModel yy_modelWithDictionary:response];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)handleDatas
{
    OrderDetailPaymentsModel *paymentModel = self.model.payments.firstObject;
    [_dataSource addObjectsFromArray:@[@{@"Order Code":self.model.orderNbr},@{@"Creation time":self.model.createdDate},@{@"Player Email":self.model.billAddress.contactEmail},@{@"Payment time":paymentModel.paymentDate},@{@"Completion time":self.model.completionDate ? self.model.completionDate: @"--"}]];
    [_orderInfoDataSource addObjectsFromArray:@[@{@"subtotal":[self.model.offerPrice currency]},@{@"promotion":[NSString stringWithFormat:@"-%@",[self.model.storeCampaignPrice currency]]},@{@"shipping Fee":[self.model.logisticsFee currency]},@{[NSString stringWithFormat:@"Total:%@ items",self.model.offerCnt]:[self.model.orderPrice currency]}]];
    [self.tableView reloadData];
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    if ([self.model.state isEqualToString:@"B"]) {
        [self.btn1 setTitle:kLocalizedString(@"REBUY") forState:0];
        self.btn2.hidden = YES;
        [self.btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomView.mas_left).offset(16);
            make.right.mas_equalTo(self.bottomView.mas_right).offset(-16);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(self.bottomView.mas_top).offset(11);
        }];
    }else if ([self.model.state isEqualToString:@"A"]){
        [self.btn1 setTitle:kLocalizedString(@"PAYNOW") forState:0];
        [self.btn2 setTitle:kLocalizedString(@"CANCEL") forState:0];
    }
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
