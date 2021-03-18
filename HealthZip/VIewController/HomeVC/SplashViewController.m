//
//  SplashViewController.m
//  HamroInstitute
//
//  Created by RaHuL on 03/09/14.
//  Copyright (c) 2014 TriState. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeVC.h"
#import "LoginVC.h"
#import "MFSideMenu.h"
#import "ImageCollectionViewCell.h"
@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(goHomeVC)
                                   userInfo:nil
                                    repeats:NO];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goHomeVC{
    
    LoginVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    if ([[USERDEFAULTS valueForKey:IsLogin] integerValue]) {
        //[self.navigationController pushViewController:homeVC animated:YES];
        [self menuCreate];
    }
    else{
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}
-(void)menuCreate{
    HomeVC *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    UIViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    MFSideMenuContainerViewController *container = [self.storyboard instantiateViewControllerWithIdentifier:@"MFSideMenuContainerViewController"];
    container.leftMenuWidth=[self designConstratin];
    [container setLeftMenuViewController:menuVC];
    UINavigationController *navControllerOfMfMenu=[[UINavigationController alloc] init];
    navControllerOfMfMenu.navigationBarHidden=YES;
    [navControllerOfMfMenu setViewControllers:[NSArray arrayWithObject:homeVC] animated:YES];
    [container setCenterViewController:navControllerOfMfMenu];
    [self.navigationController pushViewController:container animated:NO];
}
-(NSInteger)designConstratin{
    
    if (IS_IPHONE_4_OR_LESS)
    {
        return 220;
    }
    else if(IS_IPHONE_5)
    {
        return 220;
    }
    else if(IS_IPHONE_6)
    {
        return 220;
    }
    else
    {
        return 220;
    }
}
#pragma -mark UICollectionView Method

-(void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.imageCV setPagingEnabled:YES];
    [self.imageCV setCollectionViewLayout:flowLayout];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    cell.imgViewPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.arrayImages objectAtIndex:indexPath.row]]];
    for (UIView *viewIntro in cell.arrViewScreen ) {
        if (viewIntro.tag == indexPath.row) {
            viewIntro.hidden = NO;
        }else{
            viewIntro.hidden = YES;
        }
    }
    if (IS_IPHONE_4_OR_LESS) {
        [cell.imgViewPic setContentMode:UIViewContentModeScaleToFill];
    }
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.imageCV.frame.size;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 0) {
        if (scrollView.zoomScale == scrollView.minimumZoomScale) {
            int page = scrollView.contentOffset.x/self.view.bounds.size.width;
            self.pageControl.currentPage = page;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.imageCV) {
        CGPoint currentCellOffset = self.imageCV.contentOffset;
        float width = self.view.bounds.size.width * (self.arrayImages.count - 2);
        if (width < currentCellOffset.x) {
            CATransition *animation = [CATransition animation];
            animation.delegate = self;
            animation.duration = 0.4f;
            animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
           
            animation.type = kCATransitionFade;
           
            [self.navigationController.view.layer addAnimation:animation forKey:nil];
           
              LoginVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
             [self.navigationController pushViewController:loginVC animated:NO];
            
        }
    }
}
@end
