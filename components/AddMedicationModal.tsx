"use client";

import { useState, useEffect } from "react";
import { X } from "lucide-react";

interface Medication {
  id: string;
  name: string;
  dosage: string | null;
  scheduleTime: string | null;
}

interface AddMedicationModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAdd?: (medication: { name: string; dosage: string; scheduleTime: string }) => void;
  onEdit?: (id: string, medication: { name: string; dosage: string; scheduleTime: string }) => void;
  medication?: Medication | null;
}

export default function AddMedicationModal({ isOpen, onClose, onAdd, onEdit, medication }: AddMedicationModalProps) {
  const [name, setName] = useState("");
  const [dosage, setDosage] = useState("");
  const [scheduleTime, setScheduleTime] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState("");

  // Set initial values when editing
  useEffect(() => {
    if (medication) {
      setName(medication.name);
      setDosage(medication.dosage || "");
      setScheduleTime(medication.scheduleTime || "");
    } else {
      // Reset form when not editing
      setName("");
      setDosage("");
      setScheduleTime("");
    }
  }, [medication]);

  if (!isOpen) return null;

  const isEditing = !!medication;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    if (!name.trim()) {
      setError("Medication name is required");
      return;
    }

    setIsSubmitting(true);
    try {
      if (isEditing && medication && onEdit) {
        await onEdit(medication.id, { name: name.trim(), dosage: dosage.trim(), scheduleTime });
      } else if (onAdd) {
        await onAdd({ name: name.trim(), dosage: dosage.trim(), scheduleTime });
      }
      setName("");
      setDosage("");
      setScheduleTime("");
      onClose();
    } catch (err) {
      setError(isEditing ? "Failed to update medication. Please try again." : "Failed to add medication. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fade-in">
      <div
        className="relative w-full max-w-md bg-aura-slate-900 rounded-xl border-2 border-aura-purple shadow-glass-lg animate-fade-in"
        style={{
          clipPath: "polygon(0 0, calc(100% - 20px) 0, 100% 20px, 100% 100%, 20px 100%, 0 calc(100% - 20px))"
        }}
      >
        {/* Glowing corner accent */}
        <div className="absolute top-0 right-0 w-20 h-20 bg-gradient-to-bl from-aura-purple/30 to-transparent pointer-events-none" />

        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 p-2 text-gray-400 hover:text-white hover:bg-aura-slate-800 rounded-lg transition-colors z-10 touch-manipulation"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Header */}
        <div className="p-6 pb-4 border-b border-aura-purple/30">
          <h2 className="text-2xl font-bold text-white">
            <span className="text-aura-purple-light">&gt;_</span> {isEditing ? "Edit" : "Add"} Medication
          </h2>
          <p className="text-sm text-gray-400 mt-1">{isEditing ? "Update" : "Configure new"} medication schedule</p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-5">
          {error && (
            <div className="p-3 bg-red-500/10 border border-red-500/30 rounded-lg text-red-400 text-sm">
              {error}
            </div>
          )}

          {/* Name field */}
          <div>
            <label className="block text-sm font-medium text-gray-300 mb-2">
              Medication Name <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="cyberpunk w-full bg-aura-slate-800 text-white focus:outline-none"
              placeholder="e.g., Lithium Carbonate"
            />
          </div>

          {/* Dosage field */}
          <div>
            <label className="block text-sm font-medium text-gray-300 mb-2">
              Dosage
            </label>
            <input
              type="text"
              value={dosage}
              onChange={(e) => setDosage(e.target.value)}
              className="cyberpunk w-full bg-aura-slate-800 text-white focus:outline-none"
              placeholder="e.g., 300mg"
            />
          </div>

          {/* Schedule Time field */}
          <div>
            <label className="block text-sm font-medium text-gray-300 mb-2">
              Schedule Time
            </label>
            <input
              type="time"
              value={scheduleTime}
              onChange={(e) => setScheduleTime(e.target.value)}
              className="cyberpunk w-full bg-aura-slate-800 text-white focus:outline-none"
              disabled={isSubmitting}
            />
          </div>

          {/* Action buttons */}
          <div className="flex gap-3 pt-2">
            <button
              type="button"
              onClick={onClose}
              disabled={isSubmitting}
              className="flex-1 px-4 py-3 bg-aura-slate-700 hover:bg-aura-slate-600 active:bg-aura-slate-500 text-white rounded-lg font-semibold transition-colors disabled:opacity-50 disabled:cursor-not-allowed touch-manipulation"
              style={{
                clipPath: "polygon(0 0, 100% 0, 100% calc(100% - 8px), calc(100% - 8px) 100%, 0 100%)"
              }}
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting}
              className="flex-1 px-4 py-3 bg-aura-purple hover:bg-aura-purple-dark active:bg-aura-purple-darker text-white rounded-lg font-semibold shadow-glass-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed touch-manipulation relative overflow-hidden"
              style={{
                clipPath: "polygon(8px 0, 100% 0, 100% 100%, 0 100%, 0 8px)"
              }}
            >
              {isSubmitting ? (
                <span className="flex items-center justify-center gap-2">
                  <svg className="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  {isEditing ? "Updating..." : "Adding..."}
                </span>
              ) : (
                <>
                  <span className="relative z-10">{isEditing ? "Update" : "Add"} Medication</span>
                  <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent transform -skew-x-12 translate-x-full group-hover:translate-x-0 transition-transform duration-500" />
                </>
              )}
            </button>
          </div>
        </form>

        {/* Bottom corner accent */}
        <div className="absolute bottom-0 left-0 w-20 h-20 bg-gradient-to-tr from-aura-purple/20 to-transparent pointer-events-none" />
      </div>
    </div>
  );
}
