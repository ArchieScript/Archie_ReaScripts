--[[
   * Category:    Markers
   * Description: Split selected items at stretch markers and remove markers, no save processed wave
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Split selected items at stretch markers and remove markers, no save processed wave
   * О скрипте:   Разделить выбранные элементы на маркеры растяжения и удалить маркеры,
   *                                                              без сохранения обработанной волны
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




    --Mod------------------Mod---------------------Mod--
    local function GetSubdirectoriesUpToLevelFive(Path);
      local T,Enu,s,h = {Path},reaper.EnumerateSubdirectories,"\\",math.huge; 
      for i=0,h do;f1 = Enu(Path,i);if f1 then;T[#T+1]=Path..s..f1;
        for i2=0,h do;f2=Enu(Path..s..f1,i2)if f2 then T[#T+1]=Path..s..f1..s..f2;
          for i3=0,h do;f3=Enu(Path..s..f1..s..f2,i3)if f3 then T[#T+1]=Path..s..f1..s..f2..s..f3;
            for i4=0,h do;f4 = Enu(Path..s..f1..s..f2..s..f3,i4)if f4 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4;
              for i5=0,h do;f5=Enu(Path..s..f1..s..f2..s..f3..s..f4,i5)if f5 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4..s..f5;
              ------------------------
              end;if not f5 then break end;end;
            end;if not f4 then break end;end;
          end;if not f3 then break end;end;
        end;if not f2 then break end;end; 
      end;if not f1 then return T end;end;
    end;
    ---
    local function GetModule(Path,file);
    local FolPath,mod,Way = GetSubdirectoriesUpToLevelFive(Path);
    FolPath[-1]=Path..'/Scripts/Archie-ReaScripts/Functions';FolPath[0]=select(2,reaper.get_action_context()):match("(.+)[\\]")
    for i=-1,#FolPath do;for i2 = 0,math.huge do; local f = reaper.EnumerateFiles(FolPath[i],i2);
    if f == file then mod=true Way=FolPath[i]break end;if not f then break end;end; if mod then return mod,Way end;end;end;
    -----------------------------------------------------------------------------------------------------------------------
    local found_mod,ScriptPath,Arc = GetModule(reaper.GetResourcePath():gsub('%\\','/'),"Arc_Function_lua.lua")------------
    if not found_mod then reaper.ClearConsole()reaper.ShowConsoleMsg('Missing file "Arc_Function_lua",\nDownload from'..---
    'repository Archie-ReaScript and put in resources of Reaper.\nОтсутствует файл "Arc_Function_lua",\nСкачайте из '..----
    'репозитория Archie-ReaScript и поместите в ресурсы Reaper') return end------------------------------------------------
    package.path = package.path..";"..ScriptPath.."/?.lua"-----------------------------------------------------------------
    Arc = require "Arc_Function_lua"---------------------------------------------------------------------------------------
    Arc.VersionArc_Function_lua("1.1.6",ScriptPath,"")---------------------------------------------------------------------
    --=====================================================================================================================





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
                reaper.Undo_BeginBlock();
                Undo = "Active";
            end;
            ---
            local pos,SplIt,ItemGUID = {},{[1]=SelItem},{};
            local posIt = Arc.GetMediaItemInfo_Value(SelItem,"D_POSITION");
            local PlayRate = reaper.GetMediaItemTakeInfo_Value(ActiveTake,"D_PLAYRATE")
            for i = 1,NumStrMar do;
                pos[i] = posIt+select(2,reaper.GetTakeStretchMarker(ActiveTake,i-1))/PlayRate;
            end;
            ---
            for i = #pos,1,-1 do;
                SplIt[#SplIt+1] = reaper.SplitMediaItem(SelItem,pos[i]);
            end;
            ---
            for i = 1, #SplIt do;
                ItemGUID[i] = reaper.BR_GetMediaItemGUID(SplIt[i]);
            end;
            ---   
            for i = 1,#ItemGUID do;
                local ItemByG = reaper.BR_GetMediaItemByGUID(0,ItemGUID[i]);
                local ActiveTake = reaper.GetActiveTake(ItemByG);
                local NumStrMar = reaper.GetTakeNumStretchMarkers(ActiveTake);
                reaper.DeleteTakeStretchMarkers(ActiveTake,0,NumStrMar);
            end;
        end;
    end;
    ---
    if Undo then;
        local UndoPoint = "Split selected items at stretch markers and remove markers, no save processed wave"
        reaper.Undo_EndBlock(UndoPoint,-1);
    else;
        Arc.no_undo();
    end;
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();