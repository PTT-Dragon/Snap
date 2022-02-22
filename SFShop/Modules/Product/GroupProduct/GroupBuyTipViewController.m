//
//  GroupBuyTipViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/2/22.
//

#import "GroupBuyTipViewController.h"
#import "YYWebImage.h"

@interface GroupBuyTipViewController ()
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imgView1;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation GroupBuyTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imgView1.yy_imageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"img1" ofType:@"gif"]];
    self.imgView2.yy_imageURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"img2" ofType:@"gif"]];
    [self.button setTitle:kLocalizedString(@"OKAY_GOT_IT") forState:0];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
}
- (IBAction)btnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}


@end
