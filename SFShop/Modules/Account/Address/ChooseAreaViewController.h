//
//  ChooseAreaViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

@protocol ChooseAreaViewControllerDelegate <NSObject>

- (void)chooseProvince:(AreaModel *_Nullable)provinceModel city:(AreaModel *_Nullable)cityModel district:(AreaModel *_Nullable)districtModel;
- (void)chooseStreet:(AreaModel *_Nullable)streetModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ChooseAreaViewController : UIViewController
@property (nonatomic,assign) id<ChooseAreaViewControllerDelegate>delegate;
@property (nonatomic,assign) NSInteger type;//1.选择省市区  2.选择街道
@property (nonatomic,strong) AreaModel *selProvinceAreaMoel;
@property (nonatomic,strong) AreaModel *selCityAreaMoel;
@property (nonatomic,strong) AreaModel *selDistrictAreaMoel;
@property (nonatomic,strong) AreaModel *selStreetAreaMoel;
@end

NS_ASSUME_NONNULL_END
