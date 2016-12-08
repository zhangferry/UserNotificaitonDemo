//
//  ViewController.m
//  UserNotificationsDemo
//
//  Created by zhangferry on 16/9/27.
//  Copyright © 2016年 com.fly. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UNMutableNotificationContent *notiContent;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.notiContent = [[UNMutableNotificationContent alloc] init];
    //引入代理
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
}
/**
 添加普通通知
 */
- (IBAction)addLocalNotification:(id)sender {
    //通过requestWithIdentifier更新通知
    [self regiterLocalNotification:self.notiContent];
}
/**
 添加图片通知
 */
- (IBAction)addImageLocalNotification:(id)sender {
    
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"sport" ofType:@"png"];
    
    UNNotificationAttachment *imageAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"iamgeAttachment" URL:[NSURL fileURLWithPath:imageFile] options:nil error:nil];
    self.notiContent.attachments = @[imageAttachment];
    
    [self regiterLocalNotification:self.notiContent];
}

/**
 添加视频通知
 */
- (IBAction)addVideoLocalNotification:(id)sender {
    
}

/**
 添加交互通知

 */
- (IBAction)addInteractionLocalNotification:(id)sender {
    
    UNTextInputNotificationAction *action1 = [UNTextInputNotificationAction actionWithIdentifier:@"replyAction" title:@"文字回复" options:UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"enterAction" title:@"进入应用" options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"cancelAction" title:@"取消" options:UNNotificationActionOptionDestructive];
    UNNotificationCategory *categroy = [UNNotificationCategory categoryWithIdentifier:@"Categroy" actions:@[action1,action2,action3] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:categroy]];
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    self.notiContent.categoryIdentifier = @"Categroy";
    
    [self regiterLocalNotification:self.notiContent];
    
}

- (void)regiterLocalNotification:(UNMutableNotificationContent *)content{
    
    content.title = @"iOS10通知";
    content.subtitle = @"新通知学习笔记";
    content.body = @"新通知变化很大，之前本地通知和远程推送是两个类，现在合成一个了。";
    content.badge = @1;
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"caodi.m4a"];
    content.sound = sound;

    //重复提醒，时间间隔要大于60s
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    NSString *requertIdentifier = @"RequestIdentifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error);
    }];
    
}
- (IBAction)deleteNotification:(id)sender {
    
    [self deleteLocalNotification:@"RequestIdentifier"];
}

- (void)deleteLocalNotification:(NSString *)identifier{
    
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
    NSLog(@"收到通知：%@",response.notification.request.content);
    
    if ([categoryIdentifier isEqualToString:@"Categroy"]) {
        //识别需要被处理的拓展
        if ([response.actionIdentifier isEqualToString:@"replyAction"]){
            //识别用户点击的是哪个 action
            UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
            //获取输入内容
            NSString *userText = textResponse.userText;
            //发送 userText 给需要接收的方法
            NSLog(@"要发送的内容是：%@",userText);
            //[ClassName handleUserText: userText];
        }else if([response.actionIdentifier isEqualToString:@"enterAction"]){
            NSLog(@"点击了进入应用按钮");
        }else{
            NSLog(@"点击了取消");
        }
        
    }
    completionHandler();
}

//只有当前处于前台才会走，加上返回方法，使在前台显示信息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSLog(@"执行willPresentNotificaiton");
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
