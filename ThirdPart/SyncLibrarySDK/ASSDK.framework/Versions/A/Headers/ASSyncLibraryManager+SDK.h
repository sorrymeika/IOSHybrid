//
//  ASSyncLibraryManager+SDK.h
//  ASSyncLibraryProject
//
//  Created by likid1412 on 9/16/14.
//
//

#import "ASSyncLibraryManager.h"

@interface ASSyncLibraryManager (SDK)

+ (ASAddrBookObject*)sharedAddrBook;

/**
 *  获取 Document 文档路径
 *
 *  @return Document 文档路径
 */
+ (NSString*)documentPath;

@end
