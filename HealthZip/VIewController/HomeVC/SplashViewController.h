//
//  SplashViewController.h
//  HamroInstitute
//
//  Created by RaHuL on 03/09/14.
//  Copyright (c) 2014 TriState. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SplashViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIPageViewControllerDelegate,UIApplicationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ivSplashScreen;
@property (weak, nonatomic) IBOutlet UIImageView *dataImageView;

@property (nonatomic) int currentIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCV;
@property (nonatomic, strong) NSMutableArray *arrayImages;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end
