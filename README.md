# Workout Transferer

A simple SwiftUI based app to read workouts from a device, export them to a file, share them with another device and import it there.

There is also an option to export the routes from the workouts as .gpx files.
The routes of all selected Workouts will be saved in individual .gpx files. All these .gpx files will then be packed in one .zip container file.


## Use case

There are different use cases. For example:
- when developing an app which works with workout data, it is nice to have an easy way copy some real data to the simulator
- a friend has no Apple Watch, but would like the recorded data from a hike to store it in his/her Health app
- on a very, very long hike, you can split up recording and share each part later with everybody from the group


## How does it work?

Just start the app, read the short introduction and allow access to Health.


### Exporting workouts

You then will see the main view which will let you pick some filter and export options.
Click *Read workouts* next to see a list of the workouts matching your filter settings.
Select the workouts you want to share and press the share button in the navigation bar.

With version 1.1 there is also an option to export just the routes as `.gpx` files.
Select **Routes (.gpx)** as the menu option.


### Importing workouts

Just open any *.wotrfi* file (it stands for WOrkout TRansferer FIle) with the app. You then will see a list of the workouts stored in the file you opened.
Select the workouts you want to import and click the import button in the navigation bar.


## Screenshots

Here is the main view:

<img src="/img/01.png" width="400" alt="main view">

The list view to select workouts from which can be exported

<img src="/img/02.png" width="400" alt="list view">

Workouts to import are listed and can be selected

<img src="/img/03.png" width="400" alt="import list view">
