//
//  Utility.m
//  WisdomPension
//
//  Created by JC_CP3 on 15/5/5.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "Utility.h"
#import <AVFoundation/AVFoundation.h>

@implementation Utility

+(CGFloat)heightForLabel:(NSString *)content constrsize:(CGFloat)width withLabelFont:(CGFloat)labelFont{
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:labelFont]};
    
    CGRect currentRect = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    return currentRect.size.height;
    
}

+(CGFloat)widthForLabel:(NSString *)content constrsize:(CGFloat)height widthLabelFont:(CGFloat)labelFont{
    
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:labelFont]};
    
    CGRect currentRect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    return currentRect.size.width;
    
    
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(NSString *)changeTimeNumToDate:(NSString *)timeNum{
    
    if(timeNum && ![timeNum isEqual:@""] &&![timeNum isKindOfClass:[NSNull class]]){
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyyMMddHHMMss"];
        NSDate *date = [formatter dateFromString:timeNum];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *destDateString = [dateFormatter stringFromDate:date];
        
        return destDateString;
    }else{
        return @"没时间";
    }
    
}

+(NSString *)changeDateToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+(NSString *)changeOnlyTimeToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

+(NSString *)changeDateToShiFenMiao:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
//    int year = [comps year];
//    int month = [comps month];
//    int day = [comps day];
    int hour = (int)[comps hour];
    int min = (int)[comps minute];
    int sec = (int)[comps second];
    
    return [NSString stringWithFormat:@"%d时%d分%d秒",hour,min,sec];
    
}


+(NSString *)changeDateToDay:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    //    int year = [comps year];
    //    int month = [comps month];
        int day = [comps day];
//    int hour = (int)[comps hour];
//    int min = (int)[comps minute];
//    int sec = (int)[comps second];
    
    return [NSString stringWithFormat:@"%d",day];
    
    
}

+(NSString *)changeDateToShiFen:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    //    int year = [comps year];
    //    int month = [comps month];
    //    int day = [comps day];
    int hour = (int)[comps hour];
    int min = (int)[comps minute];
    
    return [NSString stringWithFormat:@"%d时%d分",hour,min];
    
}

+(NSDictionary *)changeDateToShiFenMiaoDictionay:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    //    int year = [comps year];
    //    int month = [comps month];
    //    int day = [comps day];
    int hour = (int)[comps hour];
    int min = (int)[comps minute];
    int sec = (int)[comps second];
    
    NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
    [dateDic setObject:[NSString stringWithFormat:@"%d",hour] forKey:@"hour"];
    [dateDic setObject:[NSString stringWithFormat:@"%d",min] forKey:@"min"];
    [dateDic setObject:[NSString stringWithFormat:@"%d",sec] forKey:@"sec"];
    
    return dateDic;
    
}


+(NSMutableDictionary *)changeDateToShiFenDictionary:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
//        int year = [comps year];
//        int month = [comps month];
//        int day = [comps day];
    int hour = (int)[comps hour];
    int min = (int)[comps minute];
    
    NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
    [dateDic setObject:[NSString stringWithFormat:@"%d",hour] forKey:@"hour"];
    [dateDic setObject:[NSString stringWithFormat:@"%d",min] forKey:@"min"];

    
    return dateDic;
}

+(NSString *)getNianYueRiInfoFromDate:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    int year = (int)[comps year];
    int month = (int)[comps month];
    int day = (int)[comps day];

    return [NSString stringWithFormat:@"%d/%d/%d",month,day,year];
    
}

+(NSString *)changeTianShiFenMiaoToHaoMiao:(NSString *)day withShi:(NSString *)shi withFen:(NSString *)fen withMiao:(NSString *)miao{
    
    double ms = [day intValue] * 86400000;
    
    ms += [shi intValue] * 3600000 ;
    
    ms += [fen intValue] *60000;
    
    ms += [miao intValue] *1000;
    
    return [NSString stringWithFormat:@"%.0f",ms];
    
}

