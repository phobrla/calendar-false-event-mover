-- Set this to true to actually move events (events will be moved),
-- or false for a dry run (no changes will be made, just print what would happen)
set run_for_real to false

set sourceCalName to "Phil Hobrla"
set destCalName to "Issues"
set calAccountName to "iCloud"

tell application "Calendar"
    -- Find the source and destination calendars by name and account name
    set sourceCal to missing value
    set destCal to missing value
    repeat with cal in calendars
        set calName to name of cal
        set calAccountNameCurrent to ""
        try
            set calAccountNameCurrent to (get account name of cal)
        end try
        if (calName is sourceCalName) and (calAccountNameCurrent is calAccountName) then
            set sourceCal to cal
        else if (calName is destCalName) and (calAccountNameCurrent is calAccountName) then
            set destCal to cal
        end if
    end repeat

    if (sourceCal is missing value) or (destCal is missing value) then
        display dialog "Could not find source or destination calendar with the given names and account." buttons {"OK"} default button "OK"
        return
    end if

    -- Get all events with description "False"
    set theEvents to every event of sourceCal whose description is "False"
    display dialog ("Found " & (count of theEvents) & " events to move with note 'False'.")

    repeat with ev in theEvents
        set evSummary to summary of ev
        set evStart to start date of ev
        set evEnd to end date of ev
        set evAllday to |all day event| of ev
        set evLoc to location of ev
        set evNote to description of ev
        set evURL to url of ev
        try
            set evRecurrence to recurrence of ev
        on error
            set evRecurrence to ""
        end try

        -- Attempt to get attendees info
        set attendeesInfo to ""
        try
            set evAttendees to attendees of ev
            if (count of evAttendees) > 0 then
                set attendeesInfo to attendeesInfo & linefeed & "Attendees:" & linefeed
                repeat with a in evAttendees
                    try
                        set attName to ""
                        set attEmail to ""
                        set attRole to ""
                        set attStatus to ""
                        try
                            set attName to |display name| of a
                        end try
                        try
                            set attEmail to email of a
                        end try
                        try
                            set attRole to role of a
                        end try
                        try
                            set attStatus to |participant status| of a
                        end try
                        set attendeesInfo to attendeesInfo & (attName & " <" & attEmail & "> (Role: " & attRole & ", Status: " & attStatus & ")") & linefeed
                    end try
                end repeat
            end if
        end try

        set fullNotes to evNote
        if attendeesInfo is not "" then
            set fullNotes to fullNotes & linefeed & attendeesInfo
        end if

        if run_for_real then
            -- Build the properties record step by step to avoid the AppleScript parser misinterpreting property names with spaces.
            set eventProps to {summary:evSummary, start date:evStart, end date:evEnd, location:evLoc, description:fullNotes, url:evURL, recurrence:evRecurrence}
            set eventProps'|all day event|' to evAllday
            set newEvent to make new event at end of events of destCal with properties eventProps
            delete ev
        else
            log "Would move event: " & evSummary & " (" & evStart & " - " & evEnd & ")"
            log "  Location: " & evLoc
            log "  URL: " & evURL
            log "  Recurrence: " & evRecurrence
            log "  Notes: " & fullNotes
            log "----------------------------------------"
        end if
    end repeat

    if run_for_real then
        display dialog "Move complete."
    else
        display dialog "Dry run finished. No events moved."
    end if
end tell
