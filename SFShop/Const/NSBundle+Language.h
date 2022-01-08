//
//  NSBundle+Language.h
//  SFShop
//
//  Created by Lufer on 2022/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Language)

+ (NSString *)ffLocalizedStringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
