# Clarity Finance - Full-Stack Finance Tracker 📊💸

 


A modern, cross-platform personal finance tracker built with a powerful **.NET 8 API backend** and a beautiful, creative **Flutter frontend**. This full-stack application provides a seamless and secure experience for managing income and expenses, complete with a stunning visual dashboard.

This project demonstrates a complete end-to-end development cycle, from database design and secure API creation to building a polished, feature-rich mobile application.

---

## ✨ Features

*   **Secure Authentication:** Full user registration and JWT-based login system.
*   **Creative Dashboard:** An at-a-glance summary of total income, expenses, and current balance.
*   **Expense Breakdown:** An animated, interactive pie chart visually representing spending by category.
*   **Full CRUD Operations:**
    *   **C**reate new income or expense transactions.
    *   **R**ead a real-time list of all your transactions.
    *   **D**elete transactions with an intuitive swipe-to-delete gesture and confirmation.
*   **State Management:** Built with Riverpod for a robust, scalable, and testable state management architecture.
*   **Modern UI/UX:** A custom theme with professional fonts, a clean color palette, and smooth animations for a premium user experience.

---

## 🛠️ Technology Stack

This project leverages a modern, professional technology stack to deliver a high-performance and maintainable application.

### **Backend (.NET 8)**
*   **.NET 8 Web API:** For building a fast, secure, and scalable RESTful API.
*   **C#:** The language of choice for robust, object-oriented backend logic.
*   **Entity Framework Core 8:** Code-First approach for database modeling and migrations.
*   **MySQL:** The relational database for storing all application data.
*   **JWT (JSON Web Tokens):** For stateless, secure user authentication and authorization.
*   **Repository Pattern & DTOs:** Following best practices for clean, separated concerns.

### **Frontend (Flutter)**
*   **Flutter 3:** For building a beautiful, natively compiled application for mobile from a single codebase.
*   **Dart:** The modern, client-optimized language for Flutter development.
*   **Riverpod:** For a powerful and predictable state management solution.
*   **`http`:** For communicating with the .NET REST API.
*   **`flutter_secure_storage`:** For securely persisting the user's JWT token on the device.
*   **`fl_chart`:** For creating beautiful and animated charts.
*   **`intl`:** For professional date and currency formatting.

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### **Prerequisites**

*   [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
*   [Flutter SDK](https://flutter.dev/docs/get-started/install)
*   A running instance of [MySQL](https://dev.mysql.com/downloads/installer/) (or use a tool like [XAMPP](https://www.apachefriends.org/index.html)).
*   An IDE like [Visual Studio Code](https://code.visualstudio.com/).
*   An Android Emulator or a physical device.

### **Backend Setup**

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/HamzaAbuAmrea9/your-repo-name.git
    cd your-repo-name/backend
    ```
2.  **Create the Database:**
    *   In your MySQL instance, create a new, empty database named `financetracker_db`.
3.  **Configure the Connection:**
    *   Open `appsettings.json`.
    *   Update the `DefaultConnection` string with your MySQL username and password.
    *   Update the `AppSettings:Token` with your own long, secret key for JWT signing.
4.  **Run Migrations:**
    *   This will create all the necessary tables in your database.
    ```bash
    dotnet ef database update
    ```
5.  **Run the Backend:**
    ```bash
    dotnet run
    ```
    The API will now be running, typically on `https://localhost:7014` and `http://localhost:5146`.

### **Frontend Setup**

1.  **Navigate to the frontend directory:**
    ```bash
    cd ../frontend 
    ```
2.  **Get Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Configure the API URL:**
    *   Open `lib/api/api_service.dart`.
    *   Find the `_baseUrl` constant.
    *   If using an Android Emulator, the address `http://10.0.2.2:5146` or `https://10.0.2.2:7014` should work.
    *   If using a physical device, replace `10.0.2.2` with your computer's local IPv4 address (find it with `ipconfig` or `ifconfig`).
4.  **Run the App:**
    ```bash
    flutter run
    ```

---

## 🎨 Creative Showcase

*(This is a great place to add screenshots or a GIF of your app in action!)*

| Login Screen | Dashboard | Add Transaction |
| :---: | :---: | :---: |
|  |  |  |

---

## 👤 Author

**Hamza AbuAmrea**
*   GitHub: [@HamzaAbuAmrea9](https://github.com/HamzaAbuAmrea9)
*   LinkedIn: (https://www.linkedin.com/in/hamza-awad-51a076311/)

---

