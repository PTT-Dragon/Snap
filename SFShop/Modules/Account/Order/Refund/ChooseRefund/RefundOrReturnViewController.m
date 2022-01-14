//
//  RefundOrReturnViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/1/12.
//

#import "RefundOrReturnViewController.h"
#import "ChooseReasonViewController.h"
#import "OrderListStateCell.h"
#import "OrderListItemCell.h"
#import "CancelOrderChooseReason.h"
#import "ChooseReasonViewController.h"
#import "RefundDetailImagesCell.h"

@interface RefundOrReturnViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseReasonViewControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CancelOrderReasonModel *selReasonModel;
@end

@implementation RefundOrReturnViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    NSString *reasonTitle = _type == RETURNTYPE ? @"Return": _type == REFUNDTYPE ? @"Refund":@"Change";
    self.title = kLocalizedString(reasonTitle);
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CancelOrderChooseReason" bundle:nil] forCellReuseIdentifier:@"CancelOrderChooseReason"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailImagesCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailImagesCell"];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-140);
    }];
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
        }else if (indexPath.row == _model.orderItems.count+1){
            CancelOrderChooseReason *cell = [tableView dequeueReusableCellWithIdentifier:@"CancelOrderChooseReason"];
            cell.reasonLabel.text = _selReasonModel ? _selReasonModel.orderReasonName : @"Cancellation Reason";
            return cell;
        }
        OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
        [cell setContent:_model.orderItems[indexPath.row-1]];
        return cell;
    }
    
    RefundDetailImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailImagesCell"];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? _model.orderItems.count+2 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  indexPath.row == 0 ? 40 : indexPath.row == 1+_model.orderItems.count ? 60: 118;
    }
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == _model.orderItems.count+1) {
        [self loadReasonDatas];
    }
}
- (void)loadRefundCharge
{
    [SFNetworkManager get:SFNet.refund.refundList parameters:@{} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)loadReasonDatas
{
    NSString *reasonId = _type == REFUNDTYPE ? @"3": _type == RETURNTYPE ? @"2":@"4";
    [MBProgressHUD showHudMsg:kLocalizedString(@"loading")];
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.order getReasonlOf:reasonId] success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSMutableArray *dataSource = [NSMutableArray array];
        [dataSource addObjectsFromArray:[CancelOrderReasonModel arrayOfModelsFromDictionaries:response error:nil]];
        ChooseReasonViewController *vc = [[ChooseReasonViewController alloc] init];
        vc.dataSource = dataSource;
        vc.delegate = weakself;
        [weakself presentViewController:vc animated:YES completion:^{
                    
        }];
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
        [MBProgressHUD autoDismissShowHudMsg:@"请选择原因"];
        return;
    }
    MPWeakSelf(self)
    [MBProgressHUD showHudMsg:@""];
    [SFNetworkManager post:SFNet.order.cancelOrder parameters:@{@"orderId":_model.orderId,@"cancelReasonId":_selReasonModel.orderReasonId,@"cancelReason":_selReasonModel.orderReasonName} success:^(id  _Nullable response) {
        [weakself.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD autoDismissShowHudMsg:@"Cancel Success"];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)refundAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_model.orderId forKey:@"orderId"];
    [params setValue:[_model.orderItems.firstObject id] forKey:@"orderItemId"];
    [params setValue:@"1" forKey:@"refundMode"];
    [params setValue:@"3" forKey:@"serviceType"];
    [params setValue:@"" forKey:@"refundCharge"];
    //{"orderId":22001,"orderItemId":21001,"refundMode":1,"serviceType":3,"refundCharge":6000,"submitNum":1,"orderReasonId":2,"orderReason":"尺码过大","questionDesc":"","goodReturnType":2,"contactChannel":3,"contents":[],"receivedFlag":"Y"}
    [SFNetworkManager post:SFNet.refund.refundList parameters:@{} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)returnAction
{
    
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
