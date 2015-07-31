//
//  AppDelegate.h
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/15.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//


/* 
 
 未激活之前 灰色 switch不可点 加数字判断
 
 太阳时激活成功必须输入
 
 选择开关、选择星期添加placeholder 可以多次选择
 
 周任务 至少打开或者关闭
 
 任务详情显示太阳时
 
 打开关闭默认灰色
 
 太阳时替代 switchList
 
 
 */

#import <UIKit/UIKit.h>
#import "IntelligentIntegratedDevicesViewController.h" //首页
#import "IntelligentTaskViewController.h" //任务
#import "IntelligentAlarmViewController.h" //警告
#import "IntelligentUserSettingViewController.h" //设置
#import "ContexualModelViewController.h" //情景模式首页
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,strong)IntelligentIntegratedDevicesViewController *integratedDeviceViewController;

@property (nonatomic ,strong)IntelligentTaskViewController *taskViewController;

@property (nonatomic ,strong)IntelligentAlarmViewController *alarmViewController;

@property (nonatomic ,strong)ContexualModelViewController *contextualModelViewController;

@property (nonatomic ,strong)IntelligentUserSettingViewController *userSettingViewController;//设置

/* 服务器配置信息 */
@property (nonatomic ,strong)NSString *appServerURL;
@property (nonatomic ,strong)NSString *appServerPort;

//通知开关信息
@property (nonatomic ,strong)NSString *notificationSwitchState;


//全局变量User
@property (nonatomic ,strong)User *user;

/* 个人用户相关操作*/
-(BOOL)checkUserIsLogin; //校验用户是否登陆
-(void)setCurrentLoginUser:(NSMutableDictionary *)dic;

-(void)destoryUser; //销毁账户

-(BOOL)checkNotificationSwitchIsOpen; //检验通知开关是否打开
-(void)setNotificationSwitch:(NSString *)switchState; //设置

//服务器端口配置
-(void)setCurrentAppServer:(NSString *)appURL withPort:(NSString *)port;

-(BOOL)checkCurrentAppServer;

@end

