//
//  CashOutSuccessVC.m
//  SFShop
//
//  Created by 游挺 on 2022/3/10.
//

#import "CashOutSuccessVC.h"
#import "CashOutHistoryViewController.h"
#import "SceneManager.h"

@interface CashOutSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *toHomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *toRecordBtn;

@end

@implementation CashOutSuccessVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _label1.text = kLocalizedString(@"SUBMITTED_SUCCESSFUL");
    _label2.text = kLocalizedString(@"PLEASE_WAIT_FOR_SYSTEM_REVIEW");
    [self.toHomeBtn setTitle:kLocalizedString(@"BACK_TO_HOME") forState:0];
    [self.toRecordBtn setTitle:kLocalizedString(@"CASH_OUT_HISTORY_UP") forState:0];
    [baseTool removeVCFromNavigationWithVCNameArr:@[@"verifyCodeVC",@"CaseOutDetailViewController"] currentVC:self];
}

- (IBAction)backToHomeAction:(UIButton *)sender {
    [SceneManager transToHome];
}
- (IBAction)toRecordAction:(UIButton *)sender {
    CashOutHistoryViewController *vc = [[CashOutHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [baseTool removeVCFromNavigationWithVCNameArr:@[@"CashOutSuccessVC"] currentVC:self];
}
@end
