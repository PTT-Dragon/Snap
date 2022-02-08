//
//  CancelOrderViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/31.
//

#import "CancelOrderViewController.h"
#import "OrderListStateCell.h"
#import "OrderListItemCell.h"
#import "CancelOrderChooseReason.h"
#import "ChooseReasonViewController.h"

@interface CancelOrderViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseReasonViewControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CancelOrderReasonModel *selReasonModel;
@property (nonatomic,strong) NSMutableArray *reasonArr;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;

@end

@implementation CancelOrderViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Cancellation_Request");
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    self.reasonArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CancelOrderChooseReason" bundle:nil] forCellReuseIdentifier:@"CancelOrderChooseReason"];
    [self.publishBtn setTitle:kLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-140);
    }];
    [self loadReasonDatas];
}
- (void)setModel:(OrderModel *)model
{
    _model = model;
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
//        [cell setContent:_model];
//        return cell;
//    }else
        if (indexPath.row == _model.orderItems.count){
        CancelOrderChooseReason *cell = [tableView dequeueReusableCellWithIdentifier:@"CancelOrderChooseReason"];
        __block CancelOrderChooseReason *cellBlock = cell;
        cell.block = ^(BOOL sel) {
            cellBlock.btn.selected = NO;
            ChooseReasonViewController *vc = [[ChooseReasonViewController alloc] init];
            vc.dataSource = self.reasonArr;
            vc.delegate = self;
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            vc.view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
        };
            cell.reasonLabel.text = _selReasonModel ? _selReasonModel.orderReasonName : kLocalizedString(@"PLEASE_SELECT");//@"Cancellation Reason";
        return cell;
    }
    OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
    [cell setRefundContent:_model.orderItems[indexPath.row]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.orderItems.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == _model.orderItems.count ? 110: 118;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width - 32, 5)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _model.orderItems.count+1) {
//        ChooseReasonViewController *vc = [[ChooseReasonViewController alloc] init];
//        vc.dataSource = self.reasonArr;
//        vc.delegate = self;
//        [self presentViewController:vc animated:YES completion:^{
//
//        }];
    }
}
- (void)loadReasonDatas
{
    [MBProgressHUD showHudMsg:kLocalizedString(@"loading")];
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.order getReasonlOf:@"1"] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        [weakself.reasonArr addObjectsFromArray:[CancelOrderReasonModel arrayOfModelsFromDictionaries:response error:nil]];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)chooseReason:(CancelOrderReasonModel *)model
{
    _selReasonModel = model;
    [self.tableView reloadData];
}

- (IBAction)submitAction:(UIButton *)sender {
    if (!_selReasonModel) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"REASON_TITLE")];
        return;
    }
    MPWeakSelf(self)
    [MBProgressHUD showHudMsg:@""];
    [SFNetworkManager post:SFNet.order.cancelOrder parameters:@{@"orderId":_model.orderId,@"cancelReasonId":_selReasonModel.orderReasonId,@"cancelReason":_selReasonModel.orderReasonName} success:^(id  _Nullable response) {
        [weakself.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD autoDismissShowHudMsg:@"Cancel Success"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KRefreshOrderNum" object:nil];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
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
