//
//  ViewController.m
//  指纹识别
//
//  Created by 赵 on 2017/11/20.
//  Copyright © 2017年 袁书辉. All rights reserved.
//
#import <LocalAuthentication/LocalAuthentication.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
    
}

- (IBAction)zhiwen:(id)sender {
    [self ZhiWenShiBie];
}

-(void)ZhiWenShiBie
{
    LAContext *context = [[LAContext alloc] init]; // 初始化上下文对象
    NSError *error = nil;
    // 判断设备是否支持指纹识别功能
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        
        
        NSString *myLocalizedReasonString = @"请按住Home键完成验证";
        NSLog(@"支持");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            if(success)
            {
                NSLog(@"指纹认证成功");
                
                
            }
            else
            {
                
                NSLog(@"指纹认证失败，%@",error.description);
                
                NSLog(@"%ld", (long)error.code); // 错误码 error.code
                switch (error.code)
                {
                    case LAErrorAuthenticationFailed: // Authentication was not successful, because user failed to provide valid credentials
                    {
                        NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                    }
                        break;
                    case LAErrorUserCancel: // Authentication was canceled by user (e.g. tapped Cancel button)
                    {
                        NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮
                        
                    }
                        break;
                    case LAErrorUserFallback: // Authentication was canceled, because the user tapped the fallback button (Enter Password)
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                        }];
                        
                    }
                        break;
                    case LAErrorSystemCancel: // Authentication was canceled by system (e.g. another application went to foreground)
                    {
                        NSLog(@"取消授权，如其他应用切入，用户自主"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                    }
                        break;
                    case LAErrorPasscodeNotSet: // Authentication could not start, because passcode is not set on the device.
                        
                    {
                        NSLog(@"设备系统未设置密码"); // -5
                    }
                        break;
                    case LAErrorTouchIDNotAvailable: // Authentication could not start, because Touch ID is not available on the device
                    {
                        NSLog(@"设备未设置Touch ID"); // -6
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                    {
                        NSLog(@"用户未录入指纹"); // -7
                    }
                        break;
                        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
                    case LAErrorTouchIDLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                    {
                        NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                    }
                        break;
                    case LAErrorAppCancel: // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
                    {
                        NSLog(@"用户不能控制情况下APP被挂起"); // -9
                    }
                        break;
                    case LAErrorInvalidContext: // LAContext passed to this call has been previously invalidated.
                    {
                        NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                    }
                        break;
#else
#endif
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
        
        
    }
    else
    {
        
        NSLog(@"设备不支持指纹识别");
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
