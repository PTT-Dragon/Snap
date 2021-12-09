//
//  MessageViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Message";
    [self loadDatas];
}
- (void)loadDatas
{
    
}

@end
