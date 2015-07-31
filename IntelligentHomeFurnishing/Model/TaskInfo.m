//
//  TaskInfo.m
//  IntelligentHomeFurnishing
//
//  Created by JC_CP3 on 15/5/22.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "TaskInfo.h"
#import "Utility.h"

@implementation TaskInfo

-(void)setTaskInfoWithDataDic:(NSMutableDictionary *)dataDic{
    
    if([dataDic objectForKey:@"action1"] && ![[dataDic objectForKey:@"action1"] isEqual:@""] && ![[dataDic objectForKey:@"action1"] isKindOfClass:[NSNull class]]){
        _taskAction1 = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"action1"] intValue]];
    }
    
    if([dataDic objectForKey:@"action2"] && ![[dataDic objectForKey:@"action2"] isEqual:@""] && ![[dataDic objectForKey:@"action2"] isKindOfClass:[NSNull class]]){
        _taskAction2 = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"action2"] intValue]];
    }
    
    
    if([dataDic objectForKey:@"centerControllerId"] && ![[dataDic objectForKey:@"centerControllerId"] isEqual:@""] && ![[dataDic objectForKey:@"centerControllerId"] isKindOfClass:[NSNull class]]){
        _taskCenterControllerID = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"centerControllerId"] intValue]];
    }
    
    if([dataDic objectForKey:@"center"] && ![[dataDic objectForKey:@"center"] isEqual:@""] && ![[dataDic objectForKey:@"center"] isKindOfClass:[NSNull class]]){
        
    }
    
    
    if([dataDic objectForKey:@"check"] && ![[dataDic objectForKey:@"check"] isEqual:@""] && ![[dataDic objectForKey:@"check"] isKindOfClass:[NSNull class]]){
        _taskCheck = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"check"] intValue]];
    }
    
    
    if([dataDic objectForKey:@"executionTs1"] && ![[dataDic objectForKey:@"executionTs1"] isEqual:@""] && ![[dataDic objectForKey:@"executionTs1"] isKindOfClass:[NSNull class]]){
        _taskExecutionTs1 = [[dataDic objectForKey:@"executionTs1"] stringValue];
    }
    
    
    if([dataDic objectForKey:@"executionTs2"] && ![[dataDic objectForKey:@"executionTs2"] isEqual:@""] && ![[dataDic objectForKey:@"executionTs2"] isKindOfClass:[NSNull class]]){
        _taskExecutionTs2 = [[dataDic objectForKey:@"executionTs2"] stringValue];
    }
    
    if([dataDic objectForKey:@"id"] && ![[dataDic objectForKey:@"id"] isEqual:@""] && ![[dataDic objectForKey:@"id"] isKindOfClass:[NSNull class]]){
        _taskInfoID = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"id"] intValue]];
    }
    
    
    if([dataDic objectForKey:@"switchIndex"] && ![[dataDic objectForKey:@"switchIndex"] isEqual:@""] && ![[dataDic objectForKey:@"switchIndex"] isKindOfClass:[NSNull class]]){
        
        int switchIndexNum ;
        
        if([[dataDic objectForKey:@"switchIndex"] intValue] < 0){
            switchIndexNum = -[[dataDic objectForKey:@"switchIndex"] intValue];
        }else{
            
            switchIndexNum = [[dataDic objectForKey:@"switchIndex"] intValue];
        }
        
        _taskSwitchIndex = [Utility changeTenToTwo:switchIndexNum backLength:8];
        
    }
    
    if([dataDic objectForKey:@"taskIndex"] && ![[dataDic objectForKey:@"taskIndex"] isEqual:@""] && ![[dataDic objectForKey:@"taskIndex"] isKindOfClass:[NSNull class]]){
        _taskIndex = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"taskIndex"] intValue]];
    }
    
    if([dataDic objectForKey:@"type"] && ![[dataDic objectForKey:@"type"] isEqual:@""] && ![[dataDic objectForKey:@"type"] isKindOfClass:[NSNull class]]){
        _taskType = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"type"] intValue]];
    }
    
    
    if([dataDic objectForKey:@"type2"] && ![[dataDic objectForKey:@"type2"] isEqual:@""] && ![[dataDic objectForKey:@"type2"] isKindOfClass:[NSNull class]]){
        _taskType2 = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"type2"] intValue]];
    }
    
    if([dataDic objectForKey:@"week"] && ![[dataDic objectForKey:@"week"] isEqual:@""] && ![[dataDic objectForKey:@"week"] isKindOfClass:[NSNull class]]){
        _taskWeek = [dataDic objectForKey:@"week"];
    }
    
    if([dataDic objectForKey:@"period"] && ![[dataDic objectForKey:@"period"] isEqual:@""] && ![[dataDic objectForKey:@"period"] isKindOfClass:[NSNull class]]){
        _taskPeriod = [[dataDic objectForKey:@"period"] stringValue];
    }
    
    if([dataDic objectForKey:@"childTaskId"] && ![[dataDic objectForKey:@"childTaskId"] isEqual:@""] && ![[dataDic objectForKey:@"childTaskId"] isKindOfClass:[NSNull class]]){
        _taskChildTaskID = [[dataDic objectForKey:@"childTaskId"] stringValue];
    }
    
}

@end
