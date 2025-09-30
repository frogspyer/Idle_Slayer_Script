#Requires AutoHotkey v2.0
#Include "Common.ahk"

BossFightVictor() {
    WriteInLogs("Start of BossFight Victor")
    Loop {
        Slider()
        Sleep 500
        if !PixelFind(653, 222, 653, 222, 0xFFF38F)
            break
    }
    BossBattleVictor()
}

BossBattleVictor() {
    Global bFirstStage
    ControlFocus "Idle Slayer"
    SetTimer Shoot, 50
    Sleep 5000
    bFirstStage := true
    timeWindow := 2000
    stageTimer := TimerInit()
    bossTimer := TimerInit()
    while true {
        if !bFirstStage {
            if PixelFind(1072, 150, 1072, 488, 0xFFFFFF) {
                FlameAttackVictor()
            }
        }
        if (pos := PixelFind(919, 292, 919, 452, 0xFFFFFF)) {
            SetTimer Shoot, 0
            NormalAttackVictor(pos)
        }

        if timeWindow < TimerDiff(stageTimer) {
            if PixelFind(835, 477, 835, 477, 0xFD3169) {
                SetTimer Shoot, 0
                Sleep 500
                MouseClick "L", 615, 563
                WriteInLogs("Victor Won")
                break
            }
            if bFirstStage {
                if PixelFind(272, 130, 272, 130, 0xAE6C37) {
                    bFirstStage := false
                    timeWindow := 10000
                    WriteInLogs("Victor Stage 2")
                    SetTimer Shoot, 50
                    Loop {
                        Sleep 50
                        if !PixelFind(272, 130, 272, 130, 0xAE6C37)
                            break
                    }
                    Sleep 4000
                    SetTimer Shoot, 0
                    ControlFocus "Idle Slayer"
                }
            }
            if 200000 < TimerDiff(bossTimer) {
                SetTimer Shoot, 0
                WriteInLogs("Victor Lost")
                break
            }
            stageTimer := TimerInit()
        }
    }
}

NormalAttackVictor(pos) {
    Global bFirstStage
    upper := true
    if pos[2] > 370 {
        upper := false
    }
    if upper {
        UpperAttackVictor()
    } else {
        DownAttackVictor()
    }
}

FlameAttackVictor() {
    Sleep 350
    ControlFocus "Idle Slayer"
    Send "{Up down}"
    Sleep 100
    Send "{Up up}"
    Loop 18 {
        Sleep 10
        Send "{Up}"
    }
}

DownAttackVictor() {
    Global bFirstStage
    Sleep 200
    if bFirstStage {
        SetTimer Shoot, 50
    } else {
        ControlFocus "Idle Slayer"
        Send "{Up down}"
        Sleep 100
        Send "{Up up}"
        Loop 18 {
            Sleep 10
            Send "{Up}"
        }
    }
}

UpperAttackVictor() {
    Global bFirstStage
    Sleep 730
    if bFirstStage {
        SetTimer Shoot, 50
    } else {
        Loop 15 {
            Sleep 10
            Send "{Up}"
        }
    }
}

Shoot() {
    Send "{Up}"
}
