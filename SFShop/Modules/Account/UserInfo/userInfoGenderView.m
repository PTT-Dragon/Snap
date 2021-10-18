//
//  userInfoGenderView.m
//  SFShop
//
//  Created by 游挺 on 2021/10/18.
//

#import "userInfoGenderView.h"

@interface userInfoGenderView ()
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *secrecyBtn;

@end

@implementation userInfoGenderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
}

- (IBAction)maleAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _femaleBtn.selected = NO;
    _secrecyBtn.selected = NO;
}
- (IBAction)femaleAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _maleBtn.selected = NO;
    _secrecyBtn.selected = NO;
}
- (IBAction)secrecyAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _femaleBtn.selected = NO;
    _maleBtn.selected = NO;
}

@end
