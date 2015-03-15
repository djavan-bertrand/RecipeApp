//
//  RecipeDetailViewController.h
//  RecipeApp
//
//  Created by Djavan Bertrand on 14/03/2015.
//
//

#import <UIKit/UIKit.h>
#import "RecipeObject.h"

@interface RecipeDetailViewController : UIViewController <RecipeObjectImageDelegate, RecipeObjectDetailDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UITextView *recipeText;

@property (nonatomic, retain) RecipeObject *recipeObject;

@end
