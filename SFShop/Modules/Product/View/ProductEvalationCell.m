//
//  ProductEvalationCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ProductEvalationCell.h"

@interface ProductEvalationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ProductEvalationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _bgView.layer.borderWidth = 1;
}
- (void)setModel:(ProductEvalationModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.userLogo)]];
    _nameLabel.text = model.userName;
    _rateLabel.text = model.rate;
    _contentLabel.text = model.evaluationComments;
    _timeLabel.text = model.createdDate;
    
}
@end
