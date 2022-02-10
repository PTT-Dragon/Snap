//
//  ReviewPhrchaseCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/6.
//

#import "ReviewPhrchaseCell.h"
#import "ImageCollectionViewCell.h"


@interface ReviewPhrchaseCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin2;

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation ReviewPhrchaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
}
- (void)setModel:(PurchaseReviewModel *)model
{
    self.leftMargin.constant = 47;
    self.leftMargin2.constant = 12;
    self.lineView.hidden = NO;
    _model = model;
//    _timeLabel.text = [NSString stringWithFormat:@"Additional Reviews %@ days after purchase",model.reviewTime];
    _timeLabel.text = model.storeName;
    _contentLabel.text = model.replyComments;
    [self.head sd_setImageWithURL:[NSURL URLWithString:model.storeLogoUrl] placeholderImage:[UIImage imageNamed:@"toko"]];
    [_collectionView reloadData];
}

-(void)setReviewModel:(PurchaseReviewModel *)reviewModel {
    self.leftMargin.constant = 0;
    self.leftMargin2.constant = 0;
    self.lineView.hidden = YES;
    _reviewModel = reviewModel;
    
    NSString *reviewTime = [NSString stringWithFormat:@"%.0f",fabs([reviewModel.reviewTime doubleValue])];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",kLocalizedString(@"ADDITIONAL_DAY"),reviewTime,kLocalizedString(@"days after purchase")];
    _contentLabel.text = reviewModel.reviewComments;
    [self.head sd_setImageWithURL:[NSURL URLWithString:@""]];
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
    return _reviewModel.contents.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage([_reviewModel.contents[indexPath.row] url])]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((MainScreen_width-32-30)/4 , (MainScreen_width-32-30)/4);
}
@end
