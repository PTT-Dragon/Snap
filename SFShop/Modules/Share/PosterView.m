//
//  PosterView.m
//  SFShop
//
//  Created by 游挺 on 2022/3/24.
//

#import "PosterView.h"
#import "PosterViewCell.h"

@interface PosterView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PosterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"PosterViewCell" bundle:nil] forCellWithReuseIdentifier:@"PosterViewCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.posterModelArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PosterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PosterViewCell" forIndexPath:indexPath];
    cell.model = self.posterModelArr[indexPath.row];
    cell.productModel = self.productModel;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width, self.height);
}

@end
