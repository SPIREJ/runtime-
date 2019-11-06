//
//  SPArchiveTool.h
//  runtime应用
//
//  Created by JackMa on 2019/11/6.
//  Copyright © 2019 fire. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPArchiveTool : NSObject

+ (BOOL)sp_archiveObject:(id)object prefix:(NSString *)prefix;
+ (id)sp_unarchiveClass:(Class)class prefix:(NSString *)prefix;

@end

NS_ASSUME_NONNULL_END
