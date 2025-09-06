# News Reader App

A clean, modern, and intuitive news application built with Flutter. It allows users to browse top headlines by category, search for articles, and read news with seamless offline support.

## Features

*   **Categorized News:** Browse top headlines across various categories like World, Politics, Business, Technology, and more.
*   **Powerful Search:** Instantly search for any news topic or keyword.
*   **Offline First Caching:** Articles are cached locally using Hive, so you can read them even without an internet connection.
*   **Clean & Modern UI:** A simple, intuitive, and user-friendly interface designed for a great reading experience.
*   **Article Details:** View full article details and read the complete story on the source's website.
*   **Offline Mode Indicator:** The app clearly indicates when it's displaying offline content.
*   **Pull to Refresh:** Easily refresh the news feed with the latest articles.

## Screenshots

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/ff19a07d-050c-459c-a9f7-08ddc73d487b" alt="Home Screen" width="250">
      <br>
      <sub><b>Home Screen (All News)</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/a7dc20c8-1bea-4dee-9f15-1d54e1c4e110" alt="Category Browsing" width="250">
      <br>
      <sub><b>Category Browsing (Technology)</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/32fe3849-ef8d-4bda-b948-c81ceb194321" alt="Search Screen" width="250">
      <br>
      <sub><b>Search Screen (Initial State)</b></sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/24d4f5e5-a722-44e2-a27b-e704f8004ef2" alt="Search Results" width="250">
      <br>
      <sub><b>Search Results</b></sub>
    </td>
  </tr>
</table>

## App Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern to create a clear separation of concerns, making the app scalable and easy to maintain.

*   **Model:** Represents the data and business logic. The `News` class in `models/news_model.dart` is the data model for a news article.
*   **View:** The UI of the application. These are the widgets that the user interacts with, such as `HomeScreen`, `NewsDetailScreen`, and `SearchScreen`. The View's responsibility is to display data from the ViewModel and pass user actions to it.
*   **ViewModel:** Acts as a bridge between the Model and the View. `NewsViewModel` in `viewmodels/news_viewmodel.dart` fetches data from the `NewsService`, manages the application's state (like `isLoading`, `articles`, `errorMessage`), and exposes it to the View.

## Project Structure

The project's structure is organized to be clean and scalable. The `lib` directory contains all the Dart code, divided as follows:

```
news_reader_app/
└── lib/
    ├── controllers/
    │   └── news_controller.dart
    ├── models/
    │   ├── news_model.dart
    │   └── news_model.g.dart
    ├── services/
    │   ├── connectivity_service.dart
    │   ├── news_service.dart
    │   └── storage_service.dart
    ├── viewmodels/
    │   └── news_viewmodel.dart
    ├── views/
    │   ├── home_screen.dart
    │   ├── news_detail_screen.dart
    │   └── search_screen.dart
    ├── widgets/
    │   ├── news_card.dart
    │   └── search_result_card.dart
    └── main.dart
```

*   **`controllers`**: Contains the logic that connects the services to the view models.
*   **`models`**: Contains the data model classes, like `News`, and the auto-generated files for data serialization (e.g., for Hive).
*   **`services`**: Handles external operations like fetching data from an API (`news_service.dart`), managing local storage (`storage_service.dart`), and checking network status (`connectivity_service.dart`).
*   **`viewmodels`**: Manages the state and business logic for the views.
*   **`views`**: Contains the UI screens of the application.
*   **`widgets`**: Holds reusable UI components that are used across multiple screens.
*   **`main.dart`**: The entry point of the application.

## Dependencies Used

| Plugin | Description |
| --- | --- |
| **`provider`** | For state management. |
| **`http`** | For making HTTP requests to the News API. |
| **`hive`** / **`hive_flutter`**| A lightweight and fast NoSQL database for local storage and caching. |
| **`connectivity_plus`** | To check the device's network connectivity status. |
| **`flutter_dotenv`** | To securely manage environment variables like API keys. |
| **`url_launcher`** | To launch URLs, enabling users to read the full article. |

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: [Flutter installation guide](https://flutter.dev/docs/get-started/install)
*   A code editor like VS Code or Android Studio.

### API Key Setup

1.  This project uses the [News API](https://newsapi.org/) to fetch news articles. You need to get a free API key from their website.
2.  In the root directory of the project, create a file named `.env`.
3.  Add your API key to this file as follows:
    ```
    NEWS_API_KEY=your_api_key_here
    ```

### How to Run the App

1.  Clone the repository:
    ```sh
    git clone https://github.com/Aranav8/News-Reader-App.git
    ```
2.  Navigate to the project directory:
    ```sh
    cd News-Reader-App
    ```
3.  Install the dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the app:
    ```sh
    flutter run
    ```
