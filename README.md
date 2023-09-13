# Timer & Stopwatch with API based user login demonstration

## Pre-requisites
* Flutter version 3.3.5
* Since it is a demonstration of user login using the API, other actions like user creation is not yet implemented.
* Here I uses the https://reqres.in/ for user login, which is having default user credentials
* Default Email: eve.holt@reqres.in
* Default Password: cityslicka

## Requirements
1. Timer screen implementation
   Screen should have 2 modes timer and stopwatch
   Stopwatch - start and reset
   Timer - set time and it will start to decrease in time and close on 00:00:00 and popup
2. Login Screen Implementation
   With API and handle -ve scenarios as well
   Make sure to use interceptor for header.
   Develop an app with a structured flow, emphasising code structure, including an interceptor for evaluating the architecture without API implementation.

## Development
1. Login Screen: Which is having 2 input field for email and password, and a login button. On success, user will navigate to timer screen.
2. Timer & Stopwatch Screen: Is having two tabs for timer and stopwatch
3. Single dialog box has been used for showing different messages at different places
4. Tried to implement based on the given requirement
5. Assuming that if got few more times, the application will be developed for satisfying the requirement 100%

## Future Enhancements
1. Responsive UI
2. Improve the functionality
3. Handle user creation
4. Handle the un-authenticated user
5. Perform widget & unit testing
6. Reset timer & stopwatch while navigating to another tab
