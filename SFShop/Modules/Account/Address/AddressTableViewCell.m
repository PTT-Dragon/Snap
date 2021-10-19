//
//  AddressTableViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)setContent:(addressModel *)model
{
    self.phoneLabel.text = model.contactNbr;
    self.contentLabel.text = model.contactAddress;
    self.nameLabel.text = model.contactName;
//    self.tagLabel.text = model.
    
}
- (IBAction)editAction:(id)sender {
}

@end
