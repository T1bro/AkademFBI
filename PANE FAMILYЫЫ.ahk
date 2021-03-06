﻿#SingleInstance force
#NoEnv
#include SAMPg.ahk
SetBatchLines, -1
global  var := 1



VersionBot:= "2.1"

vvupd := VersionBot

buildscr = 8
downlurl := "https://github.com/T1bro/AkademFBI/blob/master/updt.exe?raw=true"
downllen := "https://raw.githubusercontent.com/T1bro/AkademFBI/master/verlen"

Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM = 3
    Else
        BOM = 0

    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "UInt", &UniBuf, "Int", UniSize)

    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Int", 0, "Int", 0
                    , "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Str", AnsiString, "Int", AnsiSize
                    , "Int", 0, "Int", 0)
    Return AnsiString
}

WM_HELP(){
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}

OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs

SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verlen.ini
IniRead, buildupd, %a_temp%/verlen.ini, UPD, build
if buildupd =
{
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
    sleep, 2000
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
    {
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
        IfMsgBox OK
        {
            put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
            URLDownloadToFile, %downlurl%, %a_temp%/updt.exe
            sleep, 1000
            run, %a_temp%/updt.exe
            exitapp
        }
    }
}
SplashTextoff
GetLastVersionSoft(URL) { 
   URLDownloadToFile, %URL%, %A_Temp%/79124 
   FileRead, LastVersion, %A_Temp%/79124 
   FileDelete, %A_Temp%/79124 
   return LastVersion 
}




IniRead, EditK, config.ini, Setup, TegK,[]
IniRead, EditHello, config.ini, Setup, FHello,Здравствуйте
IniRead, EditPhone, config.ini, Setup, FPhone,Номер


loop 13
{
IniRead, HK%A_Index%, config.ini, HotKey, SetupHK%A_Index%,
if HK%A_Index%
      Hotkey,% HK%A_Index%, Active%A_Index%, On, UseErrorlevel  
      
}
Gui, Font, S8 CDefault, Arial
Gui, Add, Button, x10 y120 w80 h43 gGO Default, Управление
Gui, Add, Button, x100 y120 w80 h43 gAbout, Об авторе
Gui, Add, Button, x190 y120 w80 h43 gInfo, Возможности:
Gui, Add, Button, x280 y120 w80 h43 gActives, Назначить клавиши
Gui, Add, Button, x280 y10 gInfos, Информация

Gui, Add, Text, x10 y10, Тэг рации /k
Gui, Add, Text, x10 y+20, Номер телефона
Gui, Add, Edit, x120 y10 w60 vEditK, %EditK%
Gui, Add, Edit, y+10 w60 vEditPhone, %EditPhone%
Gui, Add, Text, x20 y72 , Приветствие
Gui, Add, Edit, x100 y70 w300 vEditHello, %EditHello%

Gui, Show,, Pane Family  %vvupd%

Gui, 3:Add, Text,,Назначение клавиш

Gui, 3:Add, Hotkey, x20 y30 w100 h20 vHK1 gActive, %HK1%      
Gui, 3:Add, Text, x150 y30 w100 h20, Приветствие

Gui, 3:Add, Hotkey, x20 y60 w100 h20 vHK2 gActive, %HK2%
Gui, 3:Add, Text, x150 y60 w100 h50, Показать перстень "Pane"

Gui, 3:Add, Hotkey, x20 y90 w100 h20 vHK3 gActive, %HK3%
Gui, 3:Add, Text, x150 y90 w100 h50, Показать средний палец

Gui, 3:Add, Hotkey, x20 y120 w100 h20 vHK4 gActive, %HK4%
Gui, 3:Add, Text, x150 y120 w100 h50, Закрыть/открыть авто

Gui, 3:Add, Hotkey, x20 y150 w100 h20 vHK5 gActive, %HK5%
Gui, 3:Add, Text, x150 y150 w100 h50, Дать визитку

Gui, 3:Add, HotKey, x20 y180 w100 h20 vHK6 gActive, %HK6%
Gui, 3:Add, Text, x150 y180 w100 h50, Употребить наркотики 

Gui, 3:Add, HotKey, x20 y210 w100 h20 vHK7 gActive, %HK7%
Gui, 3:Add, Text, x150 y210 w100 h50, Местонахождение в /k

Gui, 3:Add, HotKey, x20 y240 w100 h20 vHK8 gActive, %HK8%
Gui, 3:Add, Text, x150 y240 w100 h50, Позвать кого-то 

Gui, 3:Add, HotKey, x20 y270 w100 h20 vHK9 gActive, %HK9%
Gui, 3:Add, Text, x150 y270 w100 h50, /time

Gui, 3:Add, HotKey, x20 y300 w100 h20 vHK10 gActive, %HK10%
Gui, 3:Add, Text, x150 y300 w100 h50, рация /k

Gui, 3:Add, HotKey, x20 y330 w100 h20 vHK11 gActive, %HK11%
Gui, 3:Add, Text, x150 y330 w100 h50, Отключить метку

Gui, 3:Add, HotKey, x20 y360 w100 h20 vHK12 gActive, %HK12%
Gui, 3:Add, Text, x150 y360 w100 h50, /healme

