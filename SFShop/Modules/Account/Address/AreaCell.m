//
//  AreaCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import "AreaCell.h"

@interface AreaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation AreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(AreaModel *)model
{
    _model = model;
    _nameLabel.text = model.stdAddr;
    _selImgView.hidden = !model.sel;
    
}
@end
