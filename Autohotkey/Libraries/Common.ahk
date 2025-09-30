#Requires AutoHotkey v2.0

setSetting() {
    ; Enable GUI events - not directly applicable in AHK v2 but keep placeholder
    ; Ensure CapsLock remains off for consistent background input
    SetCapsLockState "AlwaysOff"
    SetTitleMatchMode 2
    ; Use window-relative coordinates for pixel/mouse operations
    CoordMode "Pixel", "Window"
    CoordMode "Mouse", "Window"
    ; Attempt to switch the Idle Slayer window to the US keyboard layout
    if WinExist("Idle Slayer") {
        hwnd := WinExist()
        hkl := DllCall("LoadKeyboardLayout", "Str", "00000409", "UInt", 1, "Ptr")
        if (hkl) {
            PostMessage 0x50, 0, hkl,, "ahk_id " hwnd  ; WM_INPUTLANGCHANGEREQUEST
        }
    }
}

TimerInit() {
    return A_TickCount
}

TimerDiff(timerRef) {
    return A_TickCount - timerRef
}

WriteInLogs(message) {
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    logDir := A_ScriptDir "\\IdleRunnerLogs"
    if !DirExist(logDir) {
        DirCreate logDir
    }
    FileAppend(Format("[{1}] {2}`n", timestamp, message), logDir "\\Logs.txt", "UTF-8")
}

cSend(pressDelay, postPressDelay := 0, key := "Up") {
    Send "{" key " Down}"
    Sleep pressDelay
    Send "{" key " Up}"
    Sleep postPressDelay
}

FindPixelUntilFound(x1, y1, x2, y2, color, timer := 15000, variation := 0) {
    start := A_TickCount
    Loop {
        if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, color, variation) {
            return [foundX, foundY]
        }
        if (A_TickCount - start) > timer {
            return false
        }
        Sleep 10
    }
}

PixelFind(x1, y1, x2, y2, color, variation := 0) {
    if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, color, variation) {
        return [foundX, foundY]
    }
    return false
}

Slider() {
    if PixelSearch(&x, &y, 443, 560, 443, 560, 0x007E00) {
        MouseMove 840, 560, 0
        MouseClickDrag "L", 840, 560, 450, 560, 0
        return
    }

    if PixelSearch(&x, &y, 443, 620, 443, 620, 0x007E00) {
        MouseMove 840, 620, 0
        MouseClickDrag "L", 840, 620, 450, 620, 0
        return
    }

    if PixelSearch(&x, &y, 850, 560, 850, 560, 0x007E00) {
        MouseMove 450, 560, 0
        MouseClickDrag "L", 450, 560, 840, 560, 0
        return
    }

    if PixelSearch(&x, &y, 850, 620, 850, 620, 0x007E00) {
        MouseMove 450, 620, 0
        MouseClickDrag "L", 450, 620, 840, 620, 0
        return
    }
}
