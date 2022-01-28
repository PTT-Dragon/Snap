//
//  FAQChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "FAQChildViewController.h"
#import "FAQTableCell.h"
#import "FAQListModel.h"
#import "FAQDetailViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface FAQChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;


@end

@implementation FAQChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    _searchText = @"";
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerClass:[FAQTableCell class] forCellReuseIdentifier:@"FAQTableCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(-0);
        make.top.bottom.mas_equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadDatas
{
    _pageIndex = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.h5.faqQuestion parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(10),@"faqCatgId":_model.faqCatgId,@"faqName":_searchText} success:^(id  _Nullable response) {
        [weakself.dataSource removeAllObjects];
        NSArray *arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            [weakself.dataSource addObject:[[FAQQuestionModel alloc] initWithDictionary:dic error:nil]];
        }
        if (weakself.block) {
            weakself.block(weakself.dataSource.count == 0,self.searchText);
        }
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreDatas
{
    _pageIndex++;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.h5.faqQuestion parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(10),@"faqCatgId":_model.faqCatgId,@"faqName":_searchText} success:^(id  _Nullable response) {
        NSArray *arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            [weakself.dataSource addObject:[[FAQQuestionModel alloc] initWithDictionary:dic error:nil]];
        }
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    [self loadDatas];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAQQuestionModel *model = self.dataSource[indexPath.row];
    FAQTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FAQTableCell"];
    [cell setContent:model.faqName highlightText:_searchText];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FAQQuestionModel *model = self.dataSource[indexPath.row];
    FAQDetailViewController *vc = [[FAQDetailViewController alloc] init];
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
