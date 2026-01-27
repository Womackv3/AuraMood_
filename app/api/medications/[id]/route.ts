import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    
    const medication = await prisma.medication.findUnique({
      where: { id },
      include: {
        medLogs: {
          orderBy: {
            takenAt: "desc",
          },
          take: 10,
        },
      },
    });

    if (!medication) {
      return NextResponse.json(
        { error: "Medication not found" },
        { status: 404 }
      );
    }

    return NextResponse.json(medication);
  } catch (error) {
    console.error("Medications API error:", error);
    return NextResponse.json(
      { error: "Failed to fetch medication" },
      { status: 500 }
    );
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
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

    const medication = await prisma.medication.update({
      where: { id },
      data: {
        name: name.trim(),
        dosage: dosage?.trim() || null,
        scheduleTime: scheduleTime || null,
      },
    });

    return NextResponse.json(medication);
  } catch (error: any) {
    if (error.code === "P2025") {
      return NextResponse.json(
        { error: "Medication not found" },
        { status: 404 }
      );
    }
    console.error("Medications API error:", error);
    return NextResponse.json(
      { error: "Failed to update medication" },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;

    await prisma.medication.delete({
      where: { id },
    });

    return NextResponse.json({ message: "Medication deleted successfully" });
  } catch (error: any) {
    if (error.code === "P2025") {
      return NextResponse.json(
        { error: "Medication not found" },
        { status: 404 }
      );
    }
    console.error("Medications API error:", error);
    return NextResponse.json(
      { error: "Failed to delete medication" },
      { status: 500 }
    );
  }
}
