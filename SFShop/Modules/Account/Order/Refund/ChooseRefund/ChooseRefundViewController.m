//
//  ChooseRefundViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/1/12.
//

#import "ChooseRefundViewController.h"
#import "accountSubCell.h"
#import "ChooseRefundTitleCell.h"
#import "OrderListItemCell.h"
#import "RefundOrReturnViewController.h"
#import "RefundViewController.h"

@interface ChooseRefundViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) RefundChargeModel *chargeModel;
@end

@implementation ChooseRefundViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"REFUND_SELECT_TITLE");
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ChooseRefundTitleCell" bundle:nil] forCellReuseIdentifier:@"ChooseRefundTitleCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    orderItemsModel *itemModel = self.model.orderItems[_row.integerValue];
    if ([itemModel.serviceTypes rangeOfString:@"3"].location != NSNotFound) {
        [self.dataSource addObject:kLocalizedString(@"I_WANT_TO_REFUND")];
    }
    if ([itemModel.serviceTypes rangeOfString:@"2"].location != NSNotFound) {
        [self.dataSource addObject:kLocalizedString(@"I_WANT_TO_RETURN")];
    }
    if ([itemModel.serviceTypes rangeOfString:@"4"].location != NSNotFound) {
        [self.dataSource addObject:kLocalizedString(@"I_WANT_TO_EXCHANGE")];
    }
    [self.dataSource addObject:kLocalizedString(@"VIEW_APPLICATION_RECORDS")];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-140);
    }];
    [self loadRefundCharge];
    [self.tableView reloadData];
}
- (void)setModel:(OrderDetailModel *)model
{
    _model = model;
    [self.tableView reloadData];
}
- (void)loadRefundCharge
{
    //TODO:这里暂时是一个商品
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.refund.charge parameters:@{@"orderId":self.model.orderId,@"orderItemId":[self.model.orderItems[_row.integerValue] orderItemId]} success:^(id  _Nullable response) {
        weakself.chargeModel = [[RefundChargeModel alloc] initWithDictionary:response error:nil];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ChooseRefundTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseRefundTitleCell"];
            cell.codeLabel.text = [NSString stringWithFormat:@"%@:%@",kLocalizedString(@"ORDER_CODE"),_model.orderNbr];
            cell.stateLabel.text = _model.getStateStr;
            return cell;
        }
        OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
        [cell setRefund2Content:_model.orderItems[_row.integerValue]];
        return cell;
    }
    accountSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSubCell"];
    cell.label.text = self.dataSource[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:@""];
    cell.labelLeading.constant = 15;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 2: self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 40 :118;
    }
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSString *str = self.dataSource[indexPath.row];
        if ([str isEqualToString:kLocalizedString(@"VIEW_APPLICATION_RECORDS")]) {
            RefundViewController *vc = [[RefundViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }else{
            RefundOrReturnViewController *vc = [[RefundOrReturnViewController alloc] init];
            vc.model = self.model;
            vc.row = _row;
            vc.chargeModel = self.chargeModel;
            vc.type = [str isEqualToString:kLocalizedString(@"I_WANT_TO_REFUND")] ? REFUNDTYPE: [str isEqualToString:kLocalizedString(@"I_WANT_TO_RETURN")] ? RETURNTYPE: REPLACETYPE;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 10)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
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
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}
@end
