--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Edit cursor
   * Description: Edit cursor; Go To Time(time).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    smrz1(---)
   * Gave idea:   smrz1(---)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [260820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local CurPos = reaper.GetCursorPosition();
    local buf = reaper.format_timestr_pos(CurPos,'',0);
    local title = 'Go To Time (time)';
    local retval,retvals_csv = reaper.GetUserInputs(title,1,'Sec:,extrawidth=25',buf);
    if not retval then no_undo()return end;
    
    local MSec = retvals_csv:match(                  '(%d+)$')or 0;
    local Sec  = retvals_csv:match(            '(%d+)%D+%d*$')or 0;
    local Min  = retvals_csv:match(      '(%d+)%D+%d*%D+%d*$')or 0;
    local Hour = retvals_csv:match('(%d+)%D+%d*%D+%d*%D+%d*$')or 0;
    
    local time = reaper.parse_timestr_pos(Hour..':'..Min..':'..Sec..'.'..MSec,0);
    reaper.SetEditCurPos(time,true,false);
    
    no_undo();