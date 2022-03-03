//
//  ProductGroupListCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/17.
//

#import "ProductGroupListCell.h"

@interface ProductGroupListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end

@implementation ProductGroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_joinBtn setTitle:kLocalizedString(@"JOIN") forState:0];
}
- (void)setModel:(ProductGroupListModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.photo)]];
    _nameLabel.text = model.nickName;
}
- (IBAction)joinAction:(UIButton *)sender {
    if (_joinBlock) {
        _joinBlock();
    }
}

@end
