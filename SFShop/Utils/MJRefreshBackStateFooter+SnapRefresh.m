//
//  MJRefreshBackStateFooter+SnapRefresh.m
//  SFShop
//
//  Created by 别天神 on 2022/2/15.
//

#import "MJRefreshBackStateFooter+SnapRefresh.h"

@implementation MJRefreshBackStateFooter (SnapRefresh)

- (void)endRefreshingWithNoMoreData {
    [super endRefreshingWithNoMoreData];
    self.stateLabel.textColor = [UIColor jk_colorWithHexString:@"#999999"];
}

@end
