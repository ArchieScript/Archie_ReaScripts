--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Set note ends to start of next note - in selected items (legato)
   * Author:      Archie
   * Version:     1.03
   * Описание:    Установите конец ноты в начало следующей ноты - в выбранных элементах (Легато)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    AlexLazer(Rmm)$
   * Gave idea:   AlexLazer(Rmm)$
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI; Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   
   *              v.1.03 [17.11.19]
   *                  +! fixed bug main window disappearing 
   
   *              v.1.02 [16.11.19]
   *                  +! fix bug  
   *              v.1.0 [16.11.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local Opacity = reaper.APIExists("JS_Window_SetOpacity");
    local Destroy = reaper.APIExists("JS_Window_Destroy");
    local js = "reaper_js_ReaScriptAPI";
    if not Opacity or not Destroy then;
        reaper.MB("Missing - "..js.."\n\nОтсутствует - "..js.."\n","Error !",0);
        no_undo() return;
    end;
    
    
    local Sel_all_event = 40006;
    local UnSel_all_evn = 40214;
    local legato_end_to = 40405;
    local Open_built_MD = 40153;
    local showMDEditWin = 2;
    local Open_all_selI = 204640;
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    
    local TakeIsMIDI;
    for i = 1,CountSelItem do;
        local Sel_item = reaper.GetSelectedMediaItem(0,i-1);
        local take = reaper.GetActiveTake(Sel_item);
        TakeIsMIDI = reaper.TakeIsMIDI(take);
        if TakeIsMIDI then break end;
    end;
    
    if not TakeIsMIDI then no_undo() return end;
    
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    ----
    while true do;
        local midieditor = reaper.MIDIEditor_GetActive();
        if midieditor then;
            reaper.MIDIEditor_OnCommand(midieditor,showMDEditWin);
            --reaper.JS_Window_Destroy(midieditor);
        else;
            break;
        end;
        --t=(t or 0)+1;
    end;
    ----
    local ConfigVar = reaper.SNM_GetIntConfigVar("midieditor",0);
    if ConfigVar ~= Open_all_selI then;
        reaper.SNM_SetIntConfigVar("midieditor",Open_all_selI);
    end;
    ---
    reaper.Main_OnCommand(Open_built_MD,0);
    local midieditor = reaper.MIDIEditor_GetActive();
    reaper.JS_Window_SetOpacity(midieditor,"ALPHA",0);
    
    reaper.MIDIEditor_OnCommand(midieditor,Sel_all_event);
    reaper.MIDIEditor_OnCommand(midieditor,legato_end_to);
    reaper.MIDIEditor_OnCommand(midieditor,UnSel_all_evn);
    reaper.JS_Window_SetOpacity(midieditor,"ALPHA",1);
    reaper.JS_Window_Destroy(midieditor);
    ---
    if ConfigVar ~= Open_all_selI then;
        reaper.SNM_SetIntConfigVar("midieditor",ConfigVar);
    end;
    ---
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("legato selected items",-1);