//
//  RefundProcessCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "RefundProcessCell.h"

@interface RefundProcessCell ()
@property (weak, nonatomic) IBOutlet UIView *indicationView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *content2Label;
@property (nonatomic,strong) RefundDetailMemosModel *model;

@end

@implementation RefundProcessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(RefundDetailMemosModel *)model hideView:(BOOL)hideView
{
    _model = model;
    _timeLabel.text = model.createdDate;
    _contentLabel.text = model.memoEventName;
    _content2Label.text = model.comments;
    _indicationView.hidden = hideView;
}
@end
