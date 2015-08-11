//
//  ViewController.m
//  PickupImageDemo
//
//  Created by Apple on 8/11/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    textButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    textButton.frame=CGRectMake(20, 40, 280, 30);
    [textButton setTitle:@"选择头像" forState:UIControlStateNormal];
    [textButton setBackgroundColor:[UIColor greenColor]];
    [textButton.layer setBorderWidth:1.0];
    
    [textButton.layer setMasksToBounds:YES];
    [textButton.layer setCornerRadius:10.0];
    textButton.tag=1;
    [textButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textButton];
    
}

-(void)buttonAction:(UIButton *)button{
    
    [self whenClickHeadImage];
}

#pragma mark - 点击头像
-(void)whenClickHeadImage{
    
    UIActionSheet *sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"宝宝头像选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"从相机中选择", nil];
    sheet.tag = 255;
    sheet.actionSheetStyle = UIBarStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    //读取图片数据，设置压缩系数为0.5.
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    NSLog(@"图片保存path:%@",fullPath);
    [imageData writeToFile:fullPath atomically:NO];
    
    // 使用MKNetworkKit 上传图片和数据
    MKNetworkEngine* engine = [[MKNetworkEngine alloc] init] ;
    NSDictionary* postvalues = [NSDictionary dictionaryWithObjectsAndKeys:@"mknetwork",@"name",nil];
    MKNetworkOperation* op = [engine operationWithURLString:@"http://192.168.40.10/IOSUPLOAD/WebForm1.aspx" params:postvalues httpMethod:@"POST"];
    [op addFile:fullPath forKey:@"img"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"mknetwork error : %@",error.debugDescription);
    }];
    [engine enqueueOperation:op];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:[NSString stringWithFormat:@"%d.png",1]];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - PickerController delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        switch (buttonIndex) {
            case 0:
                // 相册  或者 UIImagePickerControllerSourceTypePhotoLibrary
                sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                NSLog(@"选择相册图片");
                break;
                //相机
            case 1:
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Test on real device, camera is not available in simulator" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    return;
                }
            }
                break;
            case 2:
                NSLog(@"取消");
                // 取消
                return;
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate =self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
