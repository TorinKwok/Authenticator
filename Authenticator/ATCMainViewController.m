//
//  ATCMainViewController.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainViewController.h"
#import "ATCTotpEntry.h"
#import "ATCOTPEntryTableCellView.h"
#import "ATCQRCodeScannerWindowController.h"

// Private Interfaces
@interface ATCMainViewController ()

// Notification Selector
- ( void ) newTotpEntryDidAdd: ( NSNotification* )_Notif;

@end // Private Interfaces

// ATCMainViewController class
@implementation ATCMainViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    #if __debug_Entries_Table__
    otpEntries_ = [ NSMutableOrderedSet orderedSetWithObjects:
          [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Facebook" userName: @"TongKuo" secret: @"uqgrz4nub4tz5zwn" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"HackerNews" userName: @"TongKuo" secret: @"gshnvjezgtcbfagh" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Evernote" userName: @"TongKuo" secret: @"uzwyuhkjvsv2lnaj" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Twitter" userName: @"@NSTongK" secret: @"6kxcnplgdk52y47m" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"Google" userName: @"contact@tong-kuo.me" secret: @"dznyivy5pcf5si64" ]
        , [ [ ATCTotpEntry alloc ] initWithServiceName: @"GitHub" userName: @"github.com/TongKuo" secret: @"3v7ptpbjedv3ivof" ]

        , nil ];
    #else
    otpEntries_ = [ NSMutableOrderedSet orderedSet ];
    #endif

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( finishScanningQRCodeOnScreen_: ) name: ATCFinishScanningQRCodeOnScreenNotif object: nil ];

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( newTotpEntryDidAdd: ) name: ATCNewTotpEntryDidAddNotif object: nil ];
    }

- ( void ) finishScanningQRCodeOnScreen_: ( NSNotification* )_Notif
    {
    NSURL* otpAuthURL = _Notif.userInfo[ kQRCodeContents ];
    if ( otpAuthURL )
        {
        NSArray* queries = [ otpAuthURL.query componentsSeparatedByString: @"&" ];
        NSMutableDictionary* queryDict = [ NSMutableDictionary dictionaryWithCapacity: queries.count ];

        for ( NSString* _Parameter in queries )
            {
            NSArray* components = [ _Parameter componentsSeparatedByString: @"=" ];
            [ queryDict addEntriesFromDictionary: @{ components.firstObject : components.lastObject } ];
            }

        NSString* issuer = queryDict[ @"issuer" ];
        NSString* secret = queryDict[ @"secret" ];

        NSMutableArray* pathComponents = [ otpAuthURL.pathComponents mutableCopy ];
        if ( [ pathComponents.firstObject isEqualToString: @"/" ] )
            [ pathComponents removeObjectAtIndex: 0 ];

        NSMutableString* accountName = [ [ pathComponents componentsJoinedByString: @"/" ] mutableCopy ];
        [ accountName replaceOccurrencesOfString: @" " withString: @"" options: 0 range: NSMakeRange( 0, accountName.length ) ];
        [ accountName replaceOccurrencesOfString: [ NSString stringWithFormat: @"%@:", issuer ] withString: @"" options: 0 range: NSMakeRange( 0, accountName.length ) ];

        #if __debug_QRCode_Scanner__
        NSLog( @"%@", otpAuthURL );
        NSLog( @"%@", queryDict );
        NSLog( @"%@", otpAuthURL.pathComponents );
        NSLog( @"%@", accountName );
        #endif

        ATCTotpEntry* newEntry = [ [ ATCTotpEntry alloc ] initWithServiceName: issuer userName: accountName secret: secret ];
        [ otpEntries_ insertObject: newEntry atIndex: 0 ];

        [ self.optEntriesTableView reloadData ];
        }
    }

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    // Update the view, if already loaded.
    }

#pragma mark - IBActions

- ( IBAction ) scanQRCodeOnScreenAction_: ( id )_Sender
    {
    if ( !QRCodeScannerWindow_ )
        QRCodeScannerWindow_ = [ [ ATCQRCodeScannerWindowController alloc ] initWithWindowNibName: @"ATCQRCodeScannerWindowController" ];

    [ [ NSNotificationCenter defaultCenter ]
        postNotificationName: ATCBeginScanningQRCodeOnScreenNotif object: self ];
    }

#pragma mark - Conforms to <NSTableViewDataSource>

- ( NSInteger ) numberOfRowsInTableView: ( NSTableView* )_TableView
    {
    return otpEntries_.count;
    }

- ( id )            tableView: ( NSTableView * )_TableView
    objectValueForTableColumn: ( NSTableColumn* )_TableColumn
                          row: ( NSInteger )_Row
    {
    return [ otpEntries_ objectAtIndex: _Row ];
    }

#pragma mark - Conforms to <NSTableViewDelegate>

- ( CGFloat ) tableView: ( NSTableView* )_TableView
            heightOfRow: ( NSInteger )_Row
    {
    return 81.f;
    }

- ( NSView* )tableView: ( NSTableView* )_TableView
    viewForTableColumn: ( NSTableColumn* )_TableColumn
                   row: ( NSInteger )_Row
    {
    ATCTotpEntryTableCellView* result = [ _TableView makeViewWithIdentifier: _TableColumn.identifier owner: self ];

    ATCTotpEntry* optEntry = [ _TableView.dataSource tableView: _TableView objectValueForTableColumn: _TableColumn row: _Row ];
    [ result setOptEntry: optEntry ];

    NSDateFormatter* dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateStyle: NSDateFormatterMediumStyle ];
    result.createdDateField.stringValue = optEntry.createdDate ? [ dateFormatter stringFromDate: optEntry.createdDate ] : @"";
    result.serviceNameField.stringValue = optEntry.serviceName.description ?: @"";
    result.userNameField.stringValue = optEntry.userName.description ?: @"";

    return result;
    }

- ( BOOL ) tableView: ( NSTableView* )_TableView
     shouldSelectRow: ( NSInteger )_Row
    {
    return NO;
    }

#pragma mark - Private Interfaces

// Notification Selector
- ( void ) newTotpEntryDidAdd: ( NSNotification* )_Notif
    {
    ATCTotpEntry* newTotpEntry = _Notif.userInfo[ kTotpEntry ];
    if ( newTotpEntry )
        {
        [ otpEntries_ insertObject: newTotpEntry atIndex: 0 ];
        [ self.optEntriesTableView reloadData ];
        }
    }

@end // ATCMainViewController class