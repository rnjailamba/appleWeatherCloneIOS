//
//  PageContentViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 17/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "PageContentViewController.h"
#import <AFNetworking/AFNetworking.h>

#define open_weather_api_key @"1255ba5f70cf5adf3bd2ba9aaa7dd1dc"

@interface PageContentViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *weatherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempratureLabel;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.imageView.image = [UIImage imageNamed:self.imageFile];
    self.label.text = self.titleText;
    self.imageView.clipsToBounds = YES;
    [self fetchOtherDataBasedOnPlace:self.titleText];
}

-(void)fetchOtherDataBasedOnPlace:(NSString *)place{
    if([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",place,@"temp"]] == nil ||
       [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",place,@"tempName"]] == nil){
        NSDictionary *parameters = @{@"q":place,
                                     @"APPID":open_weather_api_key,
                                     @"units":@"metric"};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager GET:@"http://api.openweathermap.org/data/2.5/weather" parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
            
            //Get Temprature
            id obj = [responseObject objectForKey:@"main"];
            NSString *temp = [obj objectForKey:@"temp"];
            NSInteger tempInt = [temp intValue];
            
            //Get Temprature name
            id obj1 = [responseObject objectForKey:@"weather"];
            NSString *temp1 = [obj1[0] objectForKey:@"main"];
           
            //            NSLog(@"object: %@", responseObject);
            //            NSLog(@"temp: %@", temp);
            NSLog(@"place: %@", place);
            NSLog(@"tempname: %@", temp1);
            NSLog(@"tempInt: %ld", (long)tempInt);
            dispatch_async(dispatch_get_main_queue(), ^(){
                self.weatherNameLabel.text = temp1;
                self.tempratureLabel.text = [NSString stringWithFormat:@"%ld",(long)tempInt];
            });
            [self saveDataToNSUserTempratureName:temp1 temprature:[NSString stringWithFormat:@"%ld",(long)tempInt] forPlace:place];
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

    }
    else{
        self.weatherNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",place,@"tempName"]];
        self.tempratureLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",place,@"temp"]];
    }
}

-(void)saveDataToNSUserTempratureName:(NSString *)tempratureName temprature:(NSString *)temprature forPlace:(NSString *)place{
    [[NSUserDefaults standardUserDefaults] setObject:tempratureName forKey:[NSString stringWithFormat:@"%@%@",place,@"tempName"]];
    [[NSUserDefaults standardUserDefaults] setObject:temprature forKey:[NSString stringWithFormat:@"%@%@",place,@"temp"]];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
