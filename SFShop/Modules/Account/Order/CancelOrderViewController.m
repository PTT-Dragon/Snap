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

@interface CancelOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CancelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Cancellation Request";
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CancelOrderChooseReason" bundle:nil] forCellReuseIdentifier:@"CancelOrderChooseReason"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.bottom.mas_equalTo(self.view);
    }];
}
- (void)setModel:(OrderModel *)model
{
    _model = model;
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
        [cell setContent:_model];
        return cell;
    }else if (indexPath.row == _model.orderItems.count+1){
        CancelOrderChooseReason *cell = [tableView dequeueReusableCellWithIdentifier:@"CancelOrderChooseReason"];
        return cell;
    }
    OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
    [cell setContent:_model.orderItems[indexPath.row-1]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.orderItems.count+2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 40 : indexPath.row == 1+_model.orderItems.count ? 60: 118;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _model.orderItems.count+1) {
        
    }
}
- (IBAction)submitAction:(UIButton *)sender {
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.order.cancelOrder parameters:@{@"orderIds":@[_model.orderId]} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}


@end
