//
//  InviteTopCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "InviteTopCell.h"
#import "PublicShareView.h"

@implementation InviteTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)inviteAction:(id)sender {
    PublicShareView *view = [[NSBundle mainBundle] loadNibNamed:@"PublicShareView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    [[baseTool getCurrentVC].view addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
