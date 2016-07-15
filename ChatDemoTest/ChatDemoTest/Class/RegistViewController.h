//
//  RegistViewController.h
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/24.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *email;

+(instancetype)setupLoginViewController;

@end
