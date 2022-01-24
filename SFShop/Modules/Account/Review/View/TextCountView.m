//
//  TextCountView.m
//  SFShop
//
//  Created by Lufer on 2022/1/25.
//

#import "TextCountView.h"

@interface TextCountView ()

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation TextCountView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self initView];
}

- (void)initView {
    [self addSubview:self.countLabel];
}

- (void)configDataWithTotalCount:(NSInteger)totalCount
                    currentCount:(NSInteger)currentCount {
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", currentCount, totalCount];
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _countLabel.textColor = UIColor.blackColor;
        _countLabel.font = [UIFont systemFontOfSize:9];
    }
    return _countLabel;
}

@end
