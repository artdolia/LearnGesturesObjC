//
//  ADViewController.m
//  L23_gestures
//
//  Created by A D on 1/11/14.
//  Copyright (c) 2014 AD. All rights reserved.
//

#import "ADViewController.h"

//#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface ADViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIImageView *testView;
@property (assign, nonatomic) CGFloat testViewScale;
@property (assign, nonatomic) CGFloat testViewRotation;

@end

@implementation ADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"Left_most.png"];
    
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    [view setFrame:CGRectMake(100, 100, 200,200)];
    //view.backgroundColor = [UIColor Color];
    [self.view addSubview:view];
    self.testView = view;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];

    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    pinchGesture.delegate = self;
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self.view addGestureRecognizer:rotationGesture];
    
    rotationGesture.delegate = self;
    
   

}


#pragma mark - Gestures Handlers -

-(void) handleRotation:(UIRotationGestureRecognizer*) rotationGesture{
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewRotation = 0;
    }
    
    CGFloat newRotaion = rotationGesture.rotation - self.testViewRotation;
    
    CGAffineTransform currentRotaion = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentRotaion, newRotaion);
    
    self.testView.transform = newTransform;
    self.testViewRotation = rotationGesture.rotation;
}


-(void) handlePinch:(UIPinchGestureRecognizer *) pinchGesture{
    
    if(pinchGesture.state == UIGestureRecognizerStateBegan){
        
        self.testViewScale = 1.f;
    }
    
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.testViewScale;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.testView.transform = newTransform;
    self.testViewScale = pinchGesture.scale;
    
    
}

-(void) handleDoubleTap:(UITapGestureRecognizer*) doubleTap{
    
    NSLog(@"TwoFingerDoubleTap");
    
    [self.testView.layer removeAllAnimations];

}


-(void) handleRightSwipe:(UISwipeGestureRecognizer *) swipeRightGesture{
    
    NSLog(@"handleRightSwipe");
    
    [self animateWithRotationDegree: M_PI *2];
}


-(void) handleLeftSwipe:(UISwipeGestureRecognizer *) swipeLeftGesture{
     NSLog(@"handleLeftSwipe");
    
    [self animateWithRotationDegree:M_PI *-2];
}


-(void) handleTap:(UITapGestureRecognizer*) tapGesture{
    
    CGPoint destination = [tapGesture locationInView:self.view];
    
    [UIView animateWithDuration:5.0f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         
                         self.testView.center = destination;
                         
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Animation -

-(void) animateWithRotationDegree:(CGFloat) rotationDegree{
    
    NSLog(@"AnimateRotation");
    
    //[self.testView.layer removeAllAnimations];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:rotationDegree];
    rotationAnimation.duration = 2.0;
    //rotationAnimation.cumulative = NO;
    //rotationAnimation.repeatCount = 1.f;
    
    [self.testView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    /*
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform   rotation = CGAffineTransformRotate(currentTransform, rotationDegree);
    
    [UIView animateWithDuration:5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.testView.transform = rotation;
                         
                         
                     } completion:^(BOOL finished) {
                     }];
     */
}


#pragma mark - UIGestureRecognizerDelegate -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}


@end
