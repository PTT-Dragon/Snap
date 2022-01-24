//
//  UIButton+time.h
//  校园在线
//
//  Created by 游 on 2017/10/25.
//  Copyright © 2017年 游. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (time)
/* 防止button重复点击，设置间隔 */
@property (nonatomic, assign) NSTimeInterval mm_acceptEventInterval;
@end
