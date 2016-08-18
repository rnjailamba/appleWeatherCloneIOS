//
//  SearchViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 18/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property(strong,nonatomic) UISearchController *searchDisplayController;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen]bounds];
    UISearchBar *searchBar = [[UISearchBar alloc] init] ;
//    self.searchDisplayController
//    = [[UISearchController alloc] initWithSearchBar:searchBar
//                                        contentsController:self];
//    self.searchDisplayController.searchResultsDelegate = self;
//    self.searchDisplayController.searchResultsDataSource = self;
//    self.searchDisplayController.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.frame = CGRectMake(0, 40, self.view.frame.size.width, 38);
    [self.view addSubview:searchBar];
    // Do any additional setup after loading the view from its nib.
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
