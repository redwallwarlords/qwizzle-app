//
//  QWZViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZViewController.h"

#import "QWZQuiz.h"
#import "QWZQuizSet.h"
#import "QWZAnsweredQuizSet.h"
#import "QWZCreateViewController.h"
#import "QWZAnswerViewController.h"
#import "QWZViewAnswerViewController.h"

@interface QWZViewController ()

@end

@implementation QWZViewController

// The designated initializer
- (id)init
{
    // Call the superclass's designated initializer
    // There are two options: UITableViewStylePlain and UITableViewStyleGrouped
    // Krissada; We are forcing to use the grouped style here
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    // Is the superclass's designated initializer succeed?
    if (self) {
        
        // Initialize the 2 quiz sets here
        allQuizSets = [[NSMutableArray alloc] init];
        allAnsweredQuizSets = [[NSMutableArray alloc] init];
        
        // Add hard-coded question set here
        QWZQuiz *q1 = [[QWZQuiz alloc] initWithQuestion:@"What is your name?"];
        QWZQuiz *q2 = [[QWZQuiz alloc] initWithQuestion:@"What is your lastname?"];
        QWZQuiz *q3 = [[QWZQuiz alloc] initWithQuestion:@"What is your favourite color?" answer:@"Green"];
        
        QWZQuizSet *qs1 = [[QWZQuizSet alloc] initWithTitle:@"Identity Quiz Set"];
        [qs1 addQuiz:q1];
        [qs1 addQuiz:q2];
        
        QWZQuizSet *qs2 = [[QWZQuizSet alloc] initWithTitle:@"Identity Quiz Set 2"];
        [qs2 addQuiz:q1];
        
        QWZAnsweredQuizSet *aqs1 = [[QWZAnsweredQuizSet alloc] initWithTitle:@"Favourite Quiz Set"];
        [aqs1 addQuiz:q3];
        
        [allQuizSets addObject:qs1];
        [allQuizSets addObject:qs2];
        [allAnsweredQuizSets addObject:aqs1];
        
        // Every viewcontroller has this navigationItem property
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Qwizzle"];
        
        // Create a new bar button item that will send addNewItem: to QWZViewController
        // UIBarButtonSystemItemAdd is the default + button
        // UIBarButtonSystemItemCompose is the default compose button
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                             target:self
                                                                             action:@selector(addNewQuiz:)];
        
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    // Call the designated initializer
    return [self init];
}

// Krissada: addNewQuiz will swtich to QWZCreateViewController
- (IBAction)addNewQuiz:(id)sender
{
    // Create the QWZCreateViewController
    QWZCreateViewController *createViewController = [[QWZCreateViewController alloc] init];
    
    // Krissada: Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:createViewController animated:YES];
}

#pragma mark - Default App's Behavior
// Krissada: implement this method if there is anything needed to be configured before the view is loaded for the first time
- (void)viewDidLoad
{
    [super viewDidLoad];
}

// Krissada: implement this method if there is anything needed to be configure before the view appear on-screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

// Krissada: implement this method if there is anything needed to be done if receive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle table view datasource
// Krissada: One of the required method needed to be implemented to use UITableViewController
// return a cell given index
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *QWizzleCellIdentifier = @"QWizzleCell";
    
    // Check for a reusable cell first, use that if it exists
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:QWizzleCellIdentifier];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:QWizzleCellIdentifier];
    }
    
    // Set the text on the cell with the desciption of the item that is at the nth index of items,
    // where n = row this cell will appear in on the tableView
    // Krissada: we need to get the cell from the correct section here
    NSInteger section = [indexPath section];
    if (section == 0) { 
        QWZQuizSet *qs = [allQuizSets objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
    }
    else {
        QWZAnsweredQuizSet *qs = [allAnsweredQuizSets objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[qs title]];
    }
    
    return cell;
}

// Krissada: One of the required method needed to be implemented to use UITableViewController
// return the number rows given a section number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Krissada: we need to get the correct number associated with the given section here
    NSInteger row = 0;
    if (section == 0) {
        row = [allQuizSets count];
    }
    else {
        row = [allAnsweredQuizSets count];
    }

    // Return the number of rows in the section.
    return row;
}

#pragma mark handling multiple section
// The table view needs to know how many sections it should expect.
// Krissada: we have exactly 2 sections here - an unanswer set and an answered quiz set
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Krissada: we have to get the correct title for each section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Your Qwizzle";
    }
    else {
        return @"Answered Qwizzle";
    }
}

#pragma mark - Table view delegate
// Krissada: Implement this method to response when the user is tapping any row
// Basically it should switch to another view and load all the corresponding information
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSInteger section = [indexPath section];
    if (section == 0) {
        QWZAnswerViewController *answerViewController = [[QWZAnswerViewController alloc] init];
        
        QWZQuizSet *qs = [allQuizSets objectAtIndex:[indexPath row]];

        // Give detail view controller a pointer to the item object in row
        [answerViewController setQuizSet:qs];
        
        // Push QWZAnswerViewController onto the top of the navigation controller's stack
        [[self navigationController] pushViewController:answerViewController animated:YES];
    }
    else {
        QWZViewAnswerViewController *viewAnswerViewController = [[QWZViewAnswerViewController alloc] init];
        
        QWZQuizSet *qs = [allAnsweredQuizSets objectAtIndex:[indexPath row]];
        
        // Give detail view controller a pointer to the item object in row
        [viewAnswerViewController setQuizSet:qs];
        
        // Push QWZViewAnswerViewController onto the top of the navigation controller's stack
        [[self navigationController] pushViewController:viewAnswerViewController animated:YES];
    }
}

@end
