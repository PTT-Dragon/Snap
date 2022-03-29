//
//  MJRefreshBackFooter+SnapRefresh.m
//  SFShop
//
//  Created by 别天神 on 2022/2/7.
//

#import "MJRefreshBackFooter+SnapRefresh.h"
#import <MJRefresh/MJRefresh.h>

@implementation MJRefreshBackFooter (SnapRefresh)



- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    // 内容的高度
    CGFloat contentHeight = self.scrollView.mj_contentH + self.ignoredScrollViewContentInsetBottom;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.mj_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
    // 设置位置和尺寸
    if (self.scrollView.contentSize.height == 0) {
        self.mj_y = MAX(contentHeight, scrollHeight);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        });
    }else {
        if (self.scrollView.frame.size.height - self.scrollView.contentSize.height > 0) {
            self.mj_y = MAX(contentHeight, scrollHeight)-(self.scrollView.frame.size.height - self.scrollView.contentSize.height);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.scrollView.mj_header isRefreshing]) {
                    [self.scrollView setContentInset:UIEdgeInsetsMake(50, 0, 0, 0)];
                }else{
                    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                }
            });
        }else {
            self.mj_y = MAX(contentHeight, scrollHeight);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
            });
        }
    }
}

@end
