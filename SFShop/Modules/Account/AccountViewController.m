//
//  AccountViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "AccountViewController.h"
#import "accountInfoCell.h"
#import "accountOrderCell.h"
#import "accountSubCell.h"
#import "LoginViewController.h"
#import "AddressViewController.h"
#import "FavoriteViewController.h"


@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.hidden = YES;
    self.title = @"Account";
    _dataSource = [NSMutableArray array];
    [_dataSource addObjectsFromArray:@[@{@"image":@"00350_Distributor_Center",@"title":@"Distributor  Center"},@{@"image":@"00350_Distributor_Center",@"title":@"Refers"},@{@"image":@"00350_Distributor_Center",@"title":@"Forum"},@{@"image":@"00350_Distributor_Center",@"title":@"Reviews"},@{@"image":@"00350_Distributor_Center",@"title":@"Address"},@{@"image":@"00350_Distributor_Center",@"title":@"Service"},@{@"image":@"00350_Distributor_Center",@"title":@"Policies"},@{@"image":@"00350_Distributor_Center",@"title":@"FAQ"}]];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountInfoCell" bundle:nil] forCellReuseIdentifier:@"accountInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountOrderCell" bundle:nil] forCellReuseIdentifier:@"accountOrderCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
}
- (void)updateData
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2+_dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        accountInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountInfoCell"];
        return cell;
    }else if (indexPath.row == 1){
        accountOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountOrderCell"];
        return cell;
    }
    NSDictionary *dic = _dataSource[indexPath.row-2];
    accountSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSubCell"];
    cell.label.text = dic[@"title"];
    cell.imgView.image = [UIImage imageNamed:dic[@"image"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 175;
    }else if (indexPath.row == 1){
        return 134;
    }
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 6){
        AddressViewController *vc = [[AddressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 7){
        FavoriteViewController *vc = [[FavoriteViewController alloc] init];
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
