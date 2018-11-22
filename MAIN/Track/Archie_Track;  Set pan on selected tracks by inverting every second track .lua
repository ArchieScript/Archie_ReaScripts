--[[
   * Category:    Track
   * Description: Set pan on selected tracks by inverting every second track
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Set pan on selected tracks by inverting every second track
   * О скрипте:   Установите панораму на выбранные дорожки, инвертируя каждую вторую дорожку
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    borisuperful(Rmm/forum)
   * Gave idea:   borisuperful(Rmm/forum)
   * Changelog:   +  initialе / v.1.0
--===========================================================
SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.961 -------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
    SWS v.2.9.7 ------------ \ http://www.sws-extension.org/index.php -\(and above \ и выше)\
    ReaPack v.1.2.2 --------- \  http://reapack.com/repos --------------\(and above \ и выше)\
    Arc_Function_lua v.1.0.8 - \ http://clck.ru/EjERc -------------------\(and above \ и выше)\
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
                            .." install ReaPack to install this file.") return end
    package.path = package.path..";"..ScriptPath.."/?.lua"------------------------
    Arc = require "Arc_Function_lua"----------------------
    --==============================



   local CountSelTr = reaper.CountSelectedTracks(0);
   if CountSelTr == 0 then Arc.no_undo() return end;

   local SelTrack = reaper.GetSelectedTrack(0,0);
   local Pan = reaper.GetMediaTrackInfo_Value(SelTrack, "D_PAN");

   local cancel,retvals_csv = reaper.GetUserInputs(
                              "Set pan inverting every second track",1,
                              "Value Pan:----------------------------------",
                                        math.floor(Pan*100+0.5));
   if cancel == false then Arc.no_undo() return end;
   if not tonumber(retvals_csv) then Arc.no_undo() return end;
   retvals_csv = retvals_csv / 100;
   
   reaper.Undo_BeginBlock();

   for i = 1,CountSelTr do;  
       local SelTrack = reaper.GetSelectedTrack(0,i-1);
       reaper.SetMediaTrackInfo_Value(SelTrack, "D_PAN",retvals_csv);
       retvals_csv = Arc.invert_number(retvals_csv);
   end;

   reaper.Undo_EndBlock("Set pan on selected tracks by inverting every second track",-1);