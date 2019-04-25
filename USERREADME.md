# User Documentation

## Description

This webapp was built to allow the Belgrade Senior Center to easily manage members’ information and schedules.  Members are able to sign up for activities and view meal and activity information via the app and admins are able to easily compile reports and add new members, activities, and meals to the database. The goal of this webapp is to make an easy to use tool for Belgrade Senior Center so they can continue providing their services to the community.

## Installation

Go to the [webapp](https://bsc-development.firebaseapp.com/) and use away, no installation required.

## How to run

To run the webapp, simply open in your web browser of choice, and follow the directions on the site.

## How to use

When the page is loaded you must login, this step uses Google authentication for security. You will then be redirected to a dashboard page that will show The current logged in member's time punches. On the top of every page there is a navigation bar that links to every other page on the site.

Under the `View` tab there are links to different tables that will show the information currently stored by the system. Clicking on any of these rows within said tables will allow editing and deletion of the data.

Under the `New` tab there are links to different forms that will create a member, meal or activity and store the information in the main database when submitted. The forms have built in validation to ensure data is entered properly.

## View Pages

To view the current members (and their associated shifts), meals, or activities you can hover over the `View` tab in the top left of the screen then select which category you would like to view (Admins will have the added option to view all shifts).

You are able to search through the list by keywords.

You can download all the information for what is currently displayed by clicking the `Export` button in the right top corner of the screen.

The page can be refreshed to ensure any data added while the page was open is added to the table.

On any one of the pages, simply click on the view button for a row and it will open a detailed page where the information can be edited with the click of a button accessible only to admins.

## Add Pages

To add a new member, meal or activity you can hover over the `New` tab in the top left of the screen and select which item you would like to add, then fill out the form.

## Checking In

There are two ways to add a member to an activity. Both ensure that the member being added is not already checked in.

### 1) From the View Member's Page

On each row there is a `Check in` button that will redirect the member to the a check in page that looks like the View Activities page. From this page the member can click on any Activities check in button which will create a popup explaining if the check in was successful (a non-successful check in will occur if the user is already checked in for a class and will be explained in the same popup). Included in the success message will be a suggestion to try out a different class which will have a button that repeatedly checks in a user to new classes until they are done and click `Done` in the bottom of the popup.

### 2) From the Edit Activity Page

While editing an activity you can add a member by clicking the `Add` button in the middle right portion of the page (after `Edit` is clicked) this creates a popup that will show all members not currently checked in for this activity.

## Required Fields

### User

- First and Last name
- Email
- Phone or Cell number
- Membership date Start and End

### Meal

- Start time
- End time
- Menu

### Activity

- Name
- Instructor name
- Location
- Capacity
- Start time
- End time.

## Report a bug

Please submit a GitHub issue [here](https://github.com/SpencerCornish/belgrade-senior-center/issues).
Make sure to include the browser you are using, the operating system of your device and contact info for yourself.
Here is a an [article](https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/bugreports002.html#CHDBFAEE) for how to write a good bug report, please reference it before submitting yours.