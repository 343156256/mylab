//
//  LoginViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/6.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

- (IBAction)registBtnClick;
- (IBAction)loginBtnClick;

@end

@implementation LoginViewController

+(instancetype)setupLoginViewController{

    return [[[NSBundle mainBundle] loadNibNamed:@"LoginViewController" owner:self options:nil] lastObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.userName.text=[UserInfonCache sharedUserInfonCache].userName;
    self.passWord.text=[UserInfonCache sharedUserInfonCache].passWord;
    
    
}

- (IBAction)registBtnClick {
    
//    NSString *user=self.userName.text;
//    NSString *pwd=self.passWord.text;
//    
//    self.registBtn.enabled=NO;
//    
//    [[ChatTool sharedChatTool] registWithUserName:user withPWD:pwd scuss:^{
//        DEBUGLOG(@"注册成功")
//        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
//        self.registBtn.enabled=YES;
//    } fail:^(EMError *err) {
//        DEBUGLOG(@"注册失败--@%@",err.errorDescription);
//        [SVProgressHUD showErrorWithStatus:@"注册失败"];
//        self.registBtn.enabled=YES;
//    }];
    
    
    RegistViewController *vc=[RegistViewController setupLoginViewController];
    __weak typeof(self) weakSelf = self;
    [self presentViewController:vc animated:YES completion:^{
        vc.userName.text=weakSelf.userName.text;
        vc.passWord.text=weakSelf.passWord.text;
    }];
    
}

- (IBAction)loginBtnClick {
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    self.loginBtn.enabled=NO;

    NSString *user=self.userName.text;
    NSString *pwd=self.passWord.text;

    __weak typeof(self) weakself=self;
    
//    [[ChatTool sharedChatTool] loginWithUserName:user withPWD:pwd scuss:^{
//        
//        HMTabBarViewController *tabbarCtr=[[HMTabBarViewController alloc]init];
//        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//        app.window.rootViewController=tabbarCtr;
//        
//        [UserInfonCache sharedUserInfonCache].userName=user;
//        [UserInfonCache sharedUserInfonCache].passWord=pwd;
//        [[UserInfonCache sharedUserInfonCache] saveUserInfon];
//        
//        weakself.loginBtn.enabled=YES;
//        DEBUGLOG(@"登录成功");
//        [weakself SVPmaskType:YES];
//    } fail:^(EMError *err) {
//        DEBUGLOG(@"登录失败--@%@",err.errorDescription);
//       
//        
//        [[UserInfonCache sharedUserInfonCache] clearUserInfon];
//        
//        weakself.loginBtn.enabled=YES;
//        [weakself SVPmaskType:NO];
//    }];
    
    NSString *requestStr=[NSString stringWithFormat:@"%@%@",RootRequestUrl,@"login"];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    NSDictionary *pramga=@{@"name":user,@"password":pwd};
    
    [manager POST:requestStr parameters:pramga success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict=responseObject[@"redata"];
        BOOL status=[responseObject[@"status"] boolValue];
        NSString *email=dict[@"email"];
        NSString *qqNum=[email componentsSeparatedByString:@"@"][0];
        [UserInfonCache sharedUserInfonCache].userName=user;
        [UserInfonCache sharedUserInfonCache].passWord=pwd;
        [UserInfonCache sharedUserInfonCache].email=email;
        [UserInfonCache sharedUserInfonCache].qqNum=qqNum;
        [[UserInfonCache sharedUserInfonCache] saveUserInfon];

        weakself.loginBtn.enabled=YES;

        if (status) {
            [[ChatTool sharedChatTool] loginWithUserName:@"13699426956" withPWD:@"123" scuss:^{
            HMTabBarViewController *tabbarCtr=[[HMTabBarViewController alloc]init];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            app.window.rootViewController=tabbarCtr;
            DEBUGLOG(@"登录成功");
            [SVProgressHUD dismiss];
        } fail:^(EMError *err) {
            weakself.loginBtn.enabled=YES;
            [weakself SVPmaskType:NO];
        }];
        }else{
        
            [weakself SVPmaskType:NO];
            DEBUGLOG(@"登录失败");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [[UserInfonCache sharedUserInfonCache] clearUserInfon];

        weakself.loginBtn.enabled=YES;
        [weakself SVPmaskType:NO];
    }];
    
}

-(void)SVPmaskType:(BOOL)isok{

    if (isok) {
        [SVProgressHUD dismiss];
    }else{
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }
}

@end
