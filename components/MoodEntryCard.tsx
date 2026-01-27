"use client";

import { useState, useEffect } from "react";
import MoodRing from "./MoodRing";
import { useToast } from "@/lib/useToast";
import { Loader2, CheckCircle, Cloud } from "lucide-react";

export default function MoodEntryCard() {
  const [moodLevel, setMoodLevel] = useState(5);
  const [anxietyLevel, setAnxietyLevel] = useState(5);
  const [irritabilityLevel, setIrritabilityLevel] = useState(5);
  const [sleepHours, setSleepHours] = useState(7);
  const [notes, setNotes] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [captureWeather, setCaptureWeather] = useState(false);
  const { addToast } = useToast();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);

    try {
      let weatherData = null;

      // Optionally capture weather data
      if (captureWeather && navigator.geolocation) {
        try {
          const position = await new Promise<GeolocationPosition>((resolve, reject) => {
            navigator.geolocation.getCurrentPosition(resolve, reject);
          });

          const { latitude, longitude } = position.coords;
          const weatherResponse = await fetch(`/api/weather?lat=${latitude}&lon=${longitude}`);

          if (weatherResponse.ok) {
            weatherData = await weatherResponse.json();
          }
        } catch (weatherError) {
          console.warn("Failed to capture weather data:", weatherError);
          // Continue with mood entry even if weather fails
        }
      }

      const response = await fetch("/api/mood", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          moodLevel,
          anxietyLevel,
          irritabilityLevel,
          sleepHours,
          notes,
          weatherData,
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to save mood entry");
      }

      const data = await response.json();

      addToast({
        type: "success",
        message: weatherData
          ? "Mood entry saved with weather data!"
          : "Mood entry saved successfully!",
        duration: 3000,
      });

      // Reset notes after successful submission
      setNotes("");

      // Re-check period availability to update button state
      checkPeriodAvailability();

    } catch (error) {
      console.error("Error saving mood entry:", error);
      addToast({
        type: "error",
        message: "Failed to save mood entry. Please try again.",
        duration: 5000,
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  const [hasLogForPeriod, setHasLogForPeriod] = useState(false);
  const [periodLabel, setPeriodLabel] = useState("");

  useEffect(() => {
    checkPeriodAvailability();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const checkPeriodAvailability = async () => {
    try {
      const now = new Date();
      const isAM = now.getHours() < 12;
      setPeriodLabel(isAM ? "Morning" : "Evening");

      const response = await fetch("/api/mood?limit=5");
      if (response.ok) {
        const entries: any[] = await response.json();

        // Define period boundaries
        const startOfPeriod = new Date();
        startOfPeriod.setHours(isAM ? 0 : 12, 0, 0, 0);

        const endOfPeriod = new Date();
        endOfPeriod.setHours(isAM ? 12 : 23, 59, 59, 999);

        const hasEntry = entries.some((entry) => {
          const entryDate = new Date(entry.timestamp);
          return entryDate >= startOfPeriod && entryDate <= endOfPeriod;
        });

        setHasLogForPeriod(hasEntry);
      }
    } catch (error) {
      console.error("Failed to check logs:", error);
    }
  };

  return (
    <div className="space-y-3 sm:space-y-4 md:space-y-6">
      {/* Header */}
      <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-4 sm:p-5 md:p-6 shadow-glass border border-aura-purple/20">
        <h2 className="text-xl sm:text-2xl font-bold text-white">Log Your Mood</h2>
        <p className="text-gray-400 text-xs sm:text-sm mt-1">
          Tap the rings or dots to adjust your levels
        </p>
      </div>

      {/* Mood Rings Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-4">
        {/* Mood Level Ring */}
        <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-3 sm:p-4 md:p-6 shadow-glass border border-aura-purple/20 hover:border-aura-purple/40 active:border-aura-purple/60 transition-all">
          <MoodRing
            value={moodLevel}
            onChange={setMoodLevel}
            label="Mood"
            colors={[
              "#dc2626", // very low
              "#ea580c",
              "#f59e0b",
              "#eab308",
              "#84cc16",
              "#22c55e",
              "#10b981",
              "#14b8a6",
              "#06b6d4",
              "#0ea5e9", // very high
            ]}
          />
        </div>

        {/* Anxiety Level Ring */}
        <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-3 sm:p-4 md:p-6 shadow-glass border border-aura-purple/20 hover:border-aura-purple/40 active:border-aura-purple/60 transition-all">
          <MoodRing
            value={anxietyLevel}
            onChange={setAnxietyLevel}
            label="Anxiety"
            colors={[
              "#10b981", // low anxiety - green
              "#14b8a6",
              "#06b6d4",
              "#0ea5e9",
              "#3b82f6",
              "#6366f1",
              "#8b5cf6",
              "#a855f7",
              "#d946ef",
              "#ec4899", // high anxiety - pink/red
            ]}
          />
        </div>

        {/* Irritability Level Ring */}
        <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-3 sm:p-4 md:p-6 shadow-glass border border-aura-purple/20 hover:border-aura-purple/40 active:border-aura-purple/60 transition-all">
          <MoodRing
            value={irritabilityLevel}
            onChange={setIrritabilityLevel}
            label="Irritability"
            colors={[
              "#06b6d4", // low - cyan
              "#3b82f6",
              "#6366f1",
              "#8b5cf6",
              "#a855f7",
              "#d946ef",
              "#ec4899",
              "#f43f5e",
              "#ef4444",
              "#dc2626", // high - red
            ]}
          />
        </div>

        {/* Sleep Hours Ring */}
        <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-3 sm:p-4 md:p-6 shadow-glass border border-aura-purple/20 hover:border-aura-purple/40 active:border-aura-purple/60 transition-all">
          <MoodRing
            value={sleepHours}
            onChange={setSleepHours}
            label="Sleep (hours)"
            min={0}
            max={12}
            colors={[
              "#dc2626", // 0-1 hours - red
              "#ea580c",
              "#f59e0b",
              "#eab308",
              "#84cc16",
              "#22c55e",
              "#10b981",
              "#14b8a6",
              "#10b981",
              "#22c55e",
              "#84cc16",
              "#eab308",
              "#f59e0b", // 12 hours - orange (too much)
            ]}
          />
        </div>
      </div>

      {/* Notes and Submit */}
      <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-4 sm:p-5 md:p-6 shadow-glass border border-aura-purple/20">
        <form onSubmit={handleSubmit} className="space-y-3 sm:space-y-4">
          {/* Weather Capture Toggle */}
          <div className="flex items-center justify-between p-3 bg-aura-slate-800/30 rounded-lg border border-aura-purple/20">
            <div className="flex items-center gap-2">
              <Cloud className="w-4 h-4 sm:w-5 sm:h-5 text-aura-purple-light" />
              <span className="text-xs sm:text-sm text-gray-300">Capture Weather Data</span>
            </div>
            <button
              type="button"
              onClick={() => setCaptureWeather(!captureWeather)}
              className={`relative w-11 h-6 rounded-full transition-colors ${
                captureWeather ? "bg-aura-purple" : "bg-aura-slate-700"
              }`}
            >
              <span
                className={`absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full transition-transform ${
                  captureWeather ? "translate-x-5" : "translate-x-0"
                }`}
              />
            </button>
          </div>

          <div>
            <label className="block text-xs sm:text-sm font-medium text-gray-300 mb-2">
              Notes
            </label>
            <textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              rows={3}
              className="cyberpunk w-full bg-aura-slate-800 text-white focus:outline-none resize-none"
              placeholder="How are you feeling today?"
            />
          </div>

          <button
            type="submit"
            disabled={isSubmitting || hasLogForPeriod}
            className={`w-full py-3 sm:py-3.5 rounded-lg font-semibold text-sm sm:text-base text-white shadow-glass-lg transition-all touch-manipulation
              ${hasLogForPeriod
                ? "bg-green-600/80 cursor-default"
                : "bg-aura-purple hover:bg-aura-purple-dark active:bg-aura-purple-darker active:scale-98"
              } 
              disabled:opacity-80 disabled:active:scale-100`}
          >
            {isSubmitting ? (
              <span className="flex items-center justify-center gap-2">
                <Loader2 className="animate-spin h-5 w-5 text-white" />
                Saving...
              </span>
            ) : hasLogForPeriod ? (
              <span className="flex items-center justify-center gap-2">
                <CheckCircle className="w-5 h-5" />
                {periodLabel} Log Complete
              </span>
            ) : (
              "Save Entry"
            )}
          </button>
        </form>
      </div>
    </div>
  );
}
