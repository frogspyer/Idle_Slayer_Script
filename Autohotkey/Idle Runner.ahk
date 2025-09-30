#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

#Include "Libraries/Common.ahk"
#Include "Libraries/BonusStage.ahk"
#Include "Libraries/BossFightVictor.ahk"
#Include "Libraries/BossFightKnight.ahk"
#Include "Libraries/ChestHunt.ahk"
#Include "Libraries/AscendingHeights.ahk"

Global bAutoBuyUpgradeState := false
Global bCraftSoulBonusState := false
Global bSkipBonusStageState := false
Global bCraftRagePillState := false
Global bCirclePortalsState := false
Global bNoLockpickingState := true
Global bNoReinforcedCrystalSaverState := false
Global bBiDimensionalState := false
Global bDimensionalState := false
Global bDisableRageState := false
Global bAutoAscendState := false
Global bPerfectChestHuntState := false
Global bTogglePause := false

Global sVersion := "3.5.3"
Global iJumpSliderValue := 150
Global iCirclePortalsCount := 7
Global iAutoAscendTimer := 10
Global iAutoBuyTimer := 10
Global iAutoBuyTempTimer := 10
Global iAutoBuyLoopAmount := 0
Global iTimerAutoBuy := TimerInit()
Global iTimerAutoAscend := TimerInit()
Global iTimerFocusGame := TimerInit()
Global iLastCheckTimeLoop := TimerInit()

Global jumpState := true
Global jumpDelay := iJumpSliderValue

Global mainGui
Global startStopBtn
Global jumpSlider
Global autoAscendInput
Global autoBuyInput
Global circlePortalInput
Global statusText

setSetting()
InitUI()
LoadSettings()
ShowGUI()

Hotkey "Home", Pause
Hotkey "+Esc", IdleClose
Hotkey "^+b", AutoUpgrade

SetTimer ShootAndBoostTick, 50
SetTimer MainLoop, -10
return

InitUI() {
    Global mainGui, startStopBtn, jumpSlider, autoAscendInput, autoBuyInput, circlePortalInput, statusText

    mainGui := GuiCreate("+AlwaysOnTop", "Idle Runner v" sVersion)
    mainGui.OnEvent("Close", IdleClose)

    mainGui.AddText("Section", "General")
    mainGui.AddCheckBox("vAutoBuyUpgradeState", "Auto buy upgrades").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vAutoAscendState", "Auto ascend").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vCirclePortalsState", "Circle portals").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vDisableRageState", "Disable rage without soul bonus").OnEvent("Click", ToggleCheckbox)

    mainGui.AddText("Section xm", "Crafting")
    mainGui.AddCheckBox("vCraftSoulBonusState", "Craft soul bonus").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vCraftRagePillState", "Craft rage pill").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vDimensionalState", "Craft dimensional staff").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vBiDimensionalState", "Craft bidimensional staff").OnEvent("Click", ToggleCheckbox)

    mainGui.AddText("Section xm", "Minigames")
    mainGui.AddCheckBox("vSkipBonusStageState", "Skip bonus stage").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vNoLockpickingState", "No lockpicking (chest hunt)").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vPerfectChestHuntState", "Perfect chest hunt").OnEvent("Click", ToggleCheckbox)
    mainGui.AddCheckBox("vNoReinforcedCrystalSaverState", "No reinforced crystal saver").OnEvent("Click", ToggleCheckbox)

    mainGui.AddText("Section xm", "Jump delay (ms)")
    jumpSlider := mainGui.AddSlider("Range40-400 TickInterval20 vJumpSliderValue", iJumpSliderValue)
    jumpSlider.OnEvent("Change", UpdateSlider)

    mainGui.AddText("xm", "Auto ascend every (minutes)")
    autoAscendInput := mainGui.AddEdit("Number Limit3 w80 vAutoAscendTimer", iAutoAscendTimer)
    autoAscendInput.OnEvent("Change", UpdateTimers)

    mainGui.AddText("xm", "Auto buy every (minutes)")
    autoBuyInput := mainGui.AddEdit("Number Limit3 w80 vAutoBuyTimer", iAutoBuyTimer)
    autoBuyInput.OnEvent("Change", UpdateTimers)

    mainGui.AddText("xm", "Circle portals count")
    circlePortalInput := mainGui.AddEdit("Number Limit2 w80 vCirclePortalsCount", iCirclePortalsCount)
    circlePortalInput.OnEvent("Change", UpdateTimers)

    startStopBtn := mainGui.AddButton("Default xm w120", "Pause")
    startStopBtn.OnEvent("Click", Pause)

    mainGui.AddButton("x+m w120", "Exit").OnEvent("Click", IdleClose)

    statusText := mainGui.AddText("xm w260", "Running...")
}

