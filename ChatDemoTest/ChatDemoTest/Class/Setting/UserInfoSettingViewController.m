//
//  UserInfoSettingViewController.m
//  ChatDemoTest
//
//  Created by 陈自奎 on 16/6/21.
//  Copyright © 2016年 陈自奎. All rights reserved.
//

#import "UserInfoSettingViewController.h"
#import "LCActionSheet.h"
#import "MyImagePicker.h"

@interface UserInfoSettingViewController ()<LCActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *notificationlabel;
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)userImageBtnClick:(UIButton *)sender;
- (IBAction)SaveBtnClick:(UIButton *)sender;

@end

@implementation UserInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    // 初始化子视图界面
    [self setupAllChildViewStyle];
    
    
}

-(void)setupAllChildViewStyle{

    self.userImageBtn.layer.masksToBounds=YES;
    self.userImageBtn.layer.cornerRadius=35;
    
    self.notificationlabel.layer.masksToBounds=YES;
    self.notificationlabel.layer.cornerRadius=5;
    self.notificationlabel.layer.borderColor=[UIColor blueColor].CGColor;
    self.notificationlabel.layer.borderWidth=1;
    
    self.nickNameText.delegate=self;
    
}
#pragma mark - event response
- (void)modifyHeaderImage {

    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"头像设置"
                                                   buttonTitles:@[@"拍照", @"相册"]
                                                 redButtonIndex:-1
                                                       delegate:self];
    sheet.cancelTextColor =[UIColor redColor];
    sheet.textColor = [UIColor blueColor];
    [sheet show];
}

#pragma mark - LCActionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex {
    DEBUGLOG(@"sheet : %@",@(buttonIndex));
    
    if (buttonIndex >= 2) {
        DEBUGLOG(@"取消");
        return;
    }
    
    __weak __typeof(&*self)weakSelf = self;
    [MyImagePicker defaultPicker].allowsCustomEditing = NO;
    [[MyImagePicker defaultPicker] showImagePicker:(buttonIndex == 0) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary fromController:self successBlock:^(UIImage *image) {
        [weakSelf.userImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        [UserInfonCache sharedUserInfonCache].userImage=image;
    }];
}

#pragma mark - UITextfiledDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSLog(@"%@",string);
    return YES;
}

- (IBAction)userImageBtnClick:(UIButton *)sender {
    
    [self modifyHeaderImage];
    
}

- (IBAction)SaveBtnClick:(UIButton *)sender {
    
    DEBUGLOG(@"用户信息修改");
    if (self.nickNameText.text!=nil) {
        [UserInfonCache sharedUserInfonCache].nickName=self.nickNameText.text;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
