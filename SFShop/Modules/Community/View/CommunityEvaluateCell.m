//
//  CommunityEvaluateCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/19.
//

#import "CommunityEvaluateCell.h"

@interface CommunityEvaluateCell ()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UILabel *contentLabel;
@end

@implementation CommunityEvaluateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"进度；法鸡；地方金阿奎；都放假啊；的会计法；冷冻机房；拉克的积分；辣的减肥；蓝卡队九分裤辣的减肥；卡的积分；辣的减肥法";
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
}

@end
