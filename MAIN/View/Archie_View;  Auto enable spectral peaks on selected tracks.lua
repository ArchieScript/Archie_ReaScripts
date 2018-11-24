--[[
   * Category:    View
   * Description: Auto enable spectral peaks on selected tracks
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Auto enable spectral peaks on selected tracks
   * О скрипте:   Автоматическое включение спектральных пиков на выбранных дорожках
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1(RMM Forum)
   * Gave idea:   smrz1(RMM Forum)
   * Changelog:   + initialе / v.1.0
--===========================================================
SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.962 -------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
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
                            .." install ReaPack to install this file.") return end-------------
    package.path = package.path..";"..ScriptPath.."/?.lua"-------------------------------------
    Arc = require "Arc_Function_lua"-----------------------------------------------------------
    --========================================================================================= 



    ---------------------------------------------------------------------------------------
    -- reaper.DeleteExtState("Archie工具提示窗口AutoEnableSpectral","AutoEnableSpectral口窗示提",true)
    local TooltipWind = reaper.GetExtState("Archie工具提示窗口AutoEnableSpectral","AutoEnableSpectral口窗示提");
    if TooltipWind == "" then;
    
        local MessageBox = reaper.ShowMessageBox(
        "Rus.\n"..
        "* ВАЖНО:\n"..
        "    ** ПРИ ОТКЛЮЧЕНИИ СКРИПТА ПОЯВИТСЯ ОКНО \n"..
        "                                                 (Reascript task control):\n"..
        "       ДЛЯ КОРЕКТНОЙ РАБОТЫ СКРИПТА СТАВИМ ГАЛКУ\n"..
        "       (Remember my answer for this script)\n       НАЖИМАЕМ Terminate instances\n"..
        "-----------------------------------------------------------------------\n"..
        "Eng.\n"..
        "* IMPORTANTLY:\n"..
        "    ** WHEN you DISABLE SCRIPT WINDOW will APPEAR\n"..
        "                                                     (Reascript task control):\n"..
        "       FOR CORRECT WORK OF THE SCRIPT PUT THE CHECK\n"..
        "       (Remember my answer for this script)\n       CLICK Terminate instances\n"..
        "------------------------------------------------------------------------\n\n"..
        "НЕ ПОКАЗЫВАТЬ ПОЛЬШЕ ЭТО ОКНО  -  ОК\n\n"..
        "DO NOT SHOW THIS WINDOW - OK",
        "Help / Auto enable spectral peaks on selected tracks.", 1);
    
        if MessageBox == 1 then ;
            reaper.SetExtState("Archie工具提示窗口AutoEnableSpectral","AutoEnableSpectral口窗示提",MessageBox, true);
        end;----------------------------------------------------------------------------------------------
    end;-------------------------------------------------------------------------------------------------
    --==================================================================================================



    function SetToggleButtonOnOff(numb)
        local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context()
        reaper.SetToggleCommandState( sec, cmd, numb or 0) 
        reaper.RefreshToolbar2( sec, cmd )
    end



    local function Run()
        reaper.PreventUIRefresh(1);
        for i = 1,reaper.CountTracks(0) do
            local Track = reaper.GetTrack(0,i-1);
            local sel = reaper.IsTrackSelected(Track); 
            local PrevSpect = Arc.GetPreventSpectralPeaksInTrack(Track);
            if sel == false then;
                if PrevSpect == false then;
                    Arc.SetPreventSpectralPeaksInTrack(Track,true);
                end;
            else;
                if PrevSpect == true then;  
                    Arc.SetPreventSpectralPeaksInTrack(Track,false);
                end;
            end;
        end;
        reaper.PreventUIRefresh(-1);
    end;



    local function loop();

        local Spectral = reaper.GetToggleCommandState(42073);
        if Spectral == 0 then Arc.no_undo() return end;


        local sel1,sel2 = "";
        if not sel2 then sel2 = "" end;

        local CountTrack = reaper.CountTracks(0)
        if CountTrack == 0 then Arc.no_undo() return end;
        for i = 1,CountTrack do
            local Track = reaper.GetTrack(0,i-1)
            local sel = reaper.IsTrackSelected(Track)
            sel1 = sel1..tostring(sel) 
        end
        if sel1 ~= sel2 then
            Run()
        end
        sel2 = sel1  

        reaper.defer(loop) 
    end



    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;

    local id = 42073;
    local Spectral = reaper.GetToggleCommandState(id);
    if Spectral == 0 then Arc.Action(id) end;

    SetToggleButtonOnOff(1)
    loop()
    reaper.atexit(SetToggleButtonOnOff)