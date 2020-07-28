--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Take 
   * Description: Take; Crop to active take all items in selected tracks.lua 
   * Author:      Archie 
   * Version:     1.02 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Maestro Sound(Rmm) 
   * Gave idea:   Maestro Sound(Rmm) 
   * Extension:   Reaper 6.10+ http://www.reaper.fm/ 
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php 
   *              Arc_Function_lua v.2.8.1+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc 
   * Changelog:    
   *              v.1.0 [020620] 
   *                  + initialе 
--]]  
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
    local IGNORE_LOCK = true -- true / false 
     
    local UNSELECT_ITEMS = false  -- true / false 
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    --========================================= 
    local function MODULE(file); 
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end; 
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A; 
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/')); 
    if not Arc then return end; 
    --========================================= 
	 
 
     
    local CountSelTracks = reaper.CountSelectedTracks(0); 
    if CountSelTracks == 0 then A.no_undo()return end; 
     
     
    reaper.Undo_BeginBlock(); 
    reaper.PreventUIRefresh(1); 
     
     
    -- 1 Options: Show empty take lanes (align takes by recording pass) 
    -- 2 Options: Allow selecting empty take lanes 
    -- 3 Options: Select takes for all selected items when clicking take lane 
    local Opt_TakeLaneBehavior1 = reaper.GetToggleCommandStateEx(0,41346); 
    local Opt_TakeLaneBehavior2 = reaper.GetToggleCommandStateEx(0,41355); 
    local Opt_TakeLaneBehavior3 = reaper.GetToggleCommandStateEx(0,40249); 
    if Opt_TakeLaneBehavior1 == 1 then A.Action(41346)end; 
    if Opt_TakeLaneBehavior2 == 1 then A.Action(41355)end; 
    if Opt_TakeLaneBehavior3 == 1 then A.Action(40249)end; 
     
     
    local tblSaveIt = {}; 
    local x = 0; 
    local CountSelItems = reaper.CountSelectedMediaItems(0); 
    if CountSelItems > 0 then; 
        for i = CountSelItems-1,0,-1 do; 
            local itemSel = reaper.GetSelectedMediaItem(0,i); 
            x = x + 1; 
            tblSaveIt[x]=itemSel; 
            reaper.SetMediaItemInfo_Value(itemSel,"B_UISEL",0); 
        end; 
    end; 
     
     
    for i = 1,CountSelTracks do; 
        local selTrack = reaper.GetSelectedTrack(0,i-1); 
        local CountTrItem = reaper.CountTrackMediaItems(selTrack); 
        for i2 = 1,CountTrItem do; 
            local item = reaper.GetTrackMediaItem(selTrack,i2-1); 
            local lock; 
            if IGNORE_LOCK == true then; 
                lock = reaper.GetMediaItemInfo_Value(item,"C_LOCK",1); 
            end; 
            if lock ~= 1 then; 
                reaper.SetMediaItemInfo_Value(item,"B_UISEL",1); 
            end; 
        end; 
    end; 
     
    A.Action(40131);-- Crop to act take 
     
    reaper.SelectAllMediaItems(0,0); 
     
    if UNSELECT_ITEMS ~= true then; 
        for i = 1,#tblSaveIt do; 
            reaper.SetMediaItemInfo_Value(tblSaveIt[i],"B_UISEL",1); 
        end; 
    end; 
     
    if Opt_TakeLaneBehavior1 == 1 then A.Action(41346)end; 
    if Opt_TakeLaneBehavior2 == 1 then A.Action(41355)end; 
    if Opt_TakeLaneBehavior3 == 1 then A.Action(40249)end; 
     
    reaper.PreventUIRefresh(-1); 
    reaper.Undo_EndBlock('Crop to active take all items in selected tracks',-1); 
    reaper.UpdateArrange(); 
     
     
     
     