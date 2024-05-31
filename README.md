# Book Review App

Welcome to the Book Review App, a platform where users can submit and view reviews for books and their adaptations. This application uses Flutter for the front-end, Firebase for the backend, and provides functionalities such as user authentication, book and adaptation ratings, and user profiles.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Features

- **User Authentication**: Secure login and registration using Firebase Authentication.
- **Book and Adaptation Reviews**: Submit reviews for books and their adaptations, with separate ratings for source material, adaptation, and similarity.
- **User Profiles**: View and update user profiles with name, bio, and recent reviews.
- **Highest Ratings and All Titles**: View books with the highest ratings in different categories and browse all titles alphabetically.
- **Real-time Updates**: Reviews and ratings update in real-time using Firebase Firestore.

## Installation

### Prerequisites

- Flutter installed on your machine. [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase account with a project set up for the app. [Firebase Console](https://console.firebase.google.com/)

### Steps

1. **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/book-review-app.git
    cd book-review-app
    ```

2. **Install dependencies**:
    ```bash
    flutter pub get
    ```

3. **Set up Firebase**:
    - Follow the instructions to add your Firebase project's `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) to the respective directories in your Flutter project. [Adding Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup)

4. **Run the app**:
    ```bash
    flutter run
    ```

## Usage

### Home Screen

The home screen has a bottom navigation bar with two options:
- **Highest Ratings**: Displays three rows of books with the highest ratings for source material, adaptation, and similarity. Each row is horizontally scrollable.
- **All Titles**: Displays a vertically scrollable list of all book titles sorted alphabetically.

### Review Screen

- **Book and Adaptation Details**: View detailed information about the book and its adaptation.
- **Submit Review**: Click the "Submit a Review" button to rate and review the book or adaptation.
- **User Reviews**: See user reviews with ratings and comments.

### Profile Screen

- **User Information**: View and edit your name and bio.
- **Logout**: Log out of your account.

## Contributing

We welcome contributions from the community. To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- **Flutter**: For providing a powerful and flexible framework for building the app.
- **Firebase**: For backend services including authentication, Firestore, and hosting.
- **Contributors**: Thanks to all the developers who have contributed to this project.

## SRS Document

For a detailed overview of the project requirements, features, and design, please refer to the [Software Requirements Specification (SRS) document](https://docs.google.com/document/d/1-ZD0TjwSVjeA4IaR8TRrTIpWuhZtXMDG1h5DzjM9jgk/edit?usp=sharing).

---
