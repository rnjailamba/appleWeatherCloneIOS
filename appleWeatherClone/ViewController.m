//
//  ViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 16/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "ViewController.h"
#import "PageContentViewController.h"
#import "PageViewController.h"
#import "CollectionViewController.h"


@interface ViewController () < UIPageViewControllerDataSource >

- (IBAction)startAppleWeatherApp:(id)sender;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) NSMutableArray *placeImages;

@property (nonatomic) NSInteger currentIndex;
- (IBAction)stackClicked:(id)sender;
- (IBAction)refreshClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    self.view.frame  = [[ UIScreen mainScreen ] bounds];
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

    [self fetchDataFromNSUser];
    [self setUpPageViewController];
}

-(void)setUpPageViewController{
    // Create page view controller
    self.pageViewController =  [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                    options:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.0f]     forKey:UIPageViewControllerOptionInterPageSpacingKey]];
    
    _pageViewController.dataSource = self;
    
    self.pageViewController.dataSource = self;
    if(self.customStartPage != 0){
        
    }
    else{
        self.customStartPage = 0;
    }
    PageContentViewController *startingViewController = [self viewControllerAtIndex:self.customStartPage];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 45);
    [self performSelectorOnMainThread:@selector(showTheView) withObject:nil waitUntilDone:NO];
}

-(void)fetchDataFromNSUser{
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"firstTime"] == nil ||
        ([[NSUserDefaults standardUserDefaults] stringForKey:@"firstTime"] != nil && [[NSUserDefaults standardUserDefaults] arrayForKey:@"places"].count == 0) ){
        _placeImages = [NSMutableArray arrayWithArray:@[ @"clear.jpg", @"cold.jpg",@"beach1.jpg",@"beach2.jpg",@"clear1.jpg",@"clear2.jpg",@"clear3.jpg",@"flower1.jpg",@"rain1.jpg",@"road1.jpg",@"sun1.jpg",@"sun2.jpg"]];
        NSString *valueToSave = @"true";
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"firstTime"];
        NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:@[@"Houston",@"Frankfurt",@"Tokyo",@"Hamburg"]];
        [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"places"];
        [[NSUserDefaults standardUserDefaults] setObject:_placeImages forKey:@"placeImages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    _places = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
    _placeImages = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"placeImages"]];
}

- (void)cacheUpdated:(NSNotification *)notification {
    NSLog(@"notification recieved %@",notification.object);
}


-(void)showTheView{
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startAppleWeatherApp:(id)sender {
    if(self.currentIndex != 0){
        PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.places count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.places count] == 0) || (index >= [self.places count])) {
        return nil;
    }
    self.currentIndex = index;

    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [[PageContentViewController alloc]initWithNibName:@"PageContentViewController" bundle:nil];
    pageContentViewController.imageFile = self.placeImages[index%[self.placeImages count]];
    pageContentViewController.titleText = [self.places objectAtIndex:index];
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.places count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.currentIndex;
}


- (IBAction)stackClicked:(id)sender {
    CollectionViewController *collectionVC = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    [self presentViewController:collectionVC animated:YES completion:nil];
    [self shuffle];
    [[NSUserDefaults standardUserDefaults] setObject:_placeImages forKey:@"placeImages"];

}

- (IBAction)refreshClicked:(id)sender {
    
    for(NSString *place in self.places){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@",place,@"tempName"]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@%@",place,@"temp"]];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self viewDidLoad];
}

- (void)shuffle
{
    NSUInteger count = [self.placeImages count];
    if (count < 1) return;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.placeImages exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
