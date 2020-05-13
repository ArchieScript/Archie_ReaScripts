--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Edit cursor
   * Description: Edit cursor;  Auto edit cursor under mouse.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0+ http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [130520]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    local extname = filename:match('.+[/\\](.+)'):upper();
    local ConfigVar = reaper.SNM_GetIntConfigVar('zoommode',0);
    reaper.SNM_SetIntConfigVar('zoommode',3);
    
    
   
    --=========================================
    local StateHelp = tonumber(reaper.GetExtState(extname,'StateHelp'))or 0;
    if StateHelp < 3 then;
        local MB = reaper.MB('Rus:\nПри появлении окна "ReaScript task control"\n'..
                       'ставим галку "Remember my answer for this script"\n'..
                       'и жмем "NEW TERMINATE INSTANCES"\n\n'..
                       'Не показывать это окно - Ok\n\n\n'..
                       'Eng:\n'..
                       'When the "ReaScript task control"\n'..
                       'window appears, tick "Remember my answer for this script"\n'..
                       'and click "TERMINATE INSTANCES"\n\n'..
                       'Do not show this window-Ok'
                       ,'Help - '..extname,1);
        if MB == 1 then;
            reaper.SetExtState(extname,'StateHelp',StateHelp+1,true);
        end;
    end;
    --=========================================
    
    
    --=========================================
    local function loop();
        local window,segment,details = reaper.BR_GetMouseCursorContext();
        if window == 'arrange'then;
            local Mouspos = reaper.BR_GetMouseCursorContext_Position();
            local EditCur = reaper.GetCursorPosition();
            if Mouspos >= 0 and Mouspos ~= EditCur then;
                reaper.SetEditCurPos2(0,Mouspos,false,false);
            end;
        end;
        reaper.defer(loop);
    end;
    --=========================================
    
    
    --=========================================
    local function exit();
        reaper.SNM_SetIntConfigVar('zoommode',ConfigVar);
        reaper.SetToggleCommandState(sectionID,cmdID,0);
        reaper.RefreshToolbar2(sectionID,cmdID);
    end;
    --=========================================
    
    loop();
    reaper.atexit(exit);
    
    
    
    