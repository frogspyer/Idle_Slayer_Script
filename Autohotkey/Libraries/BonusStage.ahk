#Requires AutoHotkey v2.0
#Include "Common.ahk"

BonusStage(skipBonusStageState) {
    WriteInLogs("Start of BonusStage")
    Sleep 200
    bonusStage3 := PixelFind(200, 505, 200, 505, 0x111014) ? true : false
    Loop {
        Slider()
        Sleep 500
        if !PixelFind(775, 448, 775, 448, 0xFFFFFF)
            break
    }
    if skipBonusStageState {
        BonusStageDoNothing(bonusStage3 ? 3 : 2)
        return
    }
    Sleep 3900
    if PixelFind(454, 91, 454, 91, 0xE1E0E2) {
        if bonusStage3 {
            BonusStage3SB()
        } else {
            BonusStage2SB()
        }
    } else {
        if bonusStage3 {
            BonusStage3()
        } else {
            BonusStage2()
        }
    }
}

BonusStageDoNothing(number) {
    WriteInLogs("Do nothing BonusStage Active")
    Loop {
        Sleep 200
        if BonusStageFail(number)
            break
    }
}

BonusStageFail(number) {
    logMsg := "BonusStage" number " Failed"
    if PixelFind(780, 600, 780, 600, 0xAD0000) {
        MouseClick "L", 721, 577, 1, 0
        WriteInLogs(logMsg)
        return true
    }
    if PixelFind(780, 600, 780, 600, 0xB40000) {
        MouseClick "L", 721, 577, 1, 0
        WriteInLogs(logMsg)
        return true
    }
    return false
}

BonusStageRetry(number, spiritBoost) {
    logMsg := "BonusStage" number (spiritBoost ? "SB" : "")
    if PixelFind(615, 590, 615, 590, 0x00A400) {
        MouseClick "L", 560, 600, 1, 0
        WriteInLogs(logMsg " Retry")
        Sleep 1000
        return true
    }
    return false
}

BonusStage2Fail() {
    return BonusStageFail(2)
}

BonusStage3Fail(spiritBoost) {
    logMsg := GetBS3LogText(spiritBoost)
    if BonusStageRetry(3, spiritBoost)
        return true
    if PixelFind(1130, 604, 1130, 604, 0x989898) {
        WriteInLogs(logMsg " Failed")
        return true
    }
    if PixelFind(115, 570, 125, 590, 0x09439b) {
        WriteInLogs(logMsg " Failed")
        return true
    }
    if PixelFind(115, 570, 125, 590, 0x099b66) {
        WriteInLogs(logMsg " Failed")
        return true
    }
    return false
}

