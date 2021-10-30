//
//  CartChooseAddressCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartChooseAddressCell.h"

@interface CartChooseAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@end

@implementation CartChooseAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(addressModel *)model
{
    _phoneLabel.text = model.contactNbr;
    _nameLabel.text = model.contactName;
    _contentLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@",model.province,model.city,model.district,model.street,model.contactAddress];
//    _selBtn.selected = model.sel;
}
- (IBAction)selAction:(UIButton *)sender {
    
}

@end
