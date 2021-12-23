//
//  UserModel.m
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import "UserModel.h"

@implementation userResModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
     unsigned int count=0;
    Ivar *ivars=class_copyIvarList([userResModel class], &count);
    for (int i=0; i<count; i++) {
        Ivar ivar=ivars[i];
        const char *name=ivar_getName(ivar);
        NSString *key=[NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        unsigned int count=0;
        Ivar *ivars=class_copyIvarList([userResModel class], &count);
        for (int i=0; i<count; i++) {
            Ivar ivar=ivars[i];
            const char *name=ivar_getName(ivar);
            NSString *key=[NSString stringWithUTF8String:name];
            id value=[aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
- (NSString *)genderStr
{
    return [self.gender isEqualToString:@"M"] ? @"MALE": [self.gender isEqualToString:@"F"] ? @"FEMALE": @"Secrecy";
}
- (NSString *)birthdayDayStr
{
    // 时间字符串
    NSString *string = self.birthdayDay;

    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(为了转换成功)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:string];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];

    return currentDateString;
}

@end

@implementation UserModel


-(void)encodeWithCoder:(NSCoder *)aCoder
{
     unsigned int count=0;
    Ivar *ivars=class_copyIvarList([UserModel class], &count);
    for (int i=0; i<count; i++) {
        Ivar ivar=ivars[i];
        const char *name=ivar_getName(ivar);
        NSString *key=[NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        unsigned int count=0;
        Ivar *ivars=class_copyIvarList([UserModel class], &count);
        for (int i=0; i<count; i++) {
            Ivar ivar=ivars[i];
            const char *name=ivar_getName(ivar);
            NSString *key=[NSString stringWithUTF8String:name];
            id value=[aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}



@end
