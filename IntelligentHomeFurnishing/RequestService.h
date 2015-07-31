//
//  RequestService.h
//  FindNearest_3.0
//
//  Created by 会搜 on 15/3/7.
//  Copyright (c) 2015年 纪超Cp3. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define BaseDirectoryURL @"http://192.168.100.9:7080"
//#define BaseDirectoryURL @"http://115.236.70.155:8089/"
//#define BaseURL [APPDELEGATE appServerURL]
//#define BasePORT [APPDELEGATE appServerPort]

#define UserLogin @"loginService!doLogin.action" //登录 入参：user.name & user.password
#define UserHome @"homeService!getSwitchInfoList.action" //我的家庭 入参 homeId
#define DoSwitchCommand @"commandService!doCommand.action" //执行开关命令 入参centerControllerId&action(开｜｜关) & switchIndex
#define UserTaskAllIntegratedDevices @"taskService!getCenterControllerList.action" //所有集成器
#define IntegratedDevicesAllTask @"taskService!getSwitchTimerTaskList.action" //某个集成器下所有任务 入参centerControllerId

#define GetCurrentTaskInfo @"taskService!getSwitchTimerTask.action" //获取单个任务信息接口 入参taskId
#define DeleteCurrentTask @"taskService!deleteSwitchTimerTask.action" //删除某个任务 入参taskId&keepStatus

#define GetContextualModelList @"homeService!getModelList.action" //获取情景模式列表 （入参 homeId）
#define DoContextualModel @"homeService!doModelCommand.action" //操作情景模式 开关  入参 modelId&flag

#define SaveIntelligentSunTask @"taskService!saveSunTask.action" //保存集中器太阳时任务
#define SaveIntelligentSpacingTask @"taskService!saveSSwitchTimerTask.action" //保存集中器间隔任务
#define SaveIntelligentWeekTask @"taskService!saveSwitchTimerTask.action" //保存集中器周任务

#define SaveContexualSunTask @"taskService!saveSunTask2.action" //保存情景模式太阳时任务
#define SaveContexualSpacingTask @"taskService!saveSSwitchTimerTask2.action" //保存情景模式分隔任务
#define SaveContexualWeekTask @"taskService!saveSwitchTimerTask2.action" //保存情景模式周任务

#define GetAllSwitchByIntelligentID @"homeService!getSwitchInfoListByCenterController.action" //获取集中器下所有开关列表
#define GetContextualModelTaskList @"taskService!getModelTaskList.action" //获取情景模式任务列表

#define GetControlAllTask @"taskService!getCCListAndTaskList.action" //获取控制器下所有任务

/* 所有的情景模式功能  */

//获取情景模式开关列表 modelId
#define GetContextualModelSwitchList @"homeService!getSwitchInfoListByModel.action"
//获取所有开关列表 homeId
#define GetAllSwitchList @"homeService!getSwitchList.action"
//删除情景模式 modelId
#define DeleteCurrentContextualModel @"homeService!deleteModel.action"

//添加修改情景模式
#define SaveUpdateContextualModel @"homeService!saveModel.action"

//获取情景模式详情
#define GetContextualModelDetail @"homeService!getModel.action"
#define ChangeNotification @"homeService!updatePushStatus.action"

@interface RequestService : NSObject

//单例模式
+(RequestService *)defaultRequestService;

//异步get请求
-(void)asyncGetDataWithURL:(NSString *)requestURL paramDic:(NSMutableDictionary *)paramDic responseDicBlock:(void (^)(NSMutableDictionary * responseDic))repsonseDic errorBlock:(void(^)(NSString *errorMessage))errorMessage;

//异步post请求
-(void)asyncPostDataWithURL:(NSString *)requestURL paramDic:(NSMutableDictionary *)paramDic responseDicBlock:(void(^)(NSMutableDictionary * responseDic))responseDic errorBlock:(void(^)(NSString *errorMessage))errorMessage;

@end
