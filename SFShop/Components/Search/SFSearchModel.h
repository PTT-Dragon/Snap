//
//  SFSearchModel.h
//  SFShop
//
//  Created by MasterFly on 2021/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchModel : NSObject

@property (nonatomic, readwrite, strong) NSString *sectionIcon;
@property (nonatomic, readwrite, strong) NSString *sectionTitle;
@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *idStr;
@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, assign) CGFloat width;

@end

NS_ASSUME_NONNULL_END