+(NSString *)getTaskInfoNameByTaskInfo:(TaskInfo *)taskInfo{
    
    NSString *taskInfoName = @"";
    
    if([taskInfo.taskType isEqual:@"1"]){
        
        if([taskInfo.taskType2 isEqual:@"2"]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(周)%@-%@于每周%@的",taskInfo.taskIndex,taskInfo.taskInfoID,taskInfo.taskWeek]];
            
        }else{
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(周)%@-%@于每周%@的",taskInfo.taskIndex,taskInfo.taskSwitchIndex,taskInfo.taskWeek]];
            
        }
        
        
        if(taskInfo.taskAction1 && ![taskInfo.taskAction1 isEqual:@""]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"%@打开",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1]]];
        }
        
        if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"%@关闭",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs2]]];
        }
        
    }else if ([taskInfo.taskType isEqual:@"3"]){
        
        taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(太阳时)%@开关%@(高位在前)于",taskInfo.taskIndex,@"替代"]];
        
        if(taskInfo.taskAction1 && ![taskInfo.taskAction1 isEqual:@""]){
            taskInfoName = [taskInfoName stringByAppendingString:@"日出"];
            if([taskInfo.taskExecutionTs1 intValue]<0){
                taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"前%@分钟",taskInfo.taskExecutionTs1]];
            }else{
                taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"后%@分钟",taskInfo.taskExecutionTs1]];
            }
        }
        
        if([taskInfo.taskAction1 intValue] == 1){
            taskInfoName = [taskInfoName stringByAppendingString:@"打开"];
        }else{
            taskInfoName = [taskInfoName stringByAppendingString:@"关闭"];
        }
        
        
        if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
            taskInfoName = [taskInfoName stringByAppendingString:@"日出"];
            if([taskInfo.taskExecutionTs2 intValue]<0){
                taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"前%@分钟",taskInfo.taskExecutionTs2]];
            }else{
                taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"后%@分钟",taskInfo.taskExecutionTs2]];
            }
        }
        
        if([taskInfo.taskAction2 intValue] == 1){
            taskInfoName = [taskInfoName stringByAppendingString:@"打开"];
        }else{
            taskInfoName = [taskInfoName stringByAppendingString:@"关闭"];
        }
        
    }else{
        
        if([taskInfo.taskType2 isEqual:@"2"]){
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(间隔)%@-%@于%@%@",taskInfo.taskIndex,taskInfo.taskInfoID,[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1],[taskInfo.taskAction1 intValue] == 1? @"打开": @"关闭"]];
        }else{
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"(间隔)%@-%@于%@%@",taskInfo.taskIndex,taskInfo.taskSwitchIndex,[Utility changeTimeNumToDate:taskInfo.taskExecutionTs1],[taskInfo.taskAction1 intValue] == 1? @"打开": @"关闭"]];
        }
        
        if(taskInfo.taskAction2 && ![taskInfo.taskAction2 isEqual:@""]){
            
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"在%@后%@",[Utility changeTimeNumToDate:taskInfo.taskExecutionTs2],[taskInfo.taskAction2 intValue] == 1? @"打开": @"关闭"]];
            
        }
        
        if(taskInfo.taskPeriod){
            taskInfoName = [taskInfoName stringByAppendingString:[NSString stringWithFormat:@"之后间隔%@执行一次",[Utility changeTimeNumToDate:taskInfo.taskPeriod]]];
        }
        
        
    }
    
    return taskInfoName;
    
}

+(BOOL)checkIsNum:(NSString *)num{
    
    NSString * regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:num];
    return isMatch;
    
}

+(NSString *)changeTenToTwo:(uint16_t)tmpid backLength:(int)length
{
    
   
    
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
       
    }
    
    return a;
    
}

// 根据二进制开关数 返回拼接的字符串
-(NSString *)getAppendingSwitchNameByArray:(NSMutableArray *)array withSwitchIndex:(NSString *)switchIndex{
    
    NSString *_currentAppendingName = @"";
    
    NSMutableArray *_currentSelectedSwitchNameArray = [[NSMutableArray alloc] init];
    
    if(switchIndex && ![switchIndex isEqual:@""] && [array count]>0){
        
        NSMutableArray *switchArray = [[NSMutableArray alloc] init];
        
        for (int j = 0; j<switchIndex.length; j++) {
            
            NSString *subString = [switchIndex substringWithRange:NSMakeRange(j, 1)];
            
            [switchArray addObject:subString];
            
        }
        
        for (int i = [array count]-1; i>=0; i--) {
            
            NSString *c = [switchArray objectAtIndex:i];
            
            if([c isEqual:@"1"]){
                
                SwitchInfo *currentSwitchInfo = [array objectAtIndex:[switchArray count]-1-i];
                
                
                NSString *currentSwitchInfoString =   currentSwitchInfo.switchName;
                
                [_currentSelectedSwitchNameArray addObject:currentSwitchInfoString];
                
            }
            
        }
        
        
    }
    
    NSString *appendingString = @"";
    
    
    for (int i=0; i<[_currentSelectedSwitchNameArray count]; i++) {
        
        if(i<[_currentSelectedSwitchNameArray count]-1){
            appendingString = [appendingString stringByAppendingString:[_currentSelectedSwitchNameArray objectAtIndex:i]];
            appendingString = [appendingString stringByAppendingString:@","];
        }else{
            appendingString = [appendingString stringByAppendingString:[_currentSelectedSwitchNameArray objectAtIndex:i]];
        }
    }
    
    _currentAppendingName = appendingString;
    
    return _currentAppendingName;
}

+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController
{
    return (viewController.isViewLoaded && viewController.view.window);
}





@end
