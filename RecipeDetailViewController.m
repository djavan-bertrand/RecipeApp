//
//  RecipeDetailViewController.m
//  RecipeApp
//
//  Created by Djavan Bertrand on 14/03/2015.
//
//

#import "RecipeDetailViewController.h"

@implementation RecipeDetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setRecipeObject:(RecipeObject *)recipeObject {
    _recipeObject = recipeObject;
    _recipeObject.detailDelegate = self;
    _recipeObject.imageDelegate = self;
    if (!_recipeObject.recipeText) {
        [_recipeObject downloadRecipeDetail];
    }
    
    if (!_recipeObject.image) {
        [_recipeObject downloadImage];
    }
    
    [self updateLayout];
}

- (void)updateLayout {
    self.title = _recipeObject.title;
    [_recipeText setText:_recipeObject.recipeText];
    [_recipeText scrollRangeToVisible:NSMakeRange(0, 0)];
    
    if (_recipeObject.image) {
        [_activityIndicator setHidden:YES];
        [_image setHidden:NO];
        [_activityIndicator stopAnimating];
        [_image setImage:_recipeObject.image];
    } else {
        [_activityIndicator setHidden:NO];
        [_image setHidden:YES];
        [_activityIndicator startAnimating];
    }
    
}

- (void)recipeObject:(RecipeObject*)receipeObject didReceiveDetail:(NSString*)detail {
    if (_recipeObject == receipeObject) {
        [self updateLayout];
    }
}

- (void)recipeObject:(RecipeObject*)receipeObject didReceiveImage:(UIImage*)image {
    if (_recipeObject == receipeObject) {
        [self updateLayout];
    }
}

@end