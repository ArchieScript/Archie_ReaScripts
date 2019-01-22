--[[
   * Category:    Track
   * Description: Set pan on selected tracks by inverting every second track
   * Author:      Archie
   * Version:     1.01
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




    --======================================= FUNCTION MODULE FUNCTION =============================================================
    local Path,Mod,T,Way = reaper.GetResourcePath()--================== FUNCTION MODULE FUNCTION ===================================
    T = {Path..'\\Scripts\\Archie-ReaScripts\\Functions',(select(2,reaper.get_action_context()):match("(.+)[\\]")),Path};--=========
    for i=1,#T do;for j=0,math.huge do;Mod=reaper.EnumerateFiles(T[i],j);--=========================================================
        if Mod=="Arc_Function_lua.lua"then Way=T[i]break end;if not Mod then break end;end;if Way then break end;--=================
    end;if not Way then reaper.MB ('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in \n'..T[1]
    ..'\n\nОтсутствует файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..T[1],"Error.",0)else;--
    package.path = package.path..";"..Way.."/?.lua";Arc=require"Arc_Function_lua";Arc.VersionArc_Function_lua("2.1.8",Way,"")end;---
    --=========================================================================================================▲▲▲▲▲================



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