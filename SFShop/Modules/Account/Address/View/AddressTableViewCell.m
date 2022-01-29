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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

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
    self.contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",model.postCode,model.contactAddress,model.street,model.district,model.city,model.province,model.country];
    self.tagLabel.text = [model.isDefault isEqualToString:@"Y"] ? [NSString stringWithFormat:@" %@ ",kLocalizedString(@"DEFAULT")]: @"";
    self.tagLabel.hidden = [model.isDefault isEqualToString:@"N"];
}
- (IBAction)editAction:(id)sender {
    if (self.block) {
        self.block(_model);
    }
}

-(void)setCurAddress:(NSString *)curAddress {
    _curAddress = curAddress;
    if (curAddress) {
        self.leftMargin.constant = 60;
        self.selectBtn.hidden = NO;
        
        if ([self.model.modifyDate isEqualToString:curAddress]) {
            self.selectBtn.selected = YES;
        }else {
            self.selectBtn.selected = NO;
        }
        
    }else {
        self.leftMargin.constant = 20;
        self.selectBtn.hidden = YES;
    }
}

@end
