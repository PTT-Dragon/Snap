//
//  NSBundle+Language.m
//  SFShop
//
//  Created by Lufer on 2022/1/8.
//

#import "NSBundle+Language.h"
#import "BaseViewController.h"

@implementation NSBundle (Language)

+ (instancetype)ffStringBundleWithLanguage:(NSString *)language {
    NSBundle *bundle = [NSBundle bundleForClass:[BaseViewController class]];
    NSString *bundlePath = [bundle.resourcePath stringByAppendingPathComponent:@"LanguageBundle.bundle"];
    NSBundle *root_bundle = [NSBundle bundleWithPath:bundlePath];
    NSBundle *stringBundle = [NSBundle bundleWithPath:[root_bundle pathForResource:language ofType:@"lproj"]];
    return stringBundle;
}

+ (NSString *)ffLocalizedStringForKey:(NSString *)key {
    NSString *language = UserDefaultObjectForKey(@"Language");
    if (!language) {
        language = @"en";
    }
    NSBundle *resource_bundle = [NSBundle ffStringBundleWithLanguage:language];
    NSString *baseValue = [resource_bundle localizedStringForKey:key value:key table:@"Localizable"];
    NSString *string = [resource_bundle localizedStringForKey:key value:baseValue table:@"Localizable"];
    return string;
}

@end
