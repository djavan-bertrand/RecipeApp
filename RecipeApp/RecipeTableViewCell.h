//
//  RecipeTableViewCell.h
//  RecipeApp
//
//  Created by Djavan Bertrand on 14/03/2015.
//
//

#import <UIKit/UIKit.h>
#import "RecipeObject.h"

@interface RecipeTableViewCell : UITableViewCell <RecipeObjectThumbnailDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIImageView *thumbnail;

@property (nonatomic, strong) RecipeObject *recipeObject;

@end
