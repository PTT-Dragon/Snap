//
//  AddAddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Modify Address";
    _viewWidth.constant = MainScreen_width-32;
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
