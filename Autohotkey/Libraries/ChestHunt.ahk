#Requires AutoHotkey v2.0
#Include "Common.ahk"

RewardChest := 0
MimicChest := 1
DoubleChest := 2
ChestHuntEnd := 3
LifeSaverChest := 4

StateNoMimic := 0
StateOneMimic := 1
StateTwoMimics := 2
StateOpenLifeSaver := 3
StateNormal := 4

Chesthunt(noLockpickingState, perfectChestHuntState, noReinforcedCrystalSaverState) {
    global RewardChest, MimicChest, DoubleChest, ChestHuntEnd, LifeSaverChest
    global StateNoMimic, StateOneMimic, StateTwoMimics, StateOpenLifeSaver, StateNormal
    currentState := StateNoMimic
    WriteInLogs("Chesthunt")
    Sleep noLockpickingState ? 4000 : 2000
    saverX := 0
    saverY := 0
    pixelX := 185
    pixelY := 325
    foundSaver := false
    Loop 3 {
        Loop 10 {
            if PixelFind(pixelX, pixelY - 1, pixelX + 5, pixelY, 0xFFEB04) {
                saverX := pixelX
                saverY := pixelY
                foundSaver := true
                Break 2
            }
            pixelX += 95
        }
        pixelY += 95
        pixelX := 185
    }

    pixelX := 185
    pixelY := 325
    count := 0
    Loop 3 {
        Loop 10 {
            if pixelY = saverY && pixelX = saverX {
                if A_Index = 10 {
                    Break 1
                } else {
                    pixelX += 95
                    continue
                }
            }

            chestResult := OpenChest(pixelX, pixelY, noLockpickingState)
            if chestResult = ChestHuntEnd {
                Break 2
            }

            currentState := GetUpdatedState(count, currentState, chestResult, perfectChestHuntState, noReinforcedCrystalSaverState)
            if currentState = StateOpenLifeSaver {
                currentState := OpenLifeSaver(saverX, saverY, noLockpickingState)
            }

            pixelX += 95
            count += 1
        }
        pixelY += 95
        pixelX := 185
    }

    perfectChest := false
    while true {
        Sleep 50
        if PixelFind(500, 694, 500, 694, 0xAF0000)
            break
        if PixelFind(457, 439, 457, 439, 0xF68F37) {
            perfectChest := true
            MouseClick "L", 457, 439, 1, 0
        }
    }

    if perfectChest
        WriteInLogs("Perfect ChestHunt Completed")
    MouseClick "L", 643, 693, 1, 0
}

GetUpdatedState(count, currentState, chest, perfectChestHuntState, noReinforcedCrystalSaverState) {
    global RewardChest, MimicChest, DoubleChest, LifeSaverChest
    global StateNoMimic, StateOneMimic, StateTwoMimics, StateOpenLifeSaver, StateNormal

    if currentState = StateNormal || chest = LifeSaverChest
        return StateNormal

    if chest = DoubleChest
        return StateOpenLifeSaver

    if perfectChestHuntState {
        perfectState := PerfectChestHuntState(chest, currentState, count)
        if perfectState != -1
            return perfectState
    }

    if count = 0 {
        if noReinforcedCrystalSaverState
            return StateOpenLifeSaver
        switch chest {
            case RewardChest:
                return StateNoMimic
            case MimicChest:
                return StateOneMimic
        }
    } else if count = 1 {
        if !perfectChestHuntState
            return StateOpenLifeSaver
        switch currentState {
            case StateNoMimic:
                switch chest {
                    case RewardChest:
                        return StateNoMimic
                    case MimicChest:
                        return StateOneMimic
                }
            case StateOneMimic:
                switch chest {
                    case RewardChest:
                        return StateOneMimic
                    case MimicChest:
                        return StateTwoMimics
                }
        }
    }
    return currentState
}

PerfectChestHuntState(chest, currentState, count) {
    global RewardChest, StateNoMimic, StateOneMimic, StateTwoMimics, StateOpenLifeSaver
    if chest = RewardChest {
        if currentState = StateNoMimic && count = 13
            return StateOpenLifeSaver
        if currentState = StateOneMimic && count = 15
            return StateOpenLifeSaver
        if currentState = StateTwoMimics && count = 21
            return StateOpenLifeSaver
    }
    return -1
}

OpenLifeSaver(saverX, saverY, noLockpickingState) {
    global LifeSaverChest
    MouseClick "L", saverX + 33, saverY - 23, 1, 0
    Sleep noLockpickingState ? 1500 : 550
    return LifeSaverChest
}

OpenChest(pixelX, pixelY, noLockpickingState) {
    global RewardChest, MimicChest, DoubleChest, ChestHuntEnd
    MouseClick "L", pixelX + 33, pixelY - 23, 1, 0
    Sleep noLockpickingState ? 1500 : 550
    if PixelFind(500, 694, 500, 694, 0xAF0000)
        return ChestHuntEnd
    if PixelFind(500, 210, 500, 210, 0x00FF00) {
        Sleep 1000
        return DoubleChest
    }
    if PixelFind(434, 211, 434, 211, 0xFF0000) {
        Sleep noLockpickingState ? 2500 : 1500
        return MimicChest
    }
    return RewardChest
}
