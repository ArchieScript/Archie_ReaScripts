--[[
   * Category:    Envelope
   * Description: Show-hide track envelope last touched FX parameter(add point in start of time selection)
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Show-hide track envelope last touched FX parameter(add point in start of time selection)
   * О скрипте:   Показать-Скрыть трек автоматизации последнего тронутого параметра FX
   *                                                         (добавить точку в начало выбора времени)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Martin111(Rmm/forum)
   * Gave idea:   Martin111(Rmm/forum)
   * Changelog:   +  initialе / v.1.0
--===========================================================
SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.961 -------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
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
                                                      ---------------------------------------
                        -- = 1 | Delete the first point when creating an envelope (automation)
                        -- = 0 | Do not delete the first point when creating an envelope (automation)
                        -----------------------------------------------------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --Mod------------------Mod---------------------Mod--
    local function GetSubdirectoriesUpToLevelFive(Path);
      local T,Enu,s,h = {Path},reaper.EnumerateSubdirectories,"\\",math.huge; 
      for i=0,h do;f1 = Enu(Path,i);if f1 then;T[#T+1]=Path..s..f1;
        for i2=0,h do;f2=Enu(Path..s..f1,i2)if f2 then T[#T+1]=Path..s..f1..s..f2;
          for i3=0,h do;f3=Enu(Path..s..f1..s..f2,i3)if f3 then T[#T+1]=Path..s..f1..s..f2..s..f3;
            for i4=0,h do;f4 = Enu(Path..s..f1..s..f2..s..f3,i4)if f4 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4;
              for i5=0,h do;f5=Enu(Path..s..f1..s..f2..s..f3..s..f4,i5)if f5 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4..s..f5;
              ----------
              end;if not f5 then break end;end;
            end;if not f4 then break end;end;
          end;if not f3 then break end;end;
        end;if not f2 then break end;end; 
      end;if not f1 then return T end;end;
    end;
    ---
    local function GetModule(Path,file);
      local FolPath,mod,Way = GetSubdirectoriesUpToLevelFive(Path);
      for i=0,#FolPath do;if not FolPath[i]then FolPath[i]=select(2,reaper.get_action_context()):match("(.+)[\\]")end;
        for i2 = 0,math.huge do; local f = reaper.EnumerateFiles(FolPath[i],i2);
          if f == file then mod=true Way=FolPath[i]break end;if not f then break end;
        end; if mod then return mod,Way end;
      end----------------------------------
    end------------------------------------
    ---------------------------------------
    local found_mod,ScriptPath,Arc = GetModule(reaper.GetResourcePath(),"Arc_Function_lua.lua")
    if not found_mod then reaper.ReaScriptError("Missing 'Arc_Function_lua' file,"-------------
                            .." install ReaPack to install this file.") return end
    package.path = package.path..";"..ScriptPath.."/?.lua"------------------------
    Arc = require "Arc_Function_lua"----------------------
    --==============================




    local retval,tracknumber,fxnumber,paramnumber = reaper.GetLastTouchedFX();
    if retval == false then Arc.no_undo() return end;

    local Track = reaper.GetTrack(0,tracknumber-1);
    if not Track then Arc.no_undo() return end;

    reaper.Undo_BeginBlock();

    local visibleIn;
    local envelope = reaper.GetFXEnvelope(Track,fxnumber,paramnumber,false);

    if envelope then;

        local EnvAlloc = reaper.BR_EnvAlloc(envelope,false);
        local active,
              visible,
              armed,
              inLane,
              laneHeight,
              defaultShape,
              minValue,
              maxValue,
              centerValue,
              types,
              faderScaling = reaper.BR_EnvGetProperties(EnvAlloc);
              
        if visible == true then visibleIn = false else visibleIn = true end;
 
        reaper.BR_EnvSetProperties(EnvAlloc,
                                   active,
                                   visibleIn,--visible,
                                   armed,
                                   inLane,
                                   laneHeight,
                                   defaultShape,
                                   faderScaling);
        reaper.BR_EnvFree(EnvAlloc,true);
    else;
        local envelope = reaper.GetFXEnvelope(Track,fxnumber,paramnumber,true);
        visibleIn = true
    end;


    if visibleIn == true then;

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
    end;

    reaper.TrackList_AdjustWindows(false);
    reaper.UpdateArrange();


    if visibleIn == true then;
    local Undo = "Show track envelope last touched FX parameter(add point in start of time selection)"
        reaper.Undo_EndBlock(Undo,-1);
    elseif visibleIn == false then;
    local Undo = "Hide track envelope last touched FX parameter(add point in start of time selection)"
        reaper.Undo_EndBlock(Undo,-1);
    end;

    reaper.TrackList_AdjustWindows(false);