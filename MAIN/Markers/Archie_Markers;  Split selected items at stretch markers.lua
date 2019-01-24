--[[
   * Category:    Markers
   * Description: Split selected items at stretch markers
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Split selected items at stretch markers
   * О скрипте:   Разделить выбранные элементы по маркерам растяжкам
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    borisuperful(Rmm/forum) 
   * Gave idea:   borisuperful(Rmm/forum) 
   * Changelog:   + initialе / v.1.0 [011218]

--============================================================================================|
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.962 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.1.1.6 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
--===========================================================================================]]




    --=========================================================================================
    --/////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\\\
    --=========================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load=reaper.GetResourcePath()..'\\Scripts\\Archie-ReaScripts\\Functions',select(2,reaper.get_action_context()):match("(.+)[\\]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.1.8",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then Arc.no_undo() return end;

    local Undo;
    reaper.PreventUIRefresh(1);
    for j = CountSelItem-1,0,-1 do;

        local SelItem = reaper.GetSelectedMediaItem(0,j);
        local ActiveTake = reaper.GetActiveTake(SelItem);
        local NumStrMar = reaper.GetTakeNumStretchMarkers(ActiveTake);
        if NumStrMar > 0 then;
            if not Undo then;
                reaper.Undo_BeginBlock()
                Undo = "Active"
            end
            local PlayRate = reaper.GetMediaItemTakeInfo_Value(ActiveTake,"D_PLAYRATE")
            local posIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
            for i = NumStrMar-1,0,-1 do;
                local pos = posIt+select(2,reaper.GetTakeStretchMarker(ActiveTake,i))/PlayRate;
                reaper.SplitMediaItem(SelItem,pos);
            end;  
        end;
    end;
    

    if Undo then;
        reaper.Undo_EndBlock("Split selected items at stretch markers",-1);
    else;
        Arc.no_undo();
    end;
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();