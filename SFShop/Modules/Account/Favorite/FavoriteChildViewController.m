//
//  FavoriteChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "FavoriteChildViewController.h"
#import "FavoriteTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "EmptyView.h"
#import "ProductViewController.h"

@interface FavoriteChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) EmptyView *emptyView;

@end

@implementation FavoriteChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    _pageIndex = 1;
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"FavoriteTableViewCell" bundle:nil] forCellReuseIdentifier:@"FavoriteTableViewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.bottom.mas_equalTo(self.view);
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
        make.top.mas_equalTo(self.view.mas_top).offset(90);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
- (void)loadDatas
{
    self.pageIndex = 1;
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.pageIndex) forKey:@"pageIndex"];
    [params setValue:@(10) forKey:@"pageSize"];
    if (_type == PRICEDOWNTYPE) {
        [params setValue:@"Y" forKey:@"priceDownFlag"];
    }else if (_type == PROMOTIONTYPE){
        [params setValue:@"Y" forKey:@"promotionFlag"];
    }
    if (_rankModel) {
        __block NSString *catgId = @"";
        [_rankModel.catgIds enumerateObjectsUsingBlock:^(CategoryRankCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelected) {
                catgId = obj.idStr;
            }
        }];
        [params setValue:catgId forKey:@"catgId"];
        [params setValue:@(_rankModel.priceModel.minPrice) forKey:@"startPrice"];
        [params setValue:@(_rankModel.priceModel.maxPrice) forKey:@"endPrice"];
    }
    [SFNetworkManager get:SFNet.favorite.favorite parameters:params success:^(id  _Nullable response) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:[favoriteModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
        [weakself showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [weakself showEmptyView];
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)reloadDatas
{
    [self.tableView.mj_header beginRefreshing];
}
- (void)showEmptyView {
    if (self.dataSource.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
}

- (void)loadMoreDatas
{
    self.pageIndex ++;
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.pageIndex) forKey:@"pageIndex"];
    [params setValue:@(10) forKey:@"pageSize"];
    if (_type == PRICEDOWNTYPE) {
        [params setValue:@"Y" forKey:@"priceDownFlag"];
    }else if (_type == PROMOTIONTYPE){
        [params setValue:@"Y" forKey:@"promotionFlag"];
    }
    __block NSString *catgId = @"";
    [_rankModel.catgIds enumerateObjectsUsingBlock:^(CategoryRankCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            catgId = obj.idStr;
        }
    }];
    [params setValue:catgId forKey:@"catgId"];
    [params setValue:@(_rankModel.priceModel.minPrice) forKey:@"startPrice"];
    [params setValue:@(_rankModel.priceModel.maxPrice) forKey:@"endPrice"];
    [SFNetworkManager get:SFNet.favorite.favorite parameters:params success:^(id  _Nullable response) {
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.dataSource addObjectsFromArray:[favoriteModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteTableViewCell"];
    [cell setContent:self.dataSource[indexPath.row]];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:[NSString stringWithFormat:@"%@",kLocalizedString(@"Delete")] handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self deleteCellWithRow:indexPath.row];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"trash"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    //置顶
    UIContextualAction *topRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:[NSString stringWithFormat:@"%@",kLocalizedString(@"PIN_TO_TOP")] handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self pinToTopWithRow:indexPath.row];
    }];
    topRowAction.image = [UIImage imageNamed:@"top"];
    topRowAction.backgroundColor = RGBColorFrom16(0xFF1659);
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction,topRowAction]];
    return config;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
 
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
 
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kLocalizedString(@"Delete");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    favoriteModel *model = self.dataSource[indexPath.row];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = model.offerId.integerValue;
    vc.productId = model.productId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 10)];
    headerView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    return headerView;
}

#pragma mark -
- (void)deleteCellWithRow:(NSInteger)row
{
    favoriteModel *model = self.dataSource[row];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.favorite.del parameters:@{@"productIdList":@[model.productId]} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Delete_success")];
        [weakself.dataSource removeObjectAtIndex:row];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
//置顶
- (void)pinToTopWithRow:(NSInteger)row
{
    favoriteModel *model = self.dataSource[row];
    [SFNetworkManager post:SFNet.favorite.top parameters:@{@"productId":model.productId,@"topFlag":@"Y"} success:^(id  _Nullable response) {
        [self.tableView.mj_header beginRefreshing];
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

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNofavoriteType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}


@end
