# Aura Mood - Bipolar Tracking App

A self-hosted, privacy-first mood and medication tracking application designed for individuals with bipolar disorder. Features a cyberpunk-inspired UI with glassmorphism effects.

## Features

- **Mood Tracking**: Track mood, anxiety, irritability, and sleep with intuitive circular sliders
- **Medication Management**: Schedule and log medication adherence
- **Trend Visualization**: View mood and sleep patterns over time with interactive charts
- **Weather Correlation**: Automatically capture environmental context (temperature, cloud cover, moon phase)
- **Self-Hosted**: Your data stays on your server
- **Push Notifications**: ntfy.sh integration for medication reminders
- **Mobile-First**: Responsive design optimized for all devices

## Tech Stack

- **Frontend**: Next.js 16 (App Router), React 19, TypeScript
- **Styling**: Tailwind CSS 4, Glassmorphism effects
- **Database**: SQLite with Prisma ORM
- **Charts**: Recharts
- **UI Components**: Lucide React icons, mz-react-round-slider
- **Notifications**: ntfy.sh
- **Deployment**: Docker & Docker Compose

## Quick Start

### Prerequisites

- Node.js 20+ (with npm)
- Docker & Docker Compose (for containerized deployment)

### Local Development

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd WellnessHelper
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Initialize database**
   ```bash
   npm run db:push
   ```

5. **Start development server**
   ```bash
   npm run dev
   ```

6. **Open browser**
   Navigate to `http://localhost:3000`

### Docker Deployment

1. **Build and run with Docker Compose**
   ```bash
   docker-compose up -d
   ```

   This will start:
   - Aura Mood app on `http://localhost:3000`
   - ntfy notification server on `http://localhost:8080`

2. **View logs**
   ```bash
   docker-compose logs -f
   ```

3. **Stop services**
   ```bash
   docker-compose down
   ```

## Database Management

- **Open Prisma Studio** (database GUI):
  ```bash
  npm run db:studio
  ```

- **Push schema changes**:
  ```bash
  npm run db:push
  ```

- **Generate Prisma Client**:
  ```bash
  npm run db:generate
  ```

## API Endpoints

### Mood Entries
- `POST /api/mood` - Create mood entry
- `GET /api/mood?limit=30` - Get mood history

### Medications
- `GET /api/medications` - List all medications
- `POST /api/medications` - Create medication
- `GET /api/medications/:id` - Get medication
- `PUT /api/medications/:id` - Update medication
- `DELETE /api/medications/:id` - Delete medication

### Medication Logs
- `GET /api/med-logs` - Get medication logs
- `POST /api/med-logs` - Log medication adherence

### Weather
- `GET /api/weather?lat={lat}&lon={lon}` - Fetch weather data

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
DATABASE_URL="file:./data/aura.db"
NODE_ENV="development"
```

### Notification Setup (ntfy)

1. Install the ntfy app on your phone
2. Subscribe to a unique topic (e.g., `my_secure_mood_topic`)
3. Configure in Settings page of the app
4. Notifications will be sent for medication reminders

## Project Structure

```
├── app/
│   ├── api/              # API routes
│   │   ├── mood/         # Mood entry endpoints
│   │   ├── medications/  # Medication CRUD
│   │   ├── med-logs/     # Adherence logging
│   │   └── weather/      # Weather data
│   ├── settings/         # Settings page
│   └── page.tsx          # Dashboard
├── components/           # React components
│   ├── MoodEntryCard.tsx
│   ├── MoodRing.tsx
│   ├── MoodChart.tsx
│   ├── MedicationList.tsx
│   ├── AddMedicationModal.tsx
│   ├── WeatherSync.tsx
│   └── ToastContainer.tsx
├── lib/                  # Utilities
│   ├── prisma.ts         # Database client
│   ├── weather.ts        # Weather API
│   └── useToast.ts       # Toast notifications
├── prisma/
│   └── schema.prisma     # Database schema
└── public/               # Static assets
```

## Database Schema

### MoodEntry
- Mood level (1-10)
- Anxiety level (1-10)
- Irritability level (1-10)
- Sleep hours
- Notes
- Timestamp
- Weather snapshot (optional)

### Medication
- Name
- Dosage
- Schedule time

### MedLog
- Medication reference
- Status (taken/missed/late)
- Timestamp

### WeatherSnapshot
- Temperature (°F)
- Cloud cover (%)
- Moon phase

## Customization

### Theme Colors

Edit `app/globals.css` to customize the color palette:

```css
--color-aura-purple: #7c3aed;
--color-aura-purple-dark: #6d28d9;
--color-aura-slate-900: #0f172a;
```

### Cyberpunk Effects

The app includes custom cyberpunk styling in `app/cyberpunk-2077.css` with:
- Glitch animations
- Clipped corners
- Neon glows

## Backup & Restore

### Backup SQLite Database

```bash
cp ./data/aura.db ./backups/aura-$(date +%Y%m%d).db
```

### Restore from Backup

```bash
cp ./backups/aura-20260127.db ./data/aura.db
```

## Development Scripts

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server
npm run lint         # Run ESLint
npm run db:push      # Push schema to database
npm run db:studio    # Open Prisma Studio
npm run db:generate  # Generate Prisma Client
npm run docker:build # Build Docker image
npm run docker:up    # Start Docker containers
```

## Privacy & Security

- **Self-hosted**: All data stored locally on your server
- **No analytics**: Zero tracking or telemetry
- **SQLite**: Simple file-based database
- **Local-first**: Works offline after initial load

## License

MIT

## Contributing

Contributions welcome! Please open an issue first to discuss proposed changes.

## Support

For issues and questions, please open a GitHub issue.
