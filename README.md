# Phone Book Flutter Application

This Flutter application is a phone book solution that allows users to manage their contacts efficiently. It provides features for creating, viewing, editing, and deleting contacts, complete with profile pictures.

## Core Features

- Create new contacts with name, surname, phone number, and photo
- List all saved contacts with search functionality
- View contact information
- Edit existing contacts
- Delete contacts

## Prerequisites

- Flutter 3.3.9
- Dart SDK

## Getting Started

1. Clone the repository:
   ```
   git clone https://github.com/emirhanbayar/phonebook_app.git
   ```

2. Navigate to the project directory:
   ```
   cd phone-book-flutter
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/`: Contains the main Dart code for the application
    - `main.dart`: Entry point of the application
    - `models/`: Data models
    - `screens/`: UI screens
    - `widgets/`: Reusable UI components
    - `services/`: API and other services
    - `utils/`: Utility functions and constants

## API Integration

This application integrates with a REST API for contact management. The base URL and API key are configured in `lib/utils/constants.dart`.

- Base URL: `http://146.59.52.68:11235/`
- API Key: Stored in `AppConstants.apiKey`

## State Management

The application uses the Provider package for state management, allowing for efficient updates of the UI when data changes. The `ContactProvider` class in `models/contact.dart` manages the contact data and API interactions.

## Image Handling

- Images are cached using the `cached_network_image` package for improved performance.
- Images are compressed before upload using the `flutter_image_compress` package to reduce data usage and improve upload speed.
- The size and quality of images are reduced during the compression process to optimize storage and transmission.
- The app supports both camera and gallery image selection for contact photos.

## Known Restrictions

Because of time constraints:

- No unit or widget tests implemented in the current version.
- App currently only supports PNG and JPG formats for contact photos.
- App could be more centralized.

## Additional Features

- The app implements pull-to-refresh functionality in the contacts list for easy updates.
- A debounce mechanism is implemented in the search functionality to optimize API calls.
- The app handles app lifecycle changes to refresh data when the app is resumed.

## Important Notes

- **Platform-Specific Limitations**: After implementing image upload optimizations, creating a user with a photo and changing a photo during edit operations are disabled on the web version and emulator. These functionalities can still be used on physical mobile devices.
