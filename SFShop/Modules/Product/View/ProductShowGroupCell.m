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
    _label.text = kLocalizedString(@"PEOPLE_SHORT");
    [_joinBtn setTitle:kLocalizedString(@"JOIN") forState:0];
}

- (void)setModel:(ProductGroupListModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.photo)]];
    NSInteger a = model.shareByNum.integerValue - model.memberQty.integerValue;
    _countLabel.text = [NSString stringWithFormat:@"%ld",a];
    _nameLabel.text = model.nickName;
}

- (IBAction)joinAction:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}
@end
