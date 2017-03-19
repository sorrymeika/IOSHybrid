//
//  ASJSONKit.h
//  CaiYun
//
//  Created by Likid on 14-1-3.
//
//

#import <Foundation/Foundation.h>

////////////
#pragma mark Deserializing methods
////////////

@interface NSString (ASJSONKitDeserializing)
- (id)objectFromASJSONString;
@end

@interface NSData (ASJSONKitDeserializing)
// The NSData MUST be UTF8 encoded JSON.
- (id)objectFromASJSONData;
@end

////////////
#pragma mark Serializing methods
////////////

@interface NSString (ASJSONKitSerializing)
- (NSData *)ASJSONData;
- (NSString *)ASJSONString;
@end

@interface NSArray (ASJSONKitSerializing)
- (NSData *)ASJSONData;
- (NSString *)ASJSONString;
@end

@interface NSDictionary (ASJSONKitSerializing)
- (NSData *)ASJSONData;
- (NSString *)ASJSONString;
@end
