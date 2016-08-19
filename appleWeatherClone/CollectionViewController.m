//
//  CollectionViewController.m
//  appleWeatherClone
//
//  Created by Mr Ruby on 18/08/16.
//  Copyright © 2016 Rnjai Lamba. All rights reserved.
//

#import "CollectionViewController.h"
#import "WeatherBottomViewCell.h"
#import "ViewController.h"
#import "SearchViewController.h"
#import "CurrentViewController.h"


@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WeatherBottomViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *pageTitles;
@property (strong, nonatomic) NSMutableArray *pageImages;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated:) name:@"placeNotification" object:nil];
    [self registrNib];
    self.view.frame = [[UIScreen mainScreen]bounds];
    _pageTitles = [NSMutableArray arrayWithArray: @[@"Houston",@"Frankfurt",@"Tokyo",@"Indore"]];
    _pageImages = [NSMutableArray arrayWithArray: @[@"rainy.jpg", @"sunny.jpg", @"clear-compressed.jpg", @"cold-compressed.jpg"]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    
    // Do any additional setup after loading the view from its nib.
}

- (void)cacheUpdated:(NSNotification *)notification {
   
    NSString *location = notification.object;
    [self.pageTitles addObject:location];
    [self.collectionView reloadData];
    NSLog(@"notification recieved %@",notification.object);

}

-(void)registrNib{
    [self.collectionView registerNib:[UINib nibWithNibName:@"WeatherBottomViewCell" bundle:nil] forCellWithReuseIdentifier:@"WeatherBottomViewCell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"random"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.pageTitles count] + 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.pageTitles count]){
        WeatherBottomViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherBottomViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
        
    }
    else{
        UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"random" forIndexPath:indexPath];
        NSArray* subviews = [cell.contentView subviews];
        for (UIView* subview in subviews) {
            [subview removeFromSuperview];
        }
        cell.backgroundColor = [UIColor colorWithHue:drand48() saturation:0.7 brightness:0.9 alpha:1.0];
        cell.backgroundColor = [UIColor colorWithHue:drand48() saturation:0.7 brightness:0.9 alpha:1.0];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
        label.text = [self.pageTitles objectAtIndex:indexPath.row];
        [label setFont:[UIFont  systemFontOfSize:28 weight:UIFontWeightMedium]];
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 24, 100, 16)];
        timelabel.text = @"7:24 PM";
        [timelabel setFont:[UIFont  systemFontOfSize:12 weight:UIFontWeightMedium]];
        timelabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:timelabel];
        
        UILabel *degreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 24, 60, 56)];
        degreeLabel.text = @"23*";
        [degreeLabel setFont:[UIFont  systemFontOfSize:35 weight:UIFontWeightMedium]];
        degreeLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:degreeLabel];
        
        return cell;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.pageTitles count]){
        return CGSizeMake(self.view.frame.size.width, 200);
    }
    else{
        return CGSizeMake(self.view.frame.size.width, 80);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [self.pageTitles count]){
        NSLog(@"didselect%ld",(long)indexPath.row);
        ViewController *viewC = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
        viewC.customStartPage = indexPath.row;
        [self presentViewController:viewC animated:YES completion:nil];
    }
    else{
        
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
