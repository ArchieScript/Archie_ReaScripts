--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Stutter Duplicate items n beat
   * Author:      Archie
   * Version:     1.01
   * AboutScript: ---
   * О скрипте:   ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---(---)
   * Gave idea:   ---(---)
   * Provides:    
   *              [main] . > Archie_Item;  Stutter Duplicate items 1 beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.2 beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.2T beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.4 beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.4T beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.8 beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.8T beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.16 beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.16T beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.32 beat.lua
   *              [main] . > Archie_Item;  Stutter Duplicate items 1.32T beat.lua
   * Changelog:   v.1.01 [18.08.19]
   *                  + initialе
    
    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.981 +            --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------
    
    
    
    local scrNameT = {
                      "Archie_Item;  Stutter Duplicate items 1 beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.2 beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.2T beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.4 beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.4T beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.8 beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.8T beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.16 beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.16T beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.32 beat.lua",
                      "Archie_Item;  Stutter Duplicate items 1.32T beat.lua"
                     };
    
    local scrName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    scrName = "Archie_Item;  Stutter Duplicate items 1.4 beat.lua"
    
    
    if scrName == scrNameT[1] then;
        division = (4/ 1)       --1     beat
    elseif scrName == scrNameT[2] then;
        division = (4/ 2)       --1/2   beat
    elseif scrName == scrNameT[3] then;
        division = (4/(2*1.5))  --1/2T  beat
    elseif scrName == scrNameT[4] then;
        division = (4/ 4)       --1/4   beat
    elseif scrName == scrNameT[5] then;
        division = (4/(4*1.5))  --1/4T  beat
    elseif scrName == scrNameT[6] then;
        division = (4/ 8)       --1/8   beat
    elseif scrName == scrNameT[7] then;
        division = (4/(8*1.5))  --1/8T  beat 
    elseif scrName == scrNameT[8] then;
        division = (4/ 16)      --1/16  beat
    elseif scrName == scrNameT[9] then;
        division = (4/(16*1.5)) --1/16T beat
    elseif scrName == scrNameT[10] then;
        division = (4/ 32)      --1/32  beat
    elseif scrName == scrNameT[11] then;
        division = (4/(32*1.5)) --1/32T beat
    else;
        reaper.MB("Eng:\n* Invalid script name\n* The script name must be one of the following\n\n"..
                  "Rus:\n* Неверное имя скрипта\n* Имя скрипта должно быть одно из следующих\n"..
                  ("-"):rep(50).."\n\n\n"..
                  table.concat(scrNameT,"\n"),
                  "Error",0);
        no_undo() return;
    end;
    
    local Undo = scrName:match("^%s-Archie_Item;%s-(%S.+)%.lua$")or"";
    
    
    
    local function NewGuid_ItemAndAllTake(item);
        reaper.GetSetMediaItemInfo_String(item,"GUID",reaper.genGuid(""),1);
        for i = 1,reaper.CountTakes(item)do;
            local take = reaper.GetMediaItemTake(item,i-1);
            reaper.GetSetMediaItemTakeInfo_String(take,"GUID",reaper.genGuid(""),1);
        end;
    end;
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock()
    
    for i = CountSelItem-1,0,-1 do;
        local SelItem = reaper.GetSelectedMediaItem(0,i);
        local pos = reaper.GetMediaItemInfo_Value(SelItem,"D_POSITION");
        local trackIt = reaper.GetMediaItem_Track(SelItem);
        local beat = reaper.TimeMap_timeToQN_abs(0,pos);
        local TimeNext = reaper.TimeMap_QNToTime_abs(0,beat+division);
        reaper.SetMediaItemInfo_Value(SelItem,"D_LENGTH",TimeNext-pos);
        local retval,str = reaper.GetItemStateChunk(SelItem,"",false);
        local itemNew = reaper.AddMediaItemToTrack(trackIt);
        reaper.SetItemStateChunk(itemNew,str,false);
        NewGuid_ItemAndAllTake(itemNew);
        reaper.SetMediaItemInfo_Value(itemNew,"D_POSITION",TimeNext);
        reaper.SetMediaItemSelected(SelItem,0);
    end;
    
    reaper.Undo_EndBlock(Undo,-1);
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();