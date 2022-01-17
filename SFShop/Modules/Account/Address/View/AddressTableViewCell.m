//
//  AddressTableViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"


@interface AddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) addressModel *model;
@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)setContent:(addressModel *)model
{
    _model = model;
    self.phoneLabel.text = model.contactNbr;
    self.nameLabel.text = model.contactName;
    self.contentLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",model.postCode,model.contactAddress,model.street,model.district,model.city,model.province,model.country];
    self.tagLabel.text = [model.isDefault isEqualToString:@"Y"] ? kLocalizedString(@""): ;
    
}
- (IBAction)editAction:(id)sender {
    AddAddressViewController *vc = [[AddAddressViewController alloc] init];
    vc.model = _model;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
