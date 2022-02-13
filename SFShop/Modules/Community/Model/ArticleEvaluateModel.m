//
//  ArticleEvaluateModel.m
//  SFShop
//
//  Created by Jacue on 2021/10/19.
//

#import "ArticleEvaluateModel.h"
#import "NSDate+Helper.h"

@implementation ArticleEvaluateChildrenModel
- (NSString *)createdDateStr
{
    if ([[NSDate date] utcTimeStamp] - [[NSDate dateFromString:_createdDate] utcTimeStamp] > 3600*24) {
     //大于一天
        return [[NSDate dateFromString:_createdDate] stringWithFormat:@"YYYY.MM.dd"];
    }else if ([[NSDate date] utcTimeStamp] - [[NSDate dateFromString:_createdDate] utcTimeStamp] > 3600){
        //1小时到24小时
        return [NSString stringWithFormat:@"%ld h",([[NSDate date] utcTimeStamp] - [[NSDate dateFromString:_createdDate] utcTimeStamp])/3600];
    }else if ([[NSDate date] utcTimeStamp] - [[NSDate dateFromString:_createdDate] utcTimeStamp] > 60){
        return [NSString stringWithFormat:@"%ld min",([[NSDate date] utcTimeStamp] - [[NSDate dateFromString:_createdDate] utcTimeStamp])/60];
    }else{
        return @"1 min";
    }
    return _createdDate;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end


@implementation ArticleEvaluateModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
