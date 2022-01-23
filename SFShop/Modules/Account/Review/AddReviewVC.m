//
//  AddReviewVC.m
//  SFShop
//
//  Created by 游挺 on 2022/1/23.
//

#import "AddReviewVC.h"
#import "AddReviewItemCell.h"
#import "AddReviewStoreItemCell.h"

@interface AddReviewVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation AddReviewVC
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3+_dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AddReviewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddReviewItemCell"];
        return cell;
    }
    AddReviewStoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddReviewStoreItemCell"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [_tableView registerNib:[UINib nibWithNibName:@"AddReviewStoreItemCell" bundle:nil] forCellReuseIdentifier:@"AddReviewStoreItemCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AddReviewStoreItemCell" bundle:nil] forCellReuseIdentifier:@"AddReviewStoreItemCell"];
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
