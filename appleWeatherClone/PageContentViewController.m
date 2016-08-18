//
//  PageContentViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 17/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.imageView.image = [UIImage imageNamed:self.imageFile];
    self.label.text = self.titleText;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
