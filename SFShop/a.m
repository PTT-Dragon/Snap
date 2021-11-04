//
//  a.m
//  SFShop
//
//  Created by 游挺 on 2021/11/4.
//

#import <Foundation/Foundation.h>

@implementation NSURLRequest(NSURLRequestIgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost: (NSString *)host {
    return YES;
}
@end
