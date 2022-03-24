//
//  FlashSaleChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "FlashSaleChildViewController.h"
#import "ProductReviewLabelCell.h"
#import "FlashSaleProductCell.h"
#import "ProductViewController.h"
#import "NSDate+Helper.h"
#import <MJRefresh/MJRefresh.h>

@interface FlashSaleChildViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong) NSMutableArray *ctgArr;
@property (nonatomic,strong) FlashSaleCtgModel *selCtgModel;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (nonatomic, strong) dispatch_source_t timer;//倒计时

@end

@implementation FlashSaleChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_collectionView registerNib:[UINib nibWithNibName:@"ProductReviewLabelCell" bundle:nil] forCellWithReuseIdentifier:@"ProductReviewLabelCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"FlashSaleProductCell" bundle:nil] forCellReuseIdentifier:@"FlashSaleProductCell"];
    _dateLabel.text = [[NSDate dateFromString:_selDateModel.effDate] dayMonth];
    [self loadCtgDatas];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self loadDatas];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.pageIndex ++;
    }];
    
    [self.tableView.mj_header beginRefreshing];
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:_selDateModel.now];
    NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
    
    NSDate *effDate = [formatter dateFromString:_selDateModel.effDate];
    NSTimeInterval effTimeInterval = [effDate timeIntervalSince1970];
    
    NSDate *expDate = [formatter dateFromString:_selDateModel.expDate];
    NSTimeInterval expTimeInterval = [expDate timeIntervalSince1970];
    if (effTimeInterval > timeInterval) {
        //未开始
        self.statuLabel.text = kLocalizedString(@"Star_in");
        MPWeakSelf(self)
        __block NSInteger timeout = effTimeInterval - timeInterval; // 倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){
                
                dispatch_source_cancel(weakself.timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                NSInteger days = (int)(timeout/(3600*24));
                NSInteger hours = (int)((timeout-days*24*3600)/3600);
                NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.hourLabel.text = [NSString stringWithFormat:@"%02ld",hours+days*24];
                    weakself.minuteLabel.text = [NSString stringWithFormat:@"%02ld",minute];
                    weakself.secondLabel.text = [NSString stringWithFormat:@"%02ld",second];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }else if (expTimeInterval > timeInterval){
        //进行中
        self.statuLabel.text = kLocalizedString(@"ENDS_IN");
        MPWeakSelf(self)
        __block NSInteger timeout = expTimeInterval - timeInterval; // 倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){
                
                dispatch_source_cancel(weakself.timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                NSInteger days = (int)(timeout/(3600*24));
                NSInteger hours = (int)((timeout-days*24*3600)/3600);
                NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
                NSInteger second = timeout - days*24*3600 - hours*3600 - minute*60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.hourLabel.text = [NSString stringWithFormat:@"%02ld",hours+days*24];
                    weakself.minuteLabel.text = [NSString stringWithFormat:@"%02ld",minute];
                    weakself.secondLabel.text = [NSString stringWithFormat:@"%02ld",second];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    }else{
        //已结束
        
    }
}
- (void)loadCtgDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.flashSale getCatg:_selDateModel.campaignId] parameters:@{} success:^(id  _Nullable response) {
        weakself.ctgArr = [FlashSaleCtgModel arrayOfModelsFromDictionaries:response error:nil];
        [weakself.collectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)loadDatas
{
    _pageIndex = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.flashSale.productList parameters:@{@"campaignId":_selDateModel.campaignId,@"catalogId":_selCtgModel ? _selCtgModel.catalogId:@"101",@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [self.tableView.mj_header endRefreshing];
        if ([response[@"isLastPage"] integerValue] == 1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        weakself.dataSource = [FlashSaleProductModel arrayOfModelsFromDictionaries:response[@"list"] error:nil];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FlashSaleCtgModel *model = _ctgArr[indexPath.row];
    model.sel = !model.sel;
    _selCtgModel = model.sel ? model: nil;
    for (FlashSaleCtgModel *itemModel in _ctgArr) {
        if (itemModel != model) {
            itemModel.sel = NO;
        }
    }
    [_collectionView reloadData];
    [self loadDatas];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _ctgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlashSaleCtgModel *model = _ctgArr[indexPath.row];
    ProductReviewLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductReviewLabelCell" forIndexPath:indexPath];
    cell.ctgModel = model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlashSaleCtgModel *model = _ctgArr[indexPath.row];
    return CGSizeMake(model.width , 32);
}
#pragma mark - tableview.delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlashSaleProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlashSaleProductCell"];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 172;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FlashSaleProductModel *model = self.dataSource[indexPath.row];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = model.offerId.integerValue;
    vc.productId = model.productId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
