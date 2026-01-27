
  # Terminal AI (Web Prototype)

  This directory contains the Figma-derived web prototype for the Determinal UI.
  It runs as a standalone Vite app and is not required for the macOS app build.

  The original design source is available at https://www.figma.com/design/cX4yqwuP2aT8VTPB7Z7WZq/Terminal-AI.

  ## Requirements

  - Node.js 18+ (recommended)
  - npm (or a compatible package manager)

  ## Running the code

  Install dependencies:
  ```
  npm i
  ```

  Start the dev server:
  ```
  npm run dev
  ```

  ## Building for production

  ```
  npm run build
  ```

  Output goes to `dist/`.

  ## Notes

  - This is a UI prototype bundle; it does not include the native macOS app.
  - If you see React peer dependency warnings, install `react` and `react-dom`.
  
