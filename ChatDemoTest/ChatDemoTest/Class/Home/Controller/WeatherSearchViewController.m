//
//  WeatherSearchViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/7/4.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "WeatherSearchViewController.h"

@interface WeatherSearchViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scroolViewContraintWidth;

@property (weak, nonatomic) IBOutlet UIImageView *nowImage;
@property (weak, nonatomic) IBOutlet UILabel *nowTemp;
@property (weak, nonatomic) IBOutlet UILabel *nowTitle;
@property (weak, nonatomic) IBOutlet UIButton *locationLabel;
- (IBAction)locationBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *nowHum;
@property (weak, nonatomic) IBOutlet UILabel *nowPcpn;
@property (weak, nonatomic) IBOutlet UILabel *nowVis;
@property (weak, nonatomic) IBOutlet UILabel *nowSpd;
@property (weak, nonatomic) IBOutlet UILabel *nowPres;
@property (weak, nonatomic) IBOutlet UILabel *nowSc;
@property (weak, nonatomic) IBOutlet UILabel *nowDir;


@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UILabel *firstTitle;
@property (weak, nonatomic) IBOutlet UILabel *firstTempMax;
@property (weak, nonatomic) IBOutlet UILabel *firstTempMin;
@property (weak, nonatomic) IBOutlet UILabel *firstDate;

@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondTempMax;
@property (weak, nonatomic) IBOutlet UILabel *secondTempMin;
@property (weak, nonatomic) IBOutlet UILabel *secondDate;

@property (weak, nonatomic) IBOutlet UILabel *comf_brf;
@property (weak, nonatomic) IBOutlet UILabel *comf_text;

@property (weak, nonatomic) IBOutlet UILabel *cw_brf;
@property (weak, nonatomic) IBOutlet UILabel *cw_text;

@property (weak, nonatomic) IBOutlet UILabel *drsg_brf;
@property (weak, nonatomic) IBOutlet UILabel *drsg_text;

@property (weak, nonatomic) IBOutlet UILabel *flu_brf;
@property (weak, nonatomic) IBOutlet UILabel *flu_text;

@property (weak, nonatomic) IBOutlet UILabel *sport_brf;
@property (weak, nonatomic) IBOutlet UILabel *sport_text;

@property (weak, nonatomic) IBOutlet UILabel *trav_brf;
@property (weak, nonatomic) IBOutlet UILabel *trav_text;

@property (weak, nonatomic) IBOutlet UILabel *uv_brf;
@property (weak, nonatomic) IBOutlet UILabel *uv_text;

@end

@implementation WeatherSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scroolViewContraintWidth.constant=ScreenW;
    
    
    
    [self requstWeather];
}

-(void)requstWeather{

    NSString *city=@"成都";
    NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    NSString *utf_city=[city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *httpArg = [NSString stringWithFormat:@"city=%@",utf_city];
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
                                   NSDictionary *dic=[weakSelf dictionaryWithJsonString:responseString];
                                   [weakSelf setupNowWeatherData:dic];
                               }
                           }];
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

-(void)setupNowWeatherData:(NSDictionary *)dic{

    NSArray *HeWeather=dic[@"HeWeather data service 3.0"];
    NSDictionary *datas=HeWeather[0];
    
    
    NSDictionary *basic=datas[@"basic"];
    [self.locationLabel setTitle:[NSString stringWithFormat:@"%@  [点击切换]",basic[@"city"]] forState:UIControlStateNormal];
    
    NSDictionary *now=datas[@"now"];
    NSDictionary *cond=now[@"cond"];
    self.nowImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",cond[@"txt"]]];
    self.nowTitle.text=cond[@"txt"];
    self.nowTemp.text=[NSString stringWithFormat:@"%@℃",now[@"tmp"]];
    self.nowVis.text=now[@"vis"];
    self.nowHum.text=now[@"hum"];
    self.nowPcpn.text=now[@"pcpn"];
    self.nowPres.text=now[@"pres"];
    NSDictionary *wind=now[@"wind"];
    self.nowDir.text=wind[@"dir"];
    self.nowSpd.text=wind[@"spd"];
    self.nowSc.text=[NSString stringWithFormat:@"%@级",wind[@"sc"]];
    
    
    NSArray *daily_forecast=datas[@"daily_forecast"];
    NSDictionary *firstW=daily_forecast[1];
    self.firstDate.text=firstW[@"date"];
    NSDictionary *first_cond=firstW[@"cond"];
    self.firstImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",first_cond[@"txt_d"]]];
    self.firstTitle.text=first_cond[@"txt_d"];
    NSDictionary *first_tmp=firstW[@"tmp"];
    self.firstTempMax.text=first_tmp[@"max"];
    self.firstTempMin.text=first_tmp[@"min"];
    
    NSDictionary *secondW=daily_forecast[2];
    self.secondDate.text=secondW[@"date"];
    NSDictionary *second_cond=secondW[@"cond"];
    self.secondImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",second_cond[@"txt_d"]]];
    self.secondTitle.text=second_cond[@"txt_d"];
    NSDictionary *second_tmp=secondW[@"tmp"];
    self.secondTempMax.text=second_tmp[@"max"];
    self.secondTempMin.text=second_tmp[@"min"];
    
    NSDictionary *suggestion=datas[@"suggestion"];
    NSDictionary *comf=suggestion[@"comf"];
    self.comf_brf.text=comf[@"brf"];
    self.comf_text.text=comf[@"txt"];
    
    NSDictionary *cw=suggestion[@"cw"];
    self.cw_brf.text=cw[@"brf"];
    self.cw_text.text=cw[@"txt"];
    
    NSDictionary *drsg=suggestion[@"drsg"];
    self.drsg_brf.text=drsg[@"brf"];
    self.drsg_text.text=drsg[@"txt"];
    
    NSDictionary *flu=suggestion[@"flu"];
    self.flu_brf.text=flu[@"brf"];
    self.flu_text.text=flu[@"txt"];
    
    NSDictionary *sport=suggestion[@"sport"];
    self.sport_brf.text=sport[@"brf"];
    self.sport_text.text=sport[@"txt"];
    
    NSDictionary *trav=suggestion[@"trav"];
    self.trav_brf.text=trav[@"brf"];
    self.trav_text.text=trav[@"txt"];
    
    NSDictionary *uv=suggestion[@"uv"];
    self.uv_brf.text=uv[@"brf"];
    self.uv_text.text=uv[@"txt"];
    
}



- (IBAction)locationBtnClick:(UIButton *)sender {
    
    
    
    DEBUGLOG(@"%@",sender.currentTitle);
}
@end
