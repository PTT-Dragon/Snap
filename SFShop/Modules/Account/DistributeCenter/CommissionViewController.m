//
//  CommissionViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/2.
//

#import "CommissionViewController.h"
#import "accountSubCell.h"
#import "CashOutHistoryViewController.h"
#import "DistributorModel.h"
#import "IncomeAndExpenseViewController.h"

@interface CommissionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *inReviewLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DistributorCommissionModel *model;

@end

@implementation CommissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Commission";
    _dataSource = [NSMutableArray array];
    [_dataSource addObjectsFromArray:@[@{@"image":@"00326： My Wallet ／ Wallet",@"title":@"Cash Out"},@{@"image":@"00327： Piggy Bank ／ Savings",@"title":@"Income & Expense"},@{@"image":@"00348_ Cash Out History",@"title":@"Cash Out History"}]];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.bottomView.mas_bottom).offset(10);
    }];
    [self loadDatas];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.commission parameters:@{} success:^(id  _Nullable response) {
        weakself.model = [[DistributorCommissionModel alloc] initWithDictionary:response error:nil];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)updateDatas
{
    _balanceLabel.text = self.model.balanceCommission;
    _inReviewLabel.text = self.model.lockedCommission;
    _cashLabel.text = self.model.withdrawnCommission;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    accountSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSubCell"];
    cell.label.text = dic[@"title"];
    cell.imgView.image = [UIImage imageNamed:dic[@"image"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        CashOutHistoryViewController *vc = [[CashOutHistoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        IncomeAndExpenseViewController *vc = [[IncomeAndExpenseViewController alloc] init];
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
        _tableView.backgroundColor = [UIColor whiteColor];
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
