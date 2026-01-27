import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const MOON_PHASES = [
  "Waxing Crescent",
  "First Quarter",
  "Waxing Gibbous",
  "Full Moon",
  "Waning Gibbous"
];

async function main() {
  console.log('🗑️  Clearing existing mood entries...');

  // Delete all existing mood entries (cascades to weather snapshots)
  await prisma.moodEntry.deleteMany({});

  console.log('✅ Database cleared!');
  console.log('📊 Creating 5 days of fake data...\n');

  const now = new Date();
  const entries = [];

  // Generate 5 days of data (AM and PM for each day)
  for (let day = 4; day >= 0; day--) {
    // AM Entry (8:00 AM)
    const amDate = new Date(now);
    amDate.setDate(now.getDate() - day);
    amDate.setHours(8, 0, 0, 0);

    const amMood = Math.floor(Math.random() * 4) + 4; // 4-7 (morning moods)
    const amAnxiety = Math.floor(Math.random() * 5) + 3; // 3-7
    const amIrritability = Math.floor(Math.random() * 4) + 2; // 2-5
    const amSleep = Math.random() * 3 + 6; // 6-9 hours

    entries.push({
      timestamp: amDate,
      moodLevel: amMood,
      anxietyLevel: amAnxiety,
      irritabilityLevel: amIrritability,
      sleepHours: parseFloat(amSleep.toFixed(1)),
      notes: `Morning check-in for day ${5 - day}. Feeling ${amMood > 6 ? 'good' : 'okay'}.`,
      weatherSnapshot: {
        create: {
          tempF: Math.random() * 20 + 50, // 50-70°F
          cloudCoverPct: Math.floor(Math.random() * 60) + 20, // 20-80%
          rainMm: Math.random() < 0.3 ? Math.random() * 5 : 0, // 30% chance of rain
          moonPhase: MOON_PHASES[day % MOON_PHASES.length],
        }
      }
    });

    // PM Entry (8:00 PM)
    const pmDate = new Date(now);
    pmDate.setDate(now.getDate() - day);
    pmDate.setHours(20, 0, 0, 0);

    const pmMood = Math.floor(Math.random() * 5) + 3; // 3-7 (evening moods, slightly lower)
    const pmAnxiety = Math.floor(Math.random() * 6) + 2; // 2-7
    const pmIrritability = Math.floor(Math.random() * 5) + 3; // 3-7
    const pmSleep = 0; // No sleep data for PM entries

    entries.push({
      timestamp: pmDate,
      moodLevel: pmMood,
      anxietyLevel: pmAnxiety,
      irritabilityLevel: pmIrritability,
      sleepHours: pmSleep,
      notes: `Evening check-in for day ${5 - day}. ${pmMood < 5 ? 'Feeling tired' : 'Doing alright'}.`,
      weatherSnapshot: {
        create: {
          tempF: Math.random() * 15 + 55, // 55-70°F (evening temps)
          cloudCoverPct: Math.floor(Math.random() * 70) + 10, // 10-80%
          rainMm: Math.random() < 0.4 ? Math.random() * 8 : 0, // 40% chance of rain
          moonPhase: MOON_PHASES[day % MOON_PHASES.length],
        }
      }
    });
  }

  // Insert all entries
  for (const entry of entries) {
    const created = await prisma.moodEntry.create({
      data: entry,
      include: {
        weatherSnapshot: true,
      }
    });

    const timeOfDay = created.timestamp.getHours() < 12 ? 'AM' : 'PM';
    console.log(`✓ Created ${timeOfDay} entry: ${created.timestamp.toLocaleDateString()} ${created.timestamp.toLocaleTimeString()} | Mood: ${created.moodLevel} | Sleep: ${created.sleepHours}h`);
  }

  console.log(`\n✨ Successfully created ${entries.length} mood entries!`);
  console.log('📈 You can now view the chart with test data.');
}

main()
  .catch((e) => {
    console.error('❌ Error seeding database:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
