//
//  ProductEvalationTitleCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ProductEvalationTitleCell.h"

@interface ProductEvalationTitleCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starIcon;
@property (weak, nonatomic) IBOutlet UILabel *seeAllBtn;
@property (weak, nonatomic) IBOutlet UIImageView *indicator;

@end

@implementation ProductEvalationTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAveRate: (CGFloat)aveRate count: (NSInteger)count {
    if (count == 0) {
        self.contentLabel.text = @"(0)";
        self.starIcon.hidden = YES;
        self.seeAllBtn.hidden = YES;
        self.indicator.hidden = YES;
    } else {
        self.contentLabel.text = [NSString stringWithFormat:@"%.1f(%ld)", aveRate,count];
        self.starIcon.hidden = NO;
        self.seeAllBtn.hidden = NO;
        self.indicator.hidden = NO;
    }
}


@end
