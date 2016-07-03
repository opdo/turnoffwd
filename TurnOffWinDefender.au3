#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=E:\Data\Downloads\Dakirby309-Simply-Styled-Drive-Windows-8.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Comment=TurnOff WinDefender
#AutoIt3Wrapper_Res_Description=TurnOff WinDefender
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=VinhPham (opdo.vn)
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	// THÔNG TIN CƠ BẢN	-------------------------------------
	// TurnOff WinDefender v1.0
	// Coded by VinhPham
	// My blog: www.opdo.vn

	// ĐIỀU KHOẢN SỬ DỤNG -------------------------------------
	// Source code sử dụng cho mục đích nghiên cứu, tham khảo, học tập, phát triển.
	// Điều khoản sử dụng mã nguồn mở trên trang opdo.vn: http://www.opdo.vn/p/terms.html
#ce
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiButton.au3>
#include <APIGdiConstants.au3>
#include <WinAPIGdi.au3>
_AddFont() ; hàm add font để hiển thị icon fontawesome

Global $GUIMAIN, $_MAIN_Control[2], $_LASTCONTROL, $_HAVE_CHANGE = False ; khai báo biến
_Create_GUI("TurnOff WinDefender")
_Check_Service_Status() ; kiểm tra trạng thái các service

While 1 ; vòng lặp giữ GUI
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			if $_HAVE_CHANGE Then
				$text_end = 'You must restart your computer before the new setting will take effect'&@CRLF&'Coded by Vinh Pham. Opensource on www.opdo.vn. Tks for using ^^'
				MsgBox(64,'Tks for using',$text_end)
			EndIf
			_GUI_FadeOut($GUIMAIN)

			Exit
		Case Else
			For $i = 0 To UBound($_MAIN_Control) - 1
				Local $control_temp = $_MAIN_Control[$i]
				If $nMsg = $control_temp[4] Then
					_Set_Service_Status($i)
					ExitLoop
				EndIf
			Next
	EndSwitch
	$info = GUIGetCursorInfo($GUIMAIN)
	If $info[4] Then
		_ControlHover($info[4])
	Else
		_ControlNormal($_LASTCONTROL)
	EndIf
WEnd

#Region ------- Các hàm tạo Control , GUI -----------
Func _Create_GUI($title) ; tạo GUI
	$GUIMAIN = GUICreate($title, 286, 121, -1, -1, -1, $WS_EX_TOOLWINDOW)
	GUISetBkColor(0xFFFFFF, $GUIMAIN)
	$_MAIN_Control[0] = _Create_Control("Windows Defender", "", 22) ; tạo 2 control
	$_MAIN_Control[1] = _Create_Control("Windows Update", "", 69)
	WinSetTrans($GUIMAIN,'',0) ; hieu ung gui
	GUISetState(@SW_SHOW, $GUIMAIN)
	_GUI_FadeIn($GUIMAIN) ; hieu ung gui
EndFunc   ;==>_Create_GUI

Func _Create_Control($tilte, $icon, $y) ; tạo các control như icon, trạng thái, tiêu đề của service windows
	Local $control[5]
	$control[0] = GUICtrlCreateLabel($icon, 21, $y, 37, 33, BitOR($SS_CENTER, $SS_CENTERIMAGE), -1)
	GUICtrlSetFont(-1, 25, 400, 0, "FontAwesome")
	GUICtrlSetBkColor(-1, "-2")
	$control[1] = GUICtrlCreateLabel($tilte, 61, $y, 130, 19, $SS_CENTERIMAGE, -1)
	GUICtrlSetFont(-1, 11, 350, 0, "Segoe UI Semilight")
	GUICtrlSetBkColor(-1, "-2")
	$control[2] = GUICtrlCreateLabel("Service Status:", 61, $y + 18, 64, 14, $SS_CENTERIMAGE, -1)
	GUICtrlSetFont(-1, 8, 400, 0, "Segoe UI")
	GUICtrlSetBkColor(-1, "-2")
	$control[3] = GUICtrlCreateLabel("", 127, $y + 18, 12, 15, BitOR($SS_CENTER, $SS_CENTERIMAGE), -1)
	GUICtrlSetFont(-1, 8, 400, 0, "FontAwesome")
	GUICtrlSetBkColor(-1, "-2")
	$control[4] = GUICtrlCreateLabel("Turn on", 199, $y, 66, 32, BitOR($SS_CENTER, $SS_CENTERIMAGE), -1)
	GUICtrlSetFont(-1, 11, 600, 0, "Segoe UI Semibold")
	GUICtrlSetColor(-1, "0xFFFFFF")
	GUICtrlSetBkColor(-1, "0x0094cf")
	GUICtrlSetCursor(-1, 0)
	Return $control
