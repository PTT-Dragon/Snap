//
//  ProductReviewChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ProductReviewChildViewController.h"
#import "ProductDetailModel.h"
#import "ProductEvalationCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ProductReviewDetailViewController.h"

@interface ProductReviewChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,copy) NSNumber *allEvaCount;//评价总数
@property(nonatomic, strong) NSMutableArray<ProductEvalationModel *> *evalationArr;
@end

@implementation ProductReviewChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestEvaluationsList];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductEvalationCell" bundle:nil] forCellReuseIdentifier:@"ProductEvalationCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top);
    }];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self requestEvaluationsList];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self requestMoreEvaluationsList];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)requestEvaluationsList
{
    //评论列表
    _pageIndex = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.offer.evaluationList parameters:@{@"offerId":@(_offerId),@"pageIndex":@(1),@"pageSize":@(10),@"evaluationType":_evaluationType,@"labelId":_labelId?_labelId:@""} success:^(id  _Nullable response) {
        [weakself.evalationArr removeAllObjects];
        weakself.evalationArr = [ProductEvalationModel arrayOfModelsFromDictionaries:response[@"list"] error:nil];
        weakself.allEvaCount = response[@"total"];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)requestMoreEvaluationsList
{
    //评论列表
    _pageIndex ++;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.offer.evaluationList parameters:@{@"offerId":@(_offerId),@"pageIndex":@(_pageIndex),@"pageSize":@(10),@"evaluationType":_evaluationType,@"labelId":_labelId?_labelId:@""} success:^(id  _Nullable response) {
        [weakself.evalationArr addObjectsFromArray: [ProductEvalationModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.evalationArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductEvalationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductEvalationCell"];
    cell.model = self.evalationArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductEvalationModel *model = self.evalationArr[indexPath.row];
    return model.itemHie;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductEvalationModel *model = self.evalationArr[indexPath.row];
    ProductReviewDetailViewController *vc = [[ProductReviewDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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


     
     
     
     
@end
     
     
