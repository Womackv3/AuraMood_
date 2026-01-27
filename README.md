# Aura Mood - Bipolar Tracking App

A self-hosted, privacy-first mood and medication tracking application designed for individuals with bipolar disorder. Features a cyberpunk-inspired UI, environmental correlation, and localized data storage.

## Key Features

- **100% Self-Hosted**: Your data never leaves your server (SQLite + Docker).
- **Secure Access**: Served over HTTPS via Nginx reverse proxy.
- **Privacy-First**: No analytics, no external tracking.
- **Mood & Sleep Tracking**: AM/PM entries with dual-axis visualization.
- **Medication Management**: Daily adherence checklist and inventory management.
- **Environmental Context**: Automatically captures local weather (Temp, Rain, Moon Phase) for correlation analysis.
- **Cyberpunk UI**: Glassmorphism design with responsive layouts.

## Screenshots

<img width="1297" height="1054" alt="image" src="https://github.com/user-attachments/assets/299134e0-01a1-4af8-85c2-8e488c3c535e" />

## Quick Start (Docker)

The recommended way to run Aura Mood is via Docker Compose, which handles the secure proxy and database for you.

### 1. Requirements
*   Docker Desktop installed and running.

### 2. Run the Stack
```bash
docker-compose up -d --build
```
This builds the Next.js app and starts the Nginx proxy.

### 3. Access the App
Go to: **`https://localhost/auramoods`**

> **Note**: Your browser will warn you about the "Self-Signed Certificate". This is normal for a local secure setup. Click **Advanced -> Proceed** to continue. 
> *Secure Context (HTTPS) is required for Geolocation features to work on other devices.*

---

## Configuration

### Environment Variables
The app comes pre-configured for Docker. If running locally without Docker, copy `.env.example` to `.env`:
```env
DATABASE_URL="file:./dev.db"
```

### Notification Setup (ntfy)
To receive background medication reminders:
1.  Install the **ntfy** app on your phone.
2.  Subscribe to a unique topic (e.g., `my-private-mood-topic`).
3.  In Aura Mood, go to **Settings**.
4.  Enter your Ntfy Server URL (default `https://ntfy.sh` or your self-hosted one).
5.  Enter your Topic name.
6.  Click **Test Notification**.

---

## Troubleshooting

### "SSL Error / Record too long"
*   **Cause**: You tried to access the HTTP port with HTTPS protocol (e.g., `https://localhost:3000`).
*   **Fix**: Use the Nginx entry point: **`https://localhost/auramoods`** (no port required).

### Weather Data Not Loading
*   **Cause**: Browser blocked location access.
*   **Fix**: Ensure you are using **HTTPS**. Geolocation API is blocked on insecure HTTP connections (except localhost).

### Resetting the Database
If you need to wipe all data and start fresh:
```bash
# Delete the database file (locally mapped volume)
rm prisma/dev.db

# Restart the container to regenerate it
docker-compose restart app

# Push the schema
docker exec wellness-helper npx prisma db push
```

---

## Tech Stack
*   **Frontend**: Next.js 16 (App Router), Tailwind CSS 4, Recharts.
*   **Backend**: Next.js API Routes.
*   **Database**: SQLite (via Prisma ORM).
*   **Proxy**: Nginx (handling SSL termination).
*   **Base Path**: Served under `/auramoods` for flexible deployment.

## License
MIT
