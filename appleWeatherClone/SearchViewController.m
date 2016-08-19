//
//  SearchViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 18/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "SearchViewController.h"
@import GooglePlaces;
@import CoreLocation;

@interface SearchViewController ()<UISearchBarDelegate , UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong,nonatomic) UISearchController *searchDisplayController;
@property(strong,nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *results;

@end

@implementation SearchViewController{
    GMSPlacesClient *_placesClient;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activity stopAnimating];
    self.activity.hidesWhenStopped = YES;
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.results = [NSMutableArray new];
    [self searchBarSetup];
    [self aboveSearchBarSetup];
    
    _placesClient = [GMSPlacesClient sharedClient];
    [self collectionViewSetup];
    [self registerNib];
}

-(void)collectionViewSetup{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, 60);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 78, self.view.frame.size.width, self.view.frame.size.height - 78) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor darkGrayColor];
    self.collectionView.delegate = self;
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView setHidden:YES];
}

-(void)registerNib{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

-(void)aboveSearchBarSetup{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 20)];
    label.textColor = [UIColor whiteColor];
    label.font  = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Enter city,postcode or Airport location";
    [self.view addSubview:label];
}

-(void)searchBarSetup{
    self.searchBar = [[UISearchBar alloc] init] ;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.frame = CGRectMake(0, 40, self.view.frame.size.width, 38);
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    //black color on the searchbar
    self.searchBar.barTintColor = [UIColor blackColor];
    //white color for the cancel button
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor whiteColor]];
    //gray background for the text field
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = [UIColor darkGrayColor];
    txfSearchField.textColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.results count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray* subviews = [cell.contentView subviews];
    for (UIView* subview in subviews) {
        [subview removeFromSuperview];
    }
    cell.frame = CGRectMake(0, 0 + indexPath.row*60, self.view.frame.size.width, 60);
    cell.backgroundColor = [UIColor colorWithHue:drand48() saturation:0.7 brightness:0.9 alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width, 20)];
    label.text =  [self.results objectAtIndex:indexPath.row];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:label];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected %ld",(long)indexPath.row);
    NSLog(@"selected %@",[self.results objectAtIndex:indexPath.row]);
    [self handleViewDismissal];
}

#pragma UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self handleViewDismissal];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    self.results = [NSMutableArray new];
    [self.collectionView setHidden:YES];
    [self.activity startAnimating];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    
    [_placesClient autocompleteQuery:searchText
                              bounds:nil
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                [self.activity stopAnimating];
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    self.results = [NSMutableArray new];
                                    return;
                                }
//                                locality
//                                sublocality
//                                postal_code
//                                country
//                                administrative_area_level_1
//                                administrative_area_level_2
                                [self.collectionView reloadData];
                                [self.collectionView setHidden:NO];
                                for (GMSAutocompletePrediction* result in results) {
                                    for(NSString *val in result.types){
                                        if ([val isEqualToString:@"locality"]) {
                                            NSLog(@"Result '%@' with placeID %@", result.attributedPrimaryText.string, result.placeID);
                                            [self.results addObject:result.attributedPrimaryText.string];
                                            break;
                                        }
                                    }
                                }
                            }];
}

-(void)handleViewDismissal{
    [self.searchBar resignFirstResponder];
    [self.collectionView setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
