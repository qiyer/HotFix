//
//  ViewController.m
//  HotFix
//
//  Created by Zhi Zhuang on 2018/3/16.
//  Copyright © 2018年 qiye. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HotFixManager.h"

@interface ViewController ()

@end

@implementation ViewController{
    JSContext *context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    [[HotFixManager shareInstance] initHotFix];
    [[HotFixManager shareInstance] runScript:@"HotFix"];
    [[HotFixManager shareInstance] runScript:nil];
}

-(void)doTest
{
    context = [[JSContext alloc] init];
    
    context.exceptionHandler =
    ^(JSContext *_context, JSValue *exceptionValue)
    {
        _context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };

    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *formatedScript = [NSString stringWithFormat:@";(function(){try{\n%@\n}catch(e){_OC_catch(e.message, e.stack)}})();", script];
    
    context[@"jsCallOC"]=^(){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            if([[NSString stringWithFormat:@"%@",jsVal] isEqualToString:@"func_js_to_oc"])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"第二种方式" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                break;
            }
        }
        JSValue *this = [JSContext currentThis];
        NSLog(@"this: %@",this);
    };
    
    context[@"jsCallOC_share"]=^(){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            if([[NSString stringWithFormat:@"%@",jsVal] isEqualToString:@"func_js_to_oc"])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Share" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                break;
            }
        }
    };
    
    @try {
        if ([context respondsToSelector:@selector(evaluateScript:withSourceURL:)]) {
            [context evaluateScript:script withSourceURL:[NSURL URLWithString:@"main.js"]];
        } else {
            [context evaluateScript:formatedScript];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@", exception]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
