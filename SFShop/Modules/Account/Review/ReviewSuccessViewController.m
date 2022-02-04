//
//  ReviewSuccessViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/8.
//

#import "ReviewSuccessViewController.h"
#import "ReviewViewController.h"


@interface ReviewSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@end

@implementation ReviewSuccessViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _btn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn.layer.borderWidth = 1;
    _label1.text = kLocalizedString(@"REVIEW_PUBLISHED");
    _label2.text = kLocalizedString(@"THANK_REVIEW");
    [_btn1 setTitle:kLocalizedString(@"BACK_TO_HOME") forState:0];
    [_btn setTitle:kLocalizedString(@"REVIEW_LIST") forState:0];
}
- (IBAction)toHomeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)toListAction:(id)sender {
    [baseTool removeVCFromNavigationWithVCNameArr:@[@"AddReviewViewController",@"AdditionalReviewViewController"] currentVC:self];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
