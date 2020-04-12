--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   * 
   * 
   * 
   * ВАЖНО:
   * ПРИ ИСПОЛЬЗОВАНИИ ОТМЕНЫ СКРИПТ РАБОТАЕТ НЕКОРРЕКТНО, 
   * Т.Е. ЕСЛИ ВЫ СВЕРНУЛИ,РАЗВЕРНУЛИ ПАПКУ ИЛИ СКОПИРОВАЛИ 
   * ТРЕК В СВЕРНУТУЮ ПАПКУ ИЛИ СОЗДАЛИ ТРЕК В СВЕРНУТУЮ ПАПКУ
   * И ПОСЛЕ ЭТОГО НАЖАЛИ ОТМЕНУ, ТО ТРЕКИ МОГУТ ПЕРЕСТАТЬ 
   * ОТОБРАЖАТЬСЯ, Т.Е. ОНИ ОСТАЮТСЯ СКРЫТЫМИ И НУЖНО ЛИБО 
   * ЧЕРЕЗ ТРЕК МЭНЭДЖЭР ОТОБРАЗИТЬ ИХ ЛИБО ПРЕМЕНИТЬ ЭКШЕН
   * "SWS: Show all tracks in TCP"
   * ЛИБО ПРИМЕНИТЬ СКРИПТ 
   * "Script: Archie_Track;  Show child tracks of selected folders in TCP.lua"
   * 
   * IMPORTANT:
   * WHEN USING UNDO, THE SCRIPT WORKS INCORRECTLY,
   * i.e. IF YOU DECLINED, DEPLOYED THE FOLDER OR SCOPE 
   * A TRACK TO THE FOLDED FOLDER OR CREATED A TRACK TO 
   * THE FOLDED FOLDER AND AFTER THIS, UNDO, THEN THE 
   * TRACKS MAY STOP DISPLAYED, T. THEY REMAIN HIDDEN AND 
   * NEEDS EITHER THROUGH THE TRACK MANAGER TO DISPLAY THEM 
   * OR TO CHANGE THE ACTION 
   * "SWS: Show all tracks in TCP" 
   * OR TO APPLY THE SCRIPT 
   * "Script: Archie_Track;  Show child tracks of selected folders in TCP.lua"
   * 
   * 
   * 
   * 
   * 
   * 
   * Category:    Track
   * Features:    Startup
   * Description: Track;  Hide super collapsed (background)(AutoRun).lua
   * Author:      Archie
   * Version:     1.06
   * Описание:    Трек; скрыть супер свернутые (фон)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1500
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.7.6+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.06 [110420]
   *                  ! Fixed bug when copying to a collapsed folder
   
   *              v.1.05 [31.03.20]
   *                  + AutoRun
   *              v.1.02 [290320]
   *                  ! Fixed bug  
   *              v.1.0 [270320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local STARTUP = 1;  -- 0/1
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
     
     
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.6.5",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    --=========================================
    local extname = 'ARCHIE_HIDE_SUPER_COLLAPSE_BACKGROUND';
    local _,ScriptWay,sec,cmd,_,_,_ = reaper.get_action_context();
    --=========================================
    
    
    --=========================================
    local function Help(extname);
        local StateHelp = reaper.GetExtState(extname,'State_Help')=='';
        if StateHelp then;
            local MB = reaper.MB('Rus:\nПри появлении окна "ReaScript task control"\n'..
                           'ставим галку "Remember my answer for this script"\n'..
                           'и жмем "Terminate instances"\n\n'..
                           'Не показывать это окно - Ok\n\n\n'..
                           'Eng:\n'..
                           'When the "ReaScript task control"\n'..
                           'window appears, tick "Remember my answer for this script"\n'..
                           'and click "Terminate instances"\n\n'..
                           'Do not show this window-Ok'
                           ,'Help',1);
            if MB == 1 then;
                local MB = reaper.MB('Rus:\nВажно: ЗАПОМНИ!!!\n\n'..
                               'TERMINATE INSTANCES !!!\n\n'..
                               'TERMINATE INSTANCES !!!\n\n\n'..
                               'Eng:\nImportant: REMEMBER!!!\n\n'..
                               'TERMINATE INSTANCES !!!\n\n'..
                               'TERMINATE INSTANCES !!!\n\n\n'
                               ,'TERMINATE INSTANCES !!!',1);
                if MB == 1 then;
                    reaper.SetExtState(extname,'State_Help','true',true);
                end;
            end;
        end;
    end;
    --=========================================
    
    
    --=========================================
    local function GetSetStateOnOff(set,state);
        local Get = tonumber(reaper.GetExtState(extname,'ToggleState'))or 0;
        if set ~= 1 then return Get end;
        if Get ~= state and set == 1 then;
            reaper.SetExtState(extname,'ToggleState',state,true);
        end;
    end;
    --=========================================
    
    
    --=========================================
    local function Clear_ifNoTrack(extname);
        local i = 0;
        while 0 do;
            i=i+1;
            local retval,key,val = reaper.EnumProjExtState(0,extname,i-1);
            if not retval then break end;
            local track = reaper.BR_GetMediaTrackByGUID(0,key);
            if not track then;
                reaper.SetProjExtState(0,extname,key,'');
                i = i-1;
            end;
        end;
    end;
    --=========================================
    
    
    --=========================================
    local ProjState2;
    local function ChangesInProject();
        local ret;
        local ProjState = reaper.GetProjectStateChangeCount(0);
        if not ProjState2 or ProjState2 ~= ProjState then ret = true end;
        ProjState2 = ProjState;
        return ret == true;
    end;
    --=========================================
    
    
    local t = {};
    --=========================================
    local function Exit();
        local Ref;
        local i = 0;
        while 0 do;
            i=i+1;
            local retval,key,val = reaper.EnumProjExtState(0,extname,i-1);
            if not retval then break end;
            local track = reaper.BR_GetMediaTrackByGUID(0,key);
            if track then;
                local visible = reaper.IsTrackVisible(track,false);
                if not visible then;
                    reaper.SetMediaTrackInfo_Value(track,'B_SHOWINTCP',1);
                    Ref = true;
                end;
                reaper.SetProjExtState(0,extname,key,'');
                i = i-1;
            end;
        end;
        if Ref then;
            reaper.TrackList_AdjustWindows(true);
        end;
        reaper.SetToggleCommandState(sec,cmd,0);
        GetSetStateOnOff(1,0);
        t.Exit_STOP = true;
    end;
    --=========================================
    
    
    
    --=========================================
    local cpT;
    local function showNewCopyTrack();
        if not cpT then;
            cpT = {};
            for i = 1,reaper.CountTracks(0)do;
                local track = reaper.GetTrack(0,i-1);
                cpT[tostring(track)] = track;
            end;
        end;
        for i = 1,reaper.CountTracks(0)do;
            local track = reaper.GetTrack(0,i-1);
            if not cpT[tostring(track)] then;
                cpT[tostring(track)] = track;
                local GUID = reaper.GetTrackGUID(track);
                reaper.SetProjExtState(0,extname,GUID,0);
            end;
        end;
        
        for var,key in pairs(cpT)do;  
           local retval,buf = pcall(reaper.GetTrackName,key);
           if not retval then;
               cpT[tostring(key)] = nil;
           end;
        end;
    end; 
    --=========================================
    
    
    
    --=========================================
    --=========================================
    local function loop();
        if t.Exit_STOP == true then --[[reaper.atexit(Exit)]] return end;
        local ChanInProj = ChangesInProject();
        if ChanInProj then;--CHANGES_PROJ
            
            showNewCopyTrack();
            
            local Refresh,stopInside,foldX,stopX,depthX;
            ----
            --local scr_x,scr_y = reaper.GetMousePosition();
            --local track,info = reaper.GetTrackFromPoint(scr_x,scr_y);
            --if info == 0 and track then; 
            local i = 0;
            while true do;
                i=i+1;
                local track = reaper.GetTrack(0,i-1);
                if not track then break end;
                --======================
                local fold = (reaper.GetMediaTrackInfo_Value(track,'I_FOLDERDEPTH')==1);
                if fold then;--FOLD
                    local numb = reaper.GetMediaTrackInfo_Value(track,'IP_TRACKNUMBER');
                    local depth = reaper.GetTrackDepth(track);
                    local collaps = (reaper.GetMediaTrackInfo_Value(track,'I_FOLDERCOMPACT')==2);
                    if collaps then;--COLLAPS
                        -- hide start ----------------------------
                        for i2 = numb,reaper.CountTracks(0)-1 do;
                            local track2 = reaper.GetTrack(0,i2);
                            local depth2 = reaper.GetTrackDepth(track2);
                            if depth2 > depth then;
                                local visible = reaper.IsTrackVisible(track2,false);
                                if visible then;
                                    local GUID = reaper.GetTrackGUID(track2);
                                    reaper.SetMediaTrackInfo_Value(track2,'B_SHOWINTCP',0);
                                    reaper.SetProjExtState(0,extname,GUID,0);
                                    Refresh = true;
                                end;
                            else;
                                i = reaper.GetMediaTrackInfo_Value(track2,'IP_TRACKNUMBER')-1;
                                break;
                            end;
                        end;
                        -- hide END ------------------------------
                    else;
                        -- show start ----------------------------
                        if depth > 0 then;
                            for i3 = numb-2,0,-1 do;
                                local tr = reaper.GetTrack(0,i3);
                                local fld = (reaper.GetMediaTrackInfo_Value(tr,'I_FOLDERDEPTH')==1);
                                if fld then;
                                    local clps = (reaper.GetMediaTrackInfo_Value(tr,'I_FOLDERCOMPACT')==2);
                                    if clps then;
                                        stopInside = true;
                                    end;
                                    local dpth = reaper.GetTrackDepth(tr);
                                    if dpth == 0 then break end;
                                end;
                            end;
                        end;
                        
                        if not stopInside then;
                            
                            for i2 = numb,reaper.CountTracks(0)-1 do;
                                local track2 = reaper.GetTrack(0,i2);
                                local depth2 = reaper.GetTrackDepth(track2);
                                if depth2 > depth then;
                                    
                                    if not depthX or depth2 <= depthX then;
                                        stopX = nil;
                                        depthX = nil;
                                        local fold2 = (reaper.GetMediaTrackInfo_Value(track2,'I_FOLDERDEPTH')==1);
                                        if fold2 then;
                                            local collaps2 = (reaper.GetMediaTrackInfo_Value(track2,'I_FOLDERCOMPACT')==2);
                                            if collaps2 then;
                                                foldX = fold2;
                                                stopX = true;
                                                depthX = reaper.GetTrackDepth(track2);
                                            end;
                                        end;
                                    end;
                                     
                                    if not stopX or (stopX and foldX) then;
                                        foldX = nil;
                                        local GUID = reaper.GetTrackGUID(track2);
                                        local retval,val = reaper.GetProjExtState(0,extname,GUID);
                                        if retval == 1 and val ~= '' then;
                                            reaper.SetProjExtState(0,extname,GUID,'');
                                            local visible = reaper.IsTrackVisible(track2,false);
                                            if not visible then;
                                                reaper.SetMediaTrackInfo_Value(track2,'B_SHOWINTCP',1);
                                                Refresh = true;
                                            end;
                                        end;
                                    end;
                                else;
                                    break;
                                end;
                            end;
                        end;
                        ----
                        stopInside = nil;
                        depthX = nil;
                        stopX = nil;
                        foldX = nil;
                        -- show END ------------------------------
                    end;--COLLAPS END
                end;--FOLD END
               --======================
            end;--
            --=========================================
            if Refresh then;
                reaper.TrackList_AdjustWindows(true);
                Refresh = nil;
                Clear_ifNoTrack(extname);
            end;
            --=========================================
        end;--CHANGES_PROJ END
        reaper.defer(loop);
    end;
    --=========================================
    --=========================================
    
    --reaper.defer(loop);
    --reaper.SetToggleCommandState(sec,cmd,1);
    --reaper.atexit(Exit);
    --=========================================
    
    
    
    
    -------------------------------------------
    --=========================================
    -------------------------------------------
    local scriptPath,scriptName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
    local extname2 = scriptName;
    
    
    ---___-----------------------------------------------
    local FirstRun;
    if STARTUP == 1 then;
        --reaper.DeleteExtState(extname2,"FirstRun",false);
        FirstRun = reaper.GetExtState(extname2,"FirstRun")=="";
        if FirstRun then;
            reaper.SetExtState(extname2,"FirstRun",1,false);
        end;
    end;
    -----------------------------------------------------
    
    
    ---------------------
    if not FirstRun then;
        reaper.atexit(Exit);
        Help(extname);
        loop();
        reaper.SetToggleCommandState(sec,cmd,1);
        GetSetStateOnOff(1,1);
    elseif FirstRun then;
        local StateOnOff = GetSetStateOnOff(0,0);
        if StateOnOff == 0 then;
            --reaper.PreventUIRefresh(1);
            --loop();
            --Exit();
            --reaper.PreventUIRefresh(-1);
        else;
            reaper.atexit(Exit);
            loop();
            reaper.SetToggleCommandState(sec,cmd,1);
        end;
    end;
    ---------------------
    
    
    ---___-----------------------------------------------
    local function SetStartupScriptWrite();
        local id = Arc.GetIDByScriptName(scriptName,scriptPath);
        if id == -1 or type(id) ~= "string" then Arc.no_undo()return end;
        local check_Id, check_Fun = Arc.GetStartupScript(id);
        if STARTUP == 1 then;
            if not check_Id then;
                Arc.SetStartupScript(scriptName,id);
            end;
        elseif STARTUP ~= 1 then;
            if check_Id then;
                Arc.SetStartupScript(scriptName,id,nil,"ONE");
            end;
        end;
    end;
    reaper.defer(SetStartupScriptWrite);
    -----------------------------------------------------
    
  
  