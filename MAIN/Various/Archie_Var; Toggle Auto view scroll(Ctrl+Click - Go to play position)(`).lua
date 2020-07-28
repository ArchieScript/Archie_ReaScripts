--[[
   * Category:    Various
   * Description: Toggle auto view scroll(ctrl+click go to play position)
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Toggle auto view scroll(ctrl+click go to play position)
   * О скрипте:   Переключения автоматической прокрутки(Ctrl+щелчок перейти к позиции воспроизведения)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM)
   * Gave idea:   YuriOl(RMM)
   * Provides:
   *              [main] .
   *              [main=midi_editor] . > Archie_MidiEditor;  Toggle Auto view scroll(Ctrl+Click - Go to play position)(`).lua
   * Changelog:   +  initialе / v.1.0 [21.05.19]

   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos
   (+) Arc_Function_lua v.2.4.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
   (+) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6
   =======================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local AUTOSCROLON = 0
                   -- = 0 | не включать авто скролл при запуске с ctrl
                   -- = 1 | включить авто скролл при запуске с ctrl
                           ----------------------------------------
                   -- = 0 | do not turn on auto scroll when starting with ctrl
                   -- = 1 | enable auto scroll when starting with ctrl
                   ---------------------------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	



    local Api_js,version = Arc.js_ReaScriptAPI(true,0.987);
    if not Api_js then Arc.no_undo()return end;


    Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false);


    local Ctrl = reaper.JS_Mouse_GetState(127);
    if Ctrl&4 == 4 then;

        reaper.Main_OnCommand(40150,0);--Go to play
        local midieditor = reaper.MIDIEditor_GetActive();
        if midieditor then;
            reaper.MIDIEditor_OnCommand(midieditor,40150);--Go to play
        end;

        if AUTOSCROLON == 1 then;
            local Toggle = reaper.GetToggleCommandStateEx(0,40036);
            if Toggle ~= 1 then;
                reaper.Main_OnCommand(40036,0);--auto scroll
                Arc.SetToggleButtonOnOff(1);
            end;
            if midieditor then;
                Toggle = reaper.GetToggleCommandStateEx(32060,40750);--auto scroll
                if Toggle ~= 1 then;
                    reaper.MIDIEditor_OnCommand(midieditor,40750);--auto scroll
                end;
            end;
        end;
    else;
        reaper.Main_OnCommand(40036,0);--auto scroll
        local Toggle = reaper.GetToggleCommandStateEx(0,40036);

        local midieditor = reaper.MIDIEditor_GetActive();
        if midieditor then;
            local ToggleMidi = reaper.GetToggleCommandStateEx(32060,40750);--auto scroll
            if ToggleMidi ~= Toggle then;
                reaper.MIDIEditor_OnCommand(midieditor,40750);--auto scroll
            end;
        end;

        if Toggle == 1 then;
            Arc.SetToggleButtonOnOff(1);
        else;
            Arc.SetToggleButtonOnOff(0);
        end;
    end;


    local function loop();
        local _,_,sectionID,cmdID,_,_,_ = reaper.get_action_context();
        local ToggleScript = reaper.GetToggleCommandStateEx(sectionID,cmdID);
        local ToggleArrange = reaper.GetToggleCommandStateEx(0,40036);
        local ToggleMidi = reaper.GetToggleCommandStateEx(32060,40750);

        if ToggleArrange ~= 1 and ToggleMidi ~= 1 then;
            if ToggleScript == 1 then;
                Arc.SetToggleButtonOnOff(0);
            end;
        else;
            if ToggleScript == 0 then;
                Arc.SetToggleButtonOnOff(1);
            end;
        end;
        --t=(t or 0)+1
        reaper.defer(loop);
    end;
    loop();