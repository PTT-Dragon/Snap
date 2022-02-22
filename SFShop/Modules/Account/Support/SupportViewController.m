//
//  SupportViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/7.
//

#import "SupportViewController.h"
#import "PublicWebViewController.h"

@interface SupportViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

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
    self.label2.text = kLocalizedString(@"SUPPORT_CONTENT");
    self.label1.text = kLocalizedString(@"SUPPORT_THANK");
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
    PublicWebViewController *vc = [[PublicWebViewController alloc] init];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    vc.url = [NSString stringWithFormat:@"http://47.243.193.90:8064/chat/A1test@A1.com"];
    vc.sysAccount = model.account;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}


@end
