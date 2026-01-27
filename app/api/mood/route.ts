import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const {
      moodLevel,
      anxietyLevel,
      irritabilityLevel,
      sleepHours,
      notes,
      weatherData,
    } = body;

    // Validate required fields
    if (!moodLevel || moodLevel < 1 || moodLevel > 10) {
      return NextResponse.json(
        { error: "Invalid mood level (must be 1-10)" },
        { status: 400 }
      );
    }

    // AM/PM Overlap Check
    const now = new Date();
    const startOfDay = new Date(now.setHours(0, 0, 0, 0));
    const midDay = new Date(now.setHours(12, 0, 0, 0));
    const endOfDay = new Date(now.setHours(23, 59, 59, 999));

    const isAM = new Date().getHours() < 12;
    const periodStart = isAM ? startOfDay : midDay;
    const periodEnd = isAM ? midDay : endOfDay;

    const existingEntry = await prisma.moodEntry.findFirst({
      where: {
        timestamp: {
          gte: periodStart,
          lte: periodEnd,
        },
      },
    });

    if (existingEntry) {
      return NextResponse.json(
        { error: `You have already logged your ${isAM ? "Morning" : "Evening"} entry.` },
        { status: 429 } // Too Many Requests
      );
    }

    // Create mood entry with optional weather data
    const moodEntry = await prisma.moodEntry.create({
      data: {
        moodLevel,
        anxietyLevel: anxietyLevel || null,
        irritabilityLevel: irritabilityLevel || null,
        sleepHours: sleepHours || null,
        notes: notes || null,
        weatherSnapshot: weatherData
          ? {
            create: {
              // @ts-ignore
              tempF: weatherData.tempF,
              cloudCoverPct: weatherData.cloudCoverPct,
              rainMm: weatherData.rainMm || 0,
              moonPhase: weatherData.moonPhase,
            },
          }
          : undefined,
      },
      include: {
        weatherSnapshot: true,
      },
    });

    return NextResponse.json(moodEntry, { status: 201 });
  } catch (error) {
    console.error("Mood API error:", error);
    return NextResponse.json(
      { error: "Failed to create mood entry" },
      { status: 500 }
    );
  }
}

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const limit = parseInt(searchParams.get("limit") || "30");

    const moodEntries = await prisma.moodEntry.findMany({
      take: limit,
      orderBy: {
        timestamp: "desc",
      },
      include: {
        weatherSnapshot: true,
      },
    });

    return NextResponse.json(moodEntries);
  } catch (error) {
    console.error("Mood API error:", error);
    return NextResponse.json(
      { error: "Failed to fetch mood entries" },
      { status: 500 }
    );
  }
}