BonusStage2SB() {
    WriteInLogs("BonusStage2SB")
    FindPixelUntilFound(220, 465, 220, 465, 0xA0938E)
    Sleep 200
    cSend(94, 1640)
    cSend(47, 2072)
    cSend(187, 688)
    cSend(31, 672)
    cSend(31, 1700)
    cSend(94, 1640)
    cSend(47, 2072)
    cSend(187, 688)
    cSend(31, 672)
    cSend(31, 1700)
    cSend(94, 5000)
    if BonusStage2Fail()
        return
    cSend(40, 2500)
    Loop 19 {
        Send "{Up}"
        Sleep 500
    }
    if BonusStage2Fail()
        return
    WriteInLogs("BonusStage2SB Section 1 Complete")
    FindPixelUntilFound(780, 536, 780, 536, 0xBB26DF)
    cSend(156, 719)
    cSend(47, 687)
    cSend(360, 1390)
    cSend(485, 344)
    cSend(406, 749)
    cSend(78, 600)
    cSend(94, 900)
    cSend(109, 954)
    cSend(31, 672)
    cSend(515, 1344)
    cSend(484, 297)
    cSend(406, 749)
    cSend(78, 600)
    cSend(94, 900)
    cSend(109, 954)
    cSend(31, 672)
    cSend(515, 1344)
    cSend(469, 219)
    cSend(297, 750)
    cSend(156, 500)
    cSend(110, 3000)
    cSend(360, 2984)
    cSend(531, 2313)
    if BonusStage2Fail()
        return
    cSend(350, 1000)
    Loop 20 {
        Send "{Up}"
        Sleep 500
    }
    if BonusStage2Fail()
        return
    WriteInLogs("BonusStage2SB Section 2 Complete")
    FindPixelUntilFound(220, 465, 220, 465, 0xA0938E)
    cSend(109, 1203)
    cSend(31, 641)
    cSend(47, 1200)
    cSend(1, 3100)
    cSend(109, 1203)
    cSend(31, 641)
    cSend(47, 1200)
    cSend(1, 3100)
    cSend(109, 1203)
    cSend(31, 641)
    cSend(47, 1200)
    cSend(1, 3100)
    cSend(109, 1203)
    cSend(31, 641)
    cSend(47, 5125)
    if BonusStage2Fail()
        return
    cSend(900, 200)
    Loop 20 {
        Send "{Up}"
        Sleep 500
    }
    if BonusStage2Fail()
        return
    WriteInLogs("BonusStage2SB Section 3 Complete")
    FindPixelUntilFound(250, 472, 100, 250, 0x0D2030)
    Sleep 200
    cSend(32, 2800)
    cSend(31, 809)
    cSend(41, 1200)
    cSend(100, 900)
    cSend(641, 500)
    cSend(31, 850)
    cSend(41, 770)
    cSend(641, 400)
    cSend(31, 850)
    cSend(41, 870)
    cSend(641, 300)
    cSend(31, 850)
    cSend(41, 790)
    cSend(641, 400)
    cSend(31, 850)
    cSend(41, 840)
    cSend(641, 300)
    cSend(31, 850)
    cSend(41, 840)
    cSend(641, 300)
    Loop 23 {
        Send "{Up}"
        Sleep 500
    }
    if BonusStage2Fail()
        return
    WriteInLogs("BonusStage2SB Section 4 Complete")
}

BonusStage2() {
    WriteInLogs("BonusStage2")
    FindPixelUntilFound(220, 465, 220, 465, 0xA0938E)
    Sleep 200
    cSend(94, 1640)
    cSend(32, 1218)
    cSend(94, 600)
    cSend(109, 1828)
    cSend(63, 640)
    cSend(47, 688)
    cSend(78, 1906)
    cSend(141, 1625)
    cSend(47, 3187)
    cSend(47, 734)
    cSend(47, 750)
    cSend(78, 1203)
    cSend(110, 5000)
    if BonusStage2Fail()
        return
    cSend(40, 5000)
    Loop 17 {
        Send "{Up}"
        Sleep 500
    }
    if BonusStage2Fail()
        return
    WriteInLogs("BonusStage2 Section 1 Complete")
    FindPixelUntilFound(780, 536, 780, 536, 0xBB26DF)
    cSend(156, 719)
    cSend(47, 687)
    cSend(360, 1390)
    cSend(485, 344)
    cSend(406, 749)
    cSend(78, 600)
    cSend(94, 900)
    cSend(109, 954)
    cSend(31, 672)
    cSend(515, 1344)
    cSend(484, 297)
    cSend(406, 749)
    cSend(78, 600)
    cSend(94, 900)
    cSend(109, 954)
    cSend(31, 672)
    cSend(515, 1344)
    cSend(469, 219)
    cSend(297, 750)
    cSend(156, 500)
    cSend(110, 3000)
    cSend(360, 2984)
    cSend(531, 2313)
    if BonusStage2Fail()
        return
    cSend(350, 1000)
    Loop 20 {
        Send "{Up}"
        Sleep 500
    }
    if BonusStage2Fail()
        return
    WriteInLogs("BonusStage2 Section 2 Complete")
    FindPixelUntilFound(220, 465, 220, 465, 0xA0938E)
    cSend(109, 1203)
    cSend(31, 641)
    cSend(47, 1578)
    cSend(47, 2437)
    cSend(109, 1203)
    cSend(31, 641)
    cSend(47, 1578)
    cSend(47, 2437)
    cSend(109, 1203)
    cSend(31, 641)
    cSend(47, 1578)
    cSend(47, 2437)
    cSend(109, 1203)
    cSend(31, 641)
    cSend(47, 5125)
    if BonusStage2Fail()
        return
    cSend(900, 200)
    Loop 20 {
        Send "{Up}"
        Sleep 500
    }
    if BonusStage2Fail()
        return
    WriteInLogs("BonusStage2 Section 3 Complete")
    FindPixelUntilFound(250, 472, 100, 250, 0x0D2030)
    Sleep 200
    cSend(32, 1375)
    cSend(641, 690)
    cSend(41, 1375)
    cSend(41, 1374)
    cSend(641, 690)
    cSend(41, 1373)
    cSend(41, 2500)
    cSend(31, 809)
    cSend(41, 1375)
    cSend(41, 1374)
    cSend(641, 690)
    cSend(41, 1373)
    cSend(41, 1372)
    cSend(641, 690)
    cSend(41, 1371)
    cSend(41)
    Loop 23 {
        Send "{Up}"
        Sleep 500
    }
    if BonusStage2Fail()
        return
    WriteInLogs("BonusStage2 Section 4 Complete")
}

