//
//  MessageViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "MessageViewController.h"
#import "MessageListCell.h"
#import "MessageModel.h"
#import "MessageOrderListViewController.h"
#import "EmptyView.h"
#import "PublicWebViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MessageModel *model;
@property (nonatomic,strong) EmptyView *emptyView;

@end

@implementation MessageViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadDatas];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Message");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(clearUnreadMessage) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0 , 0, 22, 22);
    [button setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"MessageListCell"];
    self.tableView.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+15);
    }];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_top).offset(90);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self loadDatas];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.account.messageList parameters:@{} success:^(id  _Nullable response) {
        weakself.model = [MessageModel yy_modelWithDictionary:response];
        [weakself.tableView reloadData];
        [weakself showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [weakself showEmptyView];
    }];
}

- (void)showEmptyView {
//    if (self.model.count > 0) {
//        self.emptyView.hidden = YES;
//    } else {
//        self.emptyView.hidden = NO;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.unreadMessages.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListCell"];
    if (indexPath.row == 0) {
        cell.contactModel = self.model.contactMessage;
    }else{
        cell.unreadModel = self.model.unreadMessages[indexPath.row-1];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MessageOrderListViewController *vc = [[MessageOrderListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [self readMessage];
        return;
    }
    [self readChatMessage];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    PublicWebViewController *vc = [[PublicWebViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"http://47.243.193.90:8064/chat/A1test@A1.com"];
    vc.sysAccount = model.account;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)readMessage
{
    [SFNetworkManager post:SFNet.account.readMessage parameters:@{@"busiScope":@"CM"} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)readChatMessage
{
    MessageUnreadModel *model = self.model.unreadMessages.firstObject;
    [SFNetworkManager post:[SFNet.account readChatMessage:model.flowNo] parameters:@{} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)clearUnreadMessage
{
    NSMutableArray *arr = [NSMutableArray array];
    for (MessageUnreadModel *itemModel in _model.unreadMessages) {
        [arr addObject:itemModel.flowNo];
    }
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.account.readMessage parameters:@{@"busiScope":@"CM",@"flowNos":arr} success:^(id  _Nullable response) {
        [weakself loadDatas];
    } failed:^(NSError * _Nonnull error) {
        
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

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoMessageType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


@end
