//
//  ArticleEvaluateBottomCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/20.
//

#import "ArticleEvaluateBottomCell.h"

@interface ArticleEvaluateBottomCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTrailing;

@end

@implementation ArticleEvaluateBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setContent:(NSInteger)count showAll:(BOOL)showAll
{
    if (showAll) {
        _labelLeading.priority = 250;
        _labelTrailing.priority = 750;
        _imgView.image = [UIImage imageNamed:@"swipe-up"];
        _contentLabel.text = kLocalizedString(@"Hide");
    }else{
        _labelLeading.priority = 750;
        _labelTrailing.priority = 250;
        _imgView.image = [UIImage imageNamed:@"swipe-down"];
        _contentLabel.text = [NSString stringWithFormat:@"%@ (%ld)", kLocalizedString(@"View_replies"), count];
    }
}
@end
