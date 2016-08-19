//
//  CurrentViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 19/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "CurrentViewController.h"
@import GooglePlaces;
@import CoreLocation;

@interface CurrentViewController ()<CLLocationManagerDelegate>
// Instantiate a pair of UILabels in Interface Builder
@property ( nonatomic)  UILabel *nameLabel;
@property ( nonatomic)  UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backClicked:(id)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *yourCurrentLocationLabel;


@end

@implementation CurrentViewController {
    GMSPlacesClient *_placesClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameLabel sizeToFit];
    _placesClient = [GMSPlacesClient sharedClient];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        NSString *name = nil;
        NSString *address = nil;
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }

        name = @"No current place";
        address = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                name = place.name;
                address = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
            }
        }
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.yourCurrentLocationLabel.frame.origin.y+self.yourCurrentLocationLabel.frame.size.height + 20, self.view.frame.size.width, 20)];
        self.nameLabel.text = name;
        self.nameLabel.numberOfLines = 0;
//        [self.nameLabel sizeToFit];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.nameLabel];
        
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height + 20, self.view.frame.size.width, 20)];
        self.addressLabel.text = address;
        self.addressLabel.numberOfLines = 0;
        [self.addressLabel sizeToFit];
        self.addressLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.addressLabel];
        
    }];
}

// Add a UIButton in Interface Builder to call this function
- (IBAction)getCurrentPlace:(UIButton *)sender {
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        self.nameLabel.text = @"No current place";
        self.addressLabel.text = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                self.nameLabel.text = place.name;
                self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
            }
        }
    }];
}

- (IBAction)backClicked:(id)sender {
    [self.backButton setAttributedTitle:nil forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}






@end
