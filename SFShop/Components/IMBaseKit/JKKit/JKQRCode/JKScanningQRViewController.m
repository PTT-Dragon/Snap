//
//  JKScanningQRViewController.m
//  JKQRCode
//
//  Created by 王冲 on 2018/12/29.
//  Copyright © 2018年 JK科技有限公司. All rights reserved.
//

#import "JKScanningQRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+JKLayout.h"

@interface JKScanningQRViewController ()
<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CAAnimationDelegate>

@property(weak,nonatomic) CALayer *lineLayer;
   
@end

@implementation JKScanningQRViewController

- (void)dealloc {
    // NSLog(@"释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = UIColor.blackColor;
    
    [self initScanning];
    [self createUI];
}

#pragma mark - override
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.qrCodeManager stopScanning];
}

#pragma mark - createUI
- (void)createUI {
    // 相册
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"相册" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(albumClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.hidden = YES;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
//    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"返回_black"] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    UIBarButtonItem *leftBtnBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftBtnBarButtonItem];
        
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:backView];
    [self addBgLayer:backView];
    
    //扫描框
    CGFloat imageVWH = 265;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((MainScreen_width-imageVWH)/2, (MainScreen_height-imageVWH*1.5)/2, imageVWH, imageVWH)];
    imageV.image = [UIImage imageNamed:@"扫描框"];
    [self.view addSubview:imageV];
    
    //手电筒
    CGFloat buttonWH = 40;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((MainScreen_width-buttonWH)/2, CGRectGetMaxY(imageV.frame)+40, buttonWH, buttonWH)];
    [button setImage:[UIImage imageNamed:@"手电筒"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *scanLine = [[UIView alloc] initWithFrame:CGRectMake(imageV.jk_x, imageV.jk_y, imageV.jk_width, 1)];
    [self.view addSubview:scanLine];
    scanLine.backgroundColor = RGBColorFrom16(0x27C897);
    [scanLine jk_addShadowToViewShadowRadius:3 withColor:[UIColor colorWithRed:39/255.0 green:200/255.0 blue:151/255.0 alpha:0.16] withShadowOffset:CGSizeMake(0, 0) withShadowOpacity:1];
        
    [self setAnimitionWith:scanLine];
}

- (void)buttonAction:(UIButton *)btn {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];//创建Video类型的驱动对象用于启动手电筒
    
    if (![captureDevice hasTorch]) return;  //检测是否有灯光
    
    if(![captureDevice hasFlash])  return; //检测是否有灯光
    
    [captureDevice lockForConfiguration:nil];
    
//    官方解释,必须要持一个设备锁  --------In order to set hardware properties on an AVCaptureDevice, such as focusMode and exposureMode, clients must first acquire a lock on the device. Clients should only hold the device lock if they require settable device properties to remain unchanged. Holding the device lock unnecessarily may degrade capture quality in other applications sharing the device.
  
    if (btn.isSelected) {
        captureDevice.torchMode = AVCaptureTorchModeOff;
    }else {
        captureDevice.torchMode = AVCaptureTorchModeOn;
    }
    
    [captureDevice unlockForConfiguration];
    
    btn.selected = !btn.selected;
}

