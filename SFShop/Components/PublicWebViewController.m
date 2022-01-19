//
//  PublicWebViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "PublicWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WKWebViewJavascriptBridge.h"
#import "CouponCenterViewController.h"
#import "FlashSaleViewController.h"
#import "SFSearchView.h"
#import "MessageViewController.h"
#import "ProductViewController.h"
#import "GroupListViewController.h"
#import "ProductDetailModel.h"
#import "CategoryRankViewController.h"
#import "SceneManager.h"

@interface PublicWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (weak,nonatomic) WKWebView *webView;
@property (nonatomic,weak) WKWebViewConfiguration *configuration;
@property (nonatomic,strong) WKWebViewJavascriptBridge *jsBridge;
@end

@implementation PublicWebViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isHome) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNoTi];
    [self initWebview];
}
- (void)initWebview
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.configuration = configuration;
    WKWebView *webview = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, _isHome ? statuBarHei: navBarHei, MainScreen_width, MainScreen_height-(_isHome ? statuBarHei: navBarHei)) configuration:_configuration];
    _webView = webview;
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
//    NSString *jsFounction = [NSString stringWithFormat:@"sysAccount('%@')", _sysAccount];
//    [self.webView evaluateJavaScript:jsFounction completionHandler:nil];
//    [webview evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        NSString *newUserAgent = [result stringByAppendingFormat:@"/%@",@"app/CYLON-APP"];
//        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUserAgent}];
//    }];
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self addJsBridge];
    MPWeakSelf(self)
    [self jk_backButtonTouched:^(UIViewController *vc) {
        if (weakself.shouldBackToHome) {
            [SceneManager transToHome];
        } else {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)addNoTi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLanguageChangeNotification:)
                                                 name:@"KLanguageChange"
                                               object:nil];
}
- (void)receiveLanguageChangeNotification:(NSNotification *)noti
{
    
    [self.webView removeFromSuperview];
    [self initWebview];
}

- (void)addJsBridge
{
    _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];
    [_jsBridge setWebViewDelegate:self];
    [_jsBridge registerHandler:@"COUPON" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
}
- (void)setIsHome:(BOOL)isHome
{
    _isHome = isHome;
}
#pragma mark - WKNavigationDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#131313\"" completionHandler:nil];
//    [SVProgressHUD showInfoWithStatus:@"正在加载中"];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // iOS调用js
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    // 设置localStorage
    NSString *token = [NSString stringWithFormat:@"localStorage.setItem('h5Token', '%@')", model.accessToken];
    NSString *isLogin = [NSString stringWithFormat:@"localStorage.setItem('isLogin', '%d')", model ? YES : NO];
    [self.webView evaluateJavaScript:token completionHandler:nil];
    [self.webView evaluateJavaScript:isLogin completionHandler:nil];
    [self.jsBridge callHandler:@"reload"];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    if ([navigationAction.request.URL.absoluteString rangeOfString :@"coupon-center"].location != NSNotFound) {
        CouponCenterViewController *vc = [[CouponCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"/spike"].location != NSNotFound){
        FlashSaleViewController *vc = [[FlashSaleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString isEqualToString:@"https://www.smartfrenshop.com/search-page"]){
        
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"/message-center"].location != NSNotFound){
        MessageViewController *vc = [[MessageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"/product/detail/"].location != NSNotFound){
        NSString *offerId;
        NSRange range1 = [navigationAction.request.URL.absoluteString rangeOfString:[NSString stringWithFormat:@"%@%@",Host,@"/product/detail/"]];
        NSRange range2 = [navigationAction.request.URL.absoluteString rangeOfString:@"?"];
        if (range2.location != NSNotFound) {
            offerId = [navigationAction.request.URL.absoluteString substringWithRange:NSMakeRange(range1.length, range2.location-range1.length)];
        }else{
            offerId = [navigationAction.request.URL.absoluteString substringWithRange:NSMakeRange(range1.length, navigationAction.request.URL.absoluteString.length-range1.length)];
        }
        ProductViewController *vc = [[ProductViewController alloc] init];
        vc.offerId = offerId.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
//        [self requestProductInfoWithOfferId:offerId];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"product/GroupBuy"].location != NSNotFound){
        GroupListViewController *vc = [[GroupListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"product/list/"].location != NSNotFound){
        NSRange range1 = [navigationAction.request.URL.absoluteString rangeOfString:@"product/list/"];
        NSString *categoryId = @"";
        categoryId = [navigationAction.request.URL.absoluteString substringWithRange:NSMakeRange(range1.location+range1.length, navigationAction.request.URL.absoluteString.length-range1.location-range1.length)];
        CategoryRankViewController *vc = [[CategoryRankViewController alloc] init];
        CategoryModel *model = [[CategoryModel alloc] init];
        CategoryInnerModel *innerModel = [[CategoryInnerModel alloc] init];
        CatgRelaModel *relaModel = [[CatgRelaModel alloc] init];
        ObjValueModel *objModel = [[ObjValueModel alloc] init];
        objModel.objId = categoryId.integerValue;
        relaModel.objValue = objModel;
        innerModel.catgRela = relaModel;
        model.inner = innerModel;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([navigationAction.request.URL.absoluteString rangeOfString :@"search-page"].location != NSNotFound){
        CategoryRankViewController *vc = [[CategoryRankViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
      [webView loadRequest:navigationAction.request];
    }

    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
    
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];

        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

- (void)dealloc
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"openBankCardDialog"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (iOS9) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            NSLog(@"清楚缓存完毕");
            
        }];
    }
    
}

@end
