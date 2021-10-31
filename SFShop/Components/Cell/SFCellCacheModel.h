//
//  SFCellCacheModel.h
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFCellCacheModel : NSObject

@property (nonatomic, readwrite, assign) CGFloat width;
@property (nonatomic, readwrite, assign) CGFloat height;
@property (nonatomic, readwrite, strong) NSString *cellId;
@property (nonatomic, readwrite, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
