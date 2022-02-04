//
//  RecentlyModel.m
//  SFShop
//
//  Created by 游挺 on 2021/10/27.
//

#import "RecentlyModel.h"

@implementation RecentlyImgUrlContentModel



@end

@implementation RecentlyModel
- (NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [dateFormatter dateFromString:self.createdDate];
    return date;
}
- (NSString *)createdDateNoH
{
    NSTimeInterval time=[[NSString stringWithFormat:@"%.0f", [self.date timeIntervalSince1970]] doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation RecentlyNumListModel

@end

@implementation RecentlyNumModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
