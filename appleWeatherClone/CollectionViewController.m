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

@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WeatherBottomViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registrNib];
    self.view.frame = [[UIScreen mainScreen]bounds];
    _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];
    _pageImages = @[@"rainy.jpg", @"sunny.jpg", @"clear-compressed.jpg", @"cold-compressed.jpg"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
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
        cell.backgroundColor = [UIColor colorWithHue:drand48() saturation:0.7 brightness:0.9 alpha:1.0];
        cell.backgroundColor = [UIColor colorWithHue:drand48() saturation:0.7 brightness:0.9 alpha:1.0];
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

-(void)plusClicked:(id)sender{
    SearchViewController *searchVC = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    [self presentViewController:searchVC animated:YES completion:nil];
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
