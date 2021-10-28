//
//  RefundViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "RefundViewController.h"
#import "RefundCell.h"
#import "refundModel.h"
#import "RefundDetailViewController.h"


@interface RefundViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Refund & Return";
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundCell" bundle:nil] forCellReuseIdentifier:@"RefundCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top);
    }];
    [self loadDatas];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundCell"];
    [cell setContent:self.dataSource[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    refundModel *model = self.dataSource[indexPath.row];
    CGFloat hei = [model.state isEqualToString:@"X"] ? 178: [model.state isEqualToString:@"G"] ? 246: [model.state isEqualToString:@"A"] ? 264: 286;
    return  hei;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    refundModel *model = self.dataSource[indexPath.row];
    RefundDetailViewController *vc = [[RefundDetailViewController alloc] init];
    vc.orderApplyId = model.orderApplyId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.refund.refundList parameters:@{@"pageIndex":@(0),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [weakself.dataSource addObjectsFromArray:[refundModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
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
