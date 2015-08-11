//
//  ViewController.h
//  PickupImageDemo
//
//  Created by Apple on 8/11/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNetworkEngine.h"
@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIButton *textButton;
    NSString *fullPath;
}

@end

