//
//  CouponCenterCollectionViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/27.
//

#import "CouponCenterCollectionViewCell.h"

@interface CouponCenterCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CouponCenterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(NSDictionary *)dic
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(dic[@"imgUrl"])]];
    NSNumber *price = dic[@"salesPrice"];
    _contentLabel.text = [NSString stringWithFormat:@"RP %@",price.stringValue];
}
@end
