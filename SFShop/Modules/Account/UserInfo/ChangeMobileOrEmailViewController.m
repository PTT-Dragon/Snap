//
//  ChangeMobileOrEmailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "ChangeMobileOrEmailViewController.h"
#import "verifyCodeVC.h"


@interface ChangeMobileOrEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *field2;

@end

@implementation ChangeMobileOrEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _type == 1 ? @"Change Mobile Number": @"Email";
    _label.text = _type == 1 ? @"Password": @"Email";
    _field.placeholder = _type == 1 ? @"Change Mobile Number": @"Email";
    _label2.hidden = _type == 2;
    _field2.hidden = _type == 2;
}
- (IBAction)submitAction:(UIButton *)sender {
    verifyCodeVC *vc = [[verifyCodeVC alloc] init];
    vc.type = _type == 1 ? ChangeMobileNumber_Code: ChangeEmail_Code;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
