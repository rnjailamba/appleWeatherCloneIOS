//
//  WeatherBottomViewCell1.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 20/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "WeatherBottomViewCell1.h"

@implementation WeatherBottomViewCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)plusClicked:(id)sender {
    [self.delegate plusClicked:sender];
}


- (IBAction)currentLocationClicked:(id)sender {
    [self.delegate currentLocationClicked:sender];
    
}

@end
