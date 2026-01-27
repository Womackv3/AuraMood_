interface WeatherData {
  tempF: number;
  cloudCoverPct: number;
  rainMm: number;
  moonPhase: string;
}

interface OpenMeteoResponse {
  current: {
    temperature_2m: number;
    cloud_cover: number;
    precipitation: number;
  };
}

const MOON_PHASES = [
  "New Moon",
  "Waxing Crescent",
  "First Quarter",
  "Waxing Gibbous",
  "Full Moon",
  "Waning Gibbous",
  "Last Quarter",
  "Waning Crescent",
];

function getMoonPhase(date: Date = new Date()): string {
  // Simplified moon phase calculation
  // Reference new moon: January 6, 2000
  const referenceNewMoon = new Date("2000-01-06").getTime();
  const lunarCycle = 29.53059; // days
  
  const daysSinceReference = (date.getTime() - referenceNewMoon) / (1000 * 60 * 60 * 24);
  const phase = (daysSinceReference % lunarCycle) / lunarCycle;
  
  const phaseIndex = Math.floor(phase * 8);
  return MOON_PHASES[phaseIndex];
}

export async function fetchWeatherData(latitude: number, longitude: number): Promise<WeatherData> {
  try {
    const url = `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,cloud_cover,precipitation&temperature_unit=fahrenheit`;

    const response = await fetch(url);
    if (!response.ok) {
      throw new Error("Failed to fetch weather data");
    }

    const data: OpenMeteoResponse = await response.json();

    return {
      tempF: Math.round(data.current.temperature_2m),
      cloudCoverPct: data.current.cloud_cover,
      rainMm: data.current.precipitation || 0,
      moonPhase: getMoonPhase(),
    };
  } catch (error) {
    console.error("Weather fetch error:", error);
    throw error;
  }
}
