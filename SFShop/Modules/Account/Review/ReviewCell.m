//
//  ReviewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "ReviewCell.h"
#import "StarView.h"

@interface ReviewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *evaluationView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;


@end

@implementation ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
    
    _btn1.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn1.layer.borderWidth = 1;
    _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn2.layer.borderWidth = 1;
}
- (void)setContent:(OrderModel *)model type:(NSInteger)type
{
    _evaluationView.hidden = type == 1;
    _btn2.hidden = type == 1;
    [_btn1 setTitle:type == 1 ? @"REVIEW":@"EDIT REVIEW" forState:0];
    orderItemsModel *itemModel = model.orderItems.firstObject;
    [_storeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Host,model.storeLogoUrl]]];
    _storeNameLabel.text = model.storeName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Host,itemModel.imagUrl]]];
    _nameLabel.text = itemModel.productName;
    _countLabel.text = [NSString stringWithFormat:@"X%@",itemModel.offerCnt];
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",itemModel.unitPrice];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[itemModel.productRemark dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    _skuLabel.attributedText = attrStr;
    _dateLabel.text = [NSString stringWithFormat:@"Review Date:%@",itemModel.evaluation[@"createdDate"]];
    _commentLabel.text = itemModel.evaluation[@"evaluationComments"];
    _starView.score = [itemModel.evaluation[@"rate"] integerValue];
    
}
@end
