//
//  StarView.m
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "StarView.h"

@interface StarView ()
//@property (nonatomic,strong) UILabel *scoreLabel;
@end

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initUI];
}
- (void)initUI
{
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*20, 0, 16, 16)];
        [self addSubview:imgView];
    }
//    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 20, 10)];
//    _scoreLabel.textColor = RGBColorFrom16(0x222222);
//    _scoreLabel.font = CHINESE_MEDIUM(10);
//    [self addSubview:_scoreLabel];
}
- (void)setScore:(NSInteger)score
{
    _score = score;
//    CGFloat a = (CGFloat)score;
//    _scoreLabel.text = [NSString stringWithFormat:@"%.1f",a];
    [self updateView];
}
- (void)updateView
{
    NSInteger i = 0;
    float a = (float)_score/5;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            BOOL sel = a==1 ? YES: (a >= 0.8 && a<1) ? i == 4 ? NO: YES: (a >= 0.6 && a<0.8) ? (i == 4 || i == 3) ? NO: YES: (a >= 0.4 && a < 0.6) ? (i == 4 || i == 3 || i == 2) ? NO: YES: (a >= 0.2 && a<0.4) ? (i == 4 || i == 3 || i == 2 || i == 1) ? NO: YES:  NO;
            [(UIImageView *)subView setImage:[UIImage imageNamed:sel ? @"蒙版组 42": @"蒙版组 44"]];
        }
        i++;
    }
}
@end
