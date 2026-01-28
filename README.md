# AuraMood (Flutter Port)

A privacy-first, cyberpunk-themed mood tracker for individuals with bipolar disorder.

> **Note**: This branch (`flutter-port`) contains the Flutter rewrite of the application. The original Next.js web application code can be found on the `main` branch.

## Project Structure

- **`aura_mood_flutter/`**: The complete Flutter application code.
- **`Helper.md`**: The "brain" document defining the tech stack, schema, and design principles.

## Getting Started

1.  **Prerequisites**: Ensure you have Flutter installed.
2.  **Navigate to project**:
    ```bash
    cd aura_mood_flutter
    ```
3.  **Run**:
    ```bash
    flutter run
    ```

## Features

-   **Mood Tracking**: 1-10 slider + Anxiety/Irritability metrics.
-   **Medication Adherence**: Daily checklist with local notifications.
-   **Weather Correlation**: Automatically logs weather context using Open-Meteo.
-   **Analytics**: Dual-axis charts (Mood vs Sleep).
-   **Data**: 100% Local (SQLite/Drift).
