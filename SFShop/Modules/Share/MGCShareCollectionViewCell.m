//
//  MGCShareCollectionViewCell.m
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/5/6.
//

#import "MGCShareCollectionViewCell.h"
#import "UIView+YYAdd.h"

@interface MGCShareCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MGCShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)configDataWithItemModel:(MGCShareItemModel *)itemModel{
    self.itemModel = itemModel;
    self.iconImageView.image = [UIImage imageNamed:itemModel.itemImage];
    self.titleLabel.text = itemModel.itemName;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 42, 42)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImageView.bottom + 4, self.width, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
