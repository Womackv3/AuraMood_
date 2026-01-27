"use client";

import { useState, useEffect } from "react";
import { Cloud, Moon, Droplets } from "lucide-react";

interface WeatherData {
  tempF: number;
  cloudCoverPct: number;
  rainMm: number;
  moonPhase: string;
}

export default function WeatherSync() {
  const [weather, setWeather] = useState<WeatherData | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchWeather = async () => {
    setLoading(true);
    setError(null);

    if (!navigator.geolocation) {
      setError("Geolocation is not supported by your browser");
      setLoading(false);
      return;
    }

    navigator.geolocation.getCurrentPosition(
      async (position) => {
        try {
          const { latitude, longitude } = position.coords;

          // TODO: Call API endpoint instead of direct fetch
          const response = await fetch(
            `/api/weather?lat=${latitude}&lon=${longitude}`
          );

          if (!response.ok) {
            const errorData = await response.json().catch(() => ({}));
            console.error("Weather API error:", response.status, errorData);
            throw new Error(errorData.error || "Failed to fetch weather data");
          }

          const data = await response.json();
          setWeather(data);
        } catch (err) {
          setError("Failed to fetch weather data");
          console.error(err);
        } finally {
          setLoading(false);
        }
      },
      (err) => {
        setError("Unable to retrieve your location");
        setLoading(false);
        console.error(err);
      }
    );
  };

  useEffect(() => {
    // Optionally auto-fetch on mount
    // fetchWeather();
  }, []);

  return (
    <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-4 sm:p-5 md:p-6 shadow-glass border border-aura-purple/20">
      <h2 className="text-lg sm:text-xl font-bold text-white mb-3 sm:mb-4">Environmental Context</h2>

      {loading ? (
        <div className="space-y-3 sm:space-y-4 animate-pulse">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-2 sm:space-x-3">
              <div className="w-5 h-5 sm:w-6 sm:h-6 bg-aura-slate-700 rounded-full"></div>
              <div className="space-y-2">
                <div className="h-3 w-16 bg-aura-slate-700 rounded"></div>
                <div className="h-4 w-12 bg-aura-slate-700 rounded"></div>
              </div>
            </div>

            <div className="flex items-center space-x-2 sm:space-x-3">
              <div className="text-right space-y-2">
                <div className="h-3 w-16 bg-aura-slate-700 rounded ml-auto"></div>
                <div className="h-4 w-8 bg-aura-slate-700 rounded ml-auto"></div>
              </div>
            </div>
          </div>

          <div className="flex items-center space-x-2 sm:space-x-3 pt-3 sm:pt-4 border-t border-aura-purple/20">
            <div className="w-5 h-5 sm:w-6 sm:h-6 bg-aura-slate-700 rounded-full"></div>
            <div className="space-y-2">
              <div className="h-3 w-16 bg-aura-slate-700 rounded"></div>
              <div className="h-4 w-24 bg-aura-slate-700 rounded"></div>
            </div>
          </div>
        </div>
      ) : weather ? (
        <div className="space-y-3 sm:space-y-4">
          <div className="grid grid-cols-2 gap-3 sm:gap-4">
            <div className="flex items-center space-x-2 sm:space-x-3">
              <Cloud className="w-5 h-5 sm:w-6 sm:h-6 text-aura-purple-light" />
              <div>
                <p className="text-xs sm:text-sm text-gray-400">Temperature</p>
                <p className="text-base sm:text-lg font-semibold text-white">
                  {weather.tempF.toFixed(1)}°F
                </p>
              </div>
            </div>

            <div className="flex items-center space-x-2 sm:space-x-3">
              <Droplets className="w-5 h-5 sm:w-6 sm:h-6 text-cyan-400" />
              <div>
                <p className="text-xs sm:text-sm text-gray-400">Rainfall</p>
                <p className="text-base sm:text-lg font-semibold text-white">
                  {weather.rainMm.toFixed(1)} mm
                </p>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3 sm:gap-4 pt-3 sm:pt-4 border-t border-aura-purple/20">
            <div className="flex items-center space-x-2 sm:space-x-3">
              <Cloud className="w-5 h-5 sm:w-6 sm:h-6 text-gray-400" />
              <div>
                <p className="text-xs sm:text-sm text-gray-400">Cloud Cover</p>
                <p className="text-base sm:text-lg font-semibold text-white">
                  {weather.cloudCoverPct}%
                </p>
              </div>
            </div>

            <div className="flex items-center space-x-2 sm:space-x-3">
              <Moon className="w-5 h-5 sm:w-6 sm:h-6 text-aura-purple-light" />
              <div>
                <p className="text-xs sm:text-sm text-gray-400">Moon Phase</p>
                <p className="text-base sm:text-lg font-semibold text-white">{weather.moonPhase}</p>
              </div>
            </div>
          </div>
        </div>
      ) : (
        <div className="text-center py-3 sm:py-4">
          <p className="text-gray-400 text-xs sm:text-sm mb-3 sm:mb-4 px-2">
            Weather data correlates mood with environmental factors
          </p>
          <button
            onClick={fetchWeather}
            disabled={loading}
            className="px-5 sm:px-6 py-2 sm:py-2.5 bg-aura-purple hover:bg-aura-purple-dark active:bg-aura-purple-darker transition-colors rounded-lg font-semibold text-sm sm:text-base text-white disabled:opacity-50 active:scale-98 touch-manipulation"
          >
            Sync Weather
          </button>
          {error && <p className="text-red-400 text-xs sm:text-sm mt-2">{error}</p>}
        </div>
      )}
    </div>
  );
}
