"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { ArrowLeft, Bell } from "lucide-react";
import { useToast } from "@/lib/useToast";
import CyberpunkHeading from "@/components/CyberpunkHeading";

export default function Settings() {
  const [ntfyTopic, setNtfyTopic] = useState("");
  const [ntfyServer, setNtfyServer] = useState("http://localhost:8080");
  const [isSaving, setIsSaving] = useState(false);
  const [isTesting, setIsTesting] = useState(false);
  const { addToast } = useToast();

  // Load settings from localStorage on mount
  useEffect(() => {
    const savedTopic = localStorage.getItem("ntfyTopic");
    const savedServer = localStorage.getItem("ntfyServer");

    if (savedTopic) setNtfyTopic(savedTopic);
    if (savedServer) setNtfyServer(savedServer);
  }, []);

  const handleSave = async () => {
    setIsSaving(true);

    try {
      // Simulate API delay
      await new Promise((resolve) => setTimeout(resolve, 500));

      // Save settings to local storage
      localStorage.setItem("ntfyTopic", ntfyTopic);
      localStorage.setItem("ntfyServer", ntfyServer);

      console.log("Settings saved:", { ntfyTopic, ntfyServer });

      addToast({
        type: "success",
        message: "Settings saved successfully!",
        duration: 3000,
      });
    } catch (error) {
      console.error("Error saving settings:", error);
      addToast({
        type: "error",
        message: "Failed to save settings. Please try again.",
        duration: 5000,
      });
    } finally {
      setIsSaving(false);
    }
  };

  const handleTestNotification = async () => {
    if (!ntfyTopic || !ntfyServer) {
      addToast({
        type: "error",
        message: "Please enter both server URL and topic before testing",
        duration: 4000,
      });
      return;
    }

    setIsTesting(true);

    try {
      const response = await fetch(`${ntfyServer}/${ntfyTopic}`, {
        method: "POST",
        headers: {
          "Content-Type": "text/plain",
        },
        body: "🧪 Test notification from Aura Mood! Your notifications are working correctly.",
      });

      if (response.ok) {
        addToast({
          type: "success",
          message: "Test notification sent! Check your ntfy app.",
          duration: 4000,
        });
      } else {
        throw new Error("Failed to send notification");
      }
    } catch (error) {
      console.error("Error sending test notification:", error);
      addToast({
        type: "error",
        message: "Failed to send test notification. Check your server URL and topic.",
        duration: 5000,
      });
    } finally {
      setIsTesting(false);
    }
  };

  return (
    <main className="min-h-screen px-6 py-6 sm:px-8 md:px-12 pb-8">
      <div className="max-w-3xl mx-auto">
        {/* Header */}
        <div className="flex items-center mb-4 sm:mb-6 md:mb-8">
          <Link
            href="/"
            className="p-2 hover:bg-aura-slate-800 active:bg-aura-slate-700 rounded-lg transition-colors mr-3 sm:mr-4 touch-manipulation"
          >
            <ArrowLeft className="w-5 h-5 sm:w-6 sm:h-6 text-white" />
          </Link>
          <CyberpunkHeading
            text="Settings"
            className="text-2xl sm:text-3xl md:text-4xl font-bold text-white"
          />
        </div>

        {/* Settings Card */}
        <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-4 sm:p-5 md:p-6 shadow-glass border border-aura-purple/20">
          <h2 className="text-lg sm:text-xl md:text-2xl font-bold text-white mb-4 sm:mb-5 md:mb-6">
            Notification Settings
          </h2>

          <div className="space-y-4 sm:space-y-5 md:space-y-6">
            {/* ntfy Server */}
            <div>
              <label className="block text-xs sm:text-sm font-medium text-gray-300 mb-2">
                ntfy Server URL
              </label>
              <input
                type="text"
                value={ntfyServer}
                onChange={(e) => setNtfyServer(e.target.value)}
                className="cyberpunk w-full bg-aura-slate-800 text-white focus:outline-none text-sm sm:text-base"
                placeholder="http://localhost:8080"
              />
              <p className="text-xs sm:text-sm text-gray-400 mt-1.5">
                The URL of your self-hosted ntfy server
              </p>
            </div>

            {/* ntfy Topic */}
            <div>
              <label className="block text-xs sm:text-sm font-medium text-gray-300 mb-2">
                ntfy Topic
              </label>
              <input
                type="text"
                value={ntfyTopic}
                onChange={(e) => setNtfyTopic(e.target.value)}
                className="cyberpunk w-full bg-aura-slate-800 text-white focus:outline-none text-sm sm:text-base"
                placeholder="my_secure_mood_topic"
              />
              <p className="text-xs sm:text-sm text-gray-400 mt-1.5">
                Your private topic for medication reminders
              </p>
            </div>

            {/* Info Box */}
            <div className="p-3 sm:p-4 bg-aura-purple/10 border border-aura-purple/30 rounded-lg">
              <h3 className="font-semibold text-sm sm:text-base text-white mb-2">
                How to set up notifications:
              </h3>
              <ol className="list-decimal list-inside space-y-1 text-xs sm:text-sm text-gray-300">
                <li>Install the ntfy app on your phone</li>
                <li>Subscribe to your private topic</li>
                <li>Enter your topic name above</li>
                <li>Save settings and test the connection</li>
              </ol>
            </div>

            {/* Action Buttons */}
            <div className="flex flex-col sm:flex-row gap-3">
              {/* Test Notification Button */}
              <button
                onClick={handleTestNotification}
                disabled={isTesting || !ntfyTopic || !ntfyServer}
                className="flex-1 bg-aura-slate-700 hover:bg-aura-slate-600 active:bg-aura-slate-500 disabled:bg-aura-slate-800 disabled:cursor-not-allowed transition-colors py-3 sm:py-3.5 rounded-lg font-semibold text-sm sm:text-base text-white shadow-glass active:scale-98 touch-manipulation disabled:opacity-50 disabled:active:scale-100"
              >
                {isTesting ? (
                  <span className="flex items-center justify-center gap-2">
                    <svg
                      className="animate-spin h-5 w-5 text-white"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                    >
                      <circle
                        className="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                      ></circle>
                      <path
                        className="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                      ></path>
                    </svg>
                    Testing...
                  </span>
                ) : (
                  <span className="flex items-center justify-center gap-2">
                    <Bell className="w-4 h-4 sm:w-5 sm:h-5" />
                    Test Notification
                  </span>
                )}
              </button>

              {/* Save Button */}
              <button
                onClick={handleSave}
                disabled={isSaving}
                className="flex-1 bg-aura-purple hover:bg-aura-purple-dark active:bg-aura-purple-darker disabled:bg-aura-slate-700 disabled:cursor-not-allowed transition-colors py-3 sm:py-3.5 rounded-lg font-semibold text-sm sm:text-base text-white shadow-glass-lg active:scale-98 touch-manipulation disabled:opacity-50 disabled:active:scale-100"
              >
                {isSaving ? (
                  <span className="flex items-center justify-center gap-2">
                    <svg
                      className="animate-spin h-5 w-5 text-white"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                    >
                      <circle
                        className="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                      ></circle>
                      <path
                        className="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                      ></path>
                    </svg>
                    Saving...
                  </span>
                ) : (
                  "Save Settings"
                )}
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}
