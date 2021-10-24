//
//  CustomTextField.m
//  SFShop
//
//  Created by MasterFly on 2021/10/24.
//

#import "CustomTextField.h"

@implementation CustomTextField

#pragma mark - Delegate
// 未编辑状态下的起始位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}
// 编辑状态下的起始位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

// placeholder起始位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

@end
