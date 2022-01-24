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
    [self.dataSource addObject:@{@"text1":@"",@"text2":@""}];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ReplaceDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplaceDeliveryCell"];
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
        [self.dataSource addObject:@{@"text1":@"",@"text2":@""}];
        [self.tableView reloadData];
    }
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
@end
