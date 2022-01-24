//
//  SFNetworkOffersModule.m
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import "SFNetworkOffersModule.h"

@implementation SFNetworkOffersModule

- (NSString *)offers {
    return K_offers_domain(@"");
}
- (NSString *)viewlog {
    return K_offers_domain(@"viewlog");
}
- (NSString *)stock {
    return K_offers_domain(@"whstock");
}

- (NSString *)suggest {
    return K_offers_domain(@"suggest");
}
- (NSString *)evaluationList {
    return K_offers_domain(@"evaluations/list");
}
- (NSString *)campaigns {
    return K_offers_domain(@"campaigns");
}

- (NSString *)getDetailOf: (NSInteger)offerId {
    NSString *url = [NSString stringWithFormat:@"detail/%ld", offerId];
    return K_offers_domain(url);
}
- (NSString *)getEvaInfoOf: (NSInteger)offerId {
    NSString *url = [NSString stringWithFormat:@"evaluations/%ld", offerId];
    return K_offers_domain(url);
}

@end
