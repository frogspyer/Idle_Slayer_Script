#Requires AutoHotkey v2.0
#Include "Common.ahk"

BossFightKnight() {
    WriteInLogs("Start of BossFight Knight")
    Loop {
        Slider()
        Sleep 500
        if !PixelFind(653, 222, 653, 222, 0xFFF38F)
            break
    }
    BossBattleKnight()
}

BossBattleKnight() {
    Global bFirstStage := true
    Global bDashAttack := false
    attackWindow := 1800
    waitTimer := TimerInit()
    attackTimer := TimerInit()
    bossTimer := TimerInit()

    Loop 9 {
        ShootKnight()
    }

    while true {
        if attackWindow < TimerDiff(attackTimer) {
            if (pos := PixelFind(900, 150, 900, 343, 0x2C2C2C)) {
                attackTimer := TimerInit()
                RangeAttackKnight(pos)
            }
            if (pos := PixelFind(445, 210, 445, 387, 0xAF9967)) {
                attackTimer := TimerInit()
                CloseAttackKnight(pos)
            } else if (pos := PixelFind(445, 210, 445, 387, 0xD7CCB3)) {
                attackTimer := TimerInit()
                CloseAttackKnight(pos)
            }
        }

        if 1000 < TimerDiff(waitTimer) {
            if bFirstStage {
                if PixelFind(267, 130, 272, 130, 0xF5B784) {
                    WriteInLogs("Knight Stage 2")
                    Loop {
                        Sleep 100
                        MouseClick "L", 1020, 420, 1, 0
                        if !PixelFind(272, 130, 272, 130, 0xF5B784)
                            break
                    }
                    ControlFocus "Idle Slayer"
                    bFirstStage := false
                    bDashAttack := true
                }
            }

            if PixelFind(535, 75, 535, 75, 0x000000) {
                WriteInLogs("Knight Dark stage")
                darkTimer := TimerInit()
                loop {
                    MouseClick "L", 1000, 328, 1, 0
                    if PixelFind(835, 477, 835, 477, 0xFD3169) {
                        Sleep 500
                        MouseClick "L", 615, 563, 1, 0
                        WriteInLogs("Knight Won")
                        return
                    }
                    if TimerDiff(darkTimer) > 30000
                        break
                }
                WriteInLogs("Knight Lost")
                break
            }

            if 200000 < TimerDiff(bossTimer) {
                WriteInLogs("Knight Lost")
                break
            }

            waitTimer := TimerInit()
        }
    }
}

CloseAttackKnight(pos) {
    Global bDashAttack
    Sleep 700
    upper := pos[2] <= 283
    if upper {
        UpperAttackKnight()
        if bDashAttack {
            Sleep 500
            ControlFocus "Idle Slayer"
            Send "{Up down}"
            Sleep 170
            Send "{Up up}"
        }
    } else {
        DownAttackKnight()
        if bDashAttack {
            Loop 11 {
                Sleep 10
                MouseClick "L", 1020, 420, 1, 0
            }
            return
        }
    }
    Loop 31 {
        Sleep 10
        MouseClick "L", 1020, 420, 1, 0
    }
}

RangeAttackKnight(pos) {
    Global bDashAttack
    Sleep 150
    bDashAttack := false
    upper := pos[2] <= 240
    if upper {
        UpperAttackKnight()
    } else {
        DownAttackKnight()
    }
    Loop 25 {
        Sleep 10
        MouseClick "L", 1020, 420, 1, 0
    }
}

DownAttackKnight() {
    ControlFocus "Idle Slayer"
    Send "{Up down}"
    Sleep 170
    Send "{Up up}"
}

UpperAttackKnight() {
    Sleep 730
}

ShootKnight() {
    Sleep 200
    ControlFocus "Idle Slayer"
    Send "{Up down}"
    Sleep 300
    Send "{Up up}"
    Loop 14 {
        Sleep 5
        Send "{Up}"
    }
}