BonusStage3(currentSection := 0) {
    totalSections := 4
    if currentSection = 0 {
        WriteInLogs("BonusStage3")
    } else if currentSection >= 2 * totalSections {
        return
    }
    section := Mod(currentSection, totalSections)
    if section = 0 {
        if !BonusStage3Section1()
            return BonusStage3(currentSection + totalSections)
        currentSection += 1
        section := 1
    }
    if section = 1 {
        if !BonusStage3Section2()
            return BonusStage3(currentSection + totalSections)
        currentSection += 1
        section := 2
    }
    if section = 2 {
        if !BonusStage3Section3()
            return BonusStage3(currentSection + totalSections)
        currentSection += 1
        section := 3
    }
    if section = 3 {
        if !BonusStage3Section4()
            return BonusStage3(currentSection + totalSections)
    }
}

BonusStage3SB(currentSection := 0) {
    totalSections := 4
    if currentSection = 0 {
        WriteInLogs("BonusStage3SB")
    } else if currentSection >= 2 * totalSections {
        return
    }
    section := Mod(currentSection, totalSections)
    if section = 0 {
        if !BonusStage3Section1(true)
            return BonusStage3SB(currentSection + totalSections)
        currentSection += 1
        section := 1
    }
    if section = 1 {
        if !BonusStage3Section2(true)
            return BonusStage3SB(currentSection + totalSections)
        currentSection += 1
        section := 2
    }
    if section = 2 {
        if !BonusStage3Section3(true)
            return BonusStage3SB(currentSection + totalSections)
        currentSection += 1
        section := 3
    }
    if section = 3 {
        if !BonusStage3Section4(true)
            return BonusStage3SB(currentSection + totalSections)
    }
}

BonusStage3Section1(spiritBoost := false) {
    FindPixelUntilFound(520, 200, 580, 250, 0xFFFFFF)
    Sleep 360
    cSend(140, 530)
    cSend(70, 640)
    cSend(80, 740)
    cSend(150, 765)
    cSend(65, 625)
    cSend(65, 500)
    FindPixelUntilFound(540, 335, 555, 360, 0xFFFFFF, 700)
    cSend(150, 750)
    cSend(200, 200)
    FindPixelUntilFound(390, 230, 410, 250, 0xFFFFFF, 3500)
    cSend(130, 545)
    cSend(70, 620)
    cSend(80, 400)
    FindPixelUntilFound(500, 200, 515, 250, 0xFFFFFF, 1500)
    cSend(150, 755)
    cSend(65, 625)
    cSend(65, 500)
    FindPixelUntilFound(540, 335, 555, 360, 0xFFFFFF, 700)
    cSend(150, 740)
    cSend(200, 1490)
    cSend(110, 580)
    cSend(65, 640)
    cSend(80, 740)
    cSend(150, 765)
    cSend(130, 560)
    cSend(70, 650)
    Sleep 800
    if !CollectLootBS3(spiritBoost, 21)
        return false
    WriteInLogs(GetBS3LogText(spiritBoost) " Section 1 Complete")
    return true
}

