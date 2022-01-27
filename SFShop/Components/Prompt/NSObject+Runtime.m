//
//  NSObject+Runtime.m
//  SFShop
//
//  Created by YouHui on 2022/1/27.
//

#import "NSObject+Runtime.h"

@implementation NSObject (Runtime)

/// 返回当前类的所有属性
- (NSArray *)lz_getProperties {
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
- (NSArray *)lz_getPropertieClasses {
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
- (void)lz_initProperties {
    NSArray *names = [self lz_getProperties];
    NSArray *types = [self lz_getPropertieClasses];
    NSMutableArray *classTypes = [NSMutableArray array];
    for (NSString *type in types) {
        NSString *classType = [self subStringOf:type left:@"@\"" right:@"\","];
        [classTypes addObject:classType];
    }
    
    for (int i = 0; i < names.count; i ++) {
        NSString *name = names[i];
        if (!name || !name.length) {continue;}
        NSString *type = classTypes[i];
        Class cls = NSClassFromString(type);
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[[name substringToIndex:1].capitalizedString stringByAppendingString:[name substringFromIndex:1]]]);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:[cls new]];
        }
    }
}

/// 初始化所有属性
- (void)lz_copyModel:(id)model {
    NSArray *names = [self lz_getProperties];
    for (int i = 0; i < names.count; i ++) {
        NSString *name = names[i];
        if (!name || !name.length) {continue;}
        SEL setSel = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[[name substringToIndex:1].capitalizedString stringByAppendingString:[name substringFromIndex:1]]]);
        SEL getSel = NSSelectorFromString([NSString stringWithFormat:@"%@",name]);
        if ([model respondsToSelector:setSel] && [self respondsToSelector:getSel]) {
            id propertyValue = [self valueForKey:(NSString *)name];
            [model performSelector:setSel withObject:propertyValue];
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
