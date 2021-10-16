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
