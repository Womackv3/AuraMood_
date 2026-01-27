import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
        // Cyberpunk-Minimalist palette
        aura: {
          purple: {
            light: "#a78bfa",
            DEFAULT: "#7c3aed",
            dark: "#6d28d9",
            darker: "#5b21b6",
          },
          slate: {
            900: "#0f172a",
            800: "#1e293b",
            700: "#334155",
            600: "#475569",
          },
        },
      },
      backdropBlur: {
        xs: "2px",
      },
      backgroundImage: {
        "glass-gradient":
          "linear-gradient(135deg, rgba(124, 58, 237, 0.1) 0%, rgba(109, 40, 217, 0.05) 100%)",
      },
      boxShadow: {
        glass: "0 8px 32px 0 rgba(124, 58, 237, 0.2)",
        "glass-lg": "0 12px 48px 0 rgba(124, 58, 237, 0.3)",
      },
    },
  },
  plugins: [],
};

export default config;
