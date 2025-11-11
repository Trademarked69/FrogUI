# FrogOS - MinUI-Style File Browser for Multicore

FrogOS is a libretro core that provides a simple file browser interface for the SF2000/GB300 multicore system. It's designed to mimic the MinUI interface and allows you to browse and launch games directly from the device.

📖 **[How to Use Guide](HOW_TO_USE.md)** - Complete setup and usage instructions

## Features

- **Folder-Only Root View**: The main `/mnt/sda1/ROMS` directory only shows folders, keeping your interface clean
- **File Browsing**: Navigate into any console folder to see and select game files
- **MinUI-Style Interface**: Simple, clean design inspired by MinUI
- **D-Pad Navigation**: Use Up/Down to select, A to open/launch, B to go back
- **Automatic Integration**: Works seamlessly with the multicore boot system

## How It Works

### Directory Navigation
- When you start FrogOS, it shows only the folders in `/mnt/sda1/ROMS`
- Use **D-Pad Up/Down** to select a folder
- Press **A** to enter a folder
- Inside a folder, you'll see both subdirectories and game files
- Press **B** to go back to the parent directory

### Launching Games
- When you select a game file and press **A**, FrogOS will:
  1. Determine which core to use based on the parent folder name
  2. Write the launch information to `/mnt/sda1/frogos_boot.txt`
  3. Request a shutdown to trigger the game launch

## Installation

### Building
```bash
# From the multicore root directory
make CONSOLE=frogos CORE=cores/FrogOS
```

This will create:
- `cores/FrogOS/_libretro_sf2000.a` - The core library
- `core_87000000` - The loadable core binary
- `sdcard/cores/frogos/core_87000000` - Installed core

### Setting Up Boot-on-Startup

To make FrogOS launch automatically when the device boots, you need to create a stub file that multicore recognizes.

**Option 1: Create a stub .gba file in any ROMS folder**
```bash
# Create an empty dummy ROM in a ROMS subfolder
touch /mnt/sda1/ROMS/gba/frogos;launcher.gba
```

The multicore loader parses filenames in the format: `[corename];[filename].gba`
- When it sees `frogos;launcher.gba`, it will load the `frogos` core with `launcher` as the ROM name

**Option 2: Modify main.c to auto-boot FrogOS**
You can modify the multicore loader to automatically launch FrogOS if no game is selected or on first boot.

## Technical Details

### Screen Resolution
- 320x240 pixels
- RGB565 color format

### Input Handling
- Supports RETRO_DEVICE_JOYPAD on port 0
- Button mapping:
  - Up/Down: Navigate menu
  - A: Select/Enter
  - B: Back

### File System
- Uses custom `dirent.h` implementation for SF2000
- Scans `/mnt/sda1/ROMS` for directories and files
- Maximum 256 entries per directory

### Core Integration
- No ROM loading required (supports `RETRO_ENVIRONMENT_SET_SUPPORT_NO_GAME`)
- Runs at 60 FPS
- No audio output
- No save states needed

## Directory Structure
```
/mnt/sda1/
├── ROMS/
│   ├── gba/          <- FrogOS shows this folder
│   ├── nes/          <- And this folder
│   ├── snes/         <- etc.
│   └── ...
├── cores/
│   └── frogos/
│       └── core_87000000
└── frogos_boot.txt   <- Created when launching a game
```

## Future Enhancements

Potential features for future versions:
- Better font rendering with actual bitmap fonts
- Icons for different file types
- Favorites/recently played list
- Settings menu
- Preview images for games
- Search functionality
- Multi-column layout for more entries visible at once

## License

This core is part of the multicore project and follows the same license terms.

## Credits

- Inspired by MinUI's clean interface design
- Built on the SF2000/GB300 multicore framework
- Uses the custom SF2000 filesystem implementation
