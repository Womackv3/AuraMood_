import React from "react";

interface CyberpunkHeadingProps {
    text: string;
    tag?: string;
    className?: string;
}

const CyberpunkHeading: React.FC<CyberpunkHeadingProps> = ({
    text,
    tag = "R25",
    className = ""
}) => {
    return (
        <h1 className={`cyberpunk glitched ${className}`}>
            {text}
        </h1>
    );
};

export default CyberpunkHeading;