ShowGUI() {
    Global mainGui
    mainGui.Show()
}

ToggleCheckbox(ctrl, info) {
    global bAutoBuyUpgradeState, bAutoAscendState, bCirclePortalsState, bDisableRageState
    global bCraftSoulBonusState, bCraftRagePillState, bDimensionalState, bBiDimensionalState
    global bSkipBonusStageState, bNoLockpickingState, bPerfectChestHuntState, bNoReinforcedCrystalSaverState
    value := ctrl.Value = 1
    switch ctrl.Name {
        case "AutoBuyUpgradeState":
            bAutoBuyUpgradeState := value
        case "AutoAscendState":
            bAutoAscendState := value
        case "CirclePortalsState":
            bCirclePortalsState := value
        case "DisableRageState":
            bDisableRageState := value
        case "CraftSoulBonusState":
            bCraftSoulBonusState := value
        case "CraftRagePillState":
            bCraftRagePillState := value
        case "DimensionalState":
            bDimensionalState := value
        case "BiDimensionalState":
            bBiDimensionalState := value
        case "SkipBonusStageState":
            bSkipBonusStageState := value
        case "NoLockpickingState":
            bNoLockpickingState := value
        case "PerfectChestHuntState":
            bPerfectChestHuntState := value
        case "NoReinforcedCrystalSaverState":
            bNoReinforcedCrystalSaverState := value
    }
    SaveSettings()
}

UpdateSlider(ctrl, info) {
    global iJumpSliderValue, jumpDelay
    iJumpSliderValue := ctrl.Value
    jumpDelay := iJumpSliderValue
    SaveSettings()
}

UpdateTimers(ctrl, info) {
    global iAutoAscendTimer, iAutoBuyTimer, iCirclePortalsCount, iAutoBuyTempTimer
    switch ctrl.Name {
        case "AutoAscendTimer":
            iAutoAscendTimer := Max(1, ctrl.Value)
        case "AutoBuyTimer":
            iAutoBuyTimer := Max(1, ctrl.Value)
            iAutoBuyTempTimer := iAutoBuyTimer
        case "CirclePortalsCount":
            iCirclePortalsCount := Max(1, ctrl.Value)
    }
    SaveSettings()
}

