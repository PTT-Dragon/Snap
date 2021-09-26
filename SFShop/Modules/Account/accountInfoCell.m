//
//  accountInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/23.
//

#import "accountInfoCell.h"
#import "MyCouponViewController.h"

@interface accountInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *couponView;

@end

@implementation accountInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *couponTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponAction)];
    [_couponView addGestureRecognizer:couponTap];
}
- (void)couponAction
{
    MyCouponViewController *vc = [[MyCouponViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
