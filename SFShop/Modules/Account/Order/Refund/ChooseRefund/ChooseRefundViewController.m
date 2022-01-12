//
//  ChooseRefundViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/1/12.
//

#import "ChooseRefundViewController.h"

@interface ChooseRefundViewController ()
@property (nonatomic,strong) UITableView *tableView;
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
    [_tableView registerNib:[UINib nibWithNibName:@"CancelOrderChooseReason" bundle:nil] forCellReuseIdentifier:@"CancelOrderChooseReason"];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
