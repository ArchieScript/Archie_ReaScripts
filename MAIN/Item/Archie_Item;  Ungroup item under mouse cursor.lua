--[[
   * Category:    Item
   * Description: Ungroup item under mouse cursor
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Ungroup item under mouse cursor (to assign to the mouse wheel)
   * О скрипте:   Разгруппировать элемент под курсором мыши (назначить на колесо мыши)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75 (RMM Forum)
   * Gave idea:   Supa75 (RMM Forum)
   * Changelog:   +  initialе / v.1.0 [28.12.18]
==============================================================================================
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.8 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
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
        
   


    local window, segment, details = reaper.BR_GetMouseCursorContext();
    local item = reaper.BR_GetMouseCursorContext_Item();
    if not item then Arc.no_undo() return end;
    
    local group = reaper.GetMediaItemInfo_Value(item,"I_GROUPID");
    if group ~= 0 then;
        reaper.Undo_BeginBlock();
        reaper.SetMediaItemInfo_Value(item,"I_GROUPID",0);
        reaper.Undo_EndBlock("Ungroup item under mouse cursor",-1);
        reaper.UpdateArrange()
    else;
        Arc.no_undo();
    end;