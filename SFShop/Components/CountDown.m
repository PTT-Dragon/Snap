//
//  CountDown.m
//  JYZX
//
//  Created by yc on 2017/4/7.
//  Copyright © 2017年 Outsourcing. All rights reserved.
//

#import "CountDown.h"

@implementation CountDown{
    dispatch_source_t _timer;
}
singleton_implementation(CountDown)
-(void)countDown:(int)time andObject:(UIButton *)sender{
    __block int timeout=time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                sender.enabled = YES;
            });
        }else{
            int seconds = (timeout == 60?60:timeout % 60);
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.enabled = NO;
                [sender setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void)stopCountDown:(UIButton *)sender{
    dispatch_source_cancel(_timer);
    dispatch_async(dispatch_get_main_queue(), ^{
        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
        sender.enabled = YES;
    });
}

@end
