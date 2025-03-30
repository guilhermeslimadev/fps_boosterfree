function withOpacity(variableName) {
  return ({ opacityValue }) => {
    if (opacityValue !== undefined) {
      return `rgba(var(${variableName}), ${opacityValue})`;
    }
    return `rgb(var(${variableName}))`;
  };
}

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        background: "#0E0E0E",
        primary: "#BA67FA",
        secondary: "#6C3199",
      },
      opacity: {
        1: "0.01",
        2: "0.02",
        3: "0.03",
        4: "0.04",
      },
    },
  },
  plugins: [
    function ({ addUtilities }) {
      const newUtilities = {
        ".border": {
          borderWidth: "0.063rem",
          borderStyle: "solid",
        },
      };

      addUtilities(newUtilities, {
        variants: ["responsive"],
      });
    },
  ],
};
