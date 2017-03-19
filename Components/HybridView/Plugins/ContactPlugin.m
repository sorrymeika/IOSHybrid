//
//  ContactPlugin.m
//  CMCC
//
//  Created by 孙路 on 17/3/12.
//  Copyright © 2017年 Miku. All rights reserved.
//

#import "ContactPlugin.h"
#import <Contacts/Contacts.h>

@implementation ContactPlugin {
    
    NSString * callback;
    
}


-(void)execute:(NSDictionary *)command{
    callback=[command objectForKey:@"callback"];
    
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString *type=[params objectForKey:@"type"];
    
    if ([type isEqualToString:@"getContacts"]){
        
        int size = [[params objectForKey:@"size"] intValue];
        int position= [[params objectForKey:@"position"] intValue]?:-1;
        
        NSString *process = [command objectForKey:@"process"];
        
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
                NSLog(@"Authorized");
                
                CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactFamilyNameKey,CNContactMiddleNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey]];
                
                NSMutableArray *result = [NSMutableArray array];
                
                __block int count = 0;
                
                [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    
                    count = count+1;
                    
                    if (size==0 || count<= size) {
                        NSArray<CNLabeledValue<CNPhoneNumber*>*> *phoneNumbers = [contact phoneNumbers];
                        
                        NSString *contactName = [NSString stringWithFormat:@"%@%@",[contact familyName],[contact givenName]];
                        
                        for (CNLabeledValue<CNPhoneNumber*>* phoneNumber in phoneNumbers) {
                            
                            [result addObject:@{
                                                @"contactId":@"",
                                                @"contactName": contactName,
                                                @"phoneNumber": [[phoneNumber value] stringValue]
                                                }];
                        }
                    }
                }];
                
                NSLog(@"Read Contact");
                
                if (process) {
                    
                    [_hybridView callback:process params:@{
                                                           @"success": [NSNumber numberWithBool:true],
                                                           @"data": result
                                                           }];
                    
                    [_hybridView callback:callback params:@{
                                                            @"success": [NSNumber numberWithBool:true]
                                                            }];
                } else {
                    [_hybridView callback:callback params:@{
                                                            @"success": [NSNumber numberWithBool:true],
                                                            @"data": result
                                                            }];
                }
                
            }else{
                
                NSLog(@"Denied or Restricted");
                
                UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:nil message:@"没有权限读取通讯录" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                [alertView show];
            }
        }];
        
    } else {
        
    }
    
}


@end
