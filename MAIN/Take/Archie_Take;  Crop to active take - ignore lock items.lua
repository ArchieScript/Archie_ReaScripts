--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Take
   * Description: Take;  Crop to active take - ignore lock items.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(Rmm)
   * Gave idea:   Maestro Sound(Rmm)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [020620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    local function no_undo()reaper.defer(function()end)end;
     
    
    local CountSelItems = reaper.CountSelectedMediaItems(0);
    if CountSelItems == 0 then no_undo()return end;
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    local tblSaveIt = {};
    local x = 0;
    for i = CountSelItems-1,0,-1 do;
        local item = reaper.GetSelectedMediaItem(0,i);
        local lock = reaper.GetMediaItemInfo_Value(item,"C_LOCK");
        if lock > 0 then;
            x = x + 1;
            tblSaveIt[x]=item;
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",0);
        end;
    end;
    
    local CountSelItemsX = reaper.CountSelectedMediaItems(0);
    
    reaper.Main_OnCommand(40131,0);-- Crop to act take
    
    for i = 1,#tblSaveIt do;
        reaper.SetMediaItemInfo_Value(tblSaveIt[i],"B_UISEL",1);
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Crop to active take - ignore lock items',-1);
    reaper.UpdateArrange();
    
    
    