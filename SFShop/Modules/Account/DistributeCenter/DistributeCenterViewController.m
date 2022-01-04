//
//  DistributeCenterViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistributeCenterViewController.h"
#import "DistributorInfoCell.h"
#import "DistributorRankCell.h"
#import "DistribitorRankTopCell.h"
#import "DistributorRelationOrderCell.h"
#import "DistributorModel.h"
#import "ProductViewController.h"

@interface DistributeCenterViewController ()<UITableViewDelegate,UITableViewDataSource,DistribitorRankTopCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DistributorModel *model;
@property (nonatomic,assign) NSInteger selType;//1.sale  2.mySale

@end

@implementation DistributeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Distributor_center");
    _selType = 1;
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributorInfoCell" bundle:nil] forCellReuseIdentifier:@"DistributorInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributorRankCell" bundle:nil] forCellReuseIdentifier:@"DistributorRankCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DistribitorRankTopCell" bundle:nil] forCellReuseIdentifier:@"DistribitorRankTopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributorRelationOrderCell" bundle:nil] forCellReuseIdentifier:@"DistributorRelationOrderCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
    [self loadDatas];
    [self loadProductList];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4+self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DistributorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributorInfoCell"];
        [cell setContent:self.model.kolDayMonthSale type:1];
        return cell;
    }else if (indexPath.row == 1){
        DistributorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributorInfoCell"];
        [cell setContent:self.model.distributionSettlementDto type:2];
        return cell;
    }else if (indexPath.row == 2){
        DistributorRelationOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributorRelationOrderCell"];
        cell.model = self.model;
        return cell;
    }else if (indexPath.row == 3){
        DistribitorRankTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistribitorRankTopCell"];
        cell.delegate = self;
        return cell;
    }
    DistributorRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributorRankCell"];
    cell.model = self.dataSource[indexPath.row-4];
    cell.rank = indexPath.row-3;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 193;
    }else if (indexPath.row == 1){
        return 193;
    }else if (indexPath.row == 2){
        return 157;
    }else if (indexPath.row == 3){
        return 128;
    }
    return 106;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 3) {
        DistributorRankProductModel *model = self.dataSource[indexPath.row-4];
        ProductViewController *vc = [[ProductViewController alloc] init];
        vc.offerId = model.offerId.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - request
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.center parameters:@{} success:^(id  _Nullable response) {
        weakself.model = [[DistributorModel alloc] initWithDictionary:response error:nil];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)loadProductList
{
    MPWeakSelf(self)
    NSDictionary *params = @{@"isMySalesRanking":_selType == 1 ? @"N": @"Y"};
    [SFNetworkManager get:SFNet.distributor.rankingTop parameters:params success:^(id  _Nullable response) {
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:[DistributorRankProductModel arrayOfModelsFromDictionaries:response error:nil]];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark - cell.delegate
- (void)selProductListType:(NSInteger)type
{
    _selType = type;
    [self loadProductList];
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