- (void)addBgLayer:(UIView *)bgView {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bgView.bounds;
    gradientLayer.colors = @[(__bridge id)[[UIColor  colorWithRed:20 / 255.0 green:13 / 255.0 blue:12 / 255.0 alpha:1] colorWithAlphaComponent:.65].CGColor,(__bridge id)[[UIColor  colorWithRed:20 / 255.0 green:13 / 255.0 blue:12 / 255.0 alpha:1] colorWithAlphaComponent:.27].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    
    gradientLayer.locations = @[@0,@1];
    
    CGFloat wh = 265;
    CGPoint beginPoint = CGPointMake((CGRectGetWidth(bgView.bounds) - wh) / 2.f, (CGRectGetHeight(bgView.bounds) - wh*1.5) / 2.f);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path moveToPoint:CGPointMake(beginPoint.x , beginPoint.y)];
    [path addLineToPoint:CGPointMake(beginPoint.x + wh, beginPoint.y)];
    [path addLineToPoint:CGPointMake(beginPoint.x + wh, beginPoint.y + wh)];
    [path addLineToPoint:CGPointMake(beginPoint.x , beginPoint.y + wh)];
    [path addLineToPoint:CGPointMake(beginPoint.x , beginPoint.y)];
    
    [path addLineToPoint:CGPointMake(beginPoint.x + 9.9 , beginPoint.y)];
    [path addLineToPoint:CGPointMake(beginPoint.x + 9.9 , 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(bgView.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(bgView.bounds), CGRectGetHeight(bgView.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(bgView.bounds), 0)];
    [path addLineToPoint:CGPointMake(beginPoint.x + 10 , 0)];
    [path moveToPoint:CGPointMake(beginPoint.x + 10 , beginPoint.y)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = [UIColor blackColor].CGColor;
    gradientLayer.mask = layer;
    
    [bgView.layer addSublayer:gradientLayer];
}

#pragma mark - initDevice
- (void)initScanning {
    self.qrCodeManager = [[JKQRCode alloc] init];
    __weak typeof(self)weakSelf = self;
    [_qrCodeManager initDeviceAndAddView:self.view WithSuccessBlock:^(NSString * _Nonnull qrcode) {
        
        if (![weakSelf.comeType isEqualToString:@"1"]) {
            [weakSelf pop];
        }
        
        if (weakSelf.scanningSuccess) {
            weakSelf.scanningSuccess(qrcode);
        }
        
        [weakSelf dealScanResult:qrcode];
        
    } failBlock:^(NSError *error) {
        
        BOOL isStill = error.code == [kfailErrorCode integerValue];
        [weakSelf showAlertWithTitle:@"错误" message:error.localizedDescription isStillScanning:isStill];
    }];
}
    
#pragma mark 二维码扫描后结果的处理
-(void)dealScanResult:(NSString *)result{
    
    
    
    
}

    


#pragma mark - album
- (void)albumClick:(UIButton *)button {
    //创建UIImagePickerController对象，并设置代理和可编辑
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    __weak typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.qrCodeManager starScanning];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    __weak typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.qrCodeManager starScanning];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
    //获取到的图片
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSString *QRCodeStr = [JKQRCode readAlbumQRCode:image];
    if (!QRCodeStr.length) {
        [self showAlertWithTitle:@"错误" message:kfailErrorDesc isStillScanning:YES];
    } else {
        [self pop];
        if (self.scanningSuccess) {
            self.scanningSuccess(QRCodeStr);
        }
    }
}

- (void)leftBtnClick {
    [self pop];
}

- (void)pop {
    
    if (self.isPush == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message isStillScanning:(BOOL)isStillScanning {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self)weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!isStillScanning) {
            [weakSelf pop];
        } else {
            [weakSelf.qrCodeManager starScanning];
        }
    }];
    [alert addAction:action];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil] ;
}

// 平移
- (void)setAnimitionWith:(UIView *)view {
    //创建CALayer
    CALayer *redLayer = [CALayer layer];
    
    //设置位置和大小
    redLayer.position = view.center;
    redLayer.bounds = view.bounds;
    
    //设置背景颜色
    redLayer.backgroundColor = RGBColorFrom16(0x27C897).CGColor;
    
    //把layer添加到UIView的layer上
    [view.layer addSublayer:redLayer];
    
    self.lineLayer = redLayer;
    
    
    /*------------开始设置动画------------------------*/
    
    //创建动画对象
    CABasicAnimation *basicAni = [CABasicAnimation animation];
    
    //设置动画属性
    basicAni.keyPath = @"position";
    
    //设置动画的起始位置。也就是动画从哪里到哪里
    basicAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(view.jk_width/2, 0)];
    NSLog(@"-------%f",view.jk_x);
    //动画结束后，layer所在的位置
    basicAni.toValue = [NSValue valueWithCGPoint:CGPointMake(view.jk_width/2, view.jk_width)];

    //动画持续时间
    basicAni.duration = 2;
    
    //动画填充模式
    basicAni.fillMode = kCAFillModeForwards;
    
    //动画完成不删除
    basicAni.removedOnCompletion = NO;
    
    basicAni.repeatCount = CGFLOAT_MAX;
    
    basicAni.autoreverses = YES;
    
    //xcode8.0之后需要遵守代理协议
    basicAni.delegate = self;
    
    //把动画添加到要作用的Layer上面
    [self.lineLayer addAnimation:basicAni forKey:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
