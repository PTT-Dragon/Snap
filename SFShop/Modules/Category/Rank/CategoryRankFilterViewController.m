//
//  CategoryRankFilterViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import "CategoryRankFilterViewController.h"
#import "YHRegularLayout.h"
#import "CategoryRankFilterItem.h"
#import "CategoryRankModel.h"
#import "NSString+Add.h"
#import "UIButton+EnlargeTouchArea.h"
#import "CategoryRankFilterHeader.h"
#import "CategoryRankFilterInputItem.h"

@interface CategoryRankFilterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, readwrite, strong) UIButton *closeBtn;
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray *> *dataArray;
@end

@implementation CategoryRankFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadSubviews];
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)loadSubviews {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.closeBtn];
}

- (void)layout {
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(statuBarHei + 8);
    }];
}

#pragma mark - Event
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataArray objectAtIndex:section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CategoryRankFilterHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryRankFilterHeader" forIndexPath:indexPath];
        CategoryRankFilterModel *model = [self.dataArray objectAtIndex:indexPath.section].firstObject;
        view.titleLabel.text = model.groupName;
        return view;
    }
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cellModel = self.dataArray[indexPath.section][indexPath.row];
    if ([cellModel isKindOfClass:CategoryRankFilterModel.class]) {
        CategoryRankFilterItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankFilterItem" forIndexPath:indexPath];
        CategoryRankFilterModel *model = cellModel;
        cell.titleLabel.text = model.name;
    } else if ([cellModel isKindOfClass:CategoryRankPriceModel.class]){
        CategoryRankPriceModel *model = cellModel;
        CategoryRankFilterInputItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankFilterInputItem" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 0;
    id cellModel = self.dataArray[indexPath.section][indexPath.row];
    if ([cellModel isKindOfClass:CategoryRankFilterModel.class]) {
        CategoryRankFilterModel *model = cellModel;
        width = [model.name calWidth:[UIFont systemFontOfSize:14] lineMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter limitSize:CGSizeMake(200, 32)] + 12 * 2;
    }else {
        NSLog(@"");
    }
    return CGSizeMake(width , 32);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(MainScreen_width, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(MainScreen_width, 16);
}

#pragma mark - Getter
- (void)setModel:(CategoryRankModel *)model {
    _model = model;
    
    //组装数据
    NSArray *arr = @[model.serviceIds,model.catgIds,model.brandIds];
    for (NSArray *subArr in arr) {
        if (subArr.count) {
            [self.dataArray addObject:[NSMutableArray arrayWithArray:subArr]];
        }
    }
    
    //组装price 数据
    CategoryRankPriceModel *price = [CategoryRankPriceModel new];
    price.groupName = @"Price";
    price.minPrice = 0;
    price.maxPrice = 0;
    [self.dataArray addObject:[NSMutableArray arrayWithArray:@[price]]];
}

- (UICollectionView *)collectionView {
    if(!_collectionView){
        YHRegularLayout *flow = [[YHRegularLayout alloc] init];
        flow.minimumInteritemSpacing = 8;
        flow.minimumLineSpacing = 8;
        flow.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        flow.headerReferenceSize = CGSizeMake(MainScreen_width, 13);
        flow.footerReferenceSize = CGSizeMake(MainScreen_width, 13);
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height - navBarHei) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:CategoryRankFilterInputItem.class forCellWithReuseIdentifier:@"CategoryRankFilterInputItem"];
        [_collectionView registerClass:CategoryRankFilterItem.class forCellWithReuseIdentifier:@"CategoryRankFilterItem"];
        [_collectionView registerClass:CategoryRankFilterHeader.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryRankFilterHeader"];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _collectionView;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_closeBtn setImage:[UIImage imageNamed:@"nav_close_bold"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (NSMutableArray<NSMutableArray *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
