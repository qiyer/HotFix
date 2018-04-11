//
//  HotFixManager.h
//  HotFix
//
//  Created by Zhi Zhuang on 2018/3/21.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface HotFixManager : NSObject

@property (strong, nonatomic) JSContext *context;

+(instancetype)shareInstance;
-(void)initHotFix;
-(void)runScript:(NSString*) jsURL;
@end
