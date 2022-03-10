//
//  CashOutDetailVC.m
//  SFShop
//
//  Created by 游挺 on 2022/3/10.
//

#import "CashOutDetailVC.h"
#import "CashOutDetailCell.h"
#import "NSString+Fee.h"
#import "NSDate+Helper.h"
#import "PublicAlertView.h"


@interface CashOutDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation CashOutDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"CASH_OUT_DETAIL");
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CashOutDetailCell" bundle:nil] forCellReuseIdentifier:@"CashOutDetailCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
    }];
    [self handleDatas];
}
- (void)handleDatas
{
    [self.btn setTitle:kLocalizedString(@"CANCEL") forState:0];
    [self.dataSource addObjectsFromArray:@[@{@"title":kLocalizedString(@"Status"),@"content":self.model.state},@{@"title":kLocalizedString(@"ITEM_CODE"),@"content":self.model.reqSn},@{@"title":kLocalizedString(@"DATE"),@"content":[[NSDate dateFromString:self.model.stateDate] dayMonthYearHHMM]},@{@"title":kLocalizedString(@"Account"),@"content":[NSString stringWithFormat:@"%@\n%@\n%@",self.model.bankName,self.model.bankAcctNbr,self.model.bankAcctName]},@{@"title":kLocalizedString(@"TOTAL"),@"content":[self.model.withdrawalAmount currency]},@{@"title":kLocalizedString(@"REJECT_REASON"),@"content":self.model.handleReason ? self.model.handleReason: @"--"}]];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CashOutDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CashOutDetailCell"];
    cell.dic = self.dataSource[indexPath.row];
    return cell;
}
- (IBAction)btnAction:(UIButton *)sender {
    PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:kLocalizedString(@"CONFIRM_CANCEL_REQUEST") btnTitle:kLocalizedString(@"CONFIRM") block:^{
        [self cancelAction];
    } btn2Title:kLocalizedString(@"CANCEL") block2:^{
        
    }];
    [[baseTool getCurrentVC].view addSubview:alert];
}
- (void)cancelAction
{
    
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
