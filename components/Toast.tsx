"use client";

import { useEffect } from "react";
import { CheckCircle, XCircle, Info, X } from "lucide-react";

export interface ToastProps {
  id: string;
  type: "success" | "error" | "info";
  message: string;
  duration?: number;
  onClose: (id: string) => void;
}

export default function Toast({
  id,
  type,
  message,
  duration = 5000,
  onClose,
}: ToastProps) {
  useEffect(() => {
    const timer = setTimeout(() => {
      onClose(id);
    }, duration);

    return () => clearTimeout(timer);
  }, [id, duration, onClose]);

  const icons = {
    success: <CheckCircle className="w-5 h-5 text-green-400" />,
    error: <XCircle className="w-5 h-5 text-red-400" />,
    info: <Info className="w-5 h-5 text-blue-400" />,
  };

  const borderColors = {
    success: "border-green-500/50",
    error: "border-red-500/50",
    info: "border-blue-500/50",
  };

  return (
    <div
      className={`flex items-start gap-3 p-4 bg-glass-gradient backdrop-blur-lg rounded-lg shadow-glass-lg border ${borderColors[type]} animate-slide-in-right touch-manipulation`}
      role="alert"
    >
      <div className="flex-shrink-0 mt-0.5">{icons[type]}</div>
      <p className="flex-1 text-sm text-white">{message}</p>
      <button
        onClick={() => onClose(id)}
        className="flex-shrink-0 p-1 hover:bg-aura-slate-700/50 rounded transition-colors active:scale-95"
        aria-label="Close notification"
      >
        <X className="w-4 h-4 text-gray-400" />
      </button>
    </div>
  );
}
