//
//  FFLocalization.m
//  FMMaterialLibrary
//
//  Created by feng.lu on 2021/11/22.
//

#import "FFLocalization.h"
#import "NSBundle+Language.h"

NSString *kLocalizedString (NSString *key) {
    return [NSBundle ffLocalizedStringForKey:key];
}