Gui, 3:Add, HotKey, x20 y390 w100 h20 vHK13 gActive, %HK13%
Gui, 3:Add, Text, x150 y390 w100 h50, Поднять руки

Gui, 3:Add, Hotkey, x300 y30 w100 h20 vHK14 gActive, %HK14%
Gui, 3:Add, Text, x420 y30 w100 h50, FacePalm




Gui, 3:Add, Button, x70 y420 w80 h43 gSave, Сохранить




StringCaseSense, Locale

global lastline2 
global lastline1
global TazerTo:= -1
global TazerIn := 0
global M4To:= -1	 
global M4In := 0	
global bitaTo:= -1
global bitaIn := 0 
global deagleTo:= -1
globAl deagleIn := 0
global AK47To:= -1
global AK47In := 0
global DubinTo:= -1
global DubinIn := 0
Array:= []
ArrayCount := 0  


FileCLog:=% A_MyDocuments "\GTA San Andreas User Files\SAMP\chatlog.txt"

Stringhelp := ""
StringInfo := " Взаимодействие с игроком - прицельтесь на игрока и нажмите 'Alt'`nАвтоматическая отыгровка, достать/убирать оружие`n/pyki [id] - связать человека, кляп`n/unpyki [id] - развязать`n`n"



loop
{
 lastline := GetNewLine(FileCLog)
 

 
 
 If lastline contains {FF8C00}SMS:
 {
  if RegExMatch(lastline, "\[\d+:\d+:\d+\]\Q {FF8C00}SMS: {FFFF00}\E.*\Q{FF8C00}| {FFFF00}Отправитель:\E.*\(тел. (\d+)\)$", matche)
  {
  ; addChatMessage("{FFA500}Чтобы ответить, нажмите {B22222} X")
   KeyWait, vk58, D T10    
   if ErrorLevel 
    addChatMessage("Истек TimeOut подтверждения команды")
   else
   {
    SendInput {F6}/SMS %matche1% {Space}
   }
  }
 }




if RegExMatch(lastline, "\[\d\d:\d\d:\d\d\]\s(.*)\{FFCC99\}\s(\w+)\[(\d+)\]: Координаты:\s(.*)",match)
{
disableCheckpoint()
addChatMessage("Координаты " match2 " отмечены на миникарте. Чтобы убрать метку, введите /moff  ")
StringSplit, CoordsHelp, match4,|
setCheckpoint(CoordsHelp2,CoordsHelp3,CoordsHelp4,10) 
}
 


 
 
 If lastline contains передал листовку, передал(а) листовку
{
addChatMessage("{00CD00}Чтобы отдать листовку, нажмите кнопку Z")
Sleep 200
addChatMessage("{00CD00}У вас есть 5 секунд на чтобы нажать на Z")
KeyWait, vk5A, D T5
 if ErrorLevel 
 addChatMessage("Истек TimeOut подтверждения команды")
 else
 {
NameExPlayer := getPlayerNameById(getClosestPlayerId())
NameExPlayer := RegExReplace(NameExPlayer,"_"," ")
sleep 200
Sendinput {F6}/me взял листовку{ENTER}
Sleep 2100
SendChat("/me скомкал листовку")
Sleep 2100
SendChat("/me плюнул на листовку")
Sleep 2100
SendChat("/me снял штаны " NameExPlayer " ")
Sleep 2100
SendChat("/try засунул листовку в задницу " NameExPlayer " ")
}
;tooltip, %idPl1% "fg"
}






If lastline contains Двигатель заглох
{
  SendChat("/me ударил по рулю")
  Sleep 2100
  SendChat("О чёрт! У меня заглох двигатель!")
  Sleep 1200
  SendChat("Мне нужен срочно автомеханик.")
}


If lastline contains Cпaть
{
  SendChat("/oldanim 11")
}

If lastline contains Ваше объявление отправлено на обработку
{
  SendChat("/me подал обьявление в СМИ")
}

If lastline contains Добро пожаловать на Diamond Role Play!
{
  sleep 1000
  SendChat("/k .::Пoдключился к сepверу::.")
    playAudioStream("http://d.zaix.ru/4y85.mp3")
}


If lastline contains .:Отключилcя от сервера:.    (/q)
{

    playAudioStream("http://d.zaix.ru/4y87.mp3")
}




If lastline contains Танцyльки 
{
  SendChat("/oldanim 73")
}


If lastline contains идет заправка
{
  SendChat("/me вставил пистолет в бензобак")
}

If lastline contains Вы открыли т/с
{
  SendChat("/me нажал на брелок сигнализации 'Открыть'")
}

If lastline contains Вы закрыли т/с
{
  SendChat("/me нажал на брелок сигнализации 'Закрыть'")
}


If lastline contains Транспорт заправлен
{
  SendChat("/me убрал пистолет с бензобака")
    showGameText("Filled",500,1)
}

If lastline contains Телефон выключен
{
  SendChat("/me выключил телефон")
}

If lastline contains Телефон включен
{
  SendChat("/me включил телефон")
}


If lastline contains У игрока уже есть дом
{
  SendChat("Дружище, у тебя уже есть дом.")
}

 If lastline contains Play Stream :Минуc на минус:
{
  addChatMessage("Музыка включена")
  playAudioStream("http://dl.waix.ru/af80909e9.mp3")
 
}

If lastline contains Play Stream :Беспечный Ангел:
{
  addChatMessage("Музыка включена")
  playAudioStream("http://dl.waix.ru/dfeff2c5e.mp3")
}

If lastline contains :::Say Vеrsion:::
{
  SendInput {f6}/k ::%VersionBot%::{enter}
    showGameText("You Version Script " VersionBot "",500,1)
}



If lastline contains пукнул
{
   SendChat("/me задержл дыхание")
}



         
       
  
       

If lastline contains Гдe всe?
{
  SendChat("/k Мое местонахождение: " calculateZone(pos[1],pos[2],pos[3]) ", Город: " calculateCity(pos[1],pos[2],pos[3]))
}

If lastline contains кoд CР1
{
idd := getPlayerIdByName("Charles_Pane") 
filedelete, % SelectedFile
BlockInput, on
SendInput, {f6}/pay %idd% 5000{enter}
Sleep, 300
SendInput, {enter}
BlockInput, off
;goto, Z20
}

If lastline contains кoд SР1
{
iddd := getPlayerIdByName("Stafford_Pane") 
BlockInput, on
SendInput, {f6}/pay %iddd% 5000{enter}
Sleep, 300
SendInput, {enter}
BlockInput, off
;goto, Z20
}



 
 if RegExMatch(lastline, "\[\d\d:\d\d:\d\d\]\s\w+\s(достал|играет) ?н?а? гитаре?у?",match)
{
  ;addChatMessage("Музыка включена")
  playAudioStream("http://dl.waix.ru/31fee2e0e.mp3")
  SetTimer, AudioOff, 193000
}

if RegExMatch(lastline, "\[\d\d:\d\d:\d\d\]\s\w+\s(играет 'Выхода нет') ?н?а? гитаре",match)
{
  ;addChatMessage("Музыка включена")
  playAudioStream("http://dl.waix.ru/20cd612df.mp3")
  SetTimer, AudioOff, 193000
}

if RegExMatch(lastline, "\[\d\d:\d\d:\d\d\]\s\w+\s(играет 'Рай в шалаше') ?н?а? гитаре",match)
{
  ;addChatMessage("Музыка включена")
  playAudioStream("http://dl.waix.ru/d68cf8cd0.mp3")
  SetTimer, AudioOff, 193000
}

if RegExMatch(lastline, "\[\d\d:\d\d:\d\d\]\s\w+\sвключил радио",match)
{
 playAudioStream("http://dl.waix.ru/2a2748742.mp3")
         addChatMessage("{00CD00}Играет One Republic-Secrets")
     }



if RegExMatch(lastline, "\[\d\d:\d\d:\d\d\]\s\w+\sубрал гитару",match)
{
  stopAudioStream() 
}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;АВТОКОП';;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;
;[21:50:39] Richard_Camilleri оглушил Coul_Felps


if RegExMatch(lastline, "\[\d\d:\d\d:\d\d\] " getUsername() " оглушил (.*)", match)
{
TazerId:=getPlayerIdByName(match1)
addChatMessage("ID: " TazerId)
SendChat("/pt " TazerId)

PosTarget:=getPedCoordinates(getPedById(TazerId))
lpos := getCoordinates() 
t:=getDist(lpos,PosTarget)
TazerTime:=A_Min + 1
While (t > 1) and (TazerTime > A_Min)
{
PosTarget:=getPedCoordinates(getPedById(TazerId))
lpos := getCoordinates() 
t:=getDist(lpos,PosTarget)
;tooltip, % PosTarget "  " t
sleep 100
}

if (t<5)
{


SendChat("/me достал фоторобот")
sleep 2100
NameOOP := getPlayerNameById(TazerId)
NameOOP := RegExReplace(NameOOP,"_"," ")
SendChat("/me сверил приметы человека с фотороботом """ NameOOP """")
sleep 2100
SendChat("/me cнял наручники с пояса")
Sleep 200
SendChat("/cuff " TazerId)
KeyWait, Enter , D 
sleep 200
UnmaskNearPlayer()
Sleep 600
SendChat("/sm")
Sleep 400
SendInput {Down 10}
Sleep 100
SendInput {Enter}
color := getplayercolor(TazerId)
if (color = 2054579968)
{
SendChat("/unmask " TazerId)


}
}
}



;[12:41:51] Gualtiero_Sabatteli ударил электрошокером Baks_Green

if RegExMatch(lastline, "\[\d\d:\d\d:\d\d\] " getUsername() " ударил электрошокером (.*)", match)
{
TazerId:=getPlayerIdByName(match1)
addChatMessage("ID: " TazerId)
SendChat("/pt " TazerId)

PosTarget:=getPedCoordinates(getPedById(TazerId))
lpos := getCoordinates() 
t:=getDist(lpos,PosTarget)
TazerTime:=A_Min + 1
While (t > 2) and (TazerTime > A_Min)
{
PosTarget:=getPedCoordinates(getPedById(TazerId))
lpos := getCoordinates() 
t:=getDist(lpos,PosTarget)
;tooltip, % PosTarget "  " t
sleep 100
}

if (t<7)
{


SendChat("/me достал фоторобот")
sleep 2100
NameOOP := getPlayerNameById(TazerId)
NameOOP := RegExReplace(NameOOP,"_"," ")
SendChat("/me сверил приметы человека с фотороботом """ NameOOP """")
sleep 2100
SendChat("/me cнял наручники с пояса")
Sleep 200
SendChat("/cuff " TazerId)
KeyWait, Enter , D 
sleep 200
UnmaskNearPlayer()
Sleep 600
SendChat("/sm")
Sleep 400
SendInput {Down 11}
Sleep 100
SendInput {Enter}
color := getplayercolor(TazerId)
if (color = 2054579968)
{
SendChat("/unmask " TazerId)
}
}
}




if RegExMatch(lastline, ".*выявил сигнальный провод, идущий на детонатор \| \{FF0000\}Неудачно")
{
sleep 2200
SendChat("/me продолжает сканирование")
sleep 2200
SendChat("/try выявил сигнальный провод, идущий на детонатор")
}
 


if RegExMatch(lastline, ".*выявил сигнальный провод, идущий на детонатор \| \{33AA33\}Удачно")
{
sleep 2200
SendChat("/me достал бокорезы")
sleep 3000
Send {Enter}
SendChat("/anim 65")
SendChat("/me аккуратно перерезал сигнальный провод")
sleep 4000
SendChat("/me обезвредил бомбу")
sleep 4000
SendChat("/me извлек активатор из бомбы")
sleep 4000
SendChat("/me переложил бомбу в безопасный контейнер")
sleep 2100
SendChat("/me собрал инструменты в ящик")
}






}


;автомузыка

;Var := 1
;if IsPlayerInRangeOfPoint(1925.474854, 950.534485, 980.260620, 250) and ;var
 ; {
 ; Var := 0
 ;        playAudioStream("http://dl.waix.ru/c2ddbf324.mp3")
 ;        addChatMessage("{00CD00}Играет Journey–Separate ways ")
 ;     
 ;        }


;Var := 1
;if IsPlayerInRangeOfPoint(1340.098389, -1096.259155, -19.518063, 100) 
;{
;if var
;{
;var := 0
 ; SendChat("/k Зашел в дом Charles Lincoln'a")
 ; playAudioStream("http://dl.waix.ru/af4504787.mp3")
 ; addChatMessage("{00CD00}Играет Ария-Беспечный Ангел")
 ; }
 ; }else{
 ;var := 1
 ; StopAudioStream()
;}
;}



AudioOff:
    SetTimer, AudioOff, Off
  stopAudioStream() 
return



GO: 
MsgBox, 48,,%Stringhelp%
return


Actives:
Gui, 3:Show,, Назначение клавиш
Gui, Submit, NoHide
return



Save:
Gui, Submit, NoHide 




IniWrite, %HK1%, config.ini, HotKey, SetupHK1
IniWrite, %HK2%, config.ini, HotKey, SetupHK2
IniWrite, %HK3%, config.ini, HotKey, SetupHK3
IniWrite, %HK4%, config.ini, HotKey, SetupHK4
IniWrite, %HK5%, config.ini, HotKey, SetupHK5
IniWrite, %HK6%, config.ini, HotKey, SetupHK6
IniWrite, %HK7%, config.ini, HotKey, SetupHK7
IniWrite, %HK8%, config.ini, HotKey, SetupHK8
IniWrite, %HK9%, config.ini, HotKey, SetupHK9
IniWrite, %HK10%, config.ini, HotKey, SetupHK10
IniWrite, %HK11%, config.ini, HotKey, SetupHK11
IniWrite, %HK12%, config.ini, HotKey, SetupHK12
IniWrite, %HK13%, config.ini, HotKey, SetupHK13
IniWrite, %HK14%, config.ini, HotKey, SetupHK14
IniWrite, %HK15%, config.ini, HotKey, SetupHK15


Active:
;tooltip, Active
 If %A_GuiControl% in +,^,!,+^,+!,^!,+^!     ;If the hotkey contains only modifiers, then return to wait for a key.
  return
 num := SubStr(A_GuiControl,3)               ;Get the number of the hotkey control.  
 If (savedHK%num%) {                         ;If a hotkey was already saved in this control...
  Hotkey,% savedHK%num%, Active%num%, Off     ;     turn the old hotkey off
  savedHK%num% .= " OFF"                     ;     add the word 'OFF' to display in a message.
 }
 If (%A_GuiControl% = "") {                  ;If the new hotkey is blank...
  TrayTip, Active%num%,% savedHK%num%, 5      ;     show a message: the old hotkey is OFF
  savedHK%num% =                             ;     save the hotkey (which is now blank) for future reference.
  return                                     ;This allows an old hotkey to be disabled without enabling a new one.
 }
 Gui, Submit, NoHide
 If CB%num%                                  ;If the 'Win' box is checked, then add its modifier (#).
  %A_GuiControl% := "#" %A_GuiControl%
 If StrLen(%A_GuiControl%) = 1               ;If the new hotkey is only 1 character, then add the (~) modifier.
  %A_GuiControl% := "~" %A_GuiControl%       ;     This prevents any key from being blocked.
Hotkey,% %A_GuiControl%, Active%num%, On     ;Turn on the new hotkey.
 TrayTip, Active%num%
  ,% %A_GuiControl% " ON`n" savedHK%num%, 5  ;Show a message: the new hotkey is ON.
 savedHK%num% := %A_GuiControl%              ;Save the hotkey for future reference.
return


ShowClose: 
ExitApp 

MyHotKey: 
Gui, Submit, NoHide  
Hotkey, %MyHotKey%, key, on, useerrorlevel  
return 

;Save:
;Gui, Submit, NoHide 
;Hotkey, %MyHotKey%, key, on, useerrorlevel
;return




About:
Gui, 2:Add, Text,, Данный скрипт был написан специально для семьи 'Pane' 

Gui, 2:Add, Text,, Версия скрипта %VersionBot%            Filin
Gui, 2:Add, Text,,      By Charles Pane
Gui, 2:Show
return

Infos:
Gui, 4:Add, Text,,                     На этот раз, я вам скажу только одну вещь....
Gui, 4:Add, Text,,          Пользуйтесь кремом от загара. Он реально помогает.

Gui, 4:Add, Text,, =============================================================================
Gui, 4:Add, Text,,
Gui, 4:Add, Text,, Всем удачи ребят
Gui, 4:Add, Text,,      By Charles Pane
Gui, 4:Show
return

Info:
MsgBox, 48,,%StringInfo%
return

GuiClose:
Gui, Submit, NoHide

IniWrite, %EditK%, config.ini, Setup, TegK

IniWrite, %EditHello%, config.ini, Setup, FHello

IniWrite, %EditPhone%, config.ini, Setup, FPhone

ExitApp 



key: 
Gui, Submit, NoHide  
MsgBox,%MyHotKey% 
Hotkey, %MyHotKey%, key, off, useerrorlevel  
return 




Active1:
SendMessage, 0x50,, 0x4190419,, A
NameExPlayer := getPlayerNameById(getClosestPlayerId())
NameExPlayer := RegExReplace(NameExPlayer,"_"," ")
SendInput {f6}%EditHello%, %NameExPlayer% {Enter}
Return

Active2:
SendMessage, 0x50,, 0x4190419,, A
SendChat("/oldanim 54")
Sleep 400
SendChat("/me показал(а) перстень 'Pane' ")
Return

Active3:
SendChat("/oldanim 25")
Return

Active4:
SendMessage, 0x50,, 0x4190419,, A
SendChat("/lock")
Return

Active5:
SendMessage, 0x50,, 0x4190419,, A
SendChat("/me достал визитную карточку")
Sleep 2100
SendInput {f6}/do 'Maconnerie' Номер телефона:%EditPhone% {enter}
Return

Active6:
SendChat("/me засунул руку в карман")
Sleep 2100
SendChat("/me осмотрелся по сторонам")
Sleep 2100
SendChat("/me вспотел")
Sleep 2100
SendChat("/me достал из кармана 'Orbit'")
Sleep 2100
SendChat("/me засунул конфетку 'Orbit' в рот")
Sleep 500
SendInput {f6}/usedrugs 1 {enter}
return

Active7:
getPlayerPos(X,Y,Z) 
 mark := CoordsFromRedmarker()
SendChat("/k Координаты: |" x "|" y "|" z "| " calculateZone(x,y,z) )
return


Active8:
SendChat("/oldanim 41")
Sleep 400
SendChat("Иди сюда.")
Sleep 1400
SendChat("Подойди.")
return

Active9:
SendChat("/time")
return

Active10:
SendInput {f6}/k %EditK% {Space}
return

Active11:
AddChatMessage("Метка отключена")
 disableCheckpoint()
return

Active12:
SendChat("/healme")
return

Active13:
SendChat("/oldanim 19")
return

Active14:
SendChat("/oldanim 63")
return

:?:/map::
pos := getCoordinates()
SendChat("Мое местонахождение: " calculateZone(pos[1],pos[2],pos[3]) ", Город: " calculateCity(pos[1],pos[2],pos[3]))
return

:?:/q::
SendChat("/k .:Отключилcя от сервера:.    (/q)")
Sleep 500
SendInput {f6}/q {Enter}
Return



:?:/glasses::
SendMessage, 0x50,, 0x4190419,, A
SendChat("/me снял очки")
Sleep 500
SendChat("/oldanim 35")
Sleep 2000
SendChat("/me протёр очки")
Sleep 2100
SendChat("/me надел очки")
Sleep 1500
SendChat("/oldanim 18")
return



 
:?:/smoke::
SendMessage, 0x50,, 0x4190419,, A
SendChat("/me достал портсигар черного цвета")
Sleep 500
SendChat("/smoke")
Sleep 2100
SendChat("/me достал железную зажигалку")
Sleep 2100
SendChat("/me закурил самокруту")
return

:?:/tkhi::
SendMessage, 0x50,, 0x4190419,, A
SendChat("Добрый вечер. Добро пожаловать на собеседование в транспортную копанию 'Pane Company'")
Sleep 2000
SendChat("Через несколько минут откроют заявки на вступление.")
Sleep 2100
SendChat("Как только это произойдет - я вам сообщу")
Sleep 2100
SendChat("Попрошу всех встать к стене и соблюдать порядок.")
return

:?:/tkinfo::
SendMessage, 0x50,, 0x4190419,, A
SendChat("Чтобы вступить в транспортную компанию, вам необходимо подасть электронное заявление.")
Sleep 2000
SendChat("Сделать это можно на нашем сайте")
Sleep 2100
SendChat("/n Группа Вконтакте 'Pane Company'")
Sleep 2100
SendChat("/n Обычно заявки открываются в 20:50")
Sleep 2100
SendChat("Напоминаю, что никаких исключений мы не делаем.")
Sleep 2100
SendChat("Попасть в транспортную компанию можно только по заявкам и все.")
return

:?:/tkbb::
SendMessage, 0x50,, 0x4190419,, A
SendChat("Всем спасибо, на этом собеседование окончено")
Sleep 2000
SendChat("Тем, кому не досталось места - не огорчайтесь")
Sleep 2100
SendChat("Приходите к нам завтра и вам обязательно повезет.")
Sleep 2100
SendChat("А новым сотрудникам желаю удачи в работе и большого заработка")
Sleep 2100
SendChat("/tr Добро пожаловать в нашу компанию. С сегодняшнего дня вы сотрудники 'Pane Company'")
Sleep 2100
SendChat("/tr Не забывайте выполнять ежедневну норму [8.000%] на счет компании(27 рейсов)")
Sleep 2100
SendChat("Желаю всем приятной работы и большого заработка")
return

:?:/tkrinfo::
SendMessage, 0x50,, 0x4190419,, A
SendChat("/tr Уважаемые сотрудники Транспортной Компании 'Pane Company")
Sleep 1500
SendChat("/tr Напоминаю, что вам необходимо выполнять ежедневную норму - 8.000$")
Sleep 1500
SendChat("/tr В противном случае - вы будете уволены.")
Sleep 1500
SendChat("/tr А так же хочу напомнить вам, что у нас есть контрактная система")
Sleep 1500
SendChat("/tr Контракт освобождает вас от обязанности выполнять ежедневную норму.")
Sleep 1500
SendChat("/tr Всю информацию о контракте вы можете узнать на нашем сайте ")
Sleep 1500
SendChat("/tr (( Группа Вконтакте 'Pane Company'")
Sleep 1500
SendChat("/tr Всем спасибо. Желаю вам приятной работы и большого заработка.")
return

:?:/tkrinfo2::
SendMessage, 0x50,, 0x4190419,, A
SendChat("/tr Уважаемые сотрудники Транспортной Компании 'Pane Company")
Sleep 1500
SendChat("/tr Если у вас есть жалобы на других сотрудников компании")
Sleep 1500
SendChat("/tr Вы можете оповестить нас на нашем сайте")
Sleep 1500
SendChat("/tr (( Группа Вконтакте 'Pane Company' ))")
Sleep 1500
SendChat("/tr Жалобы без весомых док-в не принимаются")
Sleep 1500
SendChat("/tr Всем спасибо. Желаю вам приятной работы и большого заработка.")
return




:?:/бомба::
SendChat("/me достал чемоданчик с набором сапера")
sleep 3000
SendChat("/me положил чемоданчик рядом с собой")
sleep 3000
SendChat("/me достал отвертку")
sleep 4000
SendChat("/anim 65")
SendChat("/me отвинтил крышку часового механизма")
sleep 4000
SendChat("/me достал анализатор сигнала из чемоданчика")
sleep 4000
SendChat("/me аккуратно поддел провода идущие к детонатору")
sleep 3000
SendChat("/try выявил сигнальный провод, идущий на детонатор")
Return


:?:/time::
SendMessage, 0x50,, 0x4190419,, A
SendChat("/time")
Sleep 500
SendChat("/me взглянул на часы")

return

:?:pid::
SendInput, {space} 
Input, pid, L3 V I , {space} 
pnick := getPlayerNameById(pid) 
StringReplace, pnick, pnick, _, %A_SPACE%, All  
SendInput, {Backspace 3}%pnick%{space} 
return 






Alt::
SendMessage, 0x50,, 0x4190419,, A
id := getIdByPed(getTargetPed())
if id > -1
goto next
else
return
next:
nick := getPlayerNameById(id)
nick := RegExReplace(nick,"_"," ")
lvl := getPlayerScoreById(id)
ping := getPlayerPingById(id)
AddChatMessage("{FF0000}=============================================")
text := ("{FF0000}Это{FFFFFF} ID: " id " | Имя: " nick " | Лет в штате: " lvl " |")
AddChatMessage(text)
SendChat("/pt " id "")
AddChatMessage("{aaff99}Взаимодействовать с {8888FF} " nick ", {aaff99} нажмите | {FF0000}ALT |")
AddChatMessage("{FF0000}=============================================")
KeyWait, Alt, D T10
 if ErrorLevel 
 addChatMessage("Истек TimeOut подтверждения команды")
 else
 {
addChatMessage("{8888FF}Приказать поднять руки: {aaff99}нажмите 1{8888FF}. Дать 5.000$: {aaff99}нажмите 2{8888FF} Пожать руку: {aaff99}нажмите 3")
addChatMessage("{8888FF}Показать пасспорт: {aaff99}нажмите 4 | {8888FF}Жалоба в репорт DM: {aaff99}нажмите 0")  
Loop
{
Input , OutputVar, L1 V, {1}{2}{3}{4}{0}
if (ErrorLevel = "EndKey:1") or (ErrorLevel = "EndKey:2") or (ErrorLevel = "EndKey:3") or (ErrorLevel = "EndKey:4") or (ErrorLevel = "EndKey:0")
break
}
if ErrorLevel = EndKey:1
{
ToExamName :=""
 SendChat(" " nick ", руки вверх и без глупостей.")
 Sleep 1500
 SendChat("Двинешься, я тебе голову прострелю")
}
else
if ErrorLevel = EndKey:2
{
ToExamName :=""
;SendInput, {f6}/pay
SendChat("/pay " id " 5000 ")
}
else
if ErrorLevel = EndKey:3
{
ToExamName :=""
SendChat("/hi " id " ")
}
else
if ErrorLevel = EndKey:4
{
ToExamName :=""
SendChat("/pass " id "")
}
else
if ErrorLevel = EndKey:0
{
ToExamName :=""
SendChat("/rep [Жалоба]: ID " id " совершает 'DM' | Прошу проследить  ")
}
}
Return

::/stopm::
stopAudioStream() 
return


:?:/визор::
NightVision(true)
return

:?:/визорофф::
NightVision(false)
return



:?:/moff::
AddChatMessage("Метка отключена")
 disableCheckpoint()
 return
 



$~Enter::
;Enter::
;Send {Enter}
if (isInChat() = 1)
{
sleep 250
dwAddress := dwSAMP + 0x12D8F8
chatInput := readString(hGTA, dwAddress, 256)
;addchatmessage(chatInput)
if RegExMatch(chatInput,"\/id (\d\d?\d?)",ChatOut)
{
updateOScoreboardData() 
idPlayer := ChatOut1
;addchatmessage(idPlayer)
if (GetPlayerScoreById(idPlayer) >= 0)
{
NameCop := getPlayerNameById(idPlayer)
NameCop := RegExReplace(NameCop,"_"," ")

AboutPl:=% "Имя: " NameCop ", "
AboutPl:=% AboutPl "" GetPlayerScoreById(idPlayer) " лет в штате. "


addChatMessage("{CCEE00}[R] [База данных]: Игрок " idPlayer ". " AboutPl)
}
}


if (RegExMatch(chatInput, "^/funinvite"))
{
if RegExMatch(chatInput, "\/funinvite.(\d\d?\d?)", match)
{
idPlayer := getPlayerNameById(match1)
Send {F6}/k Выгнал из семьи %idPlayer%. Причина:{space}
KeyWait, Enter, D T10
Sleep 500
SendChat("/funinvite " idPlayer)
;SendChat("/k Выгнал из семьи " idplayer ")
}
  else
  addChatMessage("Исользуй /funinvite [ид] ")
}


if (RegExMatch(chatInput, "^/finvite"))
{
if RegExMatch(chatInput, "\/finvite.(\d\d?\d?)", match)
{
idPlayer := getPlayerNameById(match1)
AddChatMessage("Чтобы поприветствовать " idPlayer ", нажмите Alt ")
Sleep 300
SendChat(/finvite " idPlayer ")
KeyWait, Alt, D T10
SendChat("/k " idPlayer ", добро пожаловать в нашу семью.")
;SendChat("/k Выгнал из семьи " idplayer ")
}
  else
  addChatMessage("Исользуй /finvite [ид] ")
}


if (RegExMatch(chatInput, "^/руки"))
{
if RegExMatch(chatInput, "\/руки.(\d\d?\d?)", match)
{
idPlayer := getPlayerNameById(match1)
SendChat("/me связал руки " idPlayer "")
Sleep 2100
SendChat("/me засунул кляп в рот " idPlayer " ")
}
    else
  addChatMessage("Исользуй /руки [ид] ")
}






if (RegExMatch(chatInput, "^/анруки"))
{
if RegExMatch(chatInput, "\/анруки.(\d\d?\d?)", match)
{
idPlayer := getPlayerNameById(match1)
SendChat("/me развязал руки " idPlayer "")
Sleep 2100
SendChat("/me вытащил кляп у " idPlayer " ")
}
    else
  addChatMessage("Исользуй /анруки [ид] ")
}


if (RegExMatch(chatInput, "^/газ"))
{
if RegExMatch(chatInput, "\/газ.(\d\d?\d?)", match)
 {
idPlayer := getPlayerNameById(match1)
SendChat("/me надел противогаз на голову " idPlayer "")
Sleep 2100
SendChat("/me снял фильтр с противогаза " idPlayer "")
Sleep 2100
SendChat("/me засунул шланг в отверстие противогаза")
Sleep 2100
SendChat("/me пережал шланг")
Sleep 2100
SendChat("/do " idPlayer " задыхается")
Sleep 4000
SendChat("/me отжал шланг")
}
    else
  addChatMessage("Исользуй /газ [ид] ")
}





idPlayer:=""
return

}








GetNewLine(filename) {
   static old
   static new
   static EngineState
   if !old
   {
      FileGetSize, old, %filename%
      new := old
   }
   while old = new
   {
      sleep 100
      FileGetSize, new, %filename%
      
      
      
  ;  if (isPlayerDriver()) 
  ;  {
  ;     if (getVehicleEngineState() && !EngineState) 
  ;     {
  ;        SendChat("/me вставил(а) ключ и завел(а) " getVehicleModelName())
  ;        EngineState := true
  ;    }
  ;    else if (!getVehicleEngineState() && EngineState) 
  ;    {
 ;         SendChat("/me заглушил(а) " getVehicleModelName() " и вытащил(а) ключи")
 ;         EngineState := false
 ;     }
;  }

  

  
  
  
   
      if (getPlayerWeaponId() = 23) and (TazerIn = 0)
      {
      TazerIn := 1
      SendChat("/me снял электрошокер с пояса") 
      }
    
      if (getPlayerWeaponId() = 0) 
      {
      if TazerIn
      {
      TazerIn := 0
      SendChat("/me повесил электрошокер на пояс")   
      }
      }
      
      if (getPlayerWeaponId() = 5) and (bitaIn = 0)
      {
      bitaIn := 1
      Sleep 700
      SendChat("/me достал бейсбольную биту") 
      }
    
      if (getPlayerWeaponId() = 0) 
      {
      if bitaIn
      {
      bitaIn := 0
      Sleep 700
      SendChat("/me спрятал бейсбольную биту")   
      }
      }
      
      if (getPlayerWeaponId() = 30) and (AK47In = 0)
      {
      AK47In := 1
      Sleep 700
      SendChat("/me достал автомат AK-47") 
      }
    
      if (getPlayerWeaponId() = 0) 
      {
      if AK47In
      {
      AK47In := 0
      Sleep 700
      SendChat("/me спрятал автомат AK-47")   
      }
      }
      
      
       if (getPlayerWeaponId() = 3) and (DubinIn = 0)
      {
      DubinIn := 1
      Sleep 700
      SendChat("/me снял дубинку с пояса") 
      }
    
      if (getPlayerWeaponId() = 0) 
      {
      if DubinIn
      {
      DubinIn := 0
      Sleep 700
      SendChat("/me повесил дубинку на пояс")   
      }
      }
      
      
      if (getPlayerWeaponId() = 31) and (M4In = 0)
      {
      M4In := 1
      Sleep 700
      SendChat("/me взял карабин М4А1 в руки ") 
      }
    
      if (getPlayerWeaponId() = 0) 
      {
      if M4In
      {
      M4In := 0
      Sleep 700
      SendChat("/me спрятал карабин М4А1")   
      }
      }
      
        if (getPlayerWeaponId() = 24) and (deagleIn = 0)
      {
      deagleIn := 1
      Sleep 700
      SendChat("/me достал пистолет из кобуры") 
      }
    
      if (getPlayerWeaponId() = 0) 
      {
      if deagleIn
      {
      deagleIn := 0
      Sleep 700
      SendChat("/me положил пистолет в кобуру")   
      }
      }
      
  
  
  
    }
   old := new
   Loop, read, %filename%
      if A_LoopReadLine
   {
    global lastline11 := last
        last := A_LoopReadLine
   }
   return last
}



ptNearPlayers()
{
 dist := 20
 p := getStreamedInPlayersInfo()  ; streamedinplayers array
 if(!p)
  return
 lpos := getCoordinates() ; your position
 if(!lpos)
  return
 For i, o in p
 {
  t:=getDist(lpos,o.POS)
  if(t<=dist)
  {
   Colorpl := getplayercolor(i)
   if !(colorpl = 851712) and !(colorpl = 851882)
   {
   addChatMessage(o.NAME )
   SendChat("/pt " i )
   sleep 500
   }
  }
 }
}

ArrestNearPlayers()
{
 dist := 4
 p := getStreamedInPlayersInfo()  ; streamedinplayers array
 if(!p)
  return
 lpos := getCoordinates() ; your position
 if(!lpos)
  return
 For i, o in p
 {
  t:=getDist(lpos,o.POS)
  if(t<=dist)
  {
    Colorpl := getplayercolor(i)
      if !(colorpl = 851712) and !(colorpl = 851882)
      {
      SendChat("/arrest " i )
      Return i
      }        
  }
 }
}

UnmaskNearPlayer()
{
dist := 4
 p := getStreamedInPlayersInfo()  ; streamedinplayers array
 if(!p)
  return
 lpos := getCoordinates() ; your position
 if(!lpos)
  return
 For i, o in p
 {
  t:=getDist(lpos,o.POS)
  if(t<=dist)
  {
    Colorpl := getplayercolor(i)
      if (color = 2054579968)
      {
      SendChat("/unmask " i )
      ;Return i
      }        
  }
 }
}