EndFunc   ;==>_Create_Control
#EndRegion ------- Các hàm tạo Control , GUI -----------

#Region ------- Các hàm hiệu ứng control -----------
Func _GUI_FadeOut($GUI, $speed = 5)
	For $i = 255 to 0 Step -$speed
		WinSetTrans($GUI,'', $i)
		Sleep(5)
	Next
EndFunc
Func _GUI_FadeIn($GUI, $speed = 5)
	For $i = 0 to 255 Step $speed
		WinSetTrans($GUI,'', $i)
		Sleep(5)
	Next
EndFunc

Func _ControlHover($control)
	If $_LASTCONTROL <> $control Then
		If $_LASTCONTROL <> -1 Then _ControlNormal($_LASTCONTROL)
		For $i = 0 To UBound($_MAIN_Control) - 1
			Local $control_temp = $_MAIN_Control[$i]
			If $control = $control_temp[4] Then
				If GUICtrlRead($control) = 'Turn on' Then
					GUICtrlSetBkColor($control, "0x006993")
				Else
					GUICtrlSetBkColor($control, "0xd61212")
				EndIf
				ExitLoop
			EndIf
		Next
		$_LASTCONTROL = $control
	EndIf
EndFunc   ;==>_ControlHover
Func _ControlNormal($control)
	If $_LASTCONTROL <> -1 Then
		For $i = 0 To UBound($_MAIN_Control) - 1
			Local $control_temp = $_MAIN_Control[$i]
			If $control = $control_temp[4] Then
				If GUICtrlRead($control) = 'Turn on' Then
					GUICtrlSetBkColor($control, "0x0094cf")
				Else
					GUICtrlSetBkColor($control, "0xee1414")
				EndIf
				ExitLoop
			EndIf
		Next
		$_LASTCONTROL = -1
	EndIf
EndFunc   ;==>_ControlNormal
#EndRegion ------- Các hàm hiệu ứng control -----------

#Region ------- Các hàm tính năng -----------
Func _AddFont()
	FileInstall('fontawesome.ttf',@TempDir&'\fontawesome.ttf',1) ; load font
	if @error Then
		MsgBox(16,'Error','Failed to load font. Please run this tool as an Administrator')
		Return False
	EndIf
	_WinAPI_AddFontResourceEx(@TempDir&'\fontawesome.ttf', $FR_PRIVATE) ; load font
EndFunc

Func _Check_Service_Status()
	; https://support.microsoft.com/en-us/kb/927367
	If RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender', 'DisableAntiSpyware') = 1 Then
		_Set_Icon_Service_Status(0, False)
	Else
		_Set_Icon_Service_Status(0, True)
	EndIf
	; https://support.microsoft.com/vi-vn/kb/328010
	If RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU', 'NoAutoUpdate') = 1 Then
		_Set_Icon_Service_Status(1, False)
	Else
		_Set_Icon_Service_Status(1, True)
	EndIf

EndFunc   ;==>_Check_Service_Status

Func _Set_Service_Status($id)
	Switch $id
		Case 0
			; https://support.microsoft.com/en-us/kb/927367
			If RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender', 'DisableAntiSpyware') = 1 Then
				RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender', 'DisableAntiSpyware')
			Else
				RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender', 'DisableAntiSpyware', 'REG_DWORD', 1)
			EndIf
		Case 1
			; https://support.microsoft.com/vi-vn/kb/328010
			If RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU', 'NoAutoUpdate') = 1 Then
				RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU', 'NoAutoUpdate')
			Else
				RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU', 'NoAutoUpdate', 'REG_DWORD', 1)
			EndIf
	EndSwitch
	if @error Then
		MsgBox(16,'Error','Please run this tool as an Administrator')
		Return False
	EndIf
	$_HAVE_CHANGE = True
	_Check_Service_Status()
EndFunc   ;==>_Set_Service_Status

Func _Set_Icon_Service_Status($id, $flag)
	Local $control = $_MAIN_Control[$id]
	If $flag Then
		GUICtrlSetData($control[3], '')
		GUICtrlSetBkColor($control[4], "0xee1414")
		GUICtrlSetData($control[4], 'Turn off')
	Else
		GUICtrlSetData($control[3], '')
		GUICtrlSetBkColor($control[4], "0x0094cf")
		GUICtrlSetData($control[4], 'Turn on')
	EndIf
EndFunc   ;==>_Set_Icon_Service_Status
#EndRegion ------- Các hàm tính năng -----------
