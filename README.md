# Calendar False Event Mover

Move all events with the note "False" from one iCloud calendar to another using AppleScript.

## Features

- Finds all events in your source calendar with a description (note) of "False"
- Optionally does a dry run (no events moved, just logs what would happen)
- Moves events to your destination calendar, preserving metadata and attendee info

## Usage

1. **Edit variables at the top of `move_false_note_events.applescript`:**
    - `run_for_real`: Set to `true` to actually move events, or `false` for a dry run
    - `sourceCalName`: The name of your source calendar (e.g., "Phil Hobrla")
    - `destCalName`: The name of your destination calendar (e.g., "Issues")
    - `calAccountName`: Your calendar account name (usually "iCloud")

2. **Open the script in Script Editor and run it.**
    - You will see a dialog with the number of events found.
    - In dry run mode, details will be logged but no events are moved.
    - In run mode, events will be created in your destination calendar and deleted from the source calendar.

## Requirements

- macOS with the Calendar app
- AppleScript enabled

## Disclaimer

Use at your own risk. Always keep backups of your calendar data.
