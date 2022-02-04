//
//  LogisticsProcessViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/2/4.
//

#import "LogisticsProcessViewController.h"
#import "RefundDetailTitleCell.h"
#import "RefundProcessCell.h"

@interface LogisticsProcessViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation LogisticsProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"DETAIL");
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundProcessCell" bundle:nil] forCellReuseIdentifier:@"RefundProcessCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundDetailTitleCell" bundle:nil] forCellReuseIdentifier:@"RefundDetailTitleCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+10);
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        RefundDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundDetailTitleCell"];
        [cell setContent:self.model type:10];
        return cell;
    }
    RefundProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundProcessCell"];
    [cell setContent:self.model.memos[indexPath.row-1] hideView:indexPath.row != 1];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.memos.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hei = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            hei = 40;
        }else{
            hei = 75;
        }
    }
    return hei;
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
