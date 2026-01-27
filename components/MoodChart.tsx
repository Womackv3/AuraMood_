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
  mood: number;
  anxiety: number | null;
  irritability: number | null;
  sleep: number;
  sleepAM: number | null;
  sleepPM: number | null;
  weather: string | null;
  temp: number | null;
  rain: number | null;
}

export default function MoodChart() {
  const [chartData, setChartData] = useState<ChartData[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    fetchMoodData();
  }, []);

  const fetchMoodData = async () => {
    try {
      // Fetch up to 3 months of data (90 days * 2 entries/day = 180)
      const response = await fetch("/api/mood?limit=180");
      if (response.ok) {
        const moodEntries: MoodEntry[] = await response.json();

        // Transform API data to chart format
        const transformed = moodEntries.reverse().map((entry) => {
          const date = new Date(entry.timestamp);
          const formattedDate = date.toLocaleDateString("en-US", {
            month: "short",
            day: "numeric",
          });
          const time = date.toLocaleTimeString("en-US", {
            hour: "numeric",
            minute: "2-digit",
          });

          const isAM = date.getHours() < 12;
          const sleepHours = entry.sleepHours || 0;

          return {
            id: entry.id,
            date: `${formattedDate} ${time}`,
            mood: entry.moodLevel,
            anxiety: entry.anxietyLevel,
            irritability: entry.irritabilityLevel,
            sleep: sleepHours,
            sleepAM: isAM ? sleepHours : null,
            sleepPM: isAM ? null : sleepHours,
            weather: entry.weatherSnapshot?.moonPhase || null,
            temp: entry.weatherSnapshot?.tempF || null,
            rain: entry.weatherSnapshot?.rainMm || null,
          };
        });

        setChartData(transformed);
      }
    } catch (error) {
      console.error("Failed to fetch mood data:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const getTickLabel = (id: any) => {
    const item = chartData.find((d) => d.id === id);
    return item ? item.date.split(" ")[0] + " " + item.date.split(" ")[1] : "";
  };

  const getTooltipLabel = (id: any) => {
    const item = chartData.find((d) => d.id === id);
    return item ? item.date : "";
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
              if (name === "Mood") return [value, "Mood"];
              if (name === "Anxiety") return [value, "Anxiety"];
              if (name === "Irritability") return [value, "Irritability"];
              if (name === "Sleep (AM)" || name === "Sleep (PM)") return [`${value}h`, name];
              return [value, name];
            }}
          />

          {/* Mood Line */}
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="mood"
            stroke="#7c3aed"
            strokeWidth={2}
            dot={{ fill: "#7c3aed", r: 3 }}
            connectNulls
            name="Mood"
          />

          {/* Anxiety Line */}
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="anxiety"
            stroke="#06b6d4" // Cyan
            strokeWidth={2}
            dot={{ fill: "#06b6d4", r: 3 }}
            connectNulls
            name="Anxiety"
          />

          {/* Irritability Line */}
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="irritability"
            stroke="#ec4899" // Pink
            strokeWidth={2}
            dot={{ fill: "#ec4899", r: 3 }}
            connectNulls
            name="Irritability"
          />

          {/* Sleep Bars - AM */}
          <Bar
            yAxisId="right"
            dataKey="sleepAM"
            fill="#06b6d4"
            opacity={0.6}
            name="Sleep (AM)"
          />
          {/* Sleep Bars - PM */}
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
              // Custom formatter to show weather data alongside line data?
              // Recharts tooltip customization is tricky for non-series data.
              // We'll stick to formatting the series values nicely.
              if (name === "Mood Level") return [value, "Mood"];
              if (name === "Anxiety Level") return [value, "Anxiety"];
              if (name === "Irritability Level") return [value, "Irritability"];
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

          {/* Mood Line */}
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="mood"
            stroke="#7c3aed"
            strokeWidth={3}
            dot={{ fill: "#7c3aed", r: 5 }}
            connectNulls
            name="Mood Level"
          />

          {/* Anxiety Line */}
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="anxiety"
            stroke="#06b6d4" // Cyan
            strokeWidth={2}
            dot={{ fill: "#06b6d4", r: 4 }}
            connectNulls
            name="Anxiety Level"
          />

          {/* Irritability Line */}
          <Line
            yAxisId="left"
            type="monotone"
            dataKey="irritability"
            stroke="#ec4899" // Pink
            strokeWidth={2}
            dot={{ fill: "#ec4899", r: 4 }}
            connectNulls
            name="Irritability Level"
          />

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

      <div className="mt-3 sm:mt-4 flex items-center justify-center space-x-4 sm:space-x-6 text-xs sm:text-sm text-gray-400">
        <div className="flex items-center space-x-1.5 sm:space-x-2">
          <div className="w-2.5 h-2.5 sm:w-3 sm:h-3 rounded-full bg-red-500"></div>
          <span>Medication Missed</span>
        </div>
      </div>
    </div>
  );
}
