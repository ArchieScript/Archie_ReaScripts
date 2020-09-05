--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Shift Item Content to 10 milliseconds(Mouse wheel).lua
   * Author:      Archie
   * Version:     1.04
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Maestro Sound(Rmm)
   * Gave idea:   Maestro Sound(Rmm)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   *              Arc_Function_lua v.2.9.9+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.02/1.03/1.04 [050920]
   *                  + fixed bug
   
   *              v.1.0 [050920]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local Mode = 1;
            -- = 1 milliSec
            -- = 2 samples
    
    local ShiftValue = 10; -- milliseconds or samples depending on 'Mode'
    
    local AllSelItems = false; -- true/false
     
    local InvertMouse = false; -- true/false
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
     
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.9.9",file,'')then;A=nil;return;end;return A;
    end;local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
    
    
    Mode = math.abs(tonumber(Mode)or 1);
    ShiftValue = math.abs(tonumber(ShiftValue)or 10);
    if InvertMouse == true then;
        ShiftValue = ShiftValue-ShiftValue*2;
    end;
    
    
    --------------------------------------------------
    local function ShiftContentItemSec(item,take,sec);
        sec = sec / 1000;--in milliSeconds
        local offs = reaper.GetMediaItemTakeInfo_Value(take,'D_STARTOFFS');
        local rate = reaper.GetMediaItemTakeInfo_Value(take,'D_PLAYRATE');
        ---
        local offsNew = (offs-(sec*rate));
        --reaper.ShowConsoleMsg('\n'..  offsNew )
        if offsNew < 0 and offs >= 0 then;
            local loopIt = reaper.GetMediaItemInfo_Value(item,'B_LOOPSRC');
            if loopIt > 0 then;
                local source = reaper.GetMediaItemTake_Source(take);
                local source = reaper.GetMediaSourceParent(source) or source;
                if source then;
                    local len,lengthIsQN = reaper.GetMediaSourceLength(source);
                    if lengthIsQN then;
                        len = reaper.TimeMap_QNToTime(len);
                    end;
                    offsNew = (offs-(sec*rate))+len;
                    --reaper.ShowConsoleMsg('\n'.. offsNew )
                end;
            end;
        end;
        reaper.SetMediaItemTakeInfo_Value(take,'D_STARTOFFS',offsNew);
    end;
    --------------------------------------------------
    
    
    --[[--------------------------------------------
    local itemSel = reaper.GetSelectedMediaItem(0,0);
    local take = reaper.GetActiveTake(itemSel);
    ShiftContentItemSec(itemSel,take,ShiftValue);
    reaper.UpdateArrange();
    --]]--------------------------------------------
    
    
    --[==
    local x,y = reaper.GetMousePosition();
    local item,take = reaper.GetItemFromPoint(x,y,true);
    if not item then no_undo()return end;
    
    reaper.Undo_BeginBlock();
    
    -------------
    if Mode == 2 then;
        local rate = reaper.GetMediaItemTakeInfo_Value(take,'D_PLAYRATE');
        local SR = 1/reaper.GetSetProjectInfo(0,'PROJECT_SRATE',0,0);
        ShiftValue = ((SR * ShiftValue)*1000)/rate;
    end;
    -------------
    
    
    local _, _, _, _, _, _, val = reaper.get_action_context();
    if val <= 0 then;
        ShiftValue = (ShiftValue-ShiftValue*2);
    end;
    
    ShiftContentItemSec(item,take,ShiftValue);
    
    
    -----------
    if AllSelItems == true then;
        local CountSelItem = reaper.CountSelectedMediaItems(0);
        for i = 1,CountSelItem do;
            local itemSel = reaper.GetSelectedMediaItem(0,i-1);
            if itemSel ~= item then;
                local take = reaper.GetActiveTake(itemSel);
                if take then;
                    ShiftContentItemSec(itemSel,take,ShiftValue);
                end;
            end;
        end;
    end;
    -----------
    
    reaper.Undo_EndBlock('Shift Item Content to 10 milliseconds(mouse wheel)',-1);
    
    reaper.UpdateArrange();
    --]==]  
    
    
    