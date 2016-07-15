//
//  RegistViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/24.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "RegistViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
- (IBAction)registBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *cancleView;

@end

@implementation RegistViewController

+(instancetype)setupLoginViewController{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"RegistViewController" owner:self options:nil] lastObject];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleClick)];
    tap.numberOfTapsRequired=1;
    [self.cancleView addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registBtnClick:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"注册中..."];
    
    NSString *requestStr=[NSString stringWithFormat:@"%@%@",RootRequestUrl,@"reg"];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    NSDictionary *pramga=@{@"name":self.userName.text,@"password":self.passWord.text,@"email":self.email.text};
    
    
    [manager POST:requestStr parameters:pramga success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        BOOL status=[responseObject[@"status"] boolValue];
        NSString *log=responseObject[@"log"];
        
        if (status) {
            
            NSString *qqNum=[self.email.text componentsSeparatedByString:@"@"][0];
            [[ChatTool sharedChatTool] registWithUserName:qqNum withPWD:self.passWord.text scuss:^{
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self cancleClick];
                });
            } fail:^(EMError *err) {
                NSLog(@"聊天账号注册失败");
                [SVProgressHUD showSuccessWithStatus:@"聊天账号注册失败"];
            }];
           
        }else{
             [SVProgressHUD showErrorWithStatus:log];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
        
    }];
    
}
-(void)cancleClick{

    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}
@end
