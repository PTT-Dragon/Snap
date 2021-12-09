//
//  ProductReviewViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ProductReviewViewController.h"
#import "StarView.h"
#import "ProductReviewChildViewController.h"
#import <VTMagic/VTMagic.h>
#import "ProductDetailModel.h"
#import "ProductReviewLabelCell.h"
#import "NSString+Add.h"
#import <MJRefresh/MJRefresh.h>


@interface ProductReviewViewController ()<VTMagicViewDelegate, VTMagicViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) VTMagicController *magicController;
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (nonatomic,strong) ProductEvalationDetailModel *model;
@property (weak, nonatomic) IBOutlet StarView *allStarView;
@property (weak, nonatomic) IBOutlet StarView *starView1;
@property (weak, nonatomic) IBOutlet StarView *starView2;
@property (weak, nonatomic) IBOutlet StarView *starView3;
@property (weak, nonatomic) IBOutlet StarView *starView4;
@property (weak, nonatomic) IBOutlet StarView *starView5;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *fourCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoWidth;
@property (nonatomic,strong) ProductEvalationLabelsModel *selLabelModel;
@end

@implementation ProductReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Review";
    _collectionView.delegate = self;_collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ProductReviewLabelCell" bundle:nil] forCellWithReuseIdentifier:@"ProductReviewLabelCell"];
    self.menuList = @[@"All", @"Picture",@"Positive Review",@"Nagative Review"];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, 260, MainScreen_width, MainScreen_height-navBarHei-260);
    [_magicController.magicView reloadData];
    [self loadDatas];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.evaluate getEvaluateOf:_evaluationsId] parameters:@{} success:^(id  _Nullable response) {
        weakself.model = [ProductEvalationDetailModel yy_modelWithDictionary:response];
        [weakself updateView];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)updateView
{
    _starView1.score = 5;
    _starView2.score = 4;
    _starView3.score = 3;
    _starView4.score = 2;
    _starView5.score = 1;
    _allStarView.score = self.model.evaluationAvg.integerValue;
    _rateLabel.text = self.model.evaluationAvg;
    _reviewCountLabel.text = [NSString stringWithFormat:@"%ld Reviews",self.model.evaluationCnt];
    _oneCountLabel.text = [NSString stringWithFormat:@"%.0f",self.model.oneStarCnt];
    _twoCountLabel.text = [NSString stringWithFormat:@"%.0f",self.model.twoStarCnt];
    _threeCountLabel.text = [NSString stringWithFormat:@"%.0f",self.model.threeStarCnt];
    _fourCountLabel.text = [NSString stringWithFormat:@"%.0f",self.model.fourStarCnt];
    _fiveCountLabel.text = [NSString stringWithFormat:@"%.0f",self.model.fiveStarCnt];
    _fiveWidth.constant = self.model.fiveStarCnt/self.model.evaluationCnt*120;
    _fourWidth.constant = self.model.fourStarCnt/self.model.evaluationCnt*120;
    _threeWidth.constant = self.model.threeStarCnt/self.model.evaluationCnt*120;
    _twoWidth.constant = self.model.twoStarCnt/self.model.evaluationCnt*120;
    _oneWidth.constant = self.model.oneStarCnt/self.model.evaluationCnt*120;
    [_collectionView reloadData];
}
/// VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return self.menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor: [UIColor jk_colorWithHexString: @"#7B7B7B"] forState:UIControlStateNormal];
        [menuItem setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Trueno" size:17.f];
    }
    [menuItem setSelected: (itemIndex == self.currentMenuIndex)];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"myFavorite.childController.identifier";
    ProductReviewChildViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//    if (!gridViewController) {
        gridViewController = [[ProductReviewChildViewController alloc] init];
    gridViewController.offerId = _evaluationsId.integerValue;
    gridViewController.evaluationType = pageIndex == 0 ? @"": pageIndex == 1 ? @"A":pageIndex == 2 ? @"C": @"D";
    gridViewController.labelId = _selLabelModel.labelId;
//    }
    return gridViewController;
}

/// VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    NSLog(@"pageIndex:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
    self.currentMenuIndex = pageIndex;
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
//    viewController.view.frame = magicView.bounds;
    NSLog(@"pageIndex:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductEvalationLabelsModel *model = _model.evaluationLabels[indexPath.row];
    model.sel = !model.sel;
    _selLabelModel = model.sel ? model: nil;
    for (ProductEvalationLabelsModel *itemModel in _model.evaluationLabels) {
        if (itemModel != model) {
            itemModel.sel = NO;
        }
    }
    [_collectionView reloadData];
    for (ProductReviewChildViewController *subVc in self.magicController.viewControllers) {
        [subVc.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.evaluationLabels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductEvalationLabelsModel *labelModel = _model.evaluationLabels[indexPath.row];
    ProductReviewLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductReviewLabelCell" forIndexPath:indexPath];
    cell.model = labelModel;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductEvalationLabelsModel *labelModel = _model.evaluationLabels[indexPath.row];
    return CGSizeMake(labelModel.width , 32);
}

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor redColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.scrollEnabled = NO;
    }
    return _magicController;
}

@end
