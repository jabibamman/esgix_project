# ESGIX Project

## Introduction

This project aims to develop a social network inspired by X (formerly Twitter).

Students have access to a dedicated API shared among classes.

## API Features and Documentation

Below is the API documentation for developers.

### API Postman Documentation available here: [Postman API Documentation](https://api.postman.com/collections/30856059-ffedacd3-7733-4529-ba35-5c6308fd31ec?access_key=PMAT-01J976BQ3DB6GS3962V7CCKA9W)

> ⚠️ **Note**:
> Each student group is given an API key to communicate with the server. This helps to track potential problematic accounts.  
> If you don’t have an API key yet, please email [thomasecalle+esgix@gmail.com](mailto:thomasecalle+esgix@gmail.com), and one will be provided for your group.  
> Once you have your API key, place it in the headers of each request under the field `x-api-key`.

## API Usage and Authentication

The API documentation should be self-explanatory, but here are some additional details:

### Authentication 🔒
- In addition to the `x-api-key` in headers, certain routes require the user to be logged in.
- Once you retrieve the `token` in the login response, add it in the headers of each request as:
  `Authorization: Bearer <token>`
- For account creation, you can use the following fields:
  - `email` (required and unique)
  - `password` (required)
  - `username` (required and unique)
  - `avatar` (URL for the avatar image)

### Users 👥
- When updating a user, you can modify the following fields:
  - `username` (unique)
  - `avatar`
  - `description` (text field)

### Posts 📭
- To create a post, the following fields are available:
  - `content` (required and non-empty): Text content of the post.
  - `imageUrl`: URL of the image for the post (optional).
  - `parent`: ID of the parent post to create a comment (optional).
- To like a post:
  - The same endpoint is used for both LIKE and UNLIKE; it toggles the like status.

### Comments 💬

- Creating a comment:
  - To create a comment, use the `parent` field to specify the ID of the parent post.
- Retrieving comments for a post:
  - You can add the `parent` parameter in the query to retrieve only comments for a specific post.

## Installation and Setup

### Prerequisites
Ensure you have Flutter installed. You can download it from [Flutter's official website](https://flutter.dev/docs/get-started/install).

### Steps

1. **Clone the Repository**
   
```bash
git clone https://github.com/jabibamman/esgi_project
cd esgix_project
```

2.	**Install Dependencies**

```bash
flutter pub get
```

3.	Environment Configuration

Create a .env based on .env.example at the root of the project and fill the vars

•	Replace your_api_key_here with your provided API key.

4. Running the project

```bash
flutter run
```

## Folder Structure

The folder structure follows the BLoC (Business Logic Component) architecture pattern to separate business logic, data, and UI components.
	
-	blocs/ - Contains the BLoC files for managing the state.
    -	auth_bloc/ - Handles authentication events and states.
	
-	core/ - Houses common services, configurations, and exceptions.
    -	services/ - API services for different entities like authentication, posts, and users.
    -	exceptions/ - Custom exceptions for handling API errors.
    -	app_config.dart - Configurations, including environment setup.
    -	models/ - Data models like UserModel and PostModel.
-	screens/ - UI screens like LoginScreen.
-	theme/ - Contains theming and styling files.
    -	colors.dart - Theme color constants.
    -	text_styles.dart - Text styles used across the app.

## Additional Notes

For further customization or configuration, refer to the Flutter documentation or the [API documentation](/assets/esgix_api_doc.json) provided.

The subject is available [here](/assets/Sujet_EsgiX.md).