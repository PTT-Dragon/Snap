//
//  ImageCollectionViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/4.
//

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

@implementation ImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)delAction:(UIButton *)sender {
    if (self.block) {
        self.block(_index);
    }
}
- (void)setCanDel:(BOOL)canDel
{
    _canDel = canDel;
    _delBtn.hidden = !canDel;
}

@end
