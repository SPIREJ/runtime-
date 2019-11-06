//
//  SPArchiveTool.m
//  runtime应用
//
//  Created by JackMa on 2019/11/6.
//  Copyright © 2019 fire. All rights reserved.
//

#import "SPArchiveTool.h"

@implementation SPArchiveTool

+ (BOOL)sp_archiveObject:(id)object prefix:(NSString *)prefix {
    if (!object) {
        return NO;
    }
    
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:NO error:&error];
    
    if (error) {
        return NO;
    }
    
    [data writeToFile:[SPArchiveTool getPathWithPrefix:prefix] atomically:YES];
    
    return YES;
}

+ (id)sp_unarchiveClass:(Class)class prefix:(NSString *)prefix {
    
    NSError *error;
    NSData *data = [[NSData alloc] initWithContentsOfFile:[SPArchiveTool getPathWithPrefix:prefix]];
    
    if (!data) {
        return nil;
    }
    
    // 会调用对象的 initWithCoder方法
    id content = [NSKeyedUnarchiver unarchivedObjectOfClass:class fromData:data error:&error];
    
    if (error) {
        return nil;
    }
    return content;
}

// 存放的文件路径
+ (NSString *)getPathWithPrefix:(NSString *)prefix {
    NSError *error;
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePathFolder = [documentPath stringsByAppendingPaths:@[@"archiveTemp"]].firstObject;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePathFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePathFolder withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@.plist", filePathFolder, prefix];
    return path;
}

@end
