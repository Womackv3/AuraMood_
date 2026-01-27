"use client";

import { useState, useEffect } from "react";
import { Check, X, Loader2, Pencil, Trash2 } from "lucide-react";
import AddMedicationModal from "./AddMedicationModal";

interface Medication {
  id: string;
  name: string;
  dosage: string | null;
  scheduleTime: string | null;
  taken?: boolean;
}

export default function MedicationList() {
  const [medications, setMedications] = useState<Medication[]>([]);
  const [togglingId, setTogglingId] = useState<string | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [editingMedication, setEditingMedication] = useState<Medication | null>(null);

  // Fetch medications on mount
  useEffect(() => {
    fetchMedications();
  }, []);

  const fetchMedications = async () => {
    try {
      const [medsResponse, logsResponse] = await Promise.all([
        fetch("/auramoods/api/medications"),
        fetch("/auramoods/api/med-logs?limit=100"),
      ]);

      if (medsResponse.ok && logsResponse.ok) {
        const meds = await medsResponse.json();
        const logs = await logsResponse.json();

        // Get today's date at midnight for comparison
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        // Check which medications have been taken today
        const medsWithStatus = meds.map((med: Medication) => {
          const takenToday = logs.some((log: any) => {
            if (log.medicationId !== med.id) return false;
            const logDate = new Date(log.takenAt || log.createdAt);
            logDate.setHours(0, 0, 0, 0);
            return logDate.getTime() === today.getTime() && log.status === "taken";
          });
          return { ...med, taken: takenToday };
        });

        setMedications(medsWithStatus);
      }
    } catch (error) {
      console.error("Failed to fetch medications:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleToggleMedication = async (id: string) => {
    setTogglingId(id);

    try {
      const medication = medications.find((m) => m.id === id);
      if (!medication) return;

      const newStatus = !medication.taken;
      const status = newStatus ? "taken" : "missed";

      // Log to API
      const response = await fetch("/auramoods/api/med-logs", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ medicationId: id, status }),
      });

      if (response.ok) {
        // Update UI
        setMedications((prev) =>
          prev.map((med) =>
            med.id === id ? { ...med, taken: newStatus } : med
          )
        );
      }
    } catch (error) {
      console.error("Failed to log medication:", error);
    } finally {
      setTogglingId(null);
    }
  };

  const handleAddMedication = async (medication: { name: string; dosage: string; scheduleTime: string }) => {
    const response = await fetch("/auramoods/api/medications", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(medication),
    });

    if (!response.ok) {
      throw new Error("Failed to add medication");
    }

    const newMed = await response.json();
    setMedications((prev) => [...prev, { ...newMed, taken: false }]);
  };

  const handleUpdateMedication = async (id: string, medication: { name: string; dosage: string; scheduleTime: string }) => {
    const response = await fetch(`/auramoods/api/medications/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(medication),
    });

    if (!response.ok) {
      throw new Error("Failed to update medication");
    }

    const updatedMed = await response.json();
    setMedications((prev) =>
      prev.map((med) => (med.id === id ? { ...updatedMed, taken: med.taken } : med))
    );
    setEditingMedication(null);
  };

  const handleDeleteMedication = async (id: string) => {
    if (!confirm("Are you sure you want to remove this medication?")) return;

    try {
      const response = await fetch(`/auramoods/api/medications/${id}`, {
        method: "DELETE",
      });

      if (response.ok) {
        setMedications((prev) => prev.filter((med) => med.id !== id));
      }
    } catch (error) {
      console.error("Failed to delete medication:", error);
    }
  };

  const openEditModal = (medication: Medication) => {
    setEditingMedication(medication);
    setIsModalOpen(true);
  };

  const openAddModal = () => {
    setEditingMedication(null);
    setIsModalOpen(true);
  };

  return (
    <>
      <div className="bg-glass-gradient backdrop-blur-lg rounded-xl sm:rounded-2xl p-4 sm:p-5 md:p-6 shadow-glass border border-aura-purple/20">
        <h2 className="text-lg sm:text-xl md:text-2xl font-bold text-white mb-4 sm:mb-5 md:mb-6">
          Medication Checklist
        </h2>

        {isLoading ? (
          <div className="flex items-center justify-center py-8">
            <Loader2 className="w-8 h-8 text-aura-purple animate-spin" />
          </div>
        ) : medications.length === 0 ? (
          <p className="text-gray-400 text-center text-sm sm:text-base py-6 sm:py-8">
            No medications scheduled for today
          </p>
        ) : (
          <div className="space-y-2 sm:space-y-3">
            {medications.map((med) => (
              <div
                key={med.id}
                className="group flex items-center justify-between p-3 sm:p-4 bg-aura-slate-800/50 rounded-lg border border-aura-purple/20 transition-all hover:border-aura-purple/40 active:border-aura-purple/60"
              >
                <div className="flex-1 min-w-0 mr-3">
                  <div className="flex items-center gap-2">
                    <h3 className="font-semibold text-sm sm:text-base text-white truncate">{med.name}</h3>
                    <div className="opacity-0 group-hover:opacity-100 transition-opacity flex items-center gap-1">
                      <button
                        onClick={() => openEditModal(med)}
                        className="p-1 text-gray-400 hover:text-aura-purple-light transition-colors"
                        title="Edit"
                      >
                        <Pencil className="w-3.5 h-3.5" />
                      </button>
                      <button
                        onClick={() => handleDeleteMedication(med.id)}
                        className="p-1 text-gray-400 hover:text-red-400 transition-colors"
                        title="Delete"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </div>
                  <p className="text-xs sm:text-sm text-gray-400">
                    {med.dosage || "No dosage"} {med.scheduleTime && `• ${med.scheduleTime}`}
                  </p>
                </div>

                <button
                  onClick={() => handleToggleMedication(med.id)}
                  disabled={togglingId === med.id}
                  className={`w-10 h-10 sm:w-11 sm:h-11 flex-shrink-0 rounded-full flex items-center justify-center transition-colors active:scale-95 touch-manipulation disabled:cursor-not-allowed ${togglingId === med.id
                    ? "bg-aura-purple"
                    : med.taken
                      ? "bg-green-600 hover:bg-green-700 active:bg-green-800"
                      : "bg-aura-slate-700 hover:bg-aura-slate-600 active:bg-aura-slate-500"
                    }`}
                >
                  {togglingId === med.id ? (
                    <Loader2 className="w-5 h-5 sm:w-6 sm:h-6 text-white animate-spin" />
                  ) : med.taken ? (
                    <Check className="w-5 h-5 sm:w-6 sm:h-6 text-white" />
                  ) : (
                    <X className="w-5 h-5 sm:w-6 sm:h-6 text-gray-400" />
                  )}
                </button>
              </div>
            ))}
          </div>
        )}

        <button
          onClick={openAddModal}
          className="w-full mt-4 sm:mt-5 md:mt-6 py-2 sm:py-2.5 text-sm sm:text-base text-aura-purple-light hover:text-aura-purple active:text-aura-purple-dark transition-colors font-medium touch-manipulation"
        >
          + Add Medication
        </button>
      </div>

      <AddMedicationModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onAdd={handleAddMedication}
        onEdit={handleUpdateMedication}
        medication={editingMedication}
      />
    </>
  );
}
