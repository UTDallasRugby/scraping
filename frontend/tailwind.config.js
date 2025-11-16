/** @type {import('tailwindcss').Config} */
export default {
  content: ['./pages/**/*.{html,js,svelte,md}', './.evidence/**/*.{html,js,svelte,md}'],
  theme: {
    extend: {
      colors: {
        'utd-orange': '#e87500',
        'utd-green': '#154734',
        'utd-silverleaf': '#5fe0b7',
      },
    },
  },
  plugins: [],
}
