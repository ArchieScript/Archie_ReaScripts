--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track;  Toggle Lock selected tracks and them items - Unlock tracks restore them items
   * @                           (Archie_Track;  Unlock selected tracks and restore them items.lua)
   * @                           (Archie_Track;  Lock selected tracks and them items.lua)
   * Author:      Archie
   * Version:     1.0
   * Описание:    Переключатель - блокировать выбранные треки и их элементы - разблокировать треки, восстановить их элементы
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)$
   * Gave idea:   Archie(---)$
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [26.02.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local Path = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/MAIN/Track/';
    local LOCK = 'Archie_Track;  Lock selected tracks and them items.lua';
    local UNLOCK = 'Archie_Track;  Unlock selected tracks and restore them items.lua';
    
    
    
    --------------------------------------------------------
    local function GetLockTrackState(TrackChunk);
        local bracket = 0;
        for var in string.gmatch(TrackChunk,".-\n") do;
            if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then;
                bracket = bracket+1;
            end;
            local ret = tonumber(var:match('^%s-LOCK%s+(%d*).-$'));
            if ret then return ret end;
            if bracket >= 2 then return 0 end;
        end;
    end;
    --------------------------------------------------------
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    
    
    local NexLock;
    
    for i = 1,CountSelTrack do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        local _,str = reaper.GetTrackStateChunk(SelTrack,'',false);
        local GetLock = GetLockTrackState(str);
        if GetLock == 0 then NexLock = 1 break else NexLock = 0 end;
    end;
    
    
    if NexLock == 0 then;
        dofile(Path..UNLOCK)
    elseif NexLock == 1 then;
        dofile(Path..LOCK)
    end;
    
    
    