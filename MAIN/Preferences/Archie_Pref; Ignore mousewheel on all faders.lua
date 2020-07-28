--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Preferences
   * Description: Ignore mousewheel on all faders
   * Author:      Archie
   * Version:     1.01
   * Описание:    Игнорировать колесико мыши на всех фейдерах
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Shico(Rmm)
   * Gave idea:   Shico(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.01 [08.10.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
    local IntConfigVar = reaper.SNM_GetIntConfigVar("mousewheelmode",0);
    local mousewheelMode = IntConfigVar&2;
    if mousewheelMode ~= 0 and mousewheelMode ~= 2 then no_undo() return end;
    
    reaper.Undo_BeginBlock();
    if mousewheelMode == 0 then;
        reaper.SNM_SetIntConfigVar("mousewheelmode",IntConfigVar|2);
        reaper.SetToggleCommandState(sec,cmd,1);
        reaper.Undo_EndBlock("Enable ignore mousewheel on all faders",-1);
    else;
        reaper.SNM_SetIntConfigVar("mousewheelmode",IntConfigVar&~(IntConfigVar&2));
        reaper.SetToggleCommandState(sec,cmd,0);
        reaper.Undo_EndBlock("Disable ignore mousewheel on all faders",-1);
    end;
    reaper.RefreshToolbar2(sec,cmd);