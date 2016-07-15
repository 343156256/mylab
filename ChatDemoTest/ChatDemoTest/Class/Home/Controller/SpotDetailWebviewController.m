//
//  SpotDetailWebviewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/28.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "SpotDetailWebviewController.h"

@interface SpotDetailWebviewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webview;
@property(nonatomic,copy)NSString *url;

@end

@implementation SpotDetailWebviewController

-(UIWebView *)webview{

    if (!_webview) {
        _webview=[[UIWebView alloc]initWithFrame:self.view.frame];
        _webview.backgroundColor=[UIColor whiteColor];
    }
    return _webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [self requestSpotDetailInfomation];
    
}
-(void)requestSpotDetailInfomation{

    NSString *httpUrl = @"http://apis.baidu.com/apistore/qunaerticket/querydetail";
    NSString *httpArg = [NSString stringWithFormat:@"id=%@",self.productId];
    [self request: httpUrl withHttpArg: httpArg];
}
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: BDAPIKey forHTTPHeaderField: @"apikey"];
    
    __weak typeof(self) weakSelf=self;
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                                   [weakSelf requestWebviewData:responseString];
                               }
                           }];
}

-(void)requestWebviewData:(NSString *)responseString{

    NSDictionary *responseDic=[self dictionaryWithJsonString:responseString];
    
    NSLog(@"%@",responseDic);
    NSDictionary *retdData=responseDic[@"retData"];
    NSDictionary *ticketDetail=retdData[@"ticketDetail"];
    NSDictionary *data=ticketDetail[@"data"];
    NSDictionary *display=data[@"display"];
    NSDictionary *ticket=display[@"ticket"];
    self.url=ticket[@"detailUrl"];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webview loadRequest:request];
    self.webview.delegate=self;
    
}
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - webview代理方法

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{


    

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    //去掉header的一部分
    [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('mp-header')[0].remove();"];
    
    //去掉footer的一部分
    [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('qunarFooter').remove();"];
    
    [self.webview stringByEvaluatingJavaScriptFromString:@"var mystyle = document.createElement('style');mystyle.innerHTML = '.mpm-ticket-btn {display: none;}';document.getElementsByTagName('body')[0].appendChild(mystyle);"];
    [self.webview stringByEvaluatingJavaScriptFromString:@"var mystyle = document.createElement('style');mystyle.innerHTML = '.mpf-booking-btn {display: none;}';document.getElementsByTagName('body')[0].appendChild(mystyle);"];
    [self.webview stringByEvaluatingJavaScriptFromString:@"var mystyle = document.createElement('style');mystyle.innerHTML = '.mpf-iconpane {display: none;}';document.getElementsByTagName('body')[0].appendChild(mystyle);"];
    [self.webview stringByEvaluatingJavaScriptFromString:@"var pointA = document.getElementsByClassName('mpm-fixbooking-btn');for(var i = 0;i < pointA.length ;　i++){pointA[i].getElementsByTagName('a')[0].textContent = '立即查看';};"];
    if ([self.view.subviews count]==0) {
        [self.view addSubview:_webview];
        [SVProgressHUD dismiss];
    }
   
}
-(void)webViewDidStartLoad:(UIWebView *)webView{

    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated{

    [SVProgressHUD dismiss];
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
