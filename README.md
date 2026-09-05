# 2D Hook & Climb Platformer

A precision 2D platformer built with **[LÖVE](https://love2d.org/) (Love2D 11.5+)**, featuring fluid momentum-based movement, grappling hook swinging, wall climbing, and interactive level mechanics.

---

## ✨ Features

- **Precision Movement & Physics**:
  - Variable jump height, jump buffering, and coyote time for responsive controls.
  - Smooth acceleration, deceleration, and velocity clamping.
  - Wall sliding, wall jumping, and wall climbing with stamina management.
- **Grappling Hook**:
  - Latch onto anchor points and swing with pendulum physics and momentum.
- **Interactive Hazards & Props**:
  - **Trampolines**: Squash-and-stretch bounce pads that launch the player upward.
  - **Traps / Spikes**: Screen-shake death effect and smooth respawn tweening.
- **7 Handcrafted Levels**:
  - Designed using **LDtk** (Level Designer Toolkit) and loaded dynamically with custom entity triggers, collision boxes, and spawn points.
- **Save & Settings System**:
  - Persistent progress saving (current level) and settings (fullscreen, VSync) saved to JSON.
  - Dynamic "Continue" and "New Game" flows in the Main Menu.
- **Unified Controls**:
  - Seamless input handling supporting both Keyboard and Gamepad (Xbox/PlayStation/generic controllers) in gameplay and menus.
- **Audio & Visuals**:
  - Custom audio effects for walking, jumping, climbing, trampoline bouncing, hook grappling, and death.
  - Smooth camera tracking with deadzone clamping and screen-shake effects.

---

## 🎮 Controls

| Action | Keyboard | Gamepad |
| :--- | :--- | :--- |
| **Move Left / Right** | `A` / `D` or `Left` / `Right` | Left Stick / D-Pad |
| **Jump** | `Space` | `A` button |
| **Grapple Hook** | `K` | Right Trigger (`RT`) |
| **Climb** | `J` | Left Trigger (`LT`) |
| **Pause Game** | `Escape` | `Start` button |
| **Menu Navigate** | `W` / `S` or `Up` / `Down` | D-Pad / Left Stick |
| **Menu Select / Confirm** | `Return` / `Space` | `A` button |
| **Menu Back / Cancel** | `Backspace` | `B` button |

---

## 🚀 Getting Started

### Prerequisites
- Install **[LÖVE 11.5+](https://love2d.org/)** (Love2D).

### Running the Game

1. **Via Command Line**:
   Navigate to the project root directory and run:
   ```bash
   love .
   ```

2. **Via Drag & Drop (Windows / macOS)**:
   - Drag the project folder directly onto the `love` (or `love.exe`) executable or shortcut.

3. **In Visual Studio Code**:
   - Install the **Local Lua Debugger** extension.
   - Run via the configured launch task (`F5`).

---

## 📁 Project Structure

```
├── assets/
│   ├── map/             # LDtk world file (world.ldtk) and tilesets
│   ├── sounds/          # SFX (bounce, climb, death, hook, jump, walk)
│   └── sprites/         # Player animations & environment textures
├── classes/
│   ├── Trampoline.lua   # Trampoline entity with squash & stretch logic
│   └── UI/              # UI components (Button, Menu, RadioButton)
├── libraries/
│   ├── bump/            # Bump.lua (AABB collision library)
│   ├── ldtk-love/       # LDtk loader for LÖVE
│   └── tween/           # Tweening library for animations & respawns
├── camera.lua           # Smooth tracking & screenshake camera
├── conf.lua             # LÖVE window & engine configuration
├── controls.lua         # Unified keyboard & gamepad input manager
├── game.lua             # Top-level state machine (main_menu, gameplay, pause_menu)
├── gameplay.lua         # Main gameplay loop & debug HUD
├── main.lua             # LÖVE entry point callbacks
├── main_menu.lua        # Main menu and settings interface
├── map.lua              # LDtk level loading & entity callbacks
├── pause_menu.lua       # In-game pause menu
├── physics.lua          # Physics integration & Bump world management
├── player.lua           # Player controller, state machine, hook & climb physics
├── saving.lua           # JSON-based save & settings serializer
└── sounds.lua           # Audio sources and playback manager
```

---

## 🛠️ Built With

- **Engine**: [LÖVE (Love2D)](https://love2d.org/)
- **Language**: [Lua](https://www.lua.org/)
- **Level Editor**: [LDtk](https://ldtk.io/)
- **Collisions**: [Bump.lua](https://github.com/kikito/bump.lua)
- **Tweening**: [tween.lua](https://github.com/kikito/tween.lua)
