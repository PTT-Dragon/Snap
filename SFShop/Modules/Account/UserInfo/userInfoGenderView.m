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
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;

@end

@implementation userInfoGenderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aaa)];
    [self addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bbb)];
    [self.bgView addGestureRecognizer:tap2];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    _maleBtn.selected = [model.userRes.gender isEqualToString:@"M"];
    _femaleBtn.selected = [model.userRes.gender isEqualToString:@"F"];
    _secrecyBtn.selected = [model.userRes.gender isEqualToString:@""];
//    _titleLabel1.text = kLocalizedString(@"");
    _titleLabel2.text = kLocalizedString(@"MALE");
    _titleLabel3.text = kLocalizedString(@"FEMALE");
    _titleLabel4.text = kLocalizedString(@"PREFER_NOT_TO_RESPOND");
}
- (void)aaa
{
    [self removeFromSuperview];
}
- (void)bbb
{
    
}
- (IBAction)maleAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _femaleBtn.selected = NO;
    _secrecyBtn.selected = NO;
    [self.delegate chooseGender:@"M"];
    [self removeFromSuperview];
}
- (IBAction)femaleAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _maleBtn.selected = NO;
    _secrecyBtn.selected = NO;
    [self.delegate chooseGender:@"F"];
    [self removeFromSuperview];
}
- (IBAction)secrecyAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _femaleBtn.selected = NO;
    _maleBtn.selected = NO;
    [self.delegate chooseGender:@""];
    [self removeFromSuperview];
}

@end
