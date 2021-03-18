//
//  Animation.m
//  HealthZip
//
//  Created by Tristate on 6/3/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "Animation.h"

@implementation Animation



-(void)showAnimation
{
    
    //fadeIn And FadeOut Animation
    
    
    //[btnForgetPassword setAlpha:0.0f];
    //fade in
    //[UIView animateWithDuration:2.0f animations:^{
//        
//        [btnForgetPassword setAlpha:1.0f];
//        
//    } completion:^(BOOL finished) {
//        
        //       // fade out
        //                [UIView animateWithDuration:2.0f animations:^{
        //
        //                    [txtUsenrName setAlpha:0.0f];
        //
        //                } completion:nil];
//    }];
//    btnLogin.layer.cornerRadius=3.0;
//    btnForgetPasswordSubmit.layer.cornerRadius=3.0;
//    btnForgetPasswordCancel.layer.cornerRadius=3.0;
    
    
    //    btnLogin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    //
    //    //[self.view addSubview:popUp];
    //
    //    [UIView animateWithDuration:0.3/1.5 animations:^{
    //        btnLogin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    //    } completion:^(BOOL finished) {
    //        [UIView animateWithDuration:0.3/2 animations:^{
    //            btnLogin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    //        } completion:^(BOOL finished) {
    //            [UIView animateWithDuration:0.3/2 animations:^{
    //                btnLogin.transform = CGAffineTransformIdentity;
    //            }];
    //        }];
    //    }];
    
    
    
    
    //earthquake types animation code
    
    //    CABasicAnimation *animation =
    //    [CABasicAnimation animationWithKeyPath:@"position"];
    //    [animation setDuration:0.05];
    //    [animation setRepeatCount:8];
    //    [animation setAutoreverses:YES];
    //    [animation setFromValue:[NSValue valueWithCGPoint:
    //                             CGPointMake([btnLogin center].x - 20.0f, [btnLogin center].y)]];
    //    [animation setToValue:[NSValue valueWithCGPoint:
    //                           CGPointMake([btnLogin center].x + 20.0f, [btnLogin center].y)]];
    //    [[btnLogin layer] addAnimation:animation forKey:@"position"];
    
    //
    //    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    //    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //    animation.duration = 1.0;
    //    [animation setRepeatCount:3];
    //    animation.values = @[ @(-40), @(40), @(-30), @(30), @(-20), @(20), @(-10), @(10), @(0) ];
    //    [btnLogin.layer addAnimation:animation forKey:@"shake"];
    //
    //[self earthquake:btnLogin];
}



//- (void)earthquake:(UIView*)itemView
//{
//    CGFloat t = 2.0;
//    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
//    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
//
//    itemView.transform = leftQuake;  // starting point
//
//    [UIView beginAnimations:@"earthquake" context:(__bridge void * _Nullable)(itemView)];
//    [UIView setAnimationRepeatAutoreverses:YES]; // important
//    [UIView setAnimationRepeatCount:6];
//    [UIView setAnimationDuration:0.1];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
//
//    itemView.transform = rightQuake; // end here & auto-reverse
//
//    [UIView commitAnimations];
//}
//
//- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
//{
//    if ([finished boolValue])
//    {
//        UIView* item = (__bridge UIView *)context;
//        item.transform = CGAffineTransformIdentity;
//    }
//}


//Gravity Effect 

//-(void)showLogoAnimation
//{
//    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//
//    UIGravityBehavior* gravityBehavior =
//    [[UIGravityBehavior alloc] initWithItems:@[self.imgLogo]];
//    gravityBehavior.gravityDirection =CGVectorMake(-0.5,-0.01);
//    // gravityBehavior.angle =-0.05;
//    [self.animator addBehavior:gravityBehavior];
//
//    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.imgLogo, obstacle1, obstacle2, obstacle3]];
//    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
//    [collisionBehavior addBoundaryWithIdentifier:@"tabbar"
//                                       fromPoint:self.tabBarController.tabBar.frame.origin
//                                         toPoint:CGPointMake(self.tabBarController.tabBar.frame.origin.x + self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.origin.y)];
//    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
//    collisionBehavior.collisionDelegate = self;
//    [self.animator addBehavior:collisionBehavior];
//
//
//    [self.animator addBehavior:collisionBehavior];
//
//    UIDynamicItemBehavior *elasticityBehavior =
//    [[UIDynamicItemBehavior alloc] initWithItems:@[self.imgLogo]];
//    elasticityBehavior.elasticity = 0.9;
//    [self.animator addBehavior:elasticityBehavior];
//}



//Ball Bounce Effect

//-(void)playWithBall{
//
//    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//
//    UIGravityBehavior* gravityBehavior =
//    [[UIGravityBehavior alloc] initWithItems:@[self.imgLogo]];
//    gravityBehavior.gravityDirection =CGVectorMake(0.0,1.0);
//     gravityBehavior.angle =0.05;
//    [self.animator addBehavior:gravityBehavior];
//
//    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.imgLogo, self.lblName]];
//    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
////    [collisionBehavior addBoundaryWithIdentifier:@"tabbar"
////                                       fromPoint:CGPointMake(0,500)
////                                         toPoint:CGPointMake(0,0)];
////    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
//    collisionBehavior.collisionDelegate = self;
//    [self.animator addBehavior:collisionBehavior];
//
//
//    [self.animator addBehavior:collisionBehavior];
//
//
//
//    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.imgLogo]];
//    ballBehavior.elasticity = 0.9;
//    ballBehavior.resistance = 0.0;
//    ballBehavior.friction = 0.0;
//    ballBehavior.allowsRotation = YES;
//    [self.animator addBehavior:ballBehavior];
//
//
//    UIDynamicItemBehavior *obstacle3Behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.lblName]];
//    obstacle3Behavior.allowsRotation = NO;
//    [self.animator addBehavior:obstacle3Behavior];
//
//}


//Collision Method
//-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item1 withItem:(id)item2 atPoint:(CGPoint)p{
//    
//    //    if (item1 == self.orangeBall && item2 == self.paddle) {
//    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.lblName] mode:UIPushBehaviorModeInstantaneous];
//    pushBehavior.angle = 0.0;
//    pushBehavior.magnitude = -2.0;
//    [self.animator addBehavior:pushBehavior];
//    //}
//}


//
//-(void)waterEffect
//{
//    CATransition *animation=[CATransition animation];
//    [animation setDelegate:self];
//    [animation setDuration:1.75];
//    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
//    [animation setType:@"rippleEffect"];
//    
//    [animation setFillMode:kCAFillModeRemoved];
//    animation.endProgress=0.99;
//    [animation setRemovedOnCompletion:NO];
//    [self.view.layer addAnimation:animation forKey:nil];
//}



@end
