//
//  BaseNavigationController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/23.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "LoginViewController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

+ (void)initialize
{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationBar.hidden = YES;
//    UIViewController* vc = self.topViewController;
//    if([vc isKindOfClass:[LottertMainViewController class]])
//    {
//        [vc viewWillAppear:animated];
//    }
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.delegate = self;
//        self.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self setNavigationBarTheme];
    }
    return self;
}
// 主题
- (void)setNavigationBarTheme {
    UINavigationBar *navgationBar = [UINavigationBar appearance];
    [navgationBar setBackgroundImage:[self createImageWithColor:RGBColorFrom16(0xffffff)] forBarMetrics:UIBarMetricsDefault];//设置背景图片和颜色
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 自定义返回键(leftItem)后, 滑动返回不可用, 使用这种方式处理
//    self.navigationBar.hidden = YES;
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [self.navigationBar setTitleTextAttributes:dict];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 如果当前展示的控制器是根控制器就不让其响应
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
//        if([self.topViewController isKindOfClass:[LottertMainViewController class]] )
//        {
//            LottertMainViewController* vc = (LottertMainViewController*)self.topViewController;
//            return [vc TGinteractivePop];
//
//        }
    }
    
    return YES;
   
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass: [BaseViewController class]]) {
        if ([(BaseViewController *)viewController shouldCheckLoggedIn] && ![[FMDBManager sharedInstance] currentUser]) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            MPWeakSelf(self)
            vc.didLoginBlock = ^{
                [weakself popViewControllerAnimated:NO];
                [weakself pushViewController: viewController animated: animated];
            };
            [self pushViewController: vc animated: animated];
            return;
        }
    }
    // 禁用返回手势, 防止崩溃
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 设置返回按钮不显示文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: nil style: UIBarButtonItemStyleDone target: nil action: nil];
    [super pushViewController:viewController animated:animated];
}
// 返回手势可用
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.visibleViewController.preferredStatusBarStyle;
}
- (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    return theImage;
    
}
@end
