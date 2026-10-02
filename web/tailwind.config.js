/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        background: '#0F1117',
        surface: '#1A1D26',
        surfaceLight: '#242836',
        card: '#1E222D',
        cardBorder: '#2D3342',
        fireRed: '#E53935',
        fireRedLight: '#FF5252',
        orangeAccent: '#FF7043',
        yellowWarning: '#FFB300',
        greenSuccess: '#43A047',
        textPrimary: '#F3F4F6',
        textSecondary: '#9CA3AF',
        textMuted: '#6B7280',
      }
    },
  },
  plugins: [],
}
