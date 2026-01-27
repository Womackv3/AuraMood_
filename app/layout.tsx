import type { Metadata, Viewport } from "next";
import { Inter } from "next/font/google"; // Use Inter only
import "./cyberpunk-2077.css";
import "./globals.css";
import ToastContainer from "@/components/ToastContainer";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Aura Mood - Bipolar Tracker",
  description: "Self-hosted mood and medication tracking for mental wellness",
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 5,
  userScalable: true,
  themeColor: "#7c3aed",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark" suppressHydrationWarning>
      <body className={inter.className} suppressHydrationWarning>
        {children}
        <ToastContainer />
      </body>
    </html>
  );
}
