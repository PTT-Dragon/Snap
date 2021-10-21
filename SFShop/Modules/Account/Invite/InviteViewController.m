//
//  InviteViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/21.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDatas];
}
- (void)loadDatas
{
    [SFNetworkManager get:SFNet.invite.activityInfo parameters:@{} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

@end
