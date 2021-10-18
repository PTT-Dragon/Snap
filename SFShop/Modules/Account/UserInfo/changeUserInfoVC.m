//
//  changeUserInfoVC.m
//  SFShop
//
//  Created by 游挺 on 2021/10/18.
//

#import "changeUserInfoVC.h"
#import "userInfoGenderView.h"


@interface changeUserInfoVC ()
@property (weak, nonatomic) IBOutlet UIButton *genderBtn;

@end

@implementation changeUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Personal Information";
    _genderBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _genderBtn.layer.borderWidth = 1;
}
- (IBAction)genderAction:(UIButton *)sender {
    userInfoGenderView *genderView = [[NSBundle mainBundle] loadNibNamed:@"userInfoGenderView" owner:self options:nil].firstObject;
    genderView.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    [self.view addSubview:genderView];
}

@end
