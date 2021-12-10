//
//  FlashSaleChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "FlashSaleChildViewController.h"
#import "ProductReviewLabelCell.h"
#import "FlashSaleProductCell.h"

@interface FlashSaleChildViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong) NSMutableArray *ctgArr;
@property (nonatomic,strong) FlashSaleCtgModel *selCtgModel;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation FlashSaleChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_collectionView registerNib:[UINib nibWithNibName:@"ProductReviewLabelCell" bundle:nil] forCellWithReuseIdentifier:@"ProductReviewLabelCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"FlashSaleProductCell" bundle:nil] forCellReuseIdentifier:@"FlashSaleProductCell"];
    _dateLabel.text = _selDateModel.effDate;
    [self loadCtgDatas];
    [self loadDatas];
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
    [SFNetworkManager get:SFNet.flashSale.productList parameters:@{@"campaignId":_selDateModel.campaignId,@"catgId":_selCtgModel ? _selCtgModel.catalogId:@"",@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        weakself.dataSource = [FlashSaleProductModel arrayOfModelsFromDictionaries:response[@"list"] error:nil];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
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

@end
