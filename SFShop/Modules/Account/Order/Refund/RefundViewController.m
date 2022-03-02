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
#import <MJRefresh/MJRefresh.h>
#import "BaseNavView.h"
#import "BaseMoreView.h"
#import "EmptyView.h"
#import "CustomTextField.h"


@interface RefundViewController ()<UITableViewDelegate,UITableViewDataSource,BaseNavViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) CustomTextField *textField;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;
@property (nonatomic, strong) UIButton *gotoShopping;
@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation RefundViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView {
    [_moreView removeFromSuperview];
    _moreView = [[BaseMoreView alloc] init];
    [self.view addSubview:_moreView];
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(@"Refund_Return")];
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundCell" bundle:nil] forCellReuseIdentifier:@"RefundCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+70);
    }];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(250);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.gotoShopping];
    [self.gotoShopping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(24);
        make.right.bottom.mas_offset(-24);
        make.height.mas_offset(46);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textField).offset(0);
        make.right.offset(-30);
        make.width.height.mas_equalTo(25);
    }];
    imgV.image = [UIImage imageNamed:@"ic_nav_search"];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchAction)];
    imgV.userInteractionEnabled = YES;
    [imgV addGestureRecognizer:searchTap];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundCell"];
    [cell setContent:self.dataSource[indexPath.row]];
    cell.block = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    refundModel *model = self.dataSource[indexPath.row];
    CGFloat hei = [model.state isEqualToString:@"B"] ? 246: [model.state isEqualToString:@"H"] ? 246: [model.state isEqualToString:@"F"] ? 246: [model.state isEqualToString:@"D"] ? 246: [model.state isEqualToString:@"E"] ? 246: [model.state isEqualToString:@"G"] ? 246: [model.state isEqualToString:@"X"] ? 246: [model.state isEqualToString:@"A"] ? 286: 286;
    return  hei;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    refundModel *model = self.dataSource[indexPath.row];
    RefundDetailViewController *vc = [[RefundDetailViewController alloc] init];
    vc.orderApplyId = model.orderApplyId;
    vc.block = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadDatas
{
//    [MBProgressHUD showHudMsg:@""];
    _pageIndex = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.refund.refundList parameters:@{@"q":_textField.text,@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSInteger pageNum = [response[@"pageNum"] integerValue];
        NSInteger pages = [response[@"pages"] integerValue];
        if (pageNum >= pages) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
        [weakself.tableView.mj_header endRefreshing];
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:[refundModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
        [self showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [self showEmptyView];
        [MBProgressHUD hideFromKeyWindow];
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreDatas
{
//    [MBProgressHUD showHudMsg:@""];
    _pageIndex ++;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.refund.refundList parameters:@{@"q":_textField.text,@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSInteger pageNum = [response[@"pageNum"] integerValue];
        NSInteger pages = [response[@"pages"] integerValue];
        if (pageNum >= pages) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
        [weakself.dataSource addObjectsFromArray:[refundModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
        [self showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [self showEmptyView];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (void)showEmptyView {
    if (self.dataSource.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
    self.gotoShopping.hidden = self.emptyView.hidden;
}
#pragma mark - <click event>
- (void)gotoShoppingEvent{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)textFieldDidChangeValue:(NSNotification *)noti {
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tableView.mj_header beginRefreshing];
    return YES;
}
- (void)searchAction
{
    [self.tableView.mj_header beginRefreshing];
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
- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHei, MainScreen_width, 70)];
        _searchView.backgroundColor = [UIColor whiteColor];
        [_searchView addSubview:self.textField];
        _textField.frame = CGRectMake(16, 15, MainScreen_width-32, 40);
    }
    return _searchView;
}
- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoOrderType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (UIButton *)gotoShopping{
    
    if (!_gotoShopping) {
        
        _gotoShopping = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoShopping setTitle:kLocalizedString(@"Go_Shopping") forState:UIControlStateNormal];
        [_gotoShopping setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_gotoShopping setBackgroundColor:[UIColor jk_colorWithHexString:@"FF1659"]];
        [_gotoShopping addTarget:self action:@selector(gotoShoppingEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }return _gotoShopping;
}
- (CustomTextField *)textField {
    if (_textField == nil) {
        _textField = [[CustomTextField alloc] init];
        _textField.delegate = self;
        _textField.font = kFontRegular(16);
        _textField.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.placeholder = kLocalizedString(@"Search");
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_textField];
    }
    return _textField;
}
@end
