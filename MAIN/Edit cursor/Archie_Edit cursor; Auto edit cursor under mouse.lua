--[[  TERMINATE INSTANCES
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Edit cursor
   * Description: Edit cursor; Auto edit cursor under mouse.lua
   * Author:      Archie
   * Version:     1.03
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0+ http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.02 [030620]
   *                  + ---
   
   *              v.1.0 [130520]
   *                  + initialе
--]]
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
	

    
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    local extname = filename:match('.+[/\\](.+)'):upper();
    local ConfigVar = reaper.SNM_GetIntConfigVar('zoommode',0);
    reaper.SNM_SetIntConfigVar('zoommode',3);
    
    
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
    reaper.SetToggleCommandState(sectionID,cmdID,1);
    reaper.RefreshToolbar2(sectionID,cmdID);
    reaper.atexit(exit);
    local ScrPath,ScrName = filename:match('(.+)[/\\](.+)');
    reaper.defer(function()A.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,260,ScrPath,ScrName)end);
    
    
    