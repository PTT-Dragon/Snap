//
//  ReviewDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/5.
//

#import "ReviewDetailViewController.h"
#import "ReviewDetailInfoCell.h"
#import "OrderModel.h"
#import "ReviewPhrchaseCell.h"
#import "BaseNavView.h"
#import "BaseMoreView.h"

@interface ReviewDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BaseNavViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ReviewDetailModel *model;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;
@end

@implementation ReviewDetailViewController
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
    // Do any additional setup after loading the view from its nib.
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(@"Review_detail")];
    [self initUI];
    [self loadDatas];
}
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
    [_tableView registerNib:[UINib nibWithNibName:@"ReviewDetailInfoCell" bundle:nil] forCellReuseIdentifier:@"ReviewDetailInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ReviewPhrchaseCell" bundle:nil] forCellReuseIdentifier:@"ReviewPhrchaseCell"];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.evaluate.detail parameters:@{@"orderItemId":_orderItemId} success:^(id  _Nullable response) {
        weakself.model = [ReviewDetailModel yy_modelWithDictionary:response];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    EvaluatesModel *evaModel = self.model.evaluates.firstObject;
    return 1+evaModel.review.contents.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ReviewDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewDetailInfoCell"];
        cell.model = self.model;
        return cell;
    }
    EvaluatesModel *evaModel = self.model.evaluates.firstObject;
    ReviewPhrchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewPhrchaseCell"];
    cell.model = evaModel.review;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EvaluatesModel *evaModel = self.model.evaluates.firstObject;
        CGFloat itemHei = (MainScreen_width-32-30)/4;
        CGFloat hei = evaModel.contents.count == 0 ? 0: evaModel.contents.count < 4 ? itemHei+5:  evaModel.contents.count < 8 ? 2*itemHei+10: 3* itemHei + 15;
        return hei+224;
    }
    return 120;
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
