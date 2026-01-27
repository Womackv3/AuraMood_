import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET(request: NextRequest) {
  try {
    const medications = await prisma.medication.findMany({
      orderBy: {
        name: "asc",
      },
    });

    return NextResponse.json(medications);
  } catch (error) {
    console.error("Medications API error:", error);
    return NextResponse.json(
      { error: "Failed to fetch medications" },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { name, dosage, scheduleTime } = body;

    // Validate required fields
    if (!name || name.trim() === "") {
      return NextResponse.json(
        { error: "Medication name is required" },
        { status: 400 }
      );
    }

    // Validate time format if provided (HH:MM)
    if (scheduleTime && !/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/.test(scheduleTime)) {
      return NextResponse.json(
        { error: "Invalid time format. Use HH:MM (e.g., 09:00)" },
        { status: 400 }
      );
    }

    const medication = await prisma.medication.create({
      data: {
        name: name.trim(),
        dosage: dosage?.trim() || null,
        scheduleTime: scheduleTime || null,
      },
    });

    return NextResponse.json(medication, { status: 201 });
  } catch (error) {
    console.error("Medications API error:", error);
    return NextResponse.json(
      { error: "Failed to create medication" },
      { status: 500 }
    );
  }
}
