#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode 2
SendMode "Event"
SetKeyDelay 80, 80
CoordMode "Mouse", "Screen"

; -------- USER SETTINGS --------
Volume := "0.01"
TargetPrice := 3417.10
CopyX := 833       ; <<< set these to the live price screen coords
CopyY := 363
TabsToPlaceBtn := 6
; --------------------------------

if WinExist("ahk_exe terminal64.exe") {
    WinActivate
    Sleep 500

    ; Open New Order
    Send "{F9}"
    Sleep 800

    ; Type = Pending Order
    Send "{Tab}"
    Sleep 200
    Send "{Down}"
    Sleep 300

    ; Pending type = Buy Stop
    Send "{Tab}"
    Sleep 200
    Send "{Down 2}"
    Sleep 300

    ; Volume
    Send "{Tab}"
    Sleep 200
    Send "^a"
    Send Volume
    Sleep 200

    ; Price
    Send "{Tab}"
    Sleep 200
    Send "^a"
    Send TargetPrice
    Sleep 200

    ; -------- WAIT UNTIL LIVE PRICE REACHES TARGET --------
    Loop {
        MouseClick "left", CopyX, CopyY, 1, 0
        Sleep 50
        A_Clipboard := ""
        Send "^c"
        ClipWait 0.4
        LivePrice := A_Clipboard

        LivePrice := RegExReplace(LivePrice, "[^\d\.]")
        if (LivePrice = "") {
            Sleep 200
            continue
        }
        LivePrice := LivePrice + 0

        if (LivePrice >= TargetPrice) {
            Loop TabsToPlaceBtn {
                Send "{Tab}"
                Sleep 60
            }
            Send "{Enter}"
            ExitApp
        }
        Sleep 250
    }
}
ExitApp