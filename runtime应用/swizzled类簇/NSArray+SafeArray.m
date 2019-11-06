//
//  NSArray+SafeArray.m
//  runtime应用
//
//  Created by JackMa on 2019/11/6.
//  Copyright © 2019 fire. All rights reserved.
//

#import "NSArray+SafeArray.h"

#import <objc/runtime.h>

@implementation NSArray (SafeArray)

+ (void)load {
    [super load];
    
    Class class = objc_getClass("__NSArrayI");
    
    SEL fromSelector = @selector(objectAtIndex:);
    SEL toSelector = @selector(safe_objectAtIndex:);
    
    Method fromMethod = class_getInstanceMethod(class, fromSelector);
    Method toMethod = class_getInstanceMethod(class, toSelector);
    
    BOOL didAddMethod = class_addMethod(class, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    }else {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

- (id)safe_objectAtIndex:(NSUInteger)index {
    if (self.count-1 < index) {
        @try {
            return [self safe_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"------ %s Crash Because Method %s ------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {
            
        }
    }else {
        return [self safe_objectAtIndex:index];
    }
}

@end
