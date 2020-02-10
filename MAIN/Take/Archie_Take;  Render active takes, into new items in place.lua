--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Take
   * Description: Render active takes, into new items in place
   * Author:      Archie
   * Version:     1.0
   * Описание:    Рендер активных тейков в новые элементы на месте
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [09.02.20]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local Tail_FX = 2000;
    
    local Mute_Original = true; -- true / false
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    -------------------------------------------------------
    local function DeleteAllFxAllTakeItem(itChunk);
        local T = {};
        for line in string.gmatch(itChunk..'\n',".-\n") do;
            if line:match('^<TAKEFX')then X = true end;
            if X then;
                if line:match('^%S')=='<' then;
                    x = (x or 0)+1;
                elseif line:match('^%S')=='>'and x then;
                    x = x - 1; 
                end;
                if x == 0 then;
                    X = nil;
                end;
                line = '';
            end;
            if line ~= '' then;
                T[#T+1] = line;
            end;
        end;
        return table.concat(T);
    end;
    -------------------------------------------------------
    
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    local tail = reaper.SNM_GetIntConfigVar('itemfxtail',0);--pref/media
    Tail_FX = tonumber(Tail_FX)or 2000;
    if tail ~= Tail_FX then;
        reaper.SNM_SetIntConfigVar('itemfxtail',Tail_FX);
    end;
     
    reaper.Main_OnCommand(40209,0) -- Render items to new take
    
    local NEW_IT = {};
    for i = 1,CountSelItem do;
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local it_track = reaper.GetMediaItemTrack(item);
        local _, itChunk = reaper.GetItemStateChunk(item,'',false);
        local newItem = reaper.AddMediaItemToTrack(it_track);
        local itChunk = DeleteAllFxAllTakeItem(itChunk);
        reaper.SetItemStateChunk(newItem,itChunk,false);
        table.insert(NEW_IT,newItem);
        reaper.SetMediaItemSelected(newItem,false);
    reaper.UpdateItemInProject(newItem);
    end;
    
    reaper.Main_OnCommand(40129,0); -- Delete active take from items
    ----------------------------------------------------------------
    -- Bug Remove the empty take lane after the active take
    reaper.Main_OnCommand(41350,0);--Remove the empty take lane after the active take
    --http://forum.cockos.com/showpost.php?p=2242678&postcount=1
    ----------------------------------------------------------------
    if Mute_Original == true then;
        reaper.Main_OnCommand(40719,0); -- properties: Mute
    end;
    reaper.SelectAllMediaItems(0,false);
    
    for i = 1,#NEW_IT do;
        reaper.SetMediaItemSelected(NEW_IT[i],true);
    end;
    
    reaper.Main_OnCommand(40131,0); -- Crop to active take in items
    
    if tail ~= Tail_FX then;
        reaper.SNM_SetIntConfigVar('itemfxtail',tail);
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Render active takes, into new items in place',-1);
    
    reaper.UpdateArrange();
    
    
    