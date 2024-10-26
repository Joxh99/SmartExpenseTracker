#Smart Expense Tracker (Accountant)

A cross-platform mobile app built with Flutter to help users manage their expenses effectively with AI-driven categorization and gamification elements. Designed for students, professionals, and families, the app offers an intuitive interface to track spending patterns, set budgets, and earn achievements.


##Table of Contents

System Overview
Installation and Setup
Features
Contributing
Firebase Configuration
Usage
Screenshots
System Artifacts and Technical Design
Development Process


##System Overview

The Smart Expense Tracker integrates AI and gamification for a unique expense-tracking experience. The app simplifies budgeting by automating categorization, providing real-time insights, and encouraging financial discipline through achievements.


##Key Components

AI Categorization: Automatically categorizes expenses using TensorFlow Lite, helping users avoid manual entry.
Gamification: Encourages users to manage finances actively by awarding badges for milestones.
Real-Time Insights: Visualizations and insights on spending patterns enable better financial decision-making.


###Installation and Setup

#####Prerequisites

Flutter SDK: Install Flutter
Android Studio or Xcode (for iOS)
Firebase: Set up Firebase for Android and iOS platforms.

######Steps
Clone the Repository:

git clone https://github.com/Joxh99/SmartExpenseTracker.git

cd SmartExpenseTracker

Install Dependencies:
flutter pub get

Set Up Firebase:
Download google-services.json from Firebase Console and place it in android/app.
Download GoogleService-Info.plist for iOS and place it in ios/Runner.

Run the App:
flutter run


##Features

###Expense Tracking:
Track daily expenses with categories and amounts.

###Budgeting and Notifications:
Set and manage category-specific budgets and receive alerts when limits are exceeded.

###Recurring Expenses Management:
Manage recurring expenses with customizable frequencies (e.g., daily, weekly).

###AI-Driven Insights:
View spending recommendations and alerts for unusual spending patterns.

###Gamification Elements:
Earn badges for budgeting milestones and consistent tracking.

###Data Export and Reports:
Generate and export expense reports by month or category.

###User Customization:
Customize settings such as currency, notification preferences, and dark mode.


##Firebase Configuration
Ensure Firebase authentication and Firestore database are correctly set up in your Firebase Console to enable full functionality.

Android: Place google-services.json in the android/app directory.
iOS: Place GoogleService-Info.plist in the ios/Runner directory.


##Usage
Add Expenses: Navigate to the expense screen, enter details, and save.
Set Budgets: Define budgets for different categories in the settings.
Track Progress: View expense trends and earn badges as you track your spending.
Generate Reports: Access monthly and category-wise expense reports for detailed insights.


##Screenshots
Feature	Screenshot
Home Screen	
Budget Setup	
AI Insights	
Achievements	
Replace link-to-image with actual image URLs.


##System Artifacts and Technical Design

###Technical Overview:
Architecture: Implemented using Flutter with Firebase integration for storage and authentication.
Design Pattern: Follows the MVVM (Model-View-ViewModel) architecture for clear separation of concerns.
Database: Uses Firebase Firestore for storing user expense data securely.

###Artifacts:
Codebase: Refer to the repository for complete code documentation.
Designs: Mockups and designs can be accessed in the /designs folder.


##Development Process
Project Management: Managed using a Kanban board to track milestones and feature development.
Tools Used: Utilized GitHub for version control and issue tracking, Firebase for backend services, and Trello for agile task management.
Process Flow:
Planning: Initial project scoping and requirement gathering.
Development: Feature-by-feature development with thorough testing.
Testing: User acceptance and functionality tests before release.


##Contributing
Contributions are welcome! Fork the repository and create a pull request for major updates.


##License
This project is licensed under the MIT License.