MainLoop() {
    Global bTogglePause, iTimerFocusGame, iLastCheckTimeLoop, bCirclePortalsState
    Global bAutoBuyUpgradeState, iAutoBuyTimer, iAutoBuyTempTimer, iTimerAutoBuy, iAutoBuyLoopAmount
    Global bAutoAscendState, iTimerAutoAscend, iAutoAscendTimer
    Global bSkipBonusStageState, bNoLockpickingState, bPerfectChestHuntState, bNoReinforcedCrystalSaverState

    Loop {
        Sleep 40
        if bTogglePause
            continue

        if TimerDiff(iTimerFocusGame) > 1800000 {
            iTimerFocusGame := TimerInit()
            WinActivate "Idle Slayer"
            ControlFocus "Idle Slayer"
        }

        if PixelFind(650, 36, 650, 36, 0xCA9700) {
            WriteInLogs("Silver Box Collected")
            MouseClick "L", 644, 49, 1, 0
        }

        if PixelFind(419, 323, 419, 323, 0xDFDEE0) {
            SyncProcess(false)
            RageWhenHorde()
            SyncProcess(true)
        }

        if PixelFind(1130, 610, 1130, 610, 0xCBCB4C) {
            SyncProcess(false)
            ClaimQuests()
            SyncProcess(true)
        }

        if PixelFind(625, 143, 629, 214, 0xA86D0A) {
            ControlFocus "Idle Slayer"
            Send "{r}"
        }

        if PixelFind(99, 113, 99, 113, 0xFFFF7A) {
            SyncProcess(false)
            CollectMinion()
            SyncProcess(true)
        }

        if TimerDiff(iLastCheckTimeLoop) >= 5000 {
            iLastCheckTimeLoop := TimerInit()
            CloseAll()

            if PixelFind(660, 254, 660, 254, 0xFFE737) && PixelFind(638, 236, 638, 236, 0xFFBB31) && PixelFind(775, 448, 775, 448, 0xFFFFFF) {
                SyncProcess(false)
                BonusStage(bSkipBonusStageState)
                SyncProcess(true)
            }

            if PixelFind(639, 224, 639, 224, 0xFF878A) && PixelFind(634, 224, 634, 224, 0xF263BD) && PixelFind(644, 224, 644, 224, 0xFFF38F) {
                SyncProcess(false)
                if PixelFind(30, 690, 30, 690, 0x0B0303) {
                    BossFightKnight()
                } else {
                    BossFightVictor()
                }
                SyncProcess(true)
            }

            if PixelFind(671, 213, 671, 213, 0xC2F4F9) && PixelFind(640, 240, 634, 640, 0xFFCC66) {
                SyncProcess(false)
                AscendingHeights()
                SyncProcess(true)
            }

            if bCirclePortalsState {
                CirclePortals()
            }

            if bAutoBuyUpgradeState {
                if TimerDiff(iTimerAutoBuy) > (iAutoBuyTempTimer * 60000) {
                    iTimerAutoBuy := TimerInit()
                    iAutoBuyTempTimer := iAutoBuyTimer
                    WinActivate "Idle Slayer"
                    if WinActive("Idle Slayer") {
                        SyncProcess(false)
                        iAutoBuyLoopAmount := 0
                        AutoUpgrade()
                        SyncProcess(true)
                    }
                }
            }

            if bAutoAscendState {
                if TimerDiff(iTimerAutoAscend) > (iAutoAscendTimer * 60000) {
                    iTimerAutoAscend := TimerInit()
                    WinActivate "Idle Slayer"
                    if WinActive("Idle Slayer") {
                        SyncProcess(false)
                        AutoAscend()
                        SyncProcess(true)
                    }
                }
            }
        }
    }
}

CloseAll() {
    Sleep 2000
    if PixelFind(680, 593, 680, 593, 0xAF0000) {
        MouseClick "L", 780, 600, 1, 0
    }
}

RageWhenHorde() {
    Global bCraftRagePillState, bCraftSoulBonusState, bDisableRageState
    soulBonus := CheckForSoulBonus()
    if soulBonus {
        if bCraftRagePillState {
            BuyTempItem(0x871646)
        }
        if bCraftSoulBonusState {
            BuyTempItem(0x7D55D8)
        }
    }
    if bDisableRageState {
        if soulBonus {
            Rage()
        }
    } else {
        Rage()
    }
}

Rage() {
    Global bDimensionalState, bBiDimensionalState
    WriteInLogs("MegaHorde Rage")
    if bDimensionalState {
        BuyTempItem(0xF37C55)
        bDimensionalState := false
        SaveSettings()
    }
    if bBiDimensionalState {
        BuyTempItem(0x526629)
        bBiDimensionalState := false
        SaveSettings()
    }
    ControlFocus "Idle Slayer"
    Send "{r}"
}

CheckForSoulBonus() {
    return PixelFind(625, 143, 629, 214, 0xA86D0A) != false
}

BuyTempItem(color) {
    WriteInLogs("Trying to CraftingTemp Item")
    MouseClick "L", 160, 100, 1, 0
    Sleep 150
    MouseClick "L", 260, 690, 1, 0
    Sleep 150
    if coords := PixelFind(43, 330, 625, 630, color) {
        MouseClick "L", coords[1], coords[2], 1, 0
        Sleep 200
        MouseClick "L", 407, 213, 1, 0
        WriteInLogs("CraftingTemp Item Active")
    } else {
        WriteInLogs("CraftingTemp Item Failed, not enough materials")
    }
    MouseClick "L", 440, 690, 1, 0
    Sleep 100
}

