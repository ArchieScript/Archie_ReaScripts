--[[
   * Category:    Envelope
   * Description: Show track envelope last touched FX parameter(add point in start of time selection)
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Show track envelope last touched FX parameter(add point in start of time selection)
   * О скрипте:   Показать трек автоматизации последнего тронутого параметра FX
   *                                                         (добавить точку в начало выбора времени)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Martin111(Rmm/forum)
   * Gave idea:   Martin111(Rmm/forum)
   * Changelog:   +  initialе / v.1.0
--===========================================================
SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.962 -------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
    SWS v.2.9.7 ------------ \ http://www.sws-extension.org/index.php -\(and above \ и выше)\
    ReaPack v.1.2.2 --------- \  http://reapack.com/repos --------------\(and above \ и выше)\
    Arc_Function_lua v.1.1.0 - \ http://clck.ru/EjERc -------------------\(and above \ и выше)\
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



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --======================================= FUNCTION MODULE FUNCTION =============================================================
    local Path,Mod,T,Way = reaper.GetResourcePath()--================== FUNCTION MODULE FUNCTION ===================================
    T = {Path..'\\Scripts\\Archie-ReaScripts\\Functions',(select(2,reaper.get_action_context()):match("(.+)[\\]")),Path};--=========
    for i=1,#T do;for j=0,math.huge do;Mod=reaper.EnumerateFiles(T[i],j);--=========================================================
        if Mod=="Arc_Function_lua.lua"then Way=T[i]break end;if not Mod then break end;end;if Way then break end;--=================
    end;if not Way then reaper.MB ('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in \n'..T[1]
    ..'\n\nОтсутствует файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..T[1],"Error.",0)else;--
    package.path = package.path..";"..Way.."/?.lua";Arc=require"Arc_Function_lua";Arc.VersionArc_Function_lua("2.0.0",Way,"")end;---
    --=========================================================================================================▲▲▲▲▲================




    local retval,tracknumber,fxnumber,paramnumber = reaper.GetLastTouchedFX();
    if retval == false then Arc.no_undo() return end;

    local Track = reaper.GetTrack(0,tracknumber-1);
    if not Track then Arc.no_undo() return end;

    reaper.Undo_BeginBlock();

    local envelope =  reaper.GetFXEnvelope(Track,fxnumber,paramnumber,true);
    local startTime,endTime = reaper.GetSet_LoopTimeRange(0,0,0,0,0);

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