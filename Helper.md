1. Project Identity: "Aura Mood"

Vibe Concept: Dark-mode by default, biometric-focused, glassmorphism UI. Unlike standard trackers, this will feel more like a "cockpit" for your mental health.
2. Technical Stack (The "Vibe-Ready" Stack)

    Frontend: Next.js (App Router) + Tailwind CSS + Lucide Icons.

    Database: SQLite (easiest for local Docker backups).

    Graphs: Recharts (best for "vibe coding" as it's highly declarative).

    Notifications: ntfy.sh (Self-hosted, open-source notification server).

    Weather: Open-Meteo API (Free, no API key required).

3. Database Schema (PostgreSQL/SQLite)

Provide this block directly to your IDE.
SQL

-- Core Mood Entry
CREATE TABLE mood_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    mood_level INTEGER CHECK (mood_level BETWEEN 1 AND 10),
    anxiety_level INTEGER,
    irritability_level INTEGER,
    sleep_hours DECIMAL(4,2),
    notes TEXT
);

-- Medication Adherence
CREATE TABLE medications (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    dosage TEXT,
    schedule_time TIME
);

CREATE TABLE med_logs (
    id UUID PRIMARY KEY,
    medication_id UUID REFERENCES medications(id),
    taken_at TIMESTAMP WITH TIME ZONE,
    status TEXT -- 'taken', 'missed', 'late'
);

-- Environmental Context
CREATE TABLE weather_snapshots (
    entry_id UUID REFERENCES mood_entries(id),
    temp_c DECIMAL,
    cloud_cover_pct INTEGER,
    moon_phase TEXT
);

4. Feature Implementation Logic
The Graph Engine (Configurable)

Use a Dual-Axis Line Chart.

    Axis A (Left): Mood Level (1 to 10).

    Axis B (Right): Sleep (0 to 12 hours).

    Overlay: Small dot-markers along the bottom X-axis representing medication "Missed" events.

Weather Syncing

The app will run a background cron job (or a simple useEffect on log-in) that calls: https://api.open-meteo.com/v1/forecast?latitude=USER_LAT&longitude=USER_LON&daily=sunrise,sunset&current_weather=true It automatically correlates your mood timestamp with the local weather at that moment.
Self-Hosted Reminders (ntfy.sh)

Instead of complex SMS gateways, your app will send a simple POST request:
Bash

curl -d "Time for your morning Lithium" ntfy.sh/your_private_topic_123

You simply install the ntfy app on your phone and subscribe to your topic. No fees, no accounts.
5. Docker Implementation (docker-compose.yml)

This allows you to "one-click" deploy your custom creation.
YAML

services:
  aura-app:
    image: node:20-alpine
    container_name: aura_mood_tracker
    ports:
      - "3000:3000"
    volumes:
      - ./data:/app/data
    environment:
      - DATABASE_PATH=/app/data/aura.db
      - NTFY_TOPIC=my_secure_mood_topic
    restart: unless-stopped

  ntfy:
    image: binwiederhier/ntfy
    command: serve
    ports:
      - "8080:80"

6. The "Master Prompt" for your IDE

Copy and paste this into Cursor or your IDE's AI chat to start the "Vibe Coding" process:

    "Act as a Senior Full-Stack Engineer. I want to build 'Aura Mood,' a self-hosted Bipolar tracker in Next.js.

    Design Vibe: Cyberpunk-Minimalist. Dark purple and slate-gray palette. Uses Tailwind glassmorphism (backdrop-blur).

    Instructions:

        Create a responsive Dashboard with a 'Mood Entry' card (1-10 slider).

        Implement a Medication Adherence list that resets daily.

        Add a Recharts Line Chart that overlays Mood (Line) and Sleep (Bar).

        Integrate Open-Meteo to automatically fetch weather data based on browser geolocation when a mood is saved.

        Create a Settings page to configure an ntfy.sh topic for medication reminders.

        Setup SQLite via Prisma or Drizzle for local persistence.

    Start by scaffolding the project structure and the docker-compose.yml file."