--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Unquantize Selected item
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(Rmm)
   * Gave idea:   YuriOl(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   v.1.0 [06.02.20]
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

    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;


    local X = 0;
    local TakeIsMIDI;
    for i = 1,CountSelItem do;
        local Sel_item = reaper.GetSelectedMediaItem(0,i-1);
        local take = reaper.GetActiveTake(Sel_item);
        TakeIsMIDI = reaper.TakeIsMIDI(take);
        if TakeIsMIDI then X=X+1 end;
    end;

    if not TakeIsMIDI then no_undo() return end;


    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    ----
    while true do;
        local midieditor = reaper.MIDIEditor_GetActive();
        if midieditor then;
            reaper.MIDIEditor_OnCommand(midieditor,2);--Close window
            --reaper.JS_Window_Destroy(midieditor);
        else;
            break;
        end;
        --t=(t or 0)+1;
    end;
    ----
    --==================================================


    ----
    local ConfigVar = reaper.SNM_GetIntConfigVar("midieditor",0);
    if ConfigVar ~= 204640 then;
        reaper.SNM_SetIntConfigVar("midieditor",204640);
    end;
    ---


    --==================================================
    reaper.Main_OnCommand(40153,0);--Open MIDI editor
    local midieditor = reaper.MIDIEditor_GetActive();
    dockME = reaper.GetToggleCommandStateEx(32060,40018)--Options: Toggle window docking
    if dockME > 0 then;
        reaper.MIDIEditor_OnCommand(midieditor,40018);
    end;
    reaper.JS_Window_SetOpacity(midieditor,"ALPHA",0);
    reaper.MIDIEditor_OnCommand(midieditor,40006);--Sel all event
    for i=1,X do;
        reaper.MIDIEditor_OnCommand(midieditor,40402);--Unquantize
        reaper.MIDIEditor_OnCommand(midieditor,40833);--Activate next MIDI item
    end;
    reaper.MIDIEditor_OnCommand(midieditor,40214);--UnSel all evn
    reaper.JS_Window_SetOpacity(midieditor,"ALPHA",1);
    if dockME > 0 then;
        reaper.MIDIEditor_OnCommand(midieditor,40018);
    end;
    reaper.JS_Window_Destroy(midieditor);
    --==================================================


    ---
    if ConfigVar ~= 204640 then;
        reaper.SNM_SetIntConfigVar("midieditor",ConfigVar);
    end;
    ---

    ---
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Unquantize Selected items",-1);

