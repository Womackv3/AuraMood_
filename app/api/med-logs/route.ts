import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const medicationId = searchParams.get("medicationId");
    const limit = parseInt(searchParams.get("limit") || "30");

    const where = medicationId ? { medicationId } : {};

    const medLogs = await prisma.medLog.findMany({
      where,
      take: limit,
      orderBy: {
        takenAt: "desc",
      },
      include: {
        medication: true,
      },
    });

    return NextResponse.json(medLogs);
  } catch (error) {
    console.error("Med logs API error:", error);
    return NextResponse.json(
      { error: "Failed to fetch medication logs" },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { medicationId, status } = body;

    // Validate required fields
    if (!medicationId || !status) {
      return NextResponse.json(
        { error: "medicationId and status are required" },
        { status: 400 }
      );
    }

    // Validate status
    if (!["taken", "missed", "late"].includes(status)) {
      return NextResponse.json(
        { error: "status must be 'taken', 'missed', or 'late'" },
        { status: 400 }
      );
    }

    // Check if medication exists
    const medication = await prisma.medication.findUnique({
      where: { id: medicationId },
    });

    if (!medication) {
      return NextResponse.json(
        { error: "Medication not found" },
        { status: 404 }
      );
    }

    // Create log entry
    const medLog = await prisma.medLog.create({
      data: {
        medicationId,
        status,
        takenAt: status === "taken" ? new Date() : null,
      },
      include: {
        medication: true,
      },
    });

    return NextResponse.json(medLog, { status: 201 });
  } catch (error) {
    console.error("Med logs API error:", error);
    return NextResponse.json(
      { error: "Failed to create medication log" },
      { status: 500 }
    );
  }
}
