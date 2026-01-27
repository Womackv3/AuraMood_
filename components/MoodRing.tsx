"use client";

import { RoundSlider } from "mz-react-round-slider";

interface MoodRingProps {
  value: number;
  onChange: (value: number) => void;
  label: string;
  min?: number;
  max?: number;
  colors?: string[];
}

export default function MoodRing({
  value,
  onChange,
  label,
  min = 1,
  max = 10,
  colors = [
    "#ef4444", "#f97316", "#eab308", "#84cc16", "#22c55e",
  ],
}: MoodRingProps) {
  const getColorForValue = (val: number) => {
    const normalizedValue = (val - min) / (max - min);
    const colorIndex = Math.floor(normalizedValue * colors.length);
    return colors[Math.min(colorIndex, colors.length - 1)];
  };

  const currentColor = getColorForValue(value);

  const handleChange = (pointers: { value?: string | number }[]) => {
    if (pointers && pointers[0] && pointers[0].value !== undefined) {
      const newValue = typeof pointers[0].value === "string"
        ? parseFloat(pointers[0].value)
        : pointers[0].value;
      onChange(Math.round(newValue));
    }
  };

  // Add a 40-degree gap at the top (implemented directly in props)


  return (
    <div className="flex flex-col items-center space-y-3 sm:space-y-4">
      <div className="relative flex items-center justify-center">
        {/* Outer glow */}
        <div
          className="absolute rounded-full blur-2xl opacity-50 pointer-events-none transition-all duration-300"
          style={{
            backgroundColor: currentColor,
            width: "140px",
            height: "140px",
          }}
        />

        {/* Round Slider Container */}
        <div className="relative z-10 w-32 h-32 sm:w-36 sm:h-36 md:w-40 md:h-40 flex items-center justify-center">
          <div className="absolute inset-0 flex items-center justify-center">
            <RoundSlider
              min={min}
              max={max}
              step={1}
              pathStartAngle={290}
              pathEndAngle={250}
              pathRadius={45}
              pathThickness={10}
              pathBgColor="rgba(148, 163, 184, 0.2)"
              pointerRadius={8}
              pointers={[
                {
                  value: value,
                  bgColor: currentColor,
                  bgColorHover: currentColor,
                  bgColorSelected: currentColor,
                  border: 3,
                  borderColor: "rgba(255, 255, 255, 0.9)",
                },
              ]}
              hideConnection={true}
              hideText={true}
              animateOnClick={true}
              animationDuration={200}
              onChange={handleChange}
              svgBgColor="transparent"
            />
          </div>

          {/* Center content overlay */}
          <div className="absolute inset-0 flex items-center justify-center pointer-events-none z-20">
            <div className="text-center">
              <div
                className="text-2xl sm:text-3xl md:text-4xl font-bold transition-colors duration-300"
                style={{ color: currentColor }}
              >
                {value}
              </div>
              <div className="text-[10px] sm:text-xs text-gray-400 mt-0.5 sm:mt-1">
                {min}-{max}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Label */}
      <div className="text-center">
        <p className="text-xs sm:text-sm font-medium text-white">{label}</p>
      </div>
    </div>
  );
}
