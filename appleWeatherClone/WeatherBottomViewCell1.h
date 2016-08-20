//
//  WeatherBottomViewCell1.h
//  appleWeatherClone
//
//  Created by Mr Ruby on 20/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeatherBottomViewCell1Delegate <NSObject>

@required

-(void)plusClicked:(id)sender;
-(void)currentLocationClicked:(id)sender;

@end

@interface WeatherBottomViewCell1 : UITableViewCell

- (IBAction)plusClicked:(id)sender;
@property id<WeatherBottomViewCell1Delegate> delegate;
- (IBAction)currentLocationClicked:(id)sender;

@end
