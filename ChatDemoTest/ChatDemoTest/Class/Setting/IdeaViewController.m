//
//  IdeaViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/21.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "IdeaViewController.h"

@interface IdeaViewController ()
- (IBAction)sureBtnClick:(UIButton *)sender;

@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *bgtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidkeybord)];
    bgtap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:bgtap];
    
}

-(void)hidkeybord{

    [self.view endEditing:YES];
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

- (IBAction)sureBtnClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