BonusStage3Section2(spiritBoost := false) {
    FindPixelUntilFound(306, 200, 309, 275, 0xFFFFFF)
    Loop 2 {
        cSend(80, 440)
        cSend(95, 660)
        cSend(105, 500)
        FindPixelUntilFound(475, 445, 482, 475, 0xFFFFFF, 1000)
        cSend(79, 601)
        cSend(63, 980)
        cSend(82, 440)
        cSend(95, 660)
        cSend(48, 750)
        FindPixelUntilFound(515, 265, 522, 285, 0xFFFFFF, 1200)
        cSend(63, 500)
        BonusStage3WallJump(1)
        Sleep 80
        BonusStage3WallJump(1)
        Sleep 300
        BonusStage3WallJump(4)
        FindPixelUntilFound(306, 200, 309, 275, 0xFFFFFF, 1000)
    }
    cSend(80, 440)
    cSend(95, 660)
    if !CollectLootBS3(spiritBoost)
        return false
    WriteInLogs(GetBS3LogText(spiritBoost) " Section 2 Complete")
    return true
}

BonusStage3Section3(spiritBoost := false) {
    upperWay := false
    FindPixelUntilFound(280, 385, 330, 435, 0xFFFFFF)
    Sleep 600
    Loop 2 {
        if upperWay {
            BonusStage3WallJump()
            upperWay := false
        } else {
            cSend(120, 100)
            FindPixelUntilFound(205, 395, 215, 410, 0xFFFFFF, 780)
            cSend(95, 225)
            BonusStage3WallJump()
        }
        Sleep 2000
        cSend(300, 500)
        BonusStage3WallJump()
        FindPixelUntilFound(205, 395, 215, 410, 0xFFFFFF, 900)
        if A_Index < 3 {
            cSend(95, 250)
            BonusStage3WallJump(1, 715)
            BonusStage3WallJump(6)
            found := FindPixelUntilFound(300, 415, 330, 435, 0xFFFFFF, spiritBoost ? 1000 : 2500)
            if !found {
                upperWay := true
            } else {
                Sleep 2500
            }
            Sleep 150
        }
    }
    if !CollectLootBS3(spiritBoost)
        return false
    WriteInLogs(GetBS3LogText(spiritBoost) " Section 3 Complete")
    return true
}

BonusStage3WallJump(count := 5, sleepTime := 50) {
    Loop count {
        cSend(30, sleepTime)
    }
}

BonusStage3Section4(spiritBoost := false) {
    FindPixelUntilFound(330, 170, 380, 195, 0xFFFFFF)
    if !spiritBoost {
        Loop 5 {
            cSend(300, 600)
            cSend(300, 420)
            cSend(35, 748)
            cSend(35, 540)
            cSend(35, 1160)
        }
    } else {
        Loop 14 {
            cSend(110, 1180)
        }
        cSend(300, 300)
    }
    if !CollectLootBS3(spiritBoost, 25, false)
        return false
    WriteInLogs(GetBS3LogText(spiritBoost) " Section 4 Complete")
    return true
}

GetBS3LogText(spiritBoost) {
    return "BonusStage3" (spiritBoost ? "SB" : "")
}

CollectLootBS3(spiritBoost, count := 25, stopEarly := true) {
    if BonusStage3Fail(spiritBoost)
        return false
    Loop count {
        if stopEarly && A_Index > 8 {
            pos := FindPixelUntilFound(1100, 240, 1100, 440, 0x8D87A2, 480)
            if IsObject(pos)
                break
        } else {
            Sleep 500
        }
        cSend(0, 0)
    }
    if BonusStage3Fail(spiritBoost)
        return false
    return true
}
