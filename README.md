# hudle_assign
# 🌤️ Flutter Weather App

A modern and clean Weather application built using **Flutter** and the **BLoC pattern**, designed to demonstrate real-world state management, API handling, and clean architecture practices.

This project was developed as part of a Flutter Developer technical task to assess understanding of BLoC, repository pattern, and production-ready app structure.

---

##  Features

### Core Features
  -   Search weather by **city name**
  -   Display:
  - City name  
  - Temperature (Celsius / Fahrenheit)
  - Weather condition (Clear, Rain, Clouds, etc.)
  - Humidity & Wind Speed
  -  Loading indicator during API calls
  -  Graceful error handling (invalid city, network issues)
  -  Data fetched using **OpenWeatherMap API**

---

### Architecture & Tech Stack
- **Flutter**
- **flutter_bloc** for state management
- **Dio** for API calls
- **Repository Pattern**
- **Clean folder structure**
  - blocs (events, states)
  - models
  - repositories
  - ui/screens
  - utils/constants

---

### UI & UX Enhancements
-  Light / Dark theme toggle
-  Fully responsive UI
-  Smooth animations and transitions
-  Weather condition based UI themes
-  Global theming using `ThemeData`

---

### Extra Features 
-  Pull to refresh weather data
-  Cache last searched weather locally
-  Toggle between Celsius & Fahrenheit
-  Search history with quick access
-  Unit tests for BLoC logic
-  Well-documented and commented code

---

## 🏗️ Architecture Overview

This application follows the **BLoC (Business Logic Component)** pattern:

- **UI Layer**  
  Handles rendering widgets and reacting to state changes.

- **BLoC Layer**  
  Contains business logic, processes events, and emits states.

- **Repository Layer**  
  Responsible for API calls and data abstraction.

This separation ensures:
- Better scalability
- Easier testing
- Clean and maintainable codebase

---

##  How I Learned BLoC

I learned BLoC by:
- Understanding the **core flow**:  
  **Event → BLoC → State → UI**
- Refactoring UI-heavy logic into BLoCs
- Practicing with small examples before implementing it in this project
- Writing unit tests to validate state transitions
- Using real API integration to understand asynchronous state handling

Implementing this weather app helped solidify concepts like:
- Event-driven architecture
- State immutability
- Error and loading state management with using bloc pattern

---

##  Setup Instructions

1. Clone the repository and run:
   ```bash
   git clone <your-repo-url>
   cd hudle_assign
   flutter run

Challenges Faced & Solutions

1. Managing API states cleanly
Solved by clearly separating loading, success, and error states in BLoC.

2. Handling invalid city names gracefully
Handled using Dio error responses and custom error states.

3. Keeping UI clean with frequent state changes
Solved using BlocBuilder and minimizing rebuilds.

4. Theme and unit toggle without breaking UI
Handled using global state and consistent state updates.


## note
All code was written after task assignment

AI tools were used only for boilerplate/reference, not logic

Focus was on understanding BLoC, not just making it work
