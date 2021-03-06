//
//  PhotoAndCameraClass.m
//  MyPrivacy
//
//  Created by 枫叶 on 14-5-31.
//  Copyright (c) 2014年 skywang1994_枫叶. All rights reserved.
//

#import "PhotoAndCameraClass.h"

@implementation PhotoAndCameraClass


static PhotoAndCameraClass *instnce;

#pragma mark - 外部文件可以直接访问PhotoAndCameraClass内部函数
+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
    }
    return instnce;
}

#pragma mark - 从相册获取照片
- (UIImagePickerController *)pickImageFromCamera:(UIImagePickerController *)imagePicker AndController:(id)controllerDelegate
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = controllerDelegate;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        NSLog(@"你这是模拟器！");
    }
    
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    return imagePicker;
}


#pragma mark - 保存照片到documents

//保存单张照片到documents,返回文件名
- (NSString *)saveImageToDocuments:(NSData *)imageData AndImageName:(NSString *)imageName
{
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",imageName]] contents:imageData attributes:nil];
    
//    //得到选择后沙盒中图片的完整路径
//    NSString *imagePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  [NSString stringWithFormat:@"/%@.png",imageName]];
    
    return imageName;
}


- (NSString *)getImageURLString:(NSString *)imageName {
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *subdir = [DocumentsPath stringByAppendingPathComponent:@"RoadInfo"];//RoadInfo就是你创建的文件夹名
    //得到选择后沙盒中图片的完整路径
    NSString *imagePath = [[NSString alloc]initWithFormat:@"%@%@",subdir,  [NSString stringWithFormat:@"/%@",imageName]];
    
    
    return imagePath;
}


- (NSDictionary *)getImageWithImageName:(NSString *)imageName {
    NSData *imageData = [[NSData alloc] init];
    NSString *hasImage = @"";
    UIImage *image = [UIImage imageWithContentsOfFile:[self getImageURLString:imageName]];
    
    if (image != nil) {
        imageData = UIImagePNGRepresentation(image);
        hasImage = @"1";
    }else {
        imageData = [@"123" dataUsingEncoding:NSUTF8StringEncoding];
        hasImage = @"2";
    }
    return @{hasImage: imageData};
}

@end
