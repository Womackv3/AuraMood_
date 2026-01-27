import MoodEntryCard from "@/components/MoodEntryCard";
import MedicationList from "@/components/MedicationList";
import MoodChart from "@/components/MoodChart";
import WeatherSync from "@/components/WeatherSync";
import Link from "next/link";
import { Settings } from "lucide-react";
import CyberpunkHeading from "@/components/CyberpunkHeading";

export default function Home() {
  return (
    <main className="min-h-screen w-full flex justify-center py-8">
      <div className="w-full max-w-7xl px-6 sm:px-8 md:px-12">
        {/* Header */}
        <div className="relative flex items-center justify-center mb-4 sm:mb-6 md:mb-8">
          <div className="text-center">
            <CyberpunkHeading
              text="Aura Mood"
              className="text-2xl sm:text-3xl md:text-4xl font-bold text-white mb-1"
            />
            <p className="text-gray-400 text-sm sm:text-base">
              Your mental wellness cockpit
            </p>
          </div>
          <Link
            href="/settings"
            className="absolute right-0 top-1/2 -translate-y-1/2 p-2 sm:p-3 bg-glass-gradient backdrop-blur-lg rounded-xl border border-aura-purple/20 hover:border-aura-purple/40 transition-all active:scale-95"
          >
            <Settings className="w-5 h-5 sm:w-6 sm:h-6 text-aura-purple-light" />
          </Link>
        </div>

        {/* Main Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 sm:gap-6">
          {/* Left Column - Mood Entry */}
          <div className="lg:col-span-2 space-y-4 sm:space-y-6">
            <MoodEntryCard />
            <MoodChart />
          </div>

          {/* Right Column - Sidebar */}
          <div className="space-y-4 sm:space-y-6">
            <MedicationList />
            <WeatherSync />
          </div>
        </div>
      </div>
    </main>
  );
}
