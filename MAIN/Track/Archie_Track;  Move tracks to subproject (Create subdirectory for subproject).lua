--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track;  Move tracks to subproject (Create subdirectory for subproject).lua
   * Author:      Archie
   * Version:     1.02
   * О скрипте:   переместить треки в подпроект (создать подкаталог для подпроекта)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(Archie)
   * Gave idea:   Archie(Archie)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.9.7+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [260820]
   *                  +! special characters are replaced with '_'
   *                  +! спецсимволы заменяются на '_'
   
   *              v.1.0 [260820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local USER_INPUTS = true;
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.9.7",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
    
    
    
    -------------------------------------------
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    -------------------------------------------
    
    
    
    -------------------------------------------
    local retval,projfn = reaper.EnumProjects(-1);
    if projfn == '' then;
        local buf = reaper.GetProjectPath('');
        local MB = reaper.MB('Project not saved.\n'..
                             'Recommend clicking cancel and saving the project to avoid losing the subproject in the future\n\n'..
                             'Subproject will be created along way.\n'..buf..'\n'..
                             ('-'):rep(55)..'\n\n\n'..
                             'Проект не сохранен.\n'..
                             'Рекомендую нажать отмена и сохранить проект, чтобы избежать потери подпроекта в дальнейшем.\n\n'..
                             'Подпроект создастся по пути.\n'..buf..'\n'..('-'):rep(55)
                             ,'Warning!',1);
        if MB == 2 then no_undo() return end;
    end;
    -------------------------------------------
    
    
    local FSelTrack = reaper.GetSelectedTrack(0,0);
    local _,name = reaper.GetTrackName(FSelTrack);
    
    if USER_INPUTS == true then;
        local x=#name*5;
        local ret;
        if x > 450 then x=450 end;
        ret,name = reaper.GetUserInputs('Move tracks to subproject',1,'Enter folder name in directory,extrawidth='..x,name);
        if not ret then no_undo()return end;
    end;
    
    name = name:gsub('[\\/:*?"<>|+]','_');
    if #name:gsub('%s','')==0 then;
        name = 'no name (track '..math.ceil(reaper.GetMediaTrackInfo_Value(FSelTrack,'IP_TRACKNUMBER'))..')';
    end;
     
    buf = reaper.GetProjectPath('');
    
    local nmb = '';
    local j;
    ::restDir::;
    local N_Path = buf..'/'..name..nmb;
    local Dir = reaper.RecursiveCreateDirectory(N_Path,0);
    
    if Dir <= 0 then;
        j = (j or 1)+1;
        nmb = '_('..j..')';
        goto restDir;
    else;
        local retval,valtrNB = reaper.GetSetProjectInfo_String(0,'RECORD_PATH','',0);
        reaper.GetSetProjectInfo_String(0,'RECORD_PATH',N_Path,1);
        Action(41997);--Track: Move tracks to subproject
        reaper.GetSetProjectInfo_String(0,'RECORD_PATH',valtrNB,1);
    end;
    
    no_undo();
    