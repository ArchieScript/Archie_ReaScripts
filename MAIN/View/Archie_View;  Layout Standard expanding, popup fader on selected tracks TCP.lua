--[[
   * Category:    View 
   * Description: Layout Standard expanding, popup fader on selected tracks TCP
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Layout Standard expanding, popup fader on selected tracks TCP
   * О скрипте:   Макет Стандартное расширение, всплывающий фейдер на выбранных дорожках TCP
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   ---
   * Changelog:   +  initialе / v.1.0
--===========================================================
SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.961 -------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
    SWS v.2.9.7 ------------ \ http://www.sws-extension.org/index.php -\(and above \ и выше)\
    ReaPack v.1.2.2 --------- \  http://reapack.com/repos --------------\(and above \ и выше)\
    Arc_Function_lua v.1.0.4 - \ http://clck.ru/EjERc -------------------\(and above \ и выше)\
--===========================================================================================]]




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
                            .." install ReaPack to install this file.") return end-------------
    package.path = package.path..";"..ScriptPath.."/?.lua"-------------------------------------
    Arc = require "Arc_Function_lua"-----------------------------------------------------------
    --=========================================================================================



 

    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then Arc.no_undo() return end;
    local layoutName,Active = "af --- Standard expanding, popup fader";


    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local _,str = reaper.GetTrackStateChunk(SelTrack,"",true);
        if select(2,str:match('(LAYOUTS) (".-")')) ~= '"'..layoutName..'"' then;
            Active = "Active";
        end;
    end;

    if not Active then Arc.no_undo() return end;


    reaper.Undo_BeginBlock()

    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local _,str = reaper.GetTrackStateChunk(SelTrack,"",true);
        ----
        if select(2,str:match('(LAYOUTS) (".-")')) ~= '"'..layoutName..'"' then
            -------
            local Layout = str:match('LAYOUTS ".-" ".-"');
            if not Layout then Layout = 'LAYOUTS "" ""' end;
            if Layout == 'LAYOUTS "" ""' then;
                local Perf = str:match('PERF %d+');
                str = str:gsub(Perf, Perf..'\n'..Layout);
            end;
            ---
            local Lay, TCP, MCP = str:match('(LAYOUTS) (".-") (".-")');
            local str2 = string.gsub(str, '(LAYOUTS) (".-") (".-")',Lay.." "..'"'..layoutName..'"'.." "..MCP);
            reaper.SetTrackStateChunk(SelTrack, str2, true);
            --------
        end;
    end;

    reaper.Undo_EndBlock("Layout Standard expanding, popup fader on selected tracks TCP",-1);