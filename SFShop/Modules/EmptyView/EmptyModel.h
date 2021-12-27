//
//  EmptyModel.h
//  SFShop
//
//  Created by Lufer on 2021/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmptyModel : NSObject

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *tip;

+ (EmptyModel *)getEmptyModelWithType:(EmptyViewType)type;

@end

NS_ASSUME_NONNULL_END
