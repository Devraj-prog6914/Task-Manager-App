TASK MANAGER APP


📂 Project Structure (Where to find my code)

To evaluate the logic and design of this application, please focus on the lib/ directory. All the custom code I wrote for this project is organized as follows:

- Core Logic & Authentication
Path: lib/services/auth_service.dart

- User Interface (Screens)
Path: lib/screens/login_screen.dart AND ib/screens/home_screen.dart

Just like that, we have some ore folders like models, widgets, etc which together makes this app Complete

REGUARDING THE REST API 
Go-Quotes API (REST API): This is the external service this app calls to fetch the daily motivational quotes shown on the dashboard, handled via the http package to parse JSON data.
you can check the respective code in  lib/services/api_service.dart

BASIC WORKING : The app starts with a secure Google login to make sure only you can see your information. Once you're in, it automatically saves your tasks to the cloud, so you never lose them. It even pulls in a daily quote from the internet to keep you motivated while you organize your day.

*** I USED FIREBASE REAL TIME DATA BASE INSTEAD OF FIRESTORE DATABASE FOR THE CRUD OPERATIONS BECAUSE, USING FIRESTORE AND THE FIREBASE CLOUD STORAGE WE NEED THE FIREBASE BILLING PLAN..
       THAT IS THE REASON I USED FIREBSE REALTIME DATABASE  ***

THANKS & REGUARDS
Author:DEVRAJ SAMADHAN SHINDE
