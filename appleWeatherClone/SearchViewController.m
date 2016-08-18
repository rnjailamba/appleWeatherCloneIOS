//
//  SearchViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 18/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@property(strong,nonatomic) UISearchController *searchDisplayController;
@property(strong,nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;



@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activity stopAnimating];
    self.activity.hidesWhenStopped = YES;
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.searchBar = [[UISearchBar alloc] init] ;
//    self.searchDisplayController
//    = [[UISearchController alloc] initWithSearchBar:searchBar
//                                        contentsController:self];
//    self.searchDisplayController.searchResultsDelegate = self;
//    self.searchDisplayController.searchResultsDataSource = self;
//    self.searchDisplayController.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.frame = CGRectMake(0, 40, self.view.frame.size.width, 38);
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar {
    
    //check what was passed as the query String and get rid of the keyboard
    NSLog(@"User searched for %@", searchBar.text);
    [searchBar resignFirstResponder];
    [self.activity startAnimating];
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
