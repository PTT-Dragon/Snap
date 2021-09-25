//
//  SFNetworkURL.m
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import "SFNetworkURL.h"
#import <objc/runtime.h>

@implementation SFNetworkURL

static SFNetworkURL *_instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SFNetworkURL alloc] init];
        [_instance initModules];
    });
    return _instance;
}

/// 返回当前类的所有属性
- (NSArray *)getProperties {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    return mArray.copy;
}

/// 返回属性的类型数组
- (NSArray *)getPropertieClasses {
   unsigned int count = 0;
   objc_property_t *propertyList = class_copyPropertyList([self class] , &count);
   NSMutableArray *array = [NSMutableArray array];
    for(int i = 0 ; i < count ; i ++) {
          objc_property_t property = propertyList[i];
          const char *propertyChar = property_getAttributes(property);
          NSString *propertyType = [NSString stringWithUTF8String:propertyChar];
          [array addObject:propertyType];
     }
     free(propertyList);
     return array.copy;
}

/// 初始化所有属性
- (void)initModules {
    NSArray *names = [self getProperties];
    NSArray *types = [self getPropertieClasses];
    NSMutableArray *classTypes = [NSMutableArray array];
    for (NSString *type in types) {
        NSString *classType = [self subStringOf:type left:@"@\"" right:@"\","];
        [classTypes addObject:classType];
    }
    
    for (int i = 0; i < names.count; i ++) {
        NSString *name = names[i];
        NSString *type = classTypes[i];
        Class cls = NSClassFromString(type);
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@:",name.capitalizedString]);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:[cls new]];
        }
    }
}

- (NSString *)subStringOf:(NSString *)string left:(NSString *)left right:(NSString *)right {
    NSRange startRange = [string rangeOfString:left];
    NSRange endRange = [string rangeOfString:right];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    if (range.location == NSNotFound) {return nil;}
    NSString *result = [string substringWithRange:range];
    return result;
}

@end
