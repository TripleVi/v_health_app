# vHealth

The project is about health and fitness monitoring with the aim of changing people's exercise habits and making their fitness journey exciting and enjoyable. The app tracks users' daily activities and provides insights into their fitness progress. It allows users to record fitness activities and make recording social, fostering connections between exercisers and building a fitness community.

Changes people's fitness habits.
Helps people track their fitness progress.
Make fitness tracking social.
Motivate them to exercise, spend more time exercising.

Therefore, if users want to track their daily activities while also sharing stories about their fitness journey and keeping track of others' progress, they will need to install and use two separate apps. Users might find it time-consuming and inconvenient to switch between multiple apps. Therefore, integrating both two parts into one system ensures that users receive comprehensive support for their fitness journey without the hassle of using multiple applications.
Regarding the photo capturing feature, current apps like Strava only allow users to attach photos to activity posts after finishing recording. However, the system allows users to take photos while recording, and those are pinned on the map at the location where the user took them. It enhances user experience and provides additional useful geographic information.
## Table of Contents

## Tech Stacks
Frontend: Flutter, Firebase

Backend: ExpressJS, Neo4j

## Key Features

- Authentication

You can log in or sign up to the system using Google.

| Login | Available widgets/libraries | Sign up |
|----------------|-----------------------------|-----|
| <div style="width: 250px; height: 400px; background: url('./images/login.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/login2.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/signup2.png') top / cover;"></div> |

- Activity Feed

The public fitness activities of people the user is following are shown up on their activity feed.  Activities are prioritized for display according to the earliest time. The system does not show posts that the user has already viewed.
Moreover, users can react to and comment on any public post

| | |
|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/feed.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/feed2.png') top / cover;"></div> |

Users tap a post to view its statistics. The first section is the summary of the workout including some fitness metrics. The second section is the route that person took. The third section includes 2 spline charts showing changes in speed and pace over time.

| | |
|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/activity_stats.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/activity_stats2.png') top / cover;"></div> |

Users tap the activity’s map snapshot to view details of the route taken. There are 3 buttons at the top right corner of the map. The first button is to move to the geographical coordinate of the route. The second button is to view photos the user took while exercising. The third button is to show or hide the photos on the map

| | |
|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/route_details.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/route_details2.png') top / cover;"></div> |

Users can tap a photo marker to view the whole photo. The small location button on each photo is to move to the photo’s geographical coordinate. Users can delete any photo

| | |
|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/route_photos.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/route_photos2.png') top / cover;"></div> |

- React to posts

Users can view the list of reactions to a public post

| |
|-|
| <div style="width: 250px; height: 400px; background: url('./images/likes.png') top / cover;"></div> |

- Comment on posts

Users can comment on public posts, reply to other comments, hide replies, and view more replies.

| | |
|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/comment.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/comment2.png') top / cover;"></div> |

- Make friends

Users tap the search button to find people by their username or name. They can follow or unfollow others by tapping the “Follow” or “Unfollow” button.

| |
|-|
| <div style="width: 250px; height: 400px; background: url('./images/people_search.png') top / cover;"></div> |

- Record fitness activities

Users tap the record button to switch to the recording screen. Users can choose one of the three activities to record. They can choose one of the four target types and set a target for the workout. They tap the “START” button to start recording

| | | |
|-|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/recording.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/recording2.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/recording3.png') top / cover;"></div> |

The system records the coordinates of the route the user has taken and displays it on the map. Users tap the camera button to switch to the camera screen to take photos. Photos are pinned to the map at the location where the user took them. The user can view the workout’s metrics by tapping the button at the bottom right corner of the screen. They can tap the pause button to pause recording. They can tap the “RESUME” button to resume recording

| | | |
|-|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/recording4.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/recording5.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/recording6.png') top / cover;"></div> |

- Create activity posts

Users tap the “FINISH” button to stop recording and then switch to the post creation screen. They are required to enter some optional information. Users can decide who can view their posts by choosing post privacy. Finally, they tap the “Post” button to create the post

| | |
|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/post_creation.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/post_creation2.png') top / cover;"></div> |

- Track daily activities

The first section is statistics on daily activities including walking and running during the day. The chart on the right shows progress toward the goal. The second section is statistics on daily activities over the last 7 days and the number of days the goal was achieved. The third section includes fitness activities for users to record. The fourth section is statistics on workout time during the week.

| |
|-|
| <div style="width: 250px; height: 400px; background: url('./images/stats.png') top / cover;"></div> |

- Statistics by day, week, month, and year

Below are statistics of running and walking activities during the day. The first section shows the amount achieved compared to the goal. Users tap the backward button to view the previous day and the forward button to view the next day. There are 3 column charts that visualize the amount achieved by hour. Users tap the date button on the app bar to select a date. The date picker header displays statistics on the activities for the entire month

| | | |
|-|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/stats_day.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/stats_day2.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/stats_day3.png') top / cover;"></div> |

Below are statistics of daily activities during the week. The first section shows the amount achieved compared to the goal. Users tap the backward button to view the previous week and the forward button to view the next week. There are 3 column charts that visualize the amount achieved by day. The final section is a summary of daily activities for each day of the week

| | | |
|-|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/stats_week.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/stats_week2.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/stats_week3.png') top / cover;"></div> |

Below are statistics of daily activities during the month. The first section shows the amount achieved. Users tap the backward button to view the previous month and the forward button to view the next month. There are 3 column charts that visualize the amount achieved by day. Users tap the date button on the app bar to select a month

| | | |
|-|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/stats_month.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/stats_month2.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/stats_month3.png') top / cover;"></div> |

Below are statistics of daily activities during the year. The first section shows the amount achieved. Users tap the backward button to view the previous year and the forward button to view the next year. There are 3 column charts that visualize the amount achieved by month. Users tap the date button on the app bar to select a year

| | | |
|-|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/stats_year.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/stats_year2.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/stats_year3.png') top / cover;"></div> |

- Set goal

Users tap the settings button on the app bar to swich to this screen. They can set any indicator for their daily goals

| | |
|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/daily_goals.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/daily_goals2.png') top / cover;"></div> |

- Profile

Users tap the profile button on the bottom navigation bar to switches to this screen. They can tap the “Edit profile” button to edit profile or tap the settings button to open the settings screen

| | |
|-|-|
| <div style="width: 250px; height: 400px; background: url('./images/profile.png') top / cover;"></div> | <div style="width: 250px; height: 400px; background: url('./images/profile.png') top / cover;"></div> |


## Demo


