# Flutter-Bloc-ToDo-App
A Flutter app for managing your personal to-do list with offline storage, elegant UI theming, and robust state management using Bloc and Hive.

## Features

- **Task List:** Add, edit, search, complete, and delete tasks—simple productivity that works offline.
- **Filter & Search:** Instantly filter all, active, or completed tasks. Search your task list on the fly.
- **Animated UX:** Enjoy animated transitions and undo actions for deletes.
- **Theme Switching:** Toggle between light and dark modes; your theme preference is remembered.
- **Offline Persistence:** All your tasks and app settings are stored locally with Hive.
- **Undo Support:** Dismiss tasks with swipe-to-delete and easy undo via snackbar.
- **Modern UI:** Features a gradient AppBar, Material 3 widgets, and a responsive layout.

## Setup Instructions
1. Clone the repo:
git clone <your-repo-link>
cd todo_app
2. Install dependencies:
flutter pub get
3. Run the app:
flutter run


## Tech Stack

- **Flutter SDK:** 3.24.5 (or compatible 3.x)
- **State Management:** flutter_bloc (Bloc & Cubit)
- **Persistence:** Hive (NoSQL local storage)
- **UI Theme:** Material 3, supports dynamic theme switching

## State Management Explanation

- **Bloc Pattern:**  
All task changes (add, edit, toggle, delete) happen by dispatching events to a Bloc, which owns the business logic. State updates are emitted immutably, triggering UI rebuilds. This leads to clean code, easy scalability, robust error handling, and makes the app ready for new features like cloud sync.

- **Theme Management:**  
ThemeCubit persists the choice in Hive and lets users toggle dark/light mode with a tap.

## Known Issues / Limitations

- **No Cloud Sync:** Tasks are stored only locally; if you uninstall, your data is lost.
- **Single Device:** There’s no backup/restore or syncing between devices.
- **Task Simplicity:** The app is intentionally lean
- **No Push Notifications:** Only local storage, no task reminders.

## Download APK

APK : [Your APK download link here]

## Screenshots

### **1. Home Page, Add Task Box, Add Task**
<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/a0844fc7-fdd1-4b2c-bcc4-83e49c757d9b" alt="Home Page" width="250"/>
      <br><b>Home Page</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/9f082a18-4fd1-44b1-ba0f-4e0e97847d77" alt="Add Task Box" width="250"/>
      <br><b>Add Task Box</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/8890c643-0633-47a5-b857-526b56e3b871" alt="Add Task" width="250"/>
      <br><b>Add Task</b>
    </td>
  </tr>
</table
  
---

### **2. All, Active, Completed**
<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/d4b83a63-0620-4551-9490-d5038d4ff044" alt="All Tasks" width="250"/>
      <br><b>All Tasks</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/29c9cacd-02d1-4805-9636-d788a395f042" alt="Active Tasks" width="250"/>
      <br><b>Active Tasks</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/a45d56c7-0dbe-4a3a-8c0d-917fd3cc9580" alt="Completed Tasks" width="250"/>
      <br><b>Completed Tasks</b>
    </td>
  </tr>
</table>

---

### **3. Edit Task, Search, No Tasks**
<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/874f2462-7ace-42c0-8fba-fe9b4553f455" alt="Edit Task" width="250"/>
      <br><b>Edit Task</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/fb0e3d7c-e534-442c-83c6-2f21b087fa49" alt="Search" width="250"/>
      <br><b>Search</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/cd48c1c8-ed19-4c79-8073-c54a43277c1e" alt="No Tasks" width="250"/>
      <br><b>No Tasks</b>
    </td>
  </tr>
</table>

---

### **4. Dark Theme, Light Theme**
<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/d8c245b0-9d6e-42ef-ad23-7343ecd38c92"  alt="Dark Theme" width="250"/>
      <br><b>Dark Theme</b>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/ce5a1c3b-6082-4452-9d45-0b9536df1cec" alt="Light Theme" width="250"/>
      <br><b>Light Theme</b>
    </td>
  </tr>
</table>

---
