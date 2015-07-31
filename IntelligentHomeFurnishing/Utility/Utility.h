//
//  Utility.h
//  WisdomPension
//
//  Created by JC_CP3 on 15/5/5.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(CGFloat)heightForLabel:(NSString *)content constrsize:(CGFloat)width withLabelFont:(CGFloat)labelFont;

+(CGFloat)widthForLabel:(NSString *)content constrsize:(CGFloat)height widthLabelFont:(CGFloat)labelFont;

+(UIColor *)colorWithHexString:(NSString *)color;

//时间转换时间戳
+(NSString *)changeTimeNumToDate:(NSString *)timeNum;

//将NSDate转换NSString
+(NSString *)changeDateToString:(NSDate *)date;

+(NSString *)changeOnlyTimeToString:(NSDate *)date;

//将当前时间转换为时分秒
+(NSString *)changeDateToShiFenMiao:(NSDate *)date;

+(NSString *)changeDateToShiFen:(NSDate *)date;

+(NSString *)changeDateToDay:(NSDate *)date;


+(NSMutableDictionary *)changeDateToShiFenMiaoDictionay:(NSDate *)date;

+(NSMutableDictionary *)changeDateToShiFenDictionary:(NSDate *)date;

//将当前时间转换为毫秒数
+(NSString *)changeTianShiFenMiaoToHaoMiao:(NSString *)day withShi:(NSString *)shi withFen:(NSString *)fen withMiao:(NSString *)miao;

+(NSString *)getNianYueRiInfoFromDate:(NSDate *)date;

+(NSString *)getTaskInfoNameByTaskInfo:(TaskInfo *)taskInfo;

/* 正则表达式 验证数字 */
+(BOOL)checkIsNum:(NSString *)num;

//将十进制转换为2进制
+(NSString *)changeTenToTwo:(uint16_t)tmpid backLength:(int)length;

+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;

+(UIView *)changeColor:(UIView *)currentView;

@end
