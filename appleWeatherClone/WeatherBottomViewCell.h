//
//  WeatherBottomViewCell.h
//  appleWeatherClone
//
//  Created by Mr Ruby on 18/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeatherBottomViewCellDelegate <NSObject>

@required

-(void)plusClicked:(id)sender;
-(void)currentLocationClicked:(id)sender;

@end

@interface WeatherBottomViewCell : UICollectionViewCell

- (IBAction)plusClicked:(id)sender;
@property id<WeatherBottomViewCellDelegate> delegate;
- (IBAction)currentLocationClicked:(id)sender;

@end
