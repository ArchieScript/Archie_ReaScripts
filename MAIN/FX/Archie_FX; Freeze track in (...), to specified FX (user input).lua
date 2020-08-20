--[[
   * Category:    Fx
   * Description: Freeze track in (...), to specified Fx (user input)
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   Заморозить трек в (...), до указанного Fx (пользовательский ввод)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Maestro Sound(RMM)
   * Gave idea:   Maestro Sound(RMM)
   * Provides:
   *              [nomain] .
   *              [main] . > Archie_FX; Freeze track in mono, to specified FX (user input).lua
   *              [main] . > Archie_FX; Freeze track in stereo, to specified FX (user input).lua
   *              [main] . > Archie_FX; Freeze track in multichannel, to specified FX (user input).lua
   * Changelog:   v.1.01 [09062019]
   *                  +  initialе


    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.975 +            --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (+) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]]



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------


    local scrName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");

    local command_id,inf;
    if scrName == "Archie_FX; Freeze track in mono, to specified FX (user input).lua" then;
        command_id = 40901;--freez
        inf = "mono"
    elseif scrName == "Archie_FX; Freeze track in stereo, to specified FX (user input).lua" then;
        command_id = 41223;
        inf = "stereo"
    elseif scrName == "Archie_FX; Freeze track in multichannel, to specified FX (user input).lua" then;
        command_id = 40877;
        inf = "multichannel"
    else;
        reaper.MB("RUS:\nНеверное имя скрипта\nИмя должно быть одно из следующих ***\n\n\n"..
                  "ENG:\nInvalid script name\nThe name must be one of the following ***\n\n\n***\n"..
                  "Archie_FX; Freeze track in mono, to specified FX (user input).lua\n"..
                  "Archie_FX; Freeze track in stereo, to specified FX (user input).lua\n"..
                  "Archie_FX; Freeze track in multichannel, to specified FX (user input).lua","ERROR",0)
        no_undo() return;
    end;




    local sel;
    local LastTouchedTrack = reaper.GetLastTouchedTrack();
    if LastTouchedTrack then;
        sel = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"I_SELECTED");
    end;

    if not LastTouchedTrack or sel == 0 then;
        reaper.MB("Track not selected","Woops",0);
        no_undo() return;
    end;

    local freezTrack = LastTouchedTrack;



    local FX_Count = reaper.TrackFX_GetCount(freezTrack);
    --if FX_Count == 0 then no_undo() return end;
    if FX_Count == 0 then;
        reaper.MB("No Fx in track","Woops",0);
        no_undo() return;
    end;



    local retval,str = reaper.GetTrackStateChunk(freezTrack,"",false);
    local numb = (tonumber(str:match("<FXCHAIN.-LASTSEL ([-]-%d+)"))or -1)+1;
    local FX_Count = reaper.TrackFX_GetCount(freezTrack);
    if FX_Count < numb then numb = FX_Count end;



    ::Repeat1::
    local retval, retvals_csv = reaper.GetUserInputs("Freeze track in "..inf..", up selected FX",1,"Set Number select FX / 1 - "..FX_Count,numb);
    if not retval then no_undo() return end;
    retvals_csv = tonumber(retvals_csv);
    if not retvals_csv or retvals_csv < 1 or retvals_csv > FX_Count then;
        local MB = reaper.MB("RUS:\nНеверные значения\nЗначения должны быть от 1 до "..FX_Count.."\n\n"..
                  "ENG:\nIncorrect value\nValues must be between 1 and "..FX_Count,"ERROR",5);
        if MB == 2 then no_undo() return end;
        if MB == 4 then goto Repeat1 end;
    end;

    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();

    reaper.InsertTrackAtIndex(0,false);
    local firstTrack = reaper.GetTrack(0,0);
    for i = reaper.TrackFX_GetCount(firstTrack)-1,0,-1 do;
        reaper.TrackFX_Delete(firstTrack,i);
    end;

    local fxCount = reaper.TrackFX_GetCount(freezTrack);
    for i = 1, (fxCount-retvals_csv) do;
        local fxCountM = reaper.TrackFX_GetCount(firstTrack);
        reaper.TrackFX_CopyToTrack(freezTrack,retvals_csv,firstTrack,fxCountM,true);
    end;

    reaper.Main_OnCommand(command_id,0);

    local FX_Count = reaper.TrackFX_GetCount(firstTrack);
    for i = 1, FX_Count do;
        local FX_GetCount = reaper.TrackFX_GetCount(freezTrack);
        reaper.TrackFX_CopyToTrack(firstTrack,0,freezTrack,FX_GetCount,true);
    end;

    reaper.DeleteTrack(firstTrack);
    reaper.Undo_EndBlock("Freeze track in "..inf..", up selected FX",-1);
    reaper.PreventUIRefresh(-1);