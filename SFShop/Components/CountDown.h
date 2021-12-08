//
//  CountDown.h
//  JYZX
//
//  Created by yc on 2017/4/7.
//  Copyright © 2017年 Outsourcing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountDown : NSObject
singleton_interface(CountDown)
-(void)countDown:(int)time andObject:(UIButton *)sender;
-(void)stopCountDown:(UIButton *)sender;
@end
