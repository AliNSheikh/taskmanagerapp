# taskmanagerapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
The application includes a login interface whereby you must enter your username and password to enter the application interfac.
The main interface includes all tasks for all users
This feature was used to activate the pagination option because the number of tasks for the known user emilys is small
All tasks can be reviewed, but the user can only edit his own tasks
The user can access his tasks through the My Tasks button
User login data is saved through the shared preferences library
If the device is connected to the Internet, the data will be accessed through an Application Programming Interface (API).
After accessing the data, it is stored locally in the application's local database (sqflite), where the user can access this data when an Internet connection is not available.
Bloc <Cubit> was used as a state management for the application 
 


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
