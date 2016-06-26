# iphone-2017

Official iOS application for HackIllinois. Please read this README before continuing.

# Branch Information #
This branch is supposed to contain the released version of applications. Currently this hosts a more updated version of 0.3.0-beta.

# Requirements #
The following requirements are required to develop this application.


These requirements are the newest at the time of writing.


1. Cocoapods 1.0.1
2. XCode 7.3.1 (7D1014)
3. Apple Swift version 2.2 (swiftlang-703.0.18.8 clang-703.0.31)
4. iOS 9.0 or greater


# Installation #

``` shell
$ cd /path/to/github/dir
$ pod install
$ open hackillinois-2017-ios.xcworkspace
```

Remember that you MUST open the .xcworkspace file and develop on that, rather than using the xcodeproj file.

# Usage / Contribution #
See keys.plist to insert API Keys.

When contibuting, please remember to ignore future changes to the keys.plist file

``` shell
$ cd /path/to/github/dir
$ git update-index --assume-unchanged hackillinois-2017-ios/keys.plist
```

# Features #
These are the features included in the application.


1. [Login Screen](#login-screen)
2. [Event](#event)
3. [Profile](#profile)
4. [HelpQ](#helpq)
5. [Cluehunt](#cluehunt)

---
## Login Screen ##
The default login screen, shown when the user first opens the application.
Setting up the user profile is handled here.


#### Sample JSON ####
The "roles" are definied by what permissions they have. See the [HelpQ Roles](#helpq-roles) for more details.

``` json
{
    "name": "Shotaro Ikeda",
    "barcode_number": "1234567890",
	"school": "University of Illinois at Urbana-Champaign",
	"major": "Bachelor of Science Computer Science",
	"role": "staff"
}
```

---
## Event ##
The 'Event' portion of the application, that handles event logistics such as event annoucments, schedule, and map of the local area


1. [Feed](#feed)
2. [Schedule](#schedule)
3. [Maps](#maps)

### Feed ###
The Feed portion, which handles annoucements.
All the annoucements are displayed here.


#### Sample JSON ####
Note that since locations and tags are individual items, they can be separate calls.
For locations, the "abbreviation" is shown on the Maps, while the "name" is shown everywhere else.


``` json
{
    "timestamp": 1464038000,
    "annoucements": [
	{
	    "id": 1,
	    "message": "Hacking has begun!",
	    "timestamp": 1464038000,
	    "locations": [
		{
		    "name": "Siebel",
		    "abbreviation": "Siebel",
		    "latitude": 40.113926,
		    "longitude": -88.224916
		},
		{
		    "name": "Electronic and Computer Engineering Building",
		    "abbreviation": "ECEB",
		    "latitude": 40.114828,
		    "longitude": -88.228049
		},
		{
		    "name": "Illini Union",
		    "abbreviation": "Union",
		    "latitude": 40.109395,
		    "longitude": -88.227181
		}
	    ],
	    "tags": [
			{
				"name": "General"
			}
	    ]
	}
    ]
}
```

### Schedule ###
The Schedule portion at this time of writing is hardcoded.
An API may be available by the time of release.

### Maps ###
The locations are hard coded, similar to how Locations are handed in [Feed](#feed).

---
## Profile ##
Shows the user's profile, along with a barcode they can use to obtain meals, etc.
See the [Login's Sample JSON](#login-screen) for the profile JSON.

---
## HelpQ ##
TODO: Add me

### HelpQ Roles ###
TODO: Add what roles do

---
## Cluehunt ##

Cluehunt can only played if the user authenticates over GitHub.
This may change depending on the backend features. Currently this is hosted over Firebase, so there were some comprimises made such as obtaining a server timestamp.

Most likely with the addition of our own server, this will become outdated.


1. [Clues](#clues)
2. [Scores](#scores)

#### Sample JSON ####
The score is stored along with a timestamp for an anti-cheat mechanism.
See the [Scores' Json](#Scores)


### Clues ###
Shows all clues for the Cluehunt.

#### Sample JSON ####
This only shows 2 clues, while the actual version has 10.


``` json
[
  {
    "time_released": "1455988931181",
    "release": 1,
    "qr_id": "pluto",
    "loss_per_min": -10,
    "initial_pts": 9600,
    "img_url": "https:\/\/copy.com\/SCQEuPK7rsJa2mdf",
    "img_crop": 0,
    "hint": "It's a circuit board.",
    "desc": "None",
    "clue_name": "pluto",
    "api_ver": "0.0.1"
  },
  {
    "time_released": "1455988931181",
    "release": 1,
    "qr_id": "engineering",
    "loss_per_min": -10,
    "initial_pts": 9600,
    "img_url": "https:\/\/copy.com\/huxfIHrqraueuwOf",
    "img_crop": 0,
    "hint": "Go here if you need help at Siebel.",
    "desc": "None",
    "clue_name": "engineering",
    "api_ver": "0.0.1"
  }
]
```

### Scores ###
Shows the top 20 scores users have for the cluehunt.

#### Sample JSON ####
This is based off of the user's JSON. The example only shows 1 user, but there will be multiple.


``` json
{
  "shotaroikeda": {
    "profile": {
      "username": "shotaroikeda",
      "score": 0,
      "position": 0,
      "finished_hunt": false,
      "email": "ikeda2@illinois.edu",
      "avatarUrl": "https:\/\/avatars.githubusercontent.com\/u\/9062304?v=3"
    }
  }
}
```
