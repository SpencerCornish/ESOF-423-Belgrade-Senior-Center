# User Documentation

## Completed

- [x] Login
- [x] View documentation
- [x] Reset password
- [x] Clear fields on login page with cancel button
- [x] Add new member
- [x] Add new meal
- [x] Add new activity
- [x] View current users
- [x] View current meals
- [x] View current activities
- [x] View alerts
- [x] See upcoming events
- [x] Logout
- [ ] Dismiss upcoming renewals 


## Description  

This webapp was built to allow the Belgrade Senior Center to easily manage client's information and schedules.  Client's are able to schedule
meals and classes via the app, volunteers are able to /*TODO*/, and admins are able to easily compile reports and add new clients to the database.
The goal of this webapp is to make an easy to use tool for Belgrade Senior Center so they can continue providing their services to the community.  

## Installation

Go to the [webapp](https://bsc-development.firebaseapp.com/) and use away, no installation required.

## How to run

To run the webapp, simply open in your web browser of choice, and follow the directions on the site.

## How to use

When the page is loaded you must login /*TODO create a new acount to login for the first time*/, this step uses Google authentication for security. You will then be redirected to a dashboard page that will show any Alerts, upcoming events, or membership renewals that will be defined by users /*TODO for a later release*/. On the top left of every page there is a navigation bar where that links to every other page on the site.

Under the `New` tab there are links to different forms that will create a user, meal or activity and store the information in the main database when submited. The forms have built in validation so to ensure data is entered properly.

Under the `View` tab there are links to different tables that will show the information currently stored in the main database. You can also search through the users for certain names or traits.

## Add Pages

When you would like to add a new user, meal or activity you can hover over the `New` tab in the top left of the screen to select a form.  

Select which item you would like to add, and fill out the form.  Don't worry if you unsure about the format as the form will let you know if you have made a mistake.

## View Pages

To view the current users, meals, or activies you can hover over the `View` tab in the top left of the screen.  Select which category you would like to view.

You are able to search through the list by keywords, and can export the list you have searched by clicking the `CSV` button in the right top corner of the screen.

On any one of the pages, simply click on an item in the able and it will open a detailed page where the information can be edited with the click of a button.

## Formatting for `New` Forms

### User

First and last name are required, as is email and phone or cell number.  The membership date must also be filled out.

### Meal

For the meal form please ensure that the start time is before the end time.

In the meal field please list the menu for the meal.

### Activity

The activity name, instructor name, location, and capacity fields must be filled out.  Please ensure that the start time is before the end time.

For the capacity field -1 indicates there is no upper limit for the class.  0 indicates no spaces, and any number higher than zero represents that many spaces.

#

## Report a bug

Please submit a GitHub issue [here](https://github.com/SpencerCornish/belgrade-senior-center/issues).  
Make sure to include the browser you are using, the operating system of your device and contact info for yourself.
Here is a an [article](https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/bugreports002.html#CHDBFAEE) for how to write a good bug report, please refrence it before submitting yours.
