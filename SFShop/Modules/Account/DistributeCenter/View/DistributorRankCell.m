//
//  DistributorRankCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistributorRankCell.h"

@interface DistributorRankCell ()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;

@end

@implementation DistributorRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(DistributorRankProductModel *)model
{
    _model = model;
    _nameLabel.text = model.offerName;
    _priceLabel.text = [NSString stringWithFormat:@"Commission: Rp %@",model.salesPrice];
    _skuLabel.text = [NSString stringWithFormat:@"Sales:%@",model.salesCnt];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    
}
- (void)setRank:(NSInteger)rank
{
    _rank = rank;
    _rankLabel.text = [NSString stringWithFormat:@"%ld",rank];
}
@end
