"use client";

import { useState, useEffect } from "react";
import {
  LineChart,
  Line,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  ComposedChart,
} from "recharts";
import { Loader2 } from "lucide-react";

interface MoodEntry {
  id: string;
  timestamp: string;
  moodLevel: number;
  anxietyLevel: number | null;
  irritabilityLevel: number | null;
  sleepHours: number | null;
  notes: string | null;
  weatherSnapshot?: {
    tempF: number | null;
    cloudCoverPct: number | null;
    rainMm: number | null;
    moonPhase: string | null;
  } | null;
}

interface ChartData {
  id: string; // Add ID for unique key
  date: string;
  // Split mood metrics by AM/PM
  moodAM: number | null;
  moodPM: number | null;
  anxietyAM: number | null;
  anxietyPM: number | null;
  irritabilityAM: number | null;
  irritabilityPM: number | null;
  sleepAM: number | null;
  sleepPM: number | null;
  isAM: boolean; // Track if entry is AM or PM for dot styling
  weather: string | null;
  temp: number | null;
  rain: number | null;
}

export default function MoodChart() {
  const [chartData, setChartData] = useState<ChartData[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'AM' | 'PM'>('AM');

  useEffect(() => {
    fetchMoodData();
  }, []);

  const fetchMoodData = async () => {
    try {
      // Fetch up to 3 months of data (90 days * 2 entries/day = 180)
      const response = await fetch("/auramoods/api/mood?limit=180");
      if (response.ok) {
        const moodEntries: MoodEntry[] = await response.json();

        // Group data by date
        const groupedData = new Map<string, ChartData>();

        moodEntries.forEach((entry) => {
          const date = new Date(entry.timestamp);
          const formattedDate = date.toLocaleDateString("en-US", {
            month: "short",
            day: "numeric",
          });
          // Use formatted date as key to group AM/PM same day
          const key = formattedDate;

          if (!groupedData.has(key)) {
            groupedData.set(key, {
              id: key, // Use date as ID for the x-axis
              date: formattedDate,
              moodAM: null,
              moodPM: null,
              anxietyAM: null,
              anxietyPM: null,
              irritabilityAM: null,
              irritabilityPM: null,
              sleepAM: null,
              sleepPM: null,
              isAM: false, // Not strictly needed for grouped
              weather: null,
              temp: null,
              rain: null,
            });
          }

          const dayData = groupedData.get(key)!;
          const isAM = date.getHours() < 12;
          const sleepHours = entry.sleepHours || 0;

          if (isAM) {
            dayData.moodAM = entry.moodLevel;
            dayData.anxietyAM = entry.anxietyLevel;
            dayData.irritabilityAM = entry.irritabilityLevel;
            dayData.sleepAM = sleepHours;
            // Prefer AM weather for the "day" representation if needed, or just overwrite
            if (!dayData.weather) {
              dayData.weather = entry.weatherSnapshot?.moonPhase || null;
              dayData.temp = entry.weatherSnapshot?.tempF || null;
              dayData.rain = entry.weatherSnapshot?.rainMm || null;
            }
          } else {
            dayData.moodPM = entry.moodLevel;
            dayData.anxietyPM = entry.anxietyLevel;
            dayData.irritabilityPM = entry.irritabilityLevel;
            dayData.sleepPM = sleepHours;
            // If AM weather wasn't there, take PM
            if (!dayData.weather) {
              dayData.weather = entry.weatherSnapshot?.moonPhase || null;
              dayData.temp = entry.weatherSnapshot?.tempF || null;
              dayData.rain = entry.weatherSnapshot?.rainMm || null;
            }
          }
        });

        // Convert to array and reverse to show oldest to newest (actually API returns desc, so we need reverse)
        // Wait, map iteration order is insertion order?
        // Let's just create array and sort or reverse.
        // The API returns desc (newest first). We iterate.
        // Map will allow us to merge.
        // Then we assume the order might be newest first.
        const transformed = Array.from(groupedData.values()).reverse();

        setChartData(transformed);
      }
    } catch (error) {
      console.error("Failed to fetch mood data:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const getTickLabel = (id: any) => {
    // ID is now the date string "Jan 23", so we can just return it
    // Or if we want to be safe, find the item
    const item = chartData.find((d) => d.id === id);
    return item ? item.date : id;
  };

  const getTooltipLabel = (id: any) => {
    const item = chartData.find((d) => d.id === id);
    return item ? item.date : id;
  };

  if (isLoading) {
    return (
      <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-4 sm:p-5 md:p-6 shadow-glass border border-aura-purple/20 hover:border-aura-purple/40 transition-all animate-fade-in">
        <h2 className="text-lg sm:text-xl md:text-2xl font-bold text-white mb-4 sm:mb-5 md:mb-6">Mood & Sleep Trends</h2>
        <div className="flex items-center justify-center h-64">
          <Loader2 className="w-8 h-8 text-aura-purple animate-spin" />
        </div>
      </div>
    );
  }

  if (chartData.length === 0) {
    return (
      <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-4 sm:p-5 md:p-6 shadow-glass border border-aura-purple/20 hover:border-aura-purple/40 transition-all animate-fade-in">
        <h2 className="text-lg sm:text-xl md:text-2xl font-bold text-white mb-4 sm:mb-5 md:mb-6">Mood & Sleep Trends</h2>
        <div className="flex items-center justify-center h-64 text-gray-400">
          <p className="text-center">
            No mood data yet.<br />
            <span className="text-sm">Start tracking to see your trends.</span>
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-4 sm:p-5 md:p-6 shadow-glass border border-aura-purple/20 hover:border-aura-purple/40 transition-all animate-fade-in">
      <div className="flex items-center justify-between mb-4 sm:mb-5 md:mb-6">
        <h2 className="text-lg sm:text-xl md:text-2xl font-bold text-white">Mood & Sleep Trends</h2>
        <p className="text-xs text-gray-400">Last 3 months</p>
      </div>

      {/* AM/PM Tab Switcher */}
      <div className="flex items-center justify-center gap-2 mb-4 sm:mb-5">
        <button
          onClick={() => setActiveTab('AM')}
          className={`px-6 py-2 rounded-lg font-semibold transition-all ${activeTab === 'AM'
            ? 'bg-aura-purple text-white shadow-lg shadow-aura-purple/50'
            : 'bg-slate-800 text-gray-400 hover:text-white hover:bg-slate-700'
            }`}
        >
          Morning (AM)
        </button>
        <button
          onClick={() => setActiveTab('PM')}
          className={`px-6 py-2 rounded-lg font-semibold transition-all ${activeTab === 'PM'
            ? 'bg-aura-purple text-white shadow-lg shadow-aura-purple/50'
            : 'bg-slate-800 text-gray-400 hover:text-white hover:bg-slate-700'
            }`}
        >
          Evening (PM)
        </button>
      </div>

      <ResponsiveContainer width="100%" height={300} className="sm:hidden">
        <ComposedChart data={chartData}>
          <CartesianGrid strokeDasharray="3 3" stroke="#334155" opacity={0.3} />
          <XAxis
            dataKey="id"
            stroke="#94a3b8"
            tick={{ fill: "#94a3b8", fontSize: 10 }}
            tickFormatter={getTickLabel}
            angle={-45}
            textAnchor="end"
            height={60}
            interval="preserveStartEnd"
          />
          <YAxis
            yAxisId="left"
            stroke="#7c3aed"
            tick={{ fill: "#94a3b8", fontSize: 10 }}
          />
          <YAxis
            yAxisId="right"
            orientation="right"
            stroke="#6366f1"
            tick={{ fill: "#94a3b8", fontSize: 10 }}
          />
          <Tooltip
            contentStyle={{
              backgroundColor: "#1e293b",
              border: "1px solid #7c3aed",
              borderRadius: "8px",
              fontSize: "12px",
            }}
            labelStyle={{ color: "#fff" }}
            labelFormatter={getTooltipLabel}
            formatter={(value: any, name: any) => {
              if (name.startsWith("Mood")) return [value, name];
              if (name.startsWith("Anxiety")) return [value, name];
              if (name.startsWith("Irritability")) return [value, name];
              if (name === "Sleep (AM)" || name === "Sleep (PM)") return [`${value}h`, name];
              return [value, name];
            }}
          />

          {/* Mood Lines conditionally rendered based on activeTab */}
          {activeTab === 'AM' ? (
            <>
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="moodAM"
                stroke="#7c3aed"
                strokeWidth={2}
                dot={{ fill: "#7c3aed", r: 3 }}
                connectNulls
                name="Mood"
              />
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="anxietyAM"
                stroke="#ea580c"
                strokeWidth={2}
                dot={{ fill: "#ea580c", r: 3 }}
                connectNulls
                name="Anxiety"
              />
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="irritabilityAM"
                stroke="#db2777"
                strokeWidth={2}
                dot={{ fill: "#db2777", r: 3 }}
                connectNulls
                name="Irritability"
              />
            </>
          ) : (
            <>
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="moodPM"
                stroke="#a855f7"
                strokeWidth={2}
                dot={{ fill: "#a855f7", r: 3 }}
                connectNulls
                name="Mood"
              />
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="anxietyPM"
                stroke="#f97316"
                strokeWidth={2}
                dot={{ fill: "#f97316", r: 3 }}
                connectNulls
                name="Anxiety"
              />
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="irritabilityPM"
                stroke="#f472b6"
                strokeWidth={2}
                dot={{ fill: "#f472b6", r: 3 }}
                connectNulls
                name="Irritability"
              />
            </>
          )}

          {/* Sleep Bars - AM (Cyan) - Hours 0-11 */}
          <Bar
            yAxisId="right"
            dataKey="sleepAM"
            fill="#06b6d4"
            opacity={0.6}
            name="Sleep (AM)"
          />
          {/* Sleep Bars - PM (Indigo) - Hours 12-23 */}
          <Bar
            yAxisId="right"
            dataKey="sleepPM"
            fill="#6366f1"
            opacity={0.6}
            name="Sleep (PM)"
          />
        </ComposedChart>
      </ResponsiveContainer>

      <ResponsiveContainer width="100%" height={400} className="hidden sm:block">
        <ComposedChart data={chartData}>
          <CartesianGrid strokeDasharray="3 3" stroke="#334155" opacity={0.3} />
          <XAxis
            dataKey="id"
            stroke="#94a3b8"
            tickFormatter={getTickLabel}
            tick={{ fill: "#94a3b8" }}
            interval="preserveStartEnd"
          />
          <YAxis
            yAxisId="left"
            stroke="#7c3aed"
            domain={[1, 10]}
            allowDecimals={false}
            tick={{ fill: "#94a3b8" }}
            label={{
              value: "Mood (1-10)",
              angle: -90,
              position: "insideLeft",
              fill: "#94a3b8",
            }}
          />
          <YAxis
            yAxisId="right"
            orientation="right"
            stroke="#6366f1"
            domain={[0, 12]}
            allowDecimals={false}
            tick={{ fill: "#94a3b8" }}
            label={{
              value: "Sleep (hrs)",
              angle: 90,
              position: "insideRight",
              fill: "#94a3b8",
            }}
          />
          <Tooltip
            contentStyle={{
              backgroundColor: "#1e293b",
              border: "1px solid #7c3aed",
              borderRadius: "8px",
            }}
            labelStyle={{ color: "#fff" }}
            labelFormatter={getTooltipLabel}
            formatter={(value: any, name: any) => {
              if (name.startsWith("Mood")) return [value, name];
              if (name.startsWith("Anxiety")) return [value, name];
              if (name.startsWith("Irritability")) return [value, name];
              if (name === "Sleep Hours (AM)" || name === "Sleep Hours (PM)") return [`${value}h`, name];
              return [value, name];
            }}
            // Custom content to include weather info
            content={({ active, payload, label }) => {
              if (active && payload && payload.length) {
                const data = payload[0].payload;
                return (
                  <div className="bg-aura-slate-900 border border-aura-purple/50 p-3 rounded-lg shadow-xl">
                    <p className="font-bold text-white mb-2">{label}</p>
                    {payload.map((entry: any) => (
                      <div key={entry.name} className="flex items-center gap-2 text-sm mb-1" style={{ color: entry.color }}>
                        <span className="w-2 h-2 rounded-full" style={{ backgroundColor: entry.color }}></span>
                        <span>{entry.name}: {entry.value}</span>
                      </div>
                    ))}
                    {(data.temp || data.weather || data.rain !== null) && (
                      <div className="mt-2 pt-2 border-t border-gray-700 text-xs text-gray-400">
                        {data.temp && <p>Temp: {data.temp.toFixed(1)}°F</p>}
                        {data.rain !== null && <p>Rain: {data.rain.toFixed(1)} mm</p>}
                        {data.weather && <p>Moon: {data.weather}</p>}
                      </div>
                    )}
                  </div>
                );
              }
              return null;
            }}
          />
          <Legend />

          {/* Mood Lines conditionally rendered based on activeTab */}
          {activeTab === 'AM' ? (
            <>
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="moodAM"
                stroke="#7c3aed"
                strokeWidth={3}
                dot={{ fill: "#7c3aed", r: 5 }}
                connectNulls
                name="Mood"
              />
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="anxietyAM"
                stroke="#ea580c"
                strokeWidth={2}
                dot={{ fill: "#ea580c", r: 4 }}
                connectNulls
                name="Anxiety"
              />
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="irritabilityAM"
                stroke="#db2777"
                strokeWidth={2}
                dot={{ fill: "#db2777", r: 4 }}
                connectNulls
                name="Irritability"
              />
            </>
          ) : (
            <>
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="moodPM"
                stroke="#a855f7"
                strokeWidth={3}
                dot={{ fill: "#a855f7", r: 5 }}
                connectNulls
                name="Mood"
              />
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="anxietyPM"
                stroke="#f97316"
                strokeWidth={2}
                dot={{ fill: "#f97316", r: 4 }}
                connectNulls
                name="Anxiety"
              />
              <Line
                yAxisId="left"
                type="monotone"
                dataKey="irritabilityPM"
                stroke="#f472b6"
                strokeWidth={2}
                dot={{ fill: "#f472b6", r: 4 }}
                connectNulls
                name="Irritability"
              />
            </>
          )}

          {/* Sleep Bars - AM */}
          <Bar
            yAxisId="right"
            dataKey="sleepAM"
            fill="#06b6d4"
            opacity={0.6}
            name="Sleep Hours (AM)"
          />
          {/* Sleep Bars - PM */}
          <Bar
            yAxisId="right"
            dataKey="sleepPM"
            fill="#6366f1"
            opacity={0.6}
            name="Sleep Hours (PM)"
          />
        </ComposedChart>
      </ResponsiveContainer>


    </div>
  );
}
