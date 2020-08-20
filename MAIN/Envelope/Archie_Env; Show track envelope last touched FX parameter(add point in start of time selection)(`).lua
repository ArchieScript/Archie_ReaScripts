--[[
   * Category:    Envelope
   * Description: Show track envelope last touched FX parameter(add point in start of time selection)
   * Author:      Archie
   * Version:     1.04
   * AboutScript: Show track envelope last touched FX parameter(add point in start of time selection)
   * О скрипте:   Показать трек автоматизации последнего тронутого параметра FX
   *                                                         (добавить точку в начало выбора времени)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Martin111(Rmm/forum)
   * Gave idea:   Martin111(Rmm/forum)
   * Changelog:
   *              +  Added the ability to select a track / v.1.02 [280219]
   *              +  Добавлена возможность выделения трека / v.1.02 [280219]

   *              +  Fixed paths for Mac/ v.1.01 [29.01.19]
   *              +  Исправлены пути для Mac/ v.1.01 [29.01.19]
   *              +  initialе / v.1.0


   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local RemoveFirstPoint = 1
                        -- = 1 | Удалить первую точку при создании конверта(автоматизации)
                        -- = 0 | Не удалять первую точку при создании конверта(автоматизации)
                                                      ------------------------------------
                        -- = 1 | Delete the first point when creating an envelope (automation)
                        -- = 0 | Do not delete the first point when creating an envelope (automation)
                        -----------------------------------------------------------------------------


    local Selected_Track = 1
                      -- = 1 | Выделить трек конверта
                      -- = 0 | Не выделять трек конверта
                               -------------------------
                      -- = 1 | Select envelope track
                      -- = 0 | Do not select envelope track
                      -------------------------------------


    local StartPoint = 0
                  -- = 1 | Добавить точку в начале выбора времени
                  -- = 0 | Не добавлять точку в начале выбора времени
                           ------------------------------------------
                  -- = 1 | Add a point at the beginning of time selection
                  -- = 0 | Do not add a point at the beginning of time selection
                  --------------------------------------------------------------



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
	



    local Sel = Selected_Track;
    local retval,tracknumber,fxnumber,paramnumber = reaper.GetLastTouchedFX();
    if retval == false then Arc.no_undo() return end;

    local Track = reaper.GetTrack(0,tracknumber-1);
    if not Track then Arc.no_undo() return end;

    reaper.Undo_BeginBlock();

    local envelope =  reaper.GetFXEnvelope(Track,fxnumber,paramnumber,true);
    if Sel == 1 then
        reaper.SetCursorContext(2,envelope);
    end


    local startTime,endTime = reaper.GetSet_LoopTimeRange(0,0,0,0,0);

    if StartPoint == 1 then startTime = endTime end
    if startTime ~= endTime then;
        local retval,value,_,_,_ = reaper.Envelope_Evaluate(envelope,startTime,0,0);
        reaper.DeleteEnvelopePointRange(envelope,startTime-0.01,startTime+0.01);
        reaper.InsertEnvelopePoint(envelope,startTime,value,0,0,1,true);
        if RemoveFirstPoint == 1 then;
            local CountEnvPoint = reaper.CountEnvelopePoints(envelope);
            if CountEnvPoint <= 2 then;
                reaper.DeleteEnvelopePointRange(envelope,0,0.1);
            end;
        end;
        reaper.Envelope_SortPoints(envelope);
    end;

    local Undo = "Show track envelope last touched FX parameter(add point in start of time selection)"
    reaper.Undo_EndBlock(Undo,-1);
    reaper.TrackList_AdjustWindows(false);
    reaper.UpdateArrange();