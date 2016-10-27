//
//  ViewController.m
//  CreateAppIcon
//
//  Created by liyazhou on 16/10/27.
//  Copyright © 2016年 liyazhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *Icons;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)createAppIcon:(id)sender
{
    //IconAllSize.plist iocn的配置文件，可以在里面添加自己需要的icon尺寸
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IconAllSize" ofType:@"plist"];
    self.Icons = [NSArray arrayWithContentsOfFile:path];
    UIImage *image = [UIImage imageNamed:@"icon-default.png"];//icon模板图，大小最好是1024*1024，根据此图生成app所需的icon
    
    [self createAllAppIconWithImage:image];
}

- (void)createAllAppIconWithImage:(UIImage *)image
{
    for (NSDictionary *iconDic in self.Icons)
    {
        for (NSNumber *scale in iconDic[@"scale"])
        {
            CGSize size = CGSizeMake([iconDic[@"size"][@"width"] integerValue]*[scale integerValue], [iconDic[@"size"][@"width"] integerValue]*[scale integerValue]);
            
            UIGraphicsBeginImageContext(size);
            
            [image drawInRect:CGRectMake(0,0,size.width,size.height)];
            
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            NSData* imageData = UIImagePNGRepresentation(newImage);
            NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/icons"];
            path = @"/Users/XXX/Desktop/icons";//生成的icon的保存路径，自行替换，如：桌面
            if (![[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if ([scale integerValue] > 1)
            {
                path = [NSString stringWithFormat:@"%@/%@@%ldx.png",path,iconDic[@"name"],(long)[scale integerValue]];
            }
            else
            {
                path = [NSString stringWithFormat:@"%@/%@.png",path,iconDic[@"name"]];
            }
            [imageData writeToFile:path atomically:YES];
        }
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"icon创建完成" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertVC addAction:alertAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


@end
