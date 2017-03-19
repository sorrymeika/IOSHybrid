//
//  QRCodePlugin.m
//  CMCC
//
//  Created by 孙路 on 17/3/10.
//  Copyright © 2017年 Miku. All rights reserved.
//

#import "QRCodePlugin.h"
#import "ModalQRCodeViewController.h"

@interface QRCodePlugin (){
    
    NSString * callback;
    
}
@end

@implementation QRCodePlugin


-(void)execute:(NSDictionary *)command {
    callback=[command objectForKey:@"callback"];
    
    
    NSDictionary *params = [command objectForKey:@"params"];
    
    NSString * type=[params objectForKey:@"type"];
    
    if ([type isEqualToString:@"scan"]) {
        
        ModalQRCodeViewController *qrC = [[ModalQRCodeViewController alloc] init];
        
        qrC.viewController.delegate = self;
        
        [_hybridView.viewController presentViewController:qrC animated:YES completion:^{}];
        
    } else {
        
    }
    
}

-(void)scanQRCodeSuccess:(UIViewController *)viewController result:(NSString *)result {
    
    [_hybridView callback:callback params:@{
                                            @"code": result,
                                            @"success": [NSNumber numberWithBool:true]
                                            }];
    
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
