//
//  WeatherBottomViewCell.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 18/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "WeatherBottomViewCell.h"

@interface WeatherBottomViewCell()


@end

@implementation WeatherBottomViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (IBAction)plusClicked:(id)sender {
    [self.delegate plusClicked:sender];
}
@end
