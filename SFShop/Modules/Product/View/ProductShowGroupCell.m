//
//  ProductShowGroupCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/22.
//

#import "ProductShowGroupCell.h"

@interface ProductShowGroupCell ()
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ProductShowGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(cmpShareBuysModel *)model
{
    _model = model;
//    _imgView sd_setImageWithURL:[NSURL URLWithString:model.]
}

@end
