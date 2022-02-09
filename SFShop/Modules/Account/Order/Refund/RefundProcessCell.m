//
//  RefundProcessCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "RefundProcessCell.h"
#import "NSDate+Helper.h"

@interface RefundProcessCell ()
@property (weak, nonatomic) IBOutlet UIView *indicationView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *content2Label;
@property (nonatomic,strong) RefundDetailMemosModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewToBottom;

@end

@implementation RefundProcessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setContent:(RefundDetailMemosModel *)model hideView:(BOOL)hideView isLast:(BOOL)isLast
{
    _model = model;
    _timeLabel.text = [[NSDate dateFromString:model.createdDate] dayMonthYear];
    _contentLabel.text = model.memoEventName;
    _content2Label.text = model.comments;
    _indicationView.hidden = hideView;
    _viewToBottom.constant = isLast ? 10: 0;
}
@end
