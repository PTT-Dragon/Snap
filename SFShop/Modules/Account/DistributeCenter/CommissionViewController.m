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
#import "PublicAlertView.h"
#import "CaseOutDetailViewController.h"

@interface CommissionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
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
    self.title = kLocalizedString(@"Commission");
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
    [self drawShadow];
    [self loadDatas];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.commission parameters:@{} success:^(id  _Nullable response) {
        weakself.model = [[DistributorCommissionModel alloc] initWithDictionary:response error:nil];
        [weakself updateDatas];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)updateDatas
{
    _balanceLabel.text = [NSString stringWithFormat:@"RP %@",self.model.balanceCommission];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        CashOutHistoryViewController *vc = [[CashOutHistoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        IncomeAndExpenseViewController *vc = [[IncomeAndExpenseViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 0){
        if (self.model.balanceCommission.doubleValue < 10) {
            PublicAlertView *alertView = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:@"The balance is insufficient to be cashed out.The minimum cash withdrawal is ¥10.00" btnTitle:@"OK" block:^{
                
            }];
            [self.view addSubview:alertView];
        }else{
            CaseOutDetailViewController *vc = [[CaseOutDetailViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)drawShadow
{
    _bgView.layer.masksToBounds = NO;//默认值为NO。不能设置为YES，否则阴影无法出现。
    _bgView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    _bgView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    _bgView.layer.shadowRadius = 4;//阴影圆角
    _bgView.layer.shadowOffset = CGSizeMake(5, 0);    //阴影偏移量。有值是向下向右偏移。
    
    
    /*
     * 默认值：(0,-3)向上偏移。
     原因：阴影最先在mac平台实现，默认是向下偏移3。但由于iOS和macOS的Y轴相反，所以，iOS是向上偏移3.
     
     设置为：(0,0)，四周都有阴影。
     */
    //阴影路径
    _bgView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds cornerRadius:_bgView.layer.cornerRadius].CGPath;
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
