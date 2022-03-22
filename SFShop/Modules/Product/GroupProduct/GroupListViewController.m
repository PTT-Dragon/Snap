//
//  GroupListViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/16.
//

#import "GroupListViewController.h"
#import "CategoryRankModel.h"
#import "GroupFilterCell.h"
#import "GroupBuyListCell.h"
#import "ProductViewController.h"
#import "GroupTopImgCell.h"
#import <MJRefresh/MJRefresh.h>
#import "CategoryRankFilterViewController.h"
#import "UIButton+EnlargeTouchArea.h"
#import "GroupBuyTipViewController.h"

typedef NS_ENUM(NSUInteger, CategoryRankType) {
    CategoryRankTypeSales = 1,          //销售维度
    CategoryRankTypePopularity = 2,     //欢迎维度
    CategoryRankTypePriceAscending = 3, //价格升序纬度
    CategoryRankTypePriceDescending = 4,//价格降序维度
    CategoryRankTypeDetail = 9,         //排序详情
};




@interface GroupListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;
@property (nonatomic, readwrite, assign) CategoryRankType currentType;
@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@property (nonatomic, readwrite, strong) UIButton *popularityBtn;
@property (nonatomic, readwrite, strong) UIButton *salesBtn;
@property (nonatomic, readwrite, strong) UIButton *priceBtn;
@property (nonatomic, readwrite, strong) UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (nonatomic, readwrite, strong) UIButton *lastBtn;
@property (nonatomic, readwrite, strong) UIImageView *priceSortUpImg;
@property (nonatomic, readwrite, strong) UIImageView *priceSortDownImg;
@end

@implementation GroupListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Group_buy");
    self.currentType = 2;
    [self loadSubviewsWithType:self.currentType];
    [self layout];
    [self initUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self loadDatas:self.pageIndex sortType:self.currentType filter:self.filterCacheModel];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.pageIndex ++;
        [self loadDatas:self.pageIndex sortType:self.currentType filter:self.filterCacheModel];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    [self showTipView];
}
- (void)showTipView
{
    BOOL first = UserDefaultBOOLForKey(@"FirstOpenApp");
    if (first) {
        UserDefaultSetBOOLForKey(NO, @"FirstOpenApp")
        [self performSelector:@selector(aaa) withObject:nil afterDelay:0.5];
    }
}
- (void)aaa
{
    GroupBuyTipViewController *vc = [[GroupBuyTipViewController alloc] init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    vc.view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
}
- (void)layout {
    [self.popularityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScale(16));
        make.top.mas_equalTo(self.topImgView.mas_bottom).offset(10);
        make.height.mas_equalTo(KScale(32));
        CGFloat width = [self.popularityBtn.titleLabel.text calWidthWithLabel:self.popularityBtn.titleLabel] + 30;
        make.width.mas_equalTo(width);
    }];
    
    [self.salesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.popularityBtn.mas_right).offset(KScale(8));
        make.top.mas_equalTo(self.topImgView.mas_bottom).offset(10);
        make.height.mas_equalTo(KScale(32));
        CGFloat width = [self.salesBtn.titleLabel.text calWidthWithLabel:self.salesBtn.titleLabel] + 30;
        make.width.mas_equalTo(width);
    }];
    
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.salesBtn.mas_right).offset(KScale(8));
        make.top.mas_equalTo(self.topImgView.mas_bottom).offset(10);
        make.height.mas_equalTo(KScale(32));
        CGFloat width = [self.priceBtn.titleLabel.text calWidthWithLabel:self.priceBtn.titleLabel] + 30;
        make.width.mas_equalTo(width);
    }];
    [self.priceBtn addSubview:self.priceSortUpImg];
    [self.priceBtn addSubview:self.priceSortDownImg];
    [self.priceSortUpImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.bottom.equalTo(self.priceBtn.mas_centerY).offset(0);
        make.right.offset(-10);
    }];
    [self.priceSortDownImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.top.equalTo(self.priceBtn.mas_centerY).offset(0);
        make.right.offset(-10);
    }];
    
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KScale(-25));
        make.top.mas_equalTo(self.topImgView.mas_bottom).offset(14);
        make.height.mas_equalTo(KScale(18));
        make.width.mas_equalTo(KScale(18));
    }];
}
- (void)loadSubviewsWithType:(CategoryRankType)type {
    for (UIButton *btn in @[self.popularityBtn,self.salesBtn,self.priceBtn,self.filterBtn]) {
        if (btn.tag - 100 == type) {
            [self sortUpdateBtnUI:btn];
        }
        [self.view addSubview:btn];
    }
}
- (void)sortUpdateBtnUI:(UIButton *)btn {
    btn.selected = YES;
    btn.layer.borderColor = [UIColor jk_colorWithHexString:@"#FF1659"].CGColor;
    if (self.lastBtn && self.lastBtn != btn ) {
        self.lastBtn.selected = NO;
        self.lastBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
    }
    self.lastBtn = btn;
}
- (void)initUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupBuyListCell" bundle:nil] forCellReuseIdentifier:@"GroupBuyListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupTopImgCell" bundle:nil] forCellReuseIdentifier:@"GroupTopImgCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.topImgView.mas_bottom).offset(KScale(64));
    }];
    [self.topImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/static/GroupBy.95d35058.png",Host]]];
    self.backBtn.layer.zPosition = 1;
    self.shareBtn.layer.zPosition = 1;
    self.titleLabel.layer.zPosition = 1;
    self.titleImgView.layer.zPosition = 1;
    [self.backBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.shareBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.shareBtn];
    self.titleLabel.text = @"Group Buy";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 136;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//        return cell;
//    }else if (indexPath.row == 1){
//        GroupFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupFilterCell"];
//        if (!cell) {
//            cell = [[GroupFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupFilterCell" type:self.currentType];
//            __weak __typeof(self)weakSelf = self;
//            cell.clickFilterBlock = ^(CategoryRankType type) {
//                __strong __typeof(weakSelf)strongSelf = weakSelf;
//                switch (type) {
//                    case CategoryRankTypePopularity:
//                    case CategoryRankTypeSales:
//                    case CategoryRankTypePriceDescending:
//                    case CategoryRankTypePriceAscending: {
//                        [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
//                        strongSelf.currentType = type;
//                        [strongSelf.tableView.mj_header beginRefreshing];
//                    }
//                        break;
//                    case CategoryRankTypeDetail:
//                        [strongSelf jumpToFilterDetail];
//                        break;
//                    default:
//                        break;
//                }
//            };
//        }
//        return cell;
//    }
    GroupBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupBuyListCell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row > 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CategoryRankPageInfoListModel *model = self.dataArray[indexPath.row];
        ProductViewController *vc = [[ProductViewController alloc] init];
        vc.offerId = model.offerId;
        vc.productId = model.productId.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}