AutoAscend() {
    if PixelFind(260, 600, 260, 600, 0x58188D) {
        MouseClick "L", 260, 600, 1, 0
        Sleep 300
        MouseClick "L", 550, 580, 1, 0
        Sleep 300
        AutoUpgrade()
    } else {
        MouseClick "L", 95, 90, 1, 0
        Sleep 400
        MouseClick "L", 93, 680, 1, 0
        Sleep 400
        if PixelFind(260, 600, 260, 600, 0x58188D) {
            MouseClick "L", 260, 600, 1, 0
            Sleep 300
            MouseClick "L", 550, 580, 1, 0
            Sleep 300
            AutoUpgrade()
        }
    }
}

CollectMinion() {
    MouseClick "L", 95, 90, 1, 0
    Sleep 400
    MouseClick "L", 93, 680, 1, 0
    Sleep 200
    MouseClick "L", 193, 680, 1, 0
    Sleep 200
    MouseClick "L", 691, 680, 1, 0
    Sleep 200
    MouseClick "L", 332, 680, 1, 0
    Sleep 200

    if PixelFind(370, 410, 910, 470, 0x11AA23, 9) {
        MouseClick "L", 320, 280, 5, 0
        Sleep 200
        MouseClick "L", 320, 280, 5, 0
        Sleep 200
        MouseClick "L", 320, 180, 5, 0
        Sleep 200
        WriteInLogs("Minions Collect with Daily Bonus")
    } else {
        MouseClick "L", 318, 182, 5, 0
        Sleep 200
        MouseClick "L", 318, 182, 5, 0
        Sleep 200
        WriteInLogs("Minions Collect")
    }

    MouseClick "L", 570, 694, 1, 0
}

CirclePortals() {
    if !PixelFind(1180, 166, 1180, 166, 0x830399) && !PixelFind(1180, 166, 1180, 166, 0x290130)
        return

    if !PixelFind(1154, 144, 1210, 155, 0xFFFFFF, 9) {
        SyncProcess(false)
        MouseClick "L", 1180, 150, 1, 0
        Sleep 200
        MouseClick "L", 928, 682, 1, 0
        Sleep 200
        Loop iCirclePortalsCount {
            MouseClick "L", 1102, 412, 1, 0
            Sleep 1200
        }
        MouseClick "L", 1180, 150, 1, 0
        Sleep 200
        SyncProcess(true)
    }
}

AutoUpgrade() {
    Global iAutoBuyLoopAmount
    WriteInLogs("AutoUpgrade Active")
    MouseClick "L", 1244, 712, 1, 0
    Sleep 150
    MouseClick "L", 1163, 655, 1, 0
    Sleep 150
    if PixelFind(807, 140, 807, 155, 0xFFFFFF) {
        BuyUpgrade()
    }
}

BuyEquipment() {
    Global iAutoBuyLoopAmount
    MouseClick "L", 850, 690, 1, 0
    Sleep 50
    MouseClick "L", 1180, 636, 4, 0
    if PixelFind(1257, 340, 1257, 340, 0x11AA23) {
        MouseClick "L", 1200, 200, 5, 0
    } else {
        MouseClick "L", 1253, 592, 5, 0
        Sleep 200
    }
    while true {
        if coords := PixelFind(1160, 590, 1160, 170, 0x11AA23, 10) {
            MouseClick "L", 850, 690, 1, 0
            MouseClick "L", coords[1], coords[2], 5, 0
        } else {
            MouseMove 1260, 170, 0
            MouseWheel "Up", 1
            if !PixelFind(1260, 168, 1260, 168, 0xD6D6D6)
                break
            Sleep 10
        }
    }
    BuyUpgrade()
}

