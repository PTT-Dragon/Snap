//
//  ReplaceDeliveryViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/1/24.
//

#import "ReplaceDeliveryViewController.h"
#import "ReplaceDeliveryCell.h"
#import "ReplaceDeliveryAddCell.h"

@interface ReplaceDeliveryViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton *btn;

@end

@implementation ReplaceDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Delivery");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+10);
    }];
    [self.view addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(46);
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
    }];
    self.dataSource = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"text1":@"",@"text2":@""}];
    [self.dataSource addObject:dic];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ReplaceDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplaceDeliveryCell"];
        [cell setContent:self.dataSource[indexPath.row] row:indexPath.row];
        cell.block = ^(NSDictionary * _Nonnull infoDic, NSInteger row) {
            [self.dataSource replaceObjectAtIndex:row withObject:infoDic];
            NSLog(@"%@",self.dataSource);
        };
        cell.deleteBlock = ^(NSInteger row) {
            [self.dataSource removeObjectAtIndex:row];
            [self.tableView reloadData];
        };
        return cell;
    }
    ReplaceDeliveryAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplaceDeliveryAddCell"];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.dataSource.count:1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 230:40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"text1":@"",@"text2":@""}];
        [self.dataSource addObject:dic];
        [self.tableView reloadData];
    }
}
- (void)publish
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSMutableDictionary *dic in self.dataSource) {
        [arr addObject:@{@"shippingNbr":dic[@"text1"],@"logisticsName":dic[@"text2"]}];
    }
    [SFNetworkManager post:SFNet.refund.delivery parameters:@{@"deliverys":arr,@"orderApplyId":self.model.orderApplyId} success:^(id  _Nullable response) {
        [self.navigationController popViewControllerAnimated:YES];
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
        [_tableView registerNib:[UINib nibWithNibName:@"ReplaceDeliveryAddCell" bundle:nil] forCellReuseIdentifier:@"ReplaceDeliveryAddCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ReplaceDeliveryCell" bundle:nil] forCellReuseIdentifier:@"ReplaceDeliveryCell"];
        
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
- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.backgroundColor = RGBColorFrom16(0xFF1659);
        [_btn setTitle:kLocalizedString(@"SUBMIT") forState:0];
        _btn.titleLabel.font = CHINESE_SYSTEM(14);
        [_btn setTitleColor:[UIColor whiteColor] forState:0];
        @weakify(self)
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self publish];
                }];
    }
    return _btn;
}
@end