- (void)loadDatas:(NSInteger)currentPage sortType:(CategoryRankType)type filter:(CategoryRankFilterCacheModel *)filter
{
    MPWeakSelf(self)
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
        @"q": @"",
        @"pageIndex": @(currentPage),
        @"pageSize": @(10),
        @"sortType": [NSString stringWithFormat:@"%ld",type],
        @"offerIdList": [NSNull null],
        @"campaignType":@"4"//参照h5 有可能是动态
//        @"catgIds": @(self.model.inner.catgId)//默认是外部传入的分类,如果 filter.filterParam 有该字段,会被新值覆盖
    }];
    [parm addEntriesFromDictionary:filter.filterParam];
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        CategoryRankModel *dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        if (!self.dataModel) {
            self.dataModel = dataModel;
        }
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        if ([response[@"pageInfo"][@"isLastPage"] integerValue] == 1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.dataArray addObjectsFromArray:dataModel.pageInfo.list];
//        [self refreshNoItemsStatus];
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - Event
- (void)jumpToFilterDetail {
    //加载缓存配置到数据层
    self.dataModel.filterCache = self.filterCacheModel;
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        if (type != CategoryRankFilterRefreshCancel) {
            self.dataModel = model;
            self.filterCacheModel = model.filterCache;
            [self.tableView.mj_header beginRefreshing];
        }
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}
- (void)sort:(UIButton *)btn {
    //改变状态之前的逻辑处理
    [self dealPrice:btn];
    CategoryRankType type = btn.tag - 100;
//    if (btn == self.priceBtn) {
//        BOOL isSeleted = btn.selected;
//        if (isSeleted) {
//            if (type == CategoryRankTypePriceDescending) {
//                btn.tag = CategoryRankTypePriceAscending + 100;
//            } else {
//                btn.tag = CategoryRankTypePriceDescending + 100;
//            }
//        } else {//从未选中到选中状态默认未降序
//            btn.tag = CategoryRankTypePriceDescending + 100;
//        }
//    }
    if (type == CategoryRankTypeDetail) {
        [self jumpToFilterDetail];
    }else{
        self.currentType = type;
        [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
        [self.tableView.mj_header beginRefreshing];
    }

    //回调给外部
//    !self.clickFilterBlock?:self.clickFilterBlock(btn.tag - 100);
    

    //UI 处理
    [self sortUpdateBtnUI:btn];
}
//改变状态之前 处理升序、降序价格逻辑
- (void)dealPrice:(UIButton *)btn {
    if (btn == self.priceBtn) {
        CategoryRankType type = btn.tag - 100;
        BOOL isSeleted = btn.selected;
        if (isSeleted) {
            if (type == CategoryRankTypePriceDescending) {
                btn.tag = CategoryRankTypePriceAscending + 100;
                self.priceSortUpImg.image = [UIImage imageNamed:@"swipe-up-red"];
                self.priceSortDownImg.image = [UIImage imageNamed:@"swipe-down"];
            } else {
                btn.tag = CategoryRankTypePriceDescending + 100;
                self.priceSortUpImg.image = [UIImage imageNamed:@"swipe-up"];
                self.priceSortDownImg.image = [UIImage imageNamed:@"swipe-down-red"];
            }
        } else {//从未选中到选中状态默认未降序
            btn.tag = CategoryRankTypePriceDescending + 100;
            self.priceSortUpImg.image = [UIImage imageNamed:@"swipe-up"];
            self.priceSortDownImg.image = [UIImage imageNamed:@"swipe-down-red"];
        }
    } else {
        self.priceSortUpImg.image = [UIImage imageNamed:@"swipe-up"];
        self.priceSortDownImg.image = [UIImage imageNamed:@"swipe-down"];
    }
}
- (void)detailFilter:(UIButton *)btn {
        [self jumpToFilterDetail];
}
- (IBAction)backAction:(UIButton *)sender {
    [[baseTool getCurrentVC].navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareAction:(UIButton *)sender {
    NSString *shareUrl = [NSString stringWithFormat:@"%@/product/GroupBuy",Host];
    [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
}
- (IBAction)tipAction:(UIButton *)sender {
    GroupBuyTipViewController *vc = [[GroupBuyTipViewController alloc] init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    vc.view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
}



- (CategoryRankFilterCacheModel *)filterCacheModel {
    if (_filterCacheModel == nil) {
        _filterCacheModel = [[CategoryRankFilterCacheModel alloc] init];
        _filterCacheModel.minPrice = -1;//初始化为-1,传参时,传入@""表示没有指定min价格
        _filterCacheModel.maxPrice = -1;//初始化为-1,传参时,传入@""表示没有指定max价格
    }
    return _filterCacheModel;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
#pragma mark - Getter
- (UIButton *)popularityBtn {
    if (_popularityBtn == nil) {
        _popularityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _popularityBtn.tag = CategoryRankTypePopularity + 100;
        _popularityBtn.titleLabel.font = kFontRegular(14);
        [_popularityBtn addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
        [_popularityBtn setTitle:kLocalizedString(@"Popularity") forState:UIControlStateNormal];
        [_popularityBtn setTitleColor:[UIColor jk_colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
        [_popularityBtn setTitleColor:[UIColor jk_colorWithHexString:@"#FF1659"] forState:UIControlStateSelected];
        _popularityBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _popularityBtn.layer.borderWidth = 1;
    }
    return _popularityBtn;
}

- (UIButton *)salesBtn {
    if (_salesBtn == nil) {
        _salesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _salesBtn.tag = CategoryRankTypeSales + 100;
        _salesBtn.titleLabel.font = kFontRegular(14);
        [_salesBtn addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
        [_salesBtn setTitle:kLocalizedString(@"Sales") forState:UIControlStateNormal];
        [_salesBtn setTitleColor:[UIColor jk_colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
        [_salesBtn setTitleColor:[UIColor jk_colorWithHexString:@"#FF1659"] forState:UIControlStateSelected];
        _salesBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _salesBtn.layer.borderWidth = 1;
    }
    return _salesBtn;
}

- (UIButton *)priceBtn {
    if (_priceBtn == nil) {
        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _priceBtn.tag = CategoryRankTypePriceAscending + 100;
        _priceBtn.titleLabel.font = kFontRegular(14);
        [_priceBtn addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
        [_priceBtn setTitle:kLocalizedString(@"Price") forState:UIControlStateNormal];
        [_priceBtn setTitleColor:[UIColor jk_colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
        [_priceBtn setTitleColor:[UIColor jk_colorWithHexString:@"#FF1659"] forState:UIControlStateSelected];
        _priceBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _priceBtn.layer.borderWidth = 1;
        [_priceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    }
    return _priceBtn;
}

- (UIButton *)filterBtn {
    if (_filterBtn == nil) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
        _filterBtn.tag = CategoryRankTypeDetail + 100;
        [_filterBtn addTarget:self action:@selector(detailFilter:) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn setImage:[UIImage imageNamed:@"rank_filters"] forState:UIControlStateNormal];
    }
    return _filterBtn;
}
-(UIImageView *)priceSortUpImg {
    if (!_priceSortUpImg) {
        _priceSortUpImg = [[UIImageView alloc] init];
        _priceSortUpImg.image = [UIImage imageNamed:@"swipe-up"];
    }
    return _priceSortUpImg;
}

-(UIImageView *)priceSortDownImg {
    if (!_priceSortDownImg) {
        _priceSortDownImg = [[UIImageView alloc] init];
        _priceSortDownImg.image = [UIImage imageNamed:@"swipe-down"];
    }
    return _priceSortDownImg;
}
@end
