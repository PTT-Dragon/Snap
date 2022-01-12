//
//  ChooseRefundViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/1/12.
//

#import "ChooseRefundViewController.h"
#import "accountSubCell.h"
#import "OrderListStateCell.h"
#import "OrderListItemCell.h"
#import "RefundOrReturnViewController.h"
#import "RefundViewController.h"

@interface ChooseRefundViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation ChooseRefundViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"REFUND_SELECT_TITLE");
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    self.dataSource = @[kLocalizedString(@"I_WANT_TO_REFUND"),kLocalizedString(@"I_WANT_TO_RETURN"),kLocalizedString(@"I_WANT_TO_EXCHANGE"),kLocalizedString(@"VIEW_APPLICATION_RECORDS")];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-140);
    }];
    [self.tableView reloadData];
}
- (void)setModel:(OrderDetailModel *)model
{
    _model = model;
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
            [cell setOrderDetailContent:_model];
            return cell;
        }
        OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
        [cell setContent:_model.orderItems[indexPath.row-1]];
        return cell;
    }
    accountSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSubCell"];
    cell.label.text = self.dataSource[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:@""];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? _model.orderItems.count+1: 4;
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
        if (indexPath.row == 3) {
            RefundViewController *vc = [[RefundViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        RefundOrReturnViewController *vc = [[RefundOrReturnViewController alloc] init];
        vc.type = indexPath.row == 0 ? REFUNDTYPE: indexPath.row == 1 ? RETURNTYPE: REPLACETYPE;
        [self.navigationController pushViewController:vc animated:YES];
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
