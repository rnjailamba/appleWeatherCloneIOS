//
//  PageContentViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 17/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "PageContentViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>


#define open_weather_api_key @"1255ba5f70cf5adf3bd2ba9aaa7dd1dc"
#define flickrApiKey @"1b27f0fd8544909da3891f6f8e541d4a"

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
//    NSDictionary *parameters = @{@"method":@"flickr.photos.search",
//                                 @"api_key":flickrApiKey,
//                                 @"tags":[self.titleText lowercaseString],
//                                 @"per_page":@"1",
//                                 @"format":@"json",
//                                 @"nojsoncallback":@"1",
//                                 @"auth_token":@"72157670408905213-b705430ef34a6668",
//                                 @"api_sig":@"9ac579f2ef738bfc38324de21bd12c6a"
//                                 };
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    [manager GET:@"https://api.flickr.com/services/rest"
//      parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
//          
//          id obj = [responseObject objectForKey:@"photos"];
//          if(obj != nil){
//              id photos = [obj objectForKey:@"photo"];
//              dispatch_async(dispatch_get_main_queue(), ^{
//                  NSMutableDictionary *dict = photos[0];
//                  NSString *farm = [dict objectForKey:@"farm"];
//                  NSString *server = [dict objectForKey:@"server"];
//                  NSString *secret = [dict objectForKey:@"secret"];
//                  NSString *theId = [dict objectForKey:@"id"];
//                  NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_n.jpg",farm,server,theId,secret];
//                  NSLog(@"url is %@",url);
//                  [ self.imageView sd_setImageWithURL:[NSURL URLWithString:url ] placeholderImage:[UIImage imageNamed:@"place.png"]];
//                  self.imageView.clipsToBounds = YES;
//                  
//              });
//     
//          }
//          else{
//                self.imageView.image = [UIImage imageNamed:self.imageFile];
//
//          }
//          
//          
//          
//      } failure:^(NSURLSessionTask *operation, NSError *error) {
//          NSLog(@"Error: %@", error);
//      }];
    
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