BuyUpgrade() {
    Global iAutoBuyLoopAmount
    MouseClick "L", 927, 683, 1, 0
    Sleep 150
    MouseMove 1254, 172, 0
    Loop {
        MouseWheel "Up", 20
    } until !PixelFind(1254, 167, 1254, 167, 0xD6D6D6)
    Sleep 400
    bought := false
    y := 170
    while true {
        if PixelFind(882, y, 909, y + 72, 0xF4B41B)
            y += 96
        if PixelFind(882, y, 909, y + 72, 0xE478FF)
            y += 96
        if !(PixelFind(1180, y + 10, 1180, y + 10, 0x11A622) || PixelFind(1180, y + 10, 1180, y + 10, 0x0C7418))
            break
        bought := true
        MouseClick "L", 1180, y, 1, 0
        Sleep 50
    }
    if bought && iAutoBuyLoopAmount < 6 {
        iAutoBuyLoopAmount++
        BuyEquipment()
    } else {
        MouseClick "L", 1222, 677, 1, 0
    }
}

ClaimQuests() {
    MouseClick "L", 1244, 712, 1, 0
    Sleep 150
    MouseClick "L", 1163, 655, 1, 0
    Sleep 150
    MouseClick "L", 850, 690, 1, 0
    MouseClick "L", 927, 683, 1, 0
    Sleep 150
    MouseClick "L", 1000, 690, 1, 0
    Sleep 50
    MouseMove 1254, 272, 0
    Loop {
        MouseWheel "Up", 20
    } until !PixelFind(1254, 267, 1254, 267, 0xD6D6D6)
    Sleep 600
    while true {
        if coords := PixelFind(1160, 270, 1160, 590, 0x11A622, 10) {
            WriteInLogs("Quest Claimed")
            MouseClick "L", coords[1], coords[2], 1, 0
        } else {
            MouseMove 1267, 270, 0
            MouseWheel "Down", 1
            if PixelFind(1267, 655, 1267, 655, 0xFFFFFF)
                break
            Sleep 100
        }
    }
    MouseClick "L", 1244, 712, 1, 0
}

ShootAndBoostTick() {
    Global jumpState, jumpDelay, bTogglePause
    static lastTick := 0
    if bTogglePause
        return
    if !jumpState
        return
    if (A_TickCount - lastTick) < jumpDelay
        return
    lastTick := A_TickCount
    if !WinActive("Idle Runner")
        ControlFocus "Idle Slayer"
    Send "{Up}{Right}"
}

SyncProcess(state := true) {
    Global jumpState, bTogglePause
    jumpState := state && !bTogglePause
}

Pause(*) {
    Global bTogglePause, startStopBtn, statusText
    bTogglePause := !bTogglePause
    if bTogglePause {
        startStopBtn.Text := "Resume"
        statusText.Text := "Paused"
    } else {
        startStopBtn.Text := "Pause"
        statusText.Text := "Running..."
    }
    SyncProcess(!bTogglePause)
}

IdleClose(*) {
    ExitApp
}

LoadSettings() {
    Global bAutoBuyUpgradeState, bCraftSoulBonusState, bSkipBonusStageState, bCraftRagePillState
    Global bCirclePortalsState, bNoLockpickingState, bNoReinforcedCrystalSaverState, bBiDimensionalState
    Global bDimensionalState, bDisableRageState, bAutoAscendState, bPerfectChestHuntState
    Global iJumpSliderValue, iCirclePortalsCount, iAutoAscendTimer, iAutoBuyTimer, iAutoBuyTempTimer

    ini := A_ScriptDir "\\IdleRunnerLogs\\Settings.ini"
    settings := Map(
        "AutoBuyTimer", iAutoBuyTimer,
        "AutoAscendTimer", iAutoAscendTimer,
        "AutoAscendState", bAutoAscendState,
        "AutoBuyUpgradeState", bAutoBuyUpgradeState,
        "CraftSoulBonusState", bCraftSoulBonusState,
        "SkipBonusStageState", bSkipBonusStageState,
        "CraftRagePillState", bCraftRagePillState,
        "CirclePortalsState", bCirclePortalsState,
        "JumpSliderValue", iJumpSliderValue,
        "NoLockpickingState", bNoLockpickingState,
        "CirclePortalsCount", iCirclePortalsCount,
        "DimensionalState", bDimensionalState,
        "BiDimensionalState", bBiDimensionalState,
        "DisableRageState", bDisableRageState,
        "NoReinforcedCrystalSaverState", bNoReinforcedCrystalSaverState,
        "PerfectChestHuntState", bPerfectChestHuntState
    )

    for key, default in settings {
        value := IniRead(ini, "Settings", key, default)
        if value = "True"
            value := true
        else if value = "False"
            value := false
        else if RegExMatch(value, "^-?\d+$")
            value := Integer(value)
        %key% := value
    }

    iAutoBuyTempTimer := iAutoBuyTimer
    jumpDelay := iJumpSliderValue
    RefreshGUIControls()
}

