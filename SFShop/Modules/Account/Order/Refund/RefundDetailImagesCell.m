//
//  RefundDetailImagesCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "RefundDetailImagesCell.h"
#import "ImageCollectionViewCell.h"

@interface RefundDetailImagesCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RefundDetailImagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
}
- (void)setModel:(RefundDetailModel *)model
{
    _model = model;
    [_collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.contents.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EvaluatesContentsModel *evaModel = _model.contents[indexPath.row];
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage([evaModel imgUrl])]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((MainScreen_width-32-30)/4 , (MainScreen_width-32-30)/4);
}
@end
