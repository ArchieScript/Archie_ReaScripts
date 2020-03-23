--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Restore all track mute solo state slot 1
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [230320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local SLOT = 1; -- 1..100
    local CLEAN = false; -- true/false
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------
    local function countExState(extname);
        local i=-1;while 0 do;
            i=i+1;local retval=reaper.EnumProjExtState(0,extname,i);
            if not retval then return i end;
        end;
    end;
    -------------------------------------
    
    
    local extname = 'ARCHIE_TRACK_MUTE_SOLO_STATE_SLOT '..SLOT;
    SLOT = tonumber(SLOT)or 1;
    if SLOT < 1 or SLOT > 100 then slot = 1 end;
    
      
    local i=0;
    while true do;
        i = i + 1;
        local retval,key,val = reaper.EnumProjExtState(0,extname,i-1);
        if not retval or i>1e+4 then break end;
        local track = reaper.BR_GetMediaTrackByGUID(0,key);
        if track then;
            local mute,solo = val:match('(%S+)%s+(%S+)');
            reaper.SetMediaTrackInfo_Value(track,'B_MUTE',mute or 0);
            reaper.SetMediaTrackInfo_Value(track,'I_SOLO',solo or 0);
        end;
    end;
    
    
    local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
    reaper.SetToggleCommandState(sec,cmd,0);
    reaper.RefreshToolbar2(sec,cmd);
    
    
    if CLEAN then;
        local countExSt = countExState(extname);
        for i = countExSt-1,0,-1 do;
            local retval,key,val = reaper.EnumProjExtState(0,extname,i);
            reaper.SetProjExtState(0,extname,key,'');
        end;
    end;
    
    reaper.defer(function()end);
    
    
    