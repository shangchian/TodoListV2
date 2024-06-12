# Task Management App

A new Flutter project Requirements:

1. User Interface

	Home Screen:
		V	Display upcoming and overdue tasks.
		V	Include a quick access button for adding a new task.
		V	Provide a search bar for tasks.
	Task List:
		V   Organize tasks by categories (e.g., Work, Personal).
		V	Implement sorting options (due date, priority, creation date).
		V	Provide filtering options (completed, overdue, high priority).
	Task Detail:
		V	Allow viewing and editing of task details.
		V	Enable marking tasks as complete/incomplete.

2. Task Management

    Create Task:
        V   Include fields for title (required), description (optional), due date and time, priority (low, medium, high), category/tag, and subtasks.
    Edit Task:
        V   Allow modification of any task attribute.
    Delete Task:
        V   Implement soft delete with an undo option.

**Bonus:**

1. Notifications and Reminders

    ?   Implement push notifications for reminders based on due date/time.

2. User Experience Features

	V	Implement swipe gestures for quick actions (e.g., mark as complete, delete).
    V   Support both light and dark themes.

3. User Authentication

	V   Implement email and password authentication.
	V   Include third-party authentication (Google).


# Project Structure (MVVM)

- 'lib/' : root.

	- 'core/' : Core module including data models and services.

	- 'model/' : Defines data models.

			· 'task.dart' : Task data model.

			· 'user.dart' : User data model.
			
	- 'service/' : Defines services.

			· 'firebase_realtime_database_service.dart' : Firebase Realtime Database service.

			· 'google_signin_service.dart' : Google Sign-In service, The GoogleSigninService class handles Google Sign-In and Sign-Out functionalities using the google_sign_in package.

	- 'generated/' : Auto-generated code directory.

	- 'l10n/' : Localization related files.

	- 'router/' : Router configuration.

			· 'app_router.dart' : Application router configuration, The AppRouter class configures the app's routes using the auto_route package.

			· 'app_router.gr.dart' : Generated router file.

	- 'ui/' : User interface module.

	- 'view/' : Defines views.

			· 'base_view.dart' : The BaseView class is a generic stateful widget that provides a base structure for other views. It includes a ChangeNotifierProvider for the view model and handles the initialization of the view model.

			· 'home_view.dart' : The HomeView class is a stateless widget that builds the home screen. It uses the BaseView class to manage the view model and includes UI elements like an AppBar, a ListView for displaying tasks, and floating action buttons for sorting and adding tasks.

			· 'login_view.dart' : The LoginView class is a stateless widget that builds the login screen. It uses the BaseView class to manage the view model and includes a button for Google Sign-In.

	- 'viewmodel/' : View models.

			· 'base_view_model.dart' : BaseViewModel is a base view model class that extends ChangeNotifier. It includes:

				  1. An instance of GlobalViewModel for global state management.  

				  2. Management of the view model state.

				  3. In the dispose method, _disposed is set to true, and the notifyListeners method is overridden to ensure that listeners are notified only when the object has not been disposed.

				  4. The setBusy method is used to set the busy state and notify listeners.

				  5. The initViewModel method is used to initialize the view model.

	  	    · 'global_view_model.dart' : GlobalViewModel extends ChangeNotifier and manages global state.

			· 'home_view_model.dart' : HomeViewModel extends BaseViewModel and manages the state and logic of the home view.

	  		      1. Various TextEditingController and ValueNotifier for managing input and selection states.  

	  		      2. Data and methods for dropdown menu options.

	  		      3. Logic for handling logout, sorting tasks, adding tasks, editing tasks, and deleting tasks.

	  		      4. Methods for writing, updating, and deleting tasks from the Firebase database.

	  		      5. Method for displaying a date picker.

			· 'login_view_model.dart' : LoginViewModel extends BaseViewModel and manages the state and logic of the login view.

	- 'firebase_options.dart' : Firebase options configuration file.

	- 'locator.dart' : The file uses the get_it package for dependency injection, setting up lazy singletons for various view models and services.

	- 'main.dart' : Application entry point, that initializes the Flutter app, including Firebase and the service locator.

	- 'firebase.json' : Firebase configuration file.

	- 'pubspec.yaml' : Project configuration file including dependencies.


# Installation and Configuration
##Prerequisites
	Flutter SDK: 3.22.2
	
	
# License

This project is licensed under the ShangChianLiu License.

