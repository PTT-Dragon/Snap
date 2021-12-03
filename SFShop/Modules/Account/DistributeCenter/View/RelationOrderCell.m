//
//  RelationOrderCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/12.
//

#import "RelationOrderCell.h"

@interface RelationOrderCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation RelationOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
}

@end
