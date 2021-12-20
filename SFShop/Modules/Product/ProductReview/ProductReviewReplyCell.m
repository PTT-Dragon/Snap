//
//  ProductReviewReplyCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/17.
//

#import "ProductReviewReplyCell.h"

@interface ProductReviewReplyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ProductReviewReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ProductEvalationReplayModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogoUrl)]];
    _nameLabel.text = model.storeName;
    _timeLabel.text = model.replyDate;
    _contentLabel.text = model.replyComments;
}
@end
