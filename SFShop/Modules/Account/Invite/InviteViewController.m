//
//  InviteViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/21.
//

#import "InviteViewController.h"
#import "InviteTopCell.h"
#import "InviteCell.h"
#import "InviteModel.h"

@interface InviteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *imgUrl;

@end

@implementation InviteViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Invite Friend";
    _dataSource = [NSMutableArray array];
    [self loadDatas];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteTopCell" bundle:nil] forCellReuseIdentifier:@"InviteTopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteCell" bundle:nil] forCellReuseIdentifier:@"InviteCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.invite.activityInfo parameters:@{} success:^(id  _Nullable response) {
        NSArray *arr = response;
        weakself.imgUrl = arr.firstObject[@"ctnAttachment"];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [SFNetworkManager get:SFNet.invite.img parameters:@{} success:^(id  _Nullable response) {
        
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [SFNetworkManager get:SFNet.invite.activityInvRecord parameters:@{} success:^(id  _Nullable response) {
        NSArray *arr = response[@"list"];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [weakself.dataSource addObject:[[InviteModel alloc] initWithDictionary:dic error:nil]];
            }
            [weakself.tableView reloadData];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
//    [SFNetworkManager get:SFNet.invite.activityInvShare parameters:@{} success:^(id  _Nullable response) {
//        NSArray *arr = response[@"content"];
//        NSString *url = [arr.firstObject[@"ctnAttachment"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        weakself.imgUrl = url;
//        [weakself.tableView reloadData];
//    } failed:^(NSError * _Nonnull error) {
//
//    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+_dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        InviteTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteTopCell"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(self.imgUrl)]];
        return cell;
    }
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    [cell setContent:self.dataSource[indexPath.row-1]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 635;
    }
    return 74;
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
