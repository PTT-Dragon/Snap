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

@interface ReviewDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ReviewDetailModel *model;
@end

@implementation ReviewDetailViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Review_detail");
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
        return 300;
    }
    return 156;
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
