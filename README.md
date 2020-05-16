# wire-ios-analysis
Analysis of Wire app for iOS. Final exam for Software Engineering for Mobile Applications course (Uniandes)


To run the application: 
1. Open the project wire-ios-analysis.xcodeproj
2. Click the "Run" button in Xcode

The report is divided in sections that are in the tab bar.

The sections that are going to be analyzed are:
-  About Wire -> Static Code, Dependencies and Architecture. 
-  UI/UX
-  Eventual Connectivity
-  Security
- Performance

We made a video to show how to navigate between Workflows, if needed: 
- Workflow Explanation [Youtube Video - Workflow Explanation](https://youtu.be/DHYyXXqCHrs)

It's important to take into account that as the GitHub API is being used, we need to have in mind that it's possible to make only 60 requests per hour. With that in mind, when in Dependencies section, in the About Wire part, the table with title Dependencies Info makes requests to certain libraries. Having the requests limitation, you should be careful with the number of times cells are clicked.
