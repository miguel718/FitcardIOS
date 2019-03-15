
/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
*/

#import "RearViewController.h"
#import "MenuCell.h"
#import "SWRevealViewController.h"
#import "Globals.h"

@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;
@synthesize vwLogout;
@synthesize vwMenuTop;
@synthesize imgNut;

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    _rearTableView.delegate = self;
    _rearTableView.dataSource = self;
    self.title = NSLocalizedString(@"Rear View", nil);
    
    UITapGestureRecognizer *openContact = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openContact:)];
    [vwMenuTop addGestureRecognizer:openContact];
    
    UITapGestureRecognizer *openLogout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLogout:)];
    [vwLogout addGestureRecognizer:openLogout];
    
    
    
    
}
-(void) openContact:(UITapGestureRecognizer *)recognizer
{
    /*ContactViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactViewController"];
    [self presentViewController:viewController animated:YES completion:nil];*/
}
-(void) openLogout:(UITapGestureRecognizer *)recognizer
{

}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;

    if (nil == cell)
    {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
	
    NSString *text = nil;
    if (row == 0)
    {
        text = @"Plan alimentario";
        UIImage *image = [UIImage imageNamed:@"ic_plan_alim.png"];
        [cell.imgMenuIcon setImage:image];
    }
    else if (row == 1)
    {
        text = @"Consulta";
        UIImage *image = [UIImage imageNamed:@"ic_consulta.png"];
        [cell.imgMenuIcon setImage:image];
    }
    else if (row == 2)
    {
        text = @"Registro Diario";
        UIImage *image = [UIImage imageNamed:@"ic_registro.png"];
        [cell.imgMenuIcon setImage:image];
    }
    else if (row == 3)
    {
        text = @"Mensajes";
        UIImage *image = [UIImage imageNamed:@"ic_chat.png"];
        [cell.imgMenuIcon setImage:image];
    }
    else if (row == 4)
    {
        text = @"Editar Perfil";
        UIImage *image = [UIImage imageNamed:@"ic_profile.png"];
        [cell.imgMenuIcon setImage:image];
    }
    cell.lblMenuTitle.text = NSLocalizedString( text,nil );
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    
    UIViewController *newFrontController = nil;

    if (row == 0)
    {
        /*PlanViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlanViewController"];
        [self presentViewController:viewController animated:YES completion:nil];*/
    }
    
    else if (row == 1)
    {
        /*AppointmentViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AppointmentViewController"];
        [self presentViewController:viewController animated:YES completion:nil];*/
    }
    else if (row == 2)
    {
        /*RequestViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RequestViewController"];
        [self presentViewController:viewController animated:YES completion:nil];*/
    }
    else if (row == 3)
    {
        /*ChatControllerViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatControllerViewController"];
        [self presentViewController:viewController animated:YES completion:nil];*/
    }
    else if (row == 4)
    {
        /*ProfileViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [self presentViewController:viewController animated:YES completion:nil];*/
    }

    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    //[revealController pushFrontViewController:navigationController animated:YES];
    
    _presentedRow = row;  // <- store the presented row
}



//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}

@end