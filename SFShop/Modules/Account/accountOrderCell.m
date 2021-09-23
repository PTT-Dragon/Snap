//
//  accountOrderCell.m
//  SFShop
//
//  Created by 游挺 on 2021/9/23.
//

#import "accountOrderCell.h"

@interface accountOrderCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation accountOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self drawShadow];
}

- (void)drawShadow
{
    _bgView.layer.masksToBounds = NO;//默认值为NO。不能设置为YES，否则阴影无法出现。
    _bgView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    _bgView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    _bgView.layer.shadowRadius = 4;//阴影圆角
    _bgView.layer.shadowOffset = CGSizeMake(5, 0);    //阴影偏移量。有值是向下向右偏移。
    
    
    /*
     * 默认值：(0,-3)向上偏移。
     原因：阴影最先在mac平台实现，默认是向下偏移3。但由于iOS和macOS的Y轴相反，所以，iOS是向上偏移3.
     
     设置为：(0,0)，四周都有阴影。
     */
    //阴影路径
    _bgView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds cornerRadius:_bgView.layer.cornerRadius].CGPath;
}
@end
