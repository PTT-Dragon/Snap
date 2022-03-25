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
#import "BaseNavView.h"
#import "BaseMoreView.h"
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/SDWebImage.h>

@interface InviteViewController ()<UITableViewDelegate,UITableViewDataSource,BaseNavViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,copy) NSDictionary *ruleDic;

@end

@implementation InviteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

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

- (void)baseNavViewDidClickShareBtn:(BaseNavView *)navView {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataSource = [NSMutableArray array];
    [self loadDatas];
    [self loadRule];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteTopCell" bundle:nil] forCellReuseIdentifier:@"InviteTopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteCell" bundle:nil] forCellReuseIdentifier:@"InviteCell"];
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(@"INVITE_FRIEND")];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
}
- (void)loadDatas
{
    _pageIndex = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.invite.activityInfo parameters:@{} success:^(id  _Nullable response) {
        NSArray *arr = response;
        weakself.imgUrl = arr.firstObject[@"ctnAttachment"];
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:weakself.imgUrl];
            
            if ( !cachedImage ) {
                [self downloadImage:SFImage(self.imgUrl) forIndexPath:0];
            } else {
                
            }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [SFNetworkManager get:SFNet.invite.img parameters:@{} success:^(id  _Nullable response) {
        
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [SFNetworkManager get:SFNet.invite.activityInvRecord parameters:@{@"pageIndex":@(_pageIndex)} success:^(id  _Nullable response) {
        NSArray *arr = response[@"list"];
        self.totalCount = [response[@"total"] integerValue];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [weakself.dataSource addObject:[[InviteModel alloc] initWithDictionary:dic error:nil]];
            }
            [weakself.tableView reloadData];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)loadRule
{
    [SFNetworkManager get:SFNet.invite.activityInvRule parameters:@{} success:^(id  _Nullable response) {
        NSArray *arr = response;
        self.ruleDic = arr.firstObject;
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        [[SDImageCache sharedImageCache] storeImageToMemory:image forKey:self.imgUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
- (void)loadMoreDatas
{
    MPWeakSelf(self)
    _pageIndex ++;
    [SFNetworkManager get:SFNet.invite.activityInvRecord parameters:@{@"pageIndex":@(_pageIndex)} success:^(id  _Nullable response) {
        NSArray *arr = response[@"list"];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [weakself.dataSource addObject:[[InviteModel alloc] initWithDictionary:dic error:nil]];
            }
            [weakself.tableView reloadData];
        }
        NSInteger pageNum = [response[@"pageNum"] integerValue];
        NSInteger pages = [response[@"pages"] integerValue];
        if (pageNum >= pages) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
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
        cell.totalCount = self.totalCount;
        cell.ruleDic = self.ruleDic;
        return cell;
    }
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    [cell setContent:self.dataSource[indexPath.row-1]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
//        if (self.dataSource.count == 0) {
//            return MainScreen_height-navBarHei;
//        }
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey: self.imgUrl];
        if (!image) {
            return AdaptedHeight(635);
        }
            //手动计算cell
            CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
            return imgHeight;
//        return AdaptedHeight(635);
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
