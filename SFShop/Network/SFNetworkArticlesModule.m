//
//  SFNetworkArticlesModule.m
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import "SFNetworkArticlesModule.h"

@implementation SFNetworkArticlesModule

- (NSString *)articles {
    return K_articles_domain(@"");
}

- (NSString *)getDetailOf: (NSString *)articleId {
    return K_articles_domain(articleId);
}
@end
