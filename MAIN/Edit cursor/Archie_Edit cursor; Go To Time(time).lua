--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Edit cursor
   * Description: Edit cursor; Go To Time(time).lua
   * Author:      Archie
   * Version:     1.03
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    smrz1(---)
   * Gave idea:   smrz1(---)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [260820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local MODE = 1 -- 0 / 1
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    local title = 'Go To Time (time)';
    local _,filename,_,_,_,_,_ = reaper.get_action_context();
    local Mouse_x,Mouse_y = reaper.GetMousePosition();
    
    
    if MODE == 0 then;
        ---------------------------------------------------------
        local buf = tonumber(reaper.GetExtState(filename,title))or 0;
        
        local retval,retvals_csv = reaper.GetUserInputs(title,1,'Sec: ( H M S MS ),extrawidth=25',buf);
        if not retval then no_undo()return end;
        
        local MSec = retvals_csv:match(                  '(%d+)$')or 0;
        local Sec  = retvals_csv:match(            '(%d+)%D+%d*$')or 0;
        local Min  = retvals_csv:match(      '(%d+)%D+%d*%D+%d*$')or 0;
        local Hour = retvals_csv:match('(%d+)%D+%d*%D+%d*%D+%d*$')or 0;
        
        local time = reaper.parse_timestr_pos(Hour..':'..Min..':'..Sec..'.'..MSec,0);
        reaper.SetEditCurPos(time,true,false);
        
        reaper.SetExtState(filename,title,retvals_csv,false);
        ---------------------------------------------------------
    else;
        ---------------------------------------------------------
        local Hour = tonumber(reaper.GetExtState(filename,'Hour'))or 0;
        local Min  = tonumber(reaper.GetExtState(filename,'Min' ))or 0;
        local Sec  = tonumber(reaper.GetExtState(filename,'Sec' ))or 0;
        local MSec = tonumber(reaper.GetExtState(filename,'MSec'))or 0;
        
        local
        retval,retvals_csv = reaper.GetUserInputs(title,4,'Hour: '..(' -'):rep(40)..','..
                                                          'Minutes:  '..(' -'):rep(40)..','..
                                                          'Sec:  '..(' -'):rep(40)..','..
                                                          'Milliseconds  '..(' -'):rep(40)..','..
                                                          'extrawidth=25,separator=$',
                                                          Hour..'$'..Min..'$'..Sec..'$'..MSec);
        if not retval then no_undo()return end;------------
        retvals_csv = retvals_csv..'$';
        
        if #retvals_csv:gsub('[^$]','')> 4 then;
            reaper.TrackCtl_SetToolTip('---$---\nERROR\n-------',Mouse_x,Mouse_y,false);
            no_undo()return;
        end;
        
        
        Hour,Min,Sec,MSec = retvals_csv:match('^(.-)%$(.-)%$(.-)%$(.-)%$');
        
        Hour = tonumber(Hour)or 0;
        Min  = tonumber(Min) or 0;
        Sec  = tonumber(Sec) or 0;
        MSec = tonumber(MSec)or 0;
        
        local time = reaper.parse_timestr_pos(Hour..':'..Min..':'..Sec..'.'..MSec,0);
        reaper.SetEditCurPos(time,true,false);
        
        reaper.SetExtState(filename,'Hour',Hour,false);
        reaper.SetExtState(filename,'Min' ,Min ,false);
        reaper.SetExtState(filename,'Sec' ,Sec ,false);
        reaper.SetExtState(filename,'MSec',MSec,false);
        ---------------------------------------------------------
    end;
    
    no_undo();
    
    
    
    
    
    
    
    