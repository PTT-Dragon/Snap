//
//  GroupTopImgCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/16.
//

#import "GroupTopImgCell.h"
#import "GroupBuyTipViewController.h"
#import "UIButton+EnlargeTouchArea.h"

@interface GroupTopImgCell ()
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation GroupTopImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [_tipBtn setTitle:kLocalizedString(@"TIPS") forState:0];
//    _tipBtn.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
//    _tipBtn.layer.borderWidth = 1;
    self.titleLabel.text = kLocalizedString(@"Group_buy");
    [self.backBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [self.shareBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
}
- (IBAction)backAction:(UIButton *)sender {
    [[baseTool getCurrentVC].navigationController popViewControllerAnimated:YES];
}
- (IBAction)tipAction:(UIButton *)sender {
    GroupBuyTipViewController *vc = [[GroupBuyTipViewController alloc] init];
    [[baseTool getCurrentVC] presentViewController:vc animated:YES completion:^{
        
    }];
}
- (IBAction)shareAction:(UIButton *)sender {
    NSString *shareUrl = [NSString stringWithFormat:@"%@/product/GroupBuy",Host];
    [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
}



@end
