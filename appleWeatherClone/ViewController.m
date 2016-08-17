//
//  ViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 16/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"


@interface ViewController ()
- (IBAction)startAppleWeatherApp:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame  = [[ UIScreen mainScreen ] bounds];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startAppleWeatherApp:(id)sender {
    PageViewController *pageVC = [[PageViewController alloc]initWithNibName:@"PageViewController" bundle:nil];
    [self.navigationController pushViewController:pageVC animated:YES];
}
@end
