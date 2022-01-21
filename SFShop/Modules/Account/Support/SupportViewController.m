//
//  SupportViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "SupportViewController.h"

@interface SupportViewController ()

@end

@implementation SupportViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Support");
}
- (IBAction)emailAction:(id)sender {
    NSString *recipients = @"mailto:ysy@flyrise.cn?subject=Hello from California!";
    NSString *body = @"&body=It is raining in sunny California!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
              email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email] options:@{} completionHandler:^(BOOL success) {
            
        }];
}
- (IBAction)chatAction:(id)sender {
}


@end
