//
//  CollectionViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 18/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "CollectionViewController.h"
#import "WeatherBottomViewCell1.h"
#import "ViewController.h"
#import "SearchViewController.h"
#import "CurrentViewController.h"
#import <AFNetworking/AFNetworking.h>

#define open_weather_api_key @"1255ba5f70cf5adf3bd2ba9aaa7dd1dc"

@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate,WeatherBottomViewCell1Delegate>

@property (weak, nonatomic) IBOutlet UITableView *collectionView;
@property (strong, nonatomic) NSMutableArray *places;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated:) name:@"placeNotification" object:nil];
    self.view.frame = [[UIScreen mainScreen]bounds];
    _places = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
    [self tableViewSetup];
    [self registrNib];
}

-(void)tableViewSetup{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.collectionView.allowsMultipleSelectionDuringEditing = NO;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.collectionView addGestureRecognizer:longPress];
}

-(void)longPressGestureRecognized:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForRowAtPoint:location];
    NSLog(@"long pressed at %ld",(long)indexPath.row);
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.collectionView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.collectionView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Fade out.
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.row < [self.places count]) {
                
                // ... update data source.
                [self.places exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.collectionView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
                [self copyFromplaces];
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.collectionView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo fade out.
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            break;
        }
            // More coming soon...
            // More coming soon...
    }
}

// Add this at the end of your .m file. It returns a customized snapshot of a given view.
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

-(void)copyFromplaces{
    [[NSUserDefaults standardUserDefaults] setObject:self.places forKey:@"places"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)cacheUpdated:(NSNotification *)notification {
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
    NSLog(@"notification recieved %@",notification.object);
}


-(void)refreshTableView{
    _places = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
    [self.collectionView reloadData];
}

-(void)registrNib{
    [self.collectionView registerNib:[UINib nibWithNibName:@"WeatherBottomViewCell1" bundle:nil] forCellReuseIdentifier:@"WeatherBottomViewCell1"];
    [self.collectionView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"random"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.places count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.places count]){
        WeatherBottomViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherBottomViewCell1" forIndexPath:indexPath];
        cell.delegate = self;
//        cell.frame.size.width =  self.view.frame.size.width;
//        cell.bounds = CGRectMake(0, 0, self.view.frame.size.width, 200);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"random" forIndexPath:indexPath];
        NSArray* subviews = [cell.contentView subviews];
        for (UIView* subview in subviews) {
            [subview removeFromSuperview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [self randomNiceColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
        label.text = [self.places objectAtIndex:indexPath.row];
        [label setFont:[UIFont  systemFontOfSize:28 weight:UIFontWeightMedium]];
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",label.text,@"temp"]] == nil ||
           [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",label.text,@"tempName"]] == nil){
            NSDictionary *parameters = @{@"q":label.text,
                                         @"APPID":open_weather_api_key,
                                         @"units":@"metric"};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager GET:@"http://api.openweathermap.org/data/2.5/weather" parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
                
                //Get Temprature
                id obj = [responseObject objectForKey:@"main"];
                NSString *temp = [obj objectForKey:@"temp"];
                NSInteger tempInt = [temp intValue];
                
                //Get Temprature name
                id obj1 = [responseObject objectForKey:@"weather"];
                NSString *temp1 = [obj1[0] objectForKey:@"main"];
                
                //            NSLog(@"object: %@", responseObject);
                //            NSLog(@"temp: %@", temp);
                NSLog(@"place: %@", label.text);
                NSLog(@"tempname: %@", temp1);
                NSLog(@"tempInt: %ld", (long)tempInt);
                dispatch_async(dispatch_get_main_queue(), ^(){
                    UILabel *temperatureNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 24, 100, 16)];
                    temperatureNameLabel.text = temp1;
                    [temperatureNameLabel setFont:[UIFont  systemFontOfSize:12 weight:UIFontWeightMedium]];
                    temperatureNameLabel.textColor = [UIColor whiteColor];
                    [cell.contentView addSubview:temperatureNameLabel];
                    
                    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 24, 56, 56)];
                    tempLabel.text = [NSString stringWithFormat:@"%ld",(long)tempInt];
                    tempLabel.textAlignment = UITextAlignmentRight;
                    [tempLabel setFont:[UIFont  systemFontOfSize:44 weight:UIFontWeightMedium]];
                    tempLabel.textColor = [UIColor whiteColor];
                    [cell.contentView addSubview:tempLabel];
                });
                [self saveDataToNSUserTempratureName:temp1 temprature:[NSString stringWithFormat:@"%ld",(long)tempInt] forPlace:label.text];
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
        }
        else{
            UILabel *temperatureNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 24, 100, 16)];
            temperatureNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",label.text,@"tempName"]];
            [temperatureNameLabel setFont:[UIFont  systemFontOfSize:12 weight:UIFontWeightMedium]];
            temperatureNameLabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:temperatureNameLabel];

            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 24, 56, 56)];
            tempLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",label.text,@"temp"]];
            tempLabel.textAlignment = UITextAlignmentRight;
            [tempLabel setFont:[UIFont  systemFontOfSize:44 weight:UIFontWeightMedium]];
            tempLabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:tempLabel];
            
            
        }
        
        UILabel *degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-36, 20, 24, 24)];
        degreeLabel.text = @".";
        [degreeLabel setFont:[UIFont  boldSystemFontOfSize:24 ]];
        degreeLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:degreeLabel];
        
        
        return cell;
    }
    
}

-(void)saveDataToNSUserTempratureName:(NSString *)tempratureName temprature:(NSString *)temprature forPlace:(NSString *)place{
    [[NSUserDefaults standardUserDefaults] setObject:tempratureName forKey:[NSString stringWithFormat:@"%@%@",place,@"tempName"]];
    [[NSUserDefaults standardUserDefaults] setObject:temprature forKey:[NSString stringWithFormat:@"%@%@",place,@"temp"]];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == [self.places count]){
        return 200;
    }
    else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < [self.places count]){
        NSLog(@"didselect%ld",(long)indexPath.row);
        ViewController *viewC = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
        viewC.customStartPage = indexPath.row;
        [self presentViewController:viewC animated:YES completion:nil];
    }
    else{
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support deleting cell of the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_places removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
        [mutableArray removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"places"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _places = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
    }
}

#pragma WeatherBottomViewCellDelegate

-(void)plusClicked:(id)sender{
    SearchViewController *searchVC = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self presentViewController:searchVC animated:YES completion:nil];
}

-(void)currentLocationClicked:(id)sender{
    CurrentViewController *currentVC = [[CurrentViewController alloc]initWithNibName:@"CurrentViewController" bundle:nil];
    [self presentViewController:currentVC animated:YES completion:nil];
}

- (UIColor *)randomNiceColor
{
    CGFloat hue = (arc4random() % 360) / 359.0f;
    CGFloat saturation = (float)arc4random() / UINT32_MAX;
    CGFloat brightness = (float)arc4random() / UINT32_MAX;
    saturation = saturation < 0.5 ? 0.5 : saturation;
    brightness = brightness < 0.9 ? 0.9 : brightness;
    return [UIColor colorWithHue:hue
                      saturation:saturation
                      brightness:brightness
                           alpha:0.8];
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
