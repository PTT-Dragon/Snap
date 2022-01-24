//
//  ReplaceDeliveryAddCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/24.
//

#import "ReplaceDeliveryAddCell.h"

@interface ReplaceDeliveryAddCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ReplaceDeliveryAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.text = kLocalizedString(@"ADD_PACKAGE");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
