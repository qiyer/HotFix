//
//  HotFixManager.m
//  HotFix
//
//  Created by Zhi Zhuang on 2018/3/21.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import "HotFixManager.h"

@implementation HotFixManager


+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static HotFixManager * manager;
    dispatch_once(&onceToken, ^{
        if(nil == manager){
            manager = [[HotFixManager alloc] init];
        }
    });
    return manager;
}

-(void)initHotFix
{
    if (_context){
        NSLog(@"HotFixManager has init!");
        return;
    }
    
    if (nil == _context) {
        _context = [[JSContext alloc] init];
    }
    
    _context.exceptionHandler = ^(JSContext *_context, JSValue *exceptionValue)
    {
        _context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
    _context[@"JSLog"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSString * jsContent = @"";
        for (JSValue *jsVal in args) {
            jsContent = [NSString stringWithFormat:@"%@ %@",jsContent,jsVal.toString];
        }
        NSLog(@"JSLog:%@",jsContent);
    };
}

-(void)runScript:(NSString*) jsURL
{
    jsURL = jsURL?jsURL:@"demo";
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:jsURL ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    NSString *formatedScript = [NSString stringWithFormat:@";(function(){try{\n%@\n}catch(e){_OC_catch(e.message, e.stack)}})();", script];
    @try {
        if ([_context respondsToSelector:@selector(evaluateScript:withSourceURL:)]) {
            [_context evaluateScript:script withSourceURL:[NSURL URLWithString:@"main.js"]];
        } else {
            [_context evaluateScript:formatedScript];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@", exception]);
    }
}
@end
