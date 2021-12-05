//
//  ReviewDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/5.
//

#import "ReviewDetailViewController.h"

@interface ReviewDetailViewController ()

@end

@implementation ReviewDetailViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Review Detail";
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
