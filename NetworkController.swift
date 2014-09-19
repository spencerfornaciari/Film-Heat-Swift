//
//  NetworkController.swift
//  Film Heat
//
//  Created by Spencer Fornaciari on 9/18/14.
//  Copyright (c) 2014 Azzurri Ventures. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
    
    func rottenData () {
        let rottenString : String = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=\(kROTTEN_TOMATOES_API_KEY)"
        
        let rottenURL : NSURL = NSURL.URLWithString(rottenString)
        

        
        var rottenData : NSData = NSData.dataWithContentsOfURL(rottenURL, options: NSDataReadingOptions.DataReadingMappedAlways, error:nil)
        
        var error : NSError?
        
//        var rottenDictionary : Dictionary = NSJSONSerialization.JSONObjectWithData(rottenData, options: NSJSONReadingOptions.MutableContainers, error: &error) as Dictionary
        
//        var rottenDictionary : Dictionary = NSJSONSerialization.JSONObjectWithData(rottenData, options: NSJSONReadingOptions.MutableContainers, error: &error)
        
        
    }
    
/*

@try {
rottenDictionary = [NSJSONSerialization JSONObjectWithData:rottenData
options:NSJSONReadingMutableContainers
error:&error];
}
@catch (NSException *exception) {
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Error" message:@"The data source is currently down, try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
[alert show];
NSLog(@"API Limit Reached? %@", exception.debugDescription);
if (error) {
NSLog(@"Error: %@", error.debugDescription);
}
}

NSArray *rottenArray = [rottenDictionary objectForKey:@"movies"];

for (NSDictionary *dictionary in rottenArray) {
if ([CoreDataHelper doesFilmExist:[dictionary objectForKey:@"id"]]) {
NSLog(@"It Exists!");
} else {

Film *film = [NSEntityDescription insertNewObjectForEntityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];

//Getting ID information
film.rottenTomatoesID = [dictionary objectForKey:@"id"];

film.imdbID = [NSString stringWithFormat:@"http://www.imdb.com/title/tt%@/",[dictionary valueForKeyPath:@"alternate_ids.imdb"]];

//Set the film title
film.title = [dictionary objectForKey:@"title"];

//Set the critics rating of the film according to Rotten Tomatoes
film.criticScore = [dictionary valueForKeyPath:@"ratings.critics_score"];
film.criticRating = [dictionary valueForKeyPath:@"ratings.critics_rating"];

//Set the audience rating of the film according to Rotten Tomatoes
film.audienceScore = [dictionary valueForKeyPath:@"ratings.audience_score"];
film.audienceRating = [dictionary valueForKeyPath:@"ratings.audience_rating"];

NSInteger critics = [film.criticScore integerValue];
NSInteger audience = [film.audienceScore integerValue];
long variance = ABS(critics - audience);

film.ratingVariance = [NSNumber numberWithLong:variance];

//Grab the URL for the thumbnail of the film's poster
NSString *thumbnailString = [dictionary valueForKeyPath:@"posters.detailed"];

film.thumbnailPosterURL = [thumbnailString stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_det"];
film.thumbnailAvailable = @0;
film.posterURL = [thumbnailString stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
film.posterAvailable = @0;

//[dictionary valueForKeyPath:@"posters.original"];

//Set the film runtime
film.runtime = [dictionary valueForKeyPath:@"runtime"];

//Set the film's MPAA rating
NSString *rating = [dictionary valueForKeyPath:@"mpaa_rating"];

if (rating) {
film.mpaaRating = rating;
film.ratingValue = [self setRatingValue:film.mpaaRating];
} else {
film.mpaaRating = @"NR";
film.ratingValue = @0;
}

//Set film's release date
NSDictionary *releaseDictionary = [dictionary valueForKeyPath:@"release_dates"];
NSString *releaseDate = [releaseDictionary objectForKey:@"theater"];
NSDateFormatter *df = [[NSDateFormatter alloc] init];
[df setDateFormat:@"yyyy-MM-dd"];
film.releaseDate = [df dateFromString:releaseDate];

//Set the film's synopsis
film.synopsis = [dictionary valueForKeyPath:@"synopsis"];
film.criticalConsensus = [dictionary valueForKeyPath:@"critics_consensus"];

film.interestStatus = @0;

NSArray *castArray = [dictionary valueForKey:@"abridged_cast"];

for (NSDictionary *castMember in castArray) {
Actor *actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[CoreDataHelper managedContext]];

actor.name = [castMember valueForKey:@"name"];
NSArray *characterArray = [castMember valueForKey:@"characters"];

for (NSString *characterString in characterArray) {
Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:[CoreDataHelper managedContext]];
character.name = characterString;
[actor addNewCharacterObject:character];
}

[film addNewActorObject:actor];
}

film.findSimilarFilms = [dictionary valueForKeyPath:@"links.similar"];
}

}

[CoreDataHelper saveContext];

self.filmArray = [[CoreDataHelper findCategoryArray:@0] mutableCopy];
[self.tableView reloadData];
NSString *rottenString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=%@", kROTTEN_TOMATOES_API_KEY];

NSURL *rottenURL = [NSURL URLWithString:rottenString];

NSData *rottenData = [NSData dataWithContentsOfURL:rottenURL];

NSError *error;

NSDictionary *rottenDictionary = [NSDictionary new];


@try {
rottenDictionary = [NSJSONSerialization JSONObjectWithData:rottenData
options:NSJSONReadingMutableContainers
error:&error];
}
@catch (NSException *exception) {
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Error" message:@"The data source is currently down, try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
[alert show];
NSLog(@"API Limit Reached? %@", exception.debugDescription);
if (error) {
NSLog(@"Error: %@", error.debugDescription);
}
}

NSArray *rottenArray = [rottenDictionary objectForKey:@"movies"];

for (NSDictionary *dictionary in rottenArray) {
if ([CoreDataHelper doesFilmExist:[dictionary objectForKey:@"id"]]) {
NSLog(@"It Exists!");
} else {

Film *film = [NSEntityDescription insertNewObjectForEntityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];

//Getting ID information
film.rottenTomatoesID = [dictionary objectForKey:@"id"];

film.imdbID = [NSString stringWithFormat:@"http://www.imdb.com/title/tt%@/",[dictionary valueForKeyPath:@"alternate_ids.imdb"]];

//Set the film title
film.title = [dictionary objectForKey:@"title"];

//Set the critics rating of the film according to Rotten Tomatoes
film.criticScore = [dictionary valueForKeyPath:@"ratings.critics_score"];
film.criticRating = [dictionary valueForKeyPath:@"ratings.critics_rating"];

//Set the audience rating of the film according to Rotten Tomatoes
film.audienceScore = [dictionary valueForKeyPath:@"ratings.audience_score"];
film.audienceRating = [dictionary valueForKeyPath:@"ratings.audience_rating"];

NSInteger critics = [film.criticScore integerValue];
NSInteger audience = [film.audienceScore integerValue];
long variance = ABS(critics - audience);

film.ratingVariance = [NSNumber numberWithLong:variance];

//Grab the URL for the thumbnail of the film's poster
NSString *thumbnailString = [dictionary valueForKeyPath:@"posters.detailed"];

film.thumbnailPosterURL = [thumbnailString stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_det"];
film.thumbnailAvailable = @0;
film.posterURL = [thumbnailString stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"];
film.posterAvailable = @0;

//[dictionary valueForKeyPath:@"posters.original"];

//Set the film runtime
film.runtime = [dictionary valueForKeyPath:@"runtime"];

//Set the film's MPAA rating
NSString *rating = [dictionary valueForKeyPath:@"mpaa_rating"];

if (rating) {
film.mpaaRating = rating;
film.ratingValue = [self setRatingValue:film.mpaaRating];
} else {
film.mpaaRating = @"NR";
film.ratingValue = @0;
}

//Set film's release date
NSDictionary *releaseDictionary = [dictionary valueForKeyPath:@"release_dates"];
NSString *releaseDate = [releaseDictionary objectForKey:@"theater"];
NSDateFormatter *df = [[NSDateFormatter alloc] init];
[df setDateFormat:@"yyyy-MM-dd"];
film.releaseDate = [df dateFromString:releaseDate];

//Set the film's synopsis
film.synopsis = [dictionary valueForKeyPath:@"synopsis"];
film.criticalConsensus = [dictionary valueForKeyPath:@"critics_consensus"];

film.interestStatus = @0;

NSArray *castArray = [dictionary valueForKey:@"abridged_cast"];

for (NSDictionary *castMember in castArray) {
Actor *actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[CoreDataHelper managedContext]];

actor.name = [castMember valueForKey:@"name"];
NSArray *characterArray = [castMember valueForKey:@"characters"];

for (NSString *characterString in characterArray) {
Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:[CoreDataHelper managedContext]];
character.name = characterString;
[actor addNewCharacterObject:character];
}

[film addNewActorObject:actor];
}

film.findSimilarFilms = [dictionary valueForKeyPath:@"links.similar"];
}

}

[CoreDataHelper saveContext];

self.filmArray = [[CoreDataHelper findCategoryArray:@0] mutableCopy];
[self.tableView reloadData];
*/

}
