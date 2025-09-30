#Requires AutoHotkey v2.0
#Include "Common.ahk"

AscendingHeights() {
    WriteInLogs("Start of Ascending Heights")
    Loop {
        Slider()
        Sleep 500
        if !PixelFind(640, 240, 634, 640, 0xFFCC66)
            break
    }
    Sleep 3900
    AscendingHeightsPlay()
}

AscendingHeightsPlay() {
    posPlatX := 0
    posPlatY := 0
    repeatCount := 0
    samePlatform := false
    lastCheck := TimerInit()
    startTime := TimerInit()
    while true {
        if TimerDiff(startTime) >= 240000 {
            WriteInLogs("Ascending Heights timed out after 4 minutes")
            cSend(3000, 0, "a")
            Sleep 100
            cSend(3000, 0, "d")
            break
        }

        if TimerDiff(lastCheck) >= 5000 {
            lastCheck := TimerInit()
            if PixelFind(190, 125, 190, 125, 0xFFAF36) {
                WriteInLogs("Ascending Height Failed")
                break
            }
            if PixelFind(540, 560, 540, 560, 0x00A400) {
                Sleep 2000
                MouseClick "L", 560, 570, 1, 0
            }
            if PixelFind(700, 385, 730, 385, 0x7A444A) {
                cSend(15000, 0, "d")
                WriteInLogs("Ascending Height Won")
                break
            }
        }

        if !(posPlayer := PixelFind(375, 260, 900, 730, 0x633E75))
            continue

        if !(posPlatform := searchAllPlatformBellowPlayer(posPlayer[1], posPlayer[2], samePlatform))
            continue

        if (posPlatX = posPlatform[1] && posPlatY = posPlatform[2]) {
            repeatCount += 1
            if repeatCount = 5
                samePlatform := true
        } else {
            repeatCount := 0
            samePlatform := false
        }
        posPlatX := posPlatform[1]
        posPlatY := posPlatform[2]

        if (posPlatform[1] + 35) > (posPlayer[1] + 35) {
            MouseMove 1100, 600, 0
            MouseDown "L"
            Sleep 100
            MouseUp "L"
        } else if (posPlatform[1] + 35) < (posPlayer[1] - 35) {
            MouseMove 100, 600, 0
            MouseDown "L"
            Sleep 100
            MouseUp "L"
        }
    }
}

searchAllPlatformBellowPlayer(playerX, playerY, samePlatform) {
    if !samePlatform {
        left := playerX - 130
        right := playerX + 130
        if left < 375
            left := 375
        if right > 900
            right := 900
        posPlatform := PixelFind(left, playerY + 50, right, 752, 0xC0CBDC)
        if !posPlatform
            posPlatform := PixelFind(375, playerY + 50, 900, 752, 0xC0CBDC)
    } else {
        posPlatform := PixelFind(375, playerY + 50, 900, 752, 0xC0CBDC)
    }

    if posPlatform {
        loopCount := 0
        while true {
            loopCount += 1
            if loopCount > 1000
                return false
            if !PixelFind(posPlatform[1] + 6, posPlatform[2], posPlatform[1] + 6, posPlatform[2], 0x8B9BB4)
                return posPlatform
            if posPlatform[2] + 2 > 752
                return false
            posPlatform := PixelFind(375, posPlatform[2] + 1, 900, 752, 0xC0CBDC)
            if !posPlatform
                return false
        }
    }
    return posPlatform
}
