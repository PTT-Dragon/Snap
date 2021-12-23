//
//  NSArray+SortedString.m
//  365电竞
//
//  Created by 游 on 2018/11/29.
//  Copyright © 2018年 游. All rights reserved.
//

#import "NSArray+SortedString.h"

@implementation NSArray (SortedString)
- (NSComparisonResult)compare: (NSDictionary *)otherDictionary
{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    NSNumber *number1 = [[tempDictionary allKeys] objectAtIndex:0];
    NSNumber *number2 = [[otherDictionary allKeys] objectAtIndex:0];
    NSComparisonResult result = [number1 compare:number2];
    
    return result == NSOrderedDescending; // 升序
}
@end
