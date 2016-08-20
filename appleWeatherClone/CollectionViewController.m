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


@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate,WeatherBottomViewCell1Delegate>

@property (weak, nonatomic) IBOutlet UITableView *collectionView;
@property (strong, nonatomic) NSMutableArray *pageTitles;
@property (strong, nonatomic) NSMutableArray *pageImages;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated:) name:@"placeNotification" object:nil];
    self.view.frame = [[UIScreen mainScreen]bounds];
    _pageTitles = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
    _pageImages = [NSMutableArray arrayWithArray: @[@"rainy.jpg", @"sunny.jpg", @"clear-compressed.jpg", @"cold-compressed.jpg"]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.collectionView.allowsMultipleSelectionDuringEditing = NO;
//    self.collectionView.allowsSelection = NO;
    [self registrNib];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)cacheUpdated:(NSNotification *)notification {
//    NSString *location = notification.object;
//    _pageTitles = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
//    BOOL found = NO;
//    for(NSDictionary *val in mutableArray){
//        if([[val objectForKey:@"name"] isEqualToString: location]){
//            found = YES;
//            break;
//        }
//    }
//    if(found == NO){
//        NSMutableDictionary *dict = [NSMutableDictionary new];
//        [dict setObject:location forKey:@"name"];
//        [mutableArray addObject:dict];
//        [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"places"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        _pageTitles = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
//
//
//    }
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];

    NSLog(@"notification recieved %@",notification.object);

}


-(void)refreshTableView{
    _pageTitles = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
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
    
    return [self.pageTitles count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.pageTitles count]){
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
        cell.backgroundColor = [self randomNiceColor];        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
        label.text = [[self.pageTitles objectAtIndex:indexPath.row] objectForKey:@"name"];
        [label setFont:[UIFont  systemFontOfSize:28 weight:UIFontWeightMedium]];
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 24, 100, 16)];
        timelabel.text = @"7:24 PM";
        [timelabel setFont:[UIFont  systemFontOfSize:12 weight:UIFontWeightMedium]];
        timelabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timelabel];
        
        UILabel *degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 24, 80, 56)];
        degreeLabel.text = @"23*";
        [degreeLabel setFont:[UIFont  systemFontOfSize:44 weight:UIFontWeightMedium]];
        degreeLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:degreeLabel];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == [self.pageTitles count]){
        return 200;
    }
    else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < [self.pageTitles count]){
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
        [_pageTitles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
        [mutableArray removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"places"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _pageTitles = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"places"]];
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
