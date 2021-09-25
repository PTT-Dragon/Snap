//
//  SFNetworkH5Module.m
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import "SFNetworkH5Module.h"
#import "SFNetworkMacro.h"

@implementation SFNetworkH5Module

- (NSString *)address_delivery {
    return K_h5_domain(@"address/delivery");
}

- (NSString *)time {
    return K_h5_domain(@"time");
}

- (NSString *)articles {
    return K_h5_domain(@"articles");
}


@end
