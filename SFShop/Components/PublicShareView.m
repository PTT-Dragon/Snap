//
//  PublicShareView.m
//  SFShop
//
//  Created by 游挺 on 2021/11/22.
//

#import "PublicShareView.h"
#import "UIButton+SGImagePosition.h"

@interface PublicShareView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *whatsappBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;

@end

@implementation PublicShareView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    [_facebookBtn SG_imagePositionStyle:SGImagePositionStyleTop spacing:5];
    [_whatsappBtn SG_imagePositionStyle:SGImagePositionStyleTop spacing:5];
    [_twitterBtn SG_imagePositionStyle:SGImagePositionStyleTop spacing:5];
}
- (IBAction)btnAction:(UIButton *)sender {
}
- (void)removeSelf:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}
@end