SaveSettings() {
    Global bAutoBuyUpgradeState, bCraftSoulBonusState, bSkipBonusStageState, bCraftRagePillState
    Global bCirclePortalsState, bNoLockpickingState, bNoReinforcedCrystalSaverState, bBiDimensionalState
    Global bDimensionalState, bDisableRageState, bAutoAscendState, bPerfectChestHuntState
    Global iJumpSliderValue, iCirclePortalsCount, iAutoAscendTimer, iAutoBuyTimer

    ini := A_ScriptDir "\\IdleRunnerLogs\\Settings.ini"
    if !DirExist(A_ScriptDir "\\IdleRunnerLogs")
        DirCreate A_ScriptDir "\\IdleRunnerLogs"

    data := Map(
        "AutoBuyTimer", iAutoBuyTimer,
        "AutoAscendTimer", iAutoAscendTimer,
        "AutoAscendState", bAutoAscendState,
        "AutoBuyUpgradeState", bAutoBuyUpgradeState,
        "CraftSoulBonusState", bCraftSoulBonusState,
        "SkipBonusStageState", bSkipBonusStageState,
        "CraftRagePillState", bCraftRagePillState,
        "CirclePortalsState", bCirclePortalsState,
        "JumpSliderValue", iJumpSliderValue,
        "NoLockpickingState", bNoLockpickingState,
        "CirclePortalsCount", iCirclePortalsCount,
        "DimensionalState", bDimensionalState,
        "BiDimensionalState", bBiDimensionalState,
        "DisableRageState", bDisableRageState,
        "NoReinforcedCrystalSaverState", bNoReinforcedCrystalSaverState,
        "PerfectChestHuntState", bPerfectChestHuntState
    )

    for key, value in data {
        IniWrite(value, ini, "Settings", key)
    }
}

RefreshGUIControls() {
    Global mainGui, jumpSlider, autoAscendInput, autoBuyInput, circlePortalInput
    Global bAutoBuyUpgradeState, bCraftSoulBonusState, bSkipBonusStageState, bCraftRagePillState
    Global bCirclePortalsState, bNoLockpickingState, bNoReinforcedCrystalSaverState, bBiDimensionalState
    Global bDimensionalState, bDisableRageState, bAutoAscendState, bPerfectChestHuntState
    Global iJumpSliderValue, iCirclePortalsCount, iAutoAscendTimer, iAutoBuyTimer

    if !IsSet(mainGui)
        return

    mainGui["AutoBuyUpgradeState"].Value := bAutoBuyUpgradeState ? 1 : 0
    mainGui["AutoAscendState"].Value := bAutoAscendState ? 1 : 0
    mainGui["CirclePortalsState"].Value := bCirclePortalsState ? 1 : 0
    mainGui["DisableRageState"].Value := bDisableRageState ? 1 : 0
    mainGui["CraftSoulBonusState"].Value := bCraftSoulBonusState ? 1 : 0
    mainGui["CraftRagePillState"].Value := bCraftRagePillState ? 1 : 0
    mainGui["DimensionalState"].Value := bDimensionalState ? 1 : 0
    mainGui["BiDimensionalState"].Value := bBiDimensionalState ? 1 : 0
    mainGui["SkipBonusStageState"].Value := bSkipBonusStageState ? 1 : 0
    mainGui["NoLockpickingState"].Value := bNoLockpickingState ? 1 : 0
    mainGui["PerfectChestHuntState"].Value := bPerfectChestHuntState ? 1 : 0
    mainGui["NoReinforcedCrystalSaverState"].Value := bNoReinforcedCrystalSaverState ? 1 : 0

    jumpSlider.Value := iJumpSliderValue
    autoAscendInput.Value := iAutoAscendTimer
    autoBuyInput.Value := iAutoBuyTimer
    circlePortalInput.Value := iCirclePortalsCount
}
