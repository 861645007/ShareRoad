//
//  LogInViewController.m
//  ShareRoad
//
//  Created by wanghuanqiang on 14/10/9.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController () {
    UserInfo *user;
}

@end

@implementation LogInViewController
@synthesize personNameTextField;
@synthesize personPasswordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self->keyboardSize.height = 216;
    self->textFieldArr = @[personNameTextField, personPasswordTextField];
    [self setCustomKeyboard:self];
    
    user = [UserInfo shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 登录
- (IBAction)LogIn:(id)sender {
    NSArray *personTextFieldArr = @[personNameTextField, personPasswordTextField];
    if ([[CustomToolClass shareInstance] TextFieldIsFull:personTextFieldArr]) {
        NSMutableArray *personInfo = [[NSMutableArray alloc] initWithArray:@[@"UserName",personNameTextField.text,@"Password",personPasswordTextField.text]];
        [self webServiceWithNet:@"UsersLogin" webServiceParmeters:personInfo success:^(NSDictionary *dic){
            [self dealWithNetManageResult:dic];
        }];
    }else {
        [self showAlertView:@"抱歉" msg:@"请填写完整信息" delegate:self];
    }
}

//处理网络操作结果
- (void)dealWithNetManageResult:(NSDictionary *)dic {
    
    NSString *msg = @"";
    
    switch ([[dic objectForKey:@"result"] intValue]) {
        case 0: {
            msg = @"密码活或用户名为空";
            break;
        }
        case 1: {
            [self.view.window showHUDWithText:@"登录成功" Type:ShowPhotoYes Enabled:YES];
            
            [self performSelector:@selector(saveUserInfoAfterLogIn:) withObject:dic afterDelay:0.9];
            break;
        }
        case 2: {
            msg = @"用户名不存在";
            break;
        }
        case 3: {
            msg = @"密码错误";
            break;
        }
    }
    if (![msg isEqualToString:@""]) {
        [self showAlertView:@"抱歉" msg:msg delegate:self];
    }
}

//保存信息到手机
- (void)saveUserInfoAfterLogIn:(NSDictionary *)dic {
    NSString *userImagePath = [dic objectForKey:@"userIcon"];
    
    [user saveUserCookie];
    [user saveUserName:[dic objectForKey:@"userName"]];
    [user saveUserPhone:[dic objectForKey:@"phoneNumber"]];
    [user saveUserAddress:[dic objectForKey:@"address"]];
    
    if (![userImagePath isEqualToString:@""]) {
        [self getUserImage:userImagePath];
    }
    
    //设置JPush
//    [APService setAlias:phoneNumber callbackSelector:nil object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

//网络操作获取照片
- (void)getUserImage:(NSString *)userImagePath {
    NSURL *url = [[NSURL alloc] initWithString:userImagePath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError){
        if (data.length > 0 && connectionError == nil) {
            [user saveUserIcon:data];
        }
    }];
}

@end