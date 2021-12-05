//
//  RelationOrderDetailInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/5.
//

#import "RelationOrderDetailInfoCell.h"

@interface RelationOrderDetailInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation RelationOrderDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    _titleLabel.text = infoDic[@"title"];
    _contentLabel.text = infoDic[@"value"];
}

@end
