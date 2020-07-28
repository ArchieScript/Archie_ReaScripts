--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Item 
   * Description: Item; Apply track-take FX to items as new take(lock act take)Bypass all fx track.lua 
   * Author:      Archie 
   * Version:     1.0 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Archie(---) 
   * Gave idea:   Archie(---) 
   * Extension:   Reaper 6.12+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   *              Arc_Function_lua v.2.8.6+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc 
   * Changelog:    
   *              v.1.0 [300620] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    --========================================= 
    local function MODULE(file); 
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end; 
        if not A.VersArcFun("2.8.6",file,'')then;A=nil;return;end;return A; 
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/')); 
    if not Arc then return end; 
    --========================================= 
     
     
    local CountSelItem = reaper.CountSelectedMediaItems(0); 
    if CountSelItem == 0 then no_undo()return end; 
     
    Arc.Save_Selected_Items_Slot(1); 
     
    for i = CountSelItem-1,0,-1 do; 
        local item = reaper.GetSelectedMediaItem(0,i); 
        local take = reaper.GetActiveTake(item); 
        if not take then; 
            reaper.SetMediaItemInfo_Value(item,'B_UISEL',0); 
        end; 
    end; 
     
    local CountSelItem = reaper.CountSelectedMediaItems(0); 
    if CountSelItem == 0 then; 
        Arc.Restore_Selected_Item_Slot(1,true,false,true); 
        no_undo()return; 
    end; 
     
     
    ------------------------------------------------------------ 
    local ConfigUndo = reaper.SNM_GetIntConfigVar('undomask',0); 
    local buf = ConfigUndo; 
    if buf&1  == 0 then; buf = buf|(buf|1); end;--item 
    if buf&16 == 0 then; buf = buf|(buf|16);end;--track 
    if buf and ConfigUndo ~= buf then; 
        reaper.SNM_SetIntConfigVar('undomask',buf); 
    else; 
        ConfigUndo = nil; 
    end; 
    ------------------------------------------------------------ 
     
    reaper.Undo_BeginBlock(); 
    reaper.Undo_EndBlock(reaper.Undo_CanUndo2(0)or'',-1); 
     
    reaper.Undo_BeginBlock(); 
    reaper.PreventUIRefresh(1); 
     
     
    local t = {}; 
    for i = CountSelItem-1,0,-1 do; 
        local item = reaper.GetSelectedMediaItem(0,i); 
        local take = reaper.GetActiveTake(item); 
        t[#t+1] = {}; 
        t[#t].item = item; 
        t[#t].take = take; 
    end; 
     
    Arc.Action(40209);--Item: Apply track/take FX to items 
     
    local STOP_Script; 
    for i = 1,#t do; 
        local take = reaper.GetActiveTake(t[i].item); 
        if take == t[i].take then; 
            STOP_Script = true break; 
        end; 
    end; 
     
    if STOP_Script == true then; 
        reaper.Undo_EndBlock('&&& Cancel Apply &&&',-1); 
        reaper.Undo_DoUndo2(0); 
        Arc.Restore_Selected_Item_Slot(1,true,false,true); 
        reaper.PreventUIRefresh(-1); 
        if ConfigUndo then reaper.SNM_SetIntConfigVar('undomask',ConfigUndo)end; 
        no_undo() return; 
    end; 
     
     
    Arc.Action(41340);--Lock to active take 
     
     
    ---- 
    local t1 = {}; 
    local t2 = {}; 
    local CountSelItem = reaper.CountSelectedMediaItems(0); 
    for i = 1,CountSelItem do; 
        local item = reaper.GetSelectedMediaItem(0,i-1); 
        local track = reaper.GetMediaItemTrack(item); 
        if not t1[tostring(track)]then 
            t1[tostring(track)] = track; 
            t2[#t2+1] = track; 
        end; 
    end; 
     
    for i = 1,#t2 do; 
        local FXCount = reaper.TrackFX_GetCount(t2[i]); 
        for i2 = 1,FXCount do; 
            reaper.TrackFX_SetEnabled(t2[i],i2-1,false); 
        end; 
    end; 
    ---- 
     
     
    Arc.Restore_Selected_Item_Slot(1,true,false,true); 
     
    reaper.Undo_EndBlock('Apply track/take FX to items(lock active take)Bypass all fx track',-1); 
    reaper.PreventUIRefresh(-1); 
    if ConfigUndo then reaper.SNM_SetIntConfigVar('undomask',ConfigUndo)end; 
     
     
     