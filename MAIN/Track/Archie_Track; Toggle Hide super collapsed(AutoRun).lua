--[[      NEW INSTANCE 
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
   * ЧЕРЕЗ ТРЕК МЕНЕДЖЕР ОТОБРАЗИТЬ ИХ ЛИБО ПРЕМЕНИТЬ ЭКШЕН 
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
   * Description: Track; Toggle Hide super collapsed(AutoRun).lua 
   * Author:      Archie 
   * Version:     1.04 
   * Описание:    Трек; скрыть супер свернутые 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628/1500 
   * Customer:    Archie(---) 
   * Gave idea:   Archie(---) 
   * Extension:   Reaper 6.05+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   *              Arc_Function_lua v.2.8.4+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc 
   * Changelog:    
   *              v.1.02 [240520] 
   *                  + No changeе 
    
   *              v.1.0 [210420] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --======================================================================================  
     
     
     
    local STARTUP = 1; -- (Not recommended change) 
    --========================================= 
    local function MODULE(file); 
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end; 
        if not A.VersArcFun("2.8.5",file,'')then A.no_undo()return;end;return A; 
    end;local Arc=MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/')); 
    if not Arc then return end; 
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini'; 
    --========================================= 
     
     
     
    local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context(); 
    local extname = ScriptWay:match(".+[/\\](.+)"):upper(); 
    local extnameProj = 'ARCHIE_HIDE_SUPER_COLLAPSE_AUTORUN'; 
     
     
     
    --========================================= 
    local function SetToggleButtonOnOff(numb); 
        --local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context(); 
        reaper.SetToggleCommandState(sec,cmd,numb or 0); 
        reaper.RefreshToolbar2(sec,cmd); 
    end; 
    --========================================= 
     
     
     
    --========================================= 
    local function GetSetStateOnOff(set,state); 
        --local Get = tonumber(reaper.GetExtState(extname,'ToggleState'))or 0; 
        local Get = tonumber(Arc.iniFileReadLua(extname,'ToggleState',ArcFileIni,false))or 0; 
        if set ~= 1 then return Get end; 
        if Get ~= state and set == 1 then; 
            --reaper.SetExtState(extname,'ToggleState',state,true); 
            Arc.iniFileWriteLua(extname,'ToggleState',state,ArcFileIni,false,true); 
        end; 
    end; 
    --========================================= 
     
     
     
    --========================================= 
    local function Clear_ifNoTrack(extnameProj); 
        local i = 0; 
        while 0 do; 
            i=i+1; 
            local retval,key,val = reaper.EnumProjExtState(0,extnameProj,i-1); 
            if not retval then break end; 
            local track = reaper.BR_GetMediaTrackByGUID(0,key); 
            if not track then; 
                reaper.SetProjExtState(0,extnameProj,key,''); 
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
     
     
     
    --========================================= 
    local tm2; 
    local function timer(tmr);--sec 
        if not tonumber(tmr)then return false end; 
        local ret; 
        local tm = os.clock(); 
        if not tm2 then tm2 = tm end; 
        if tm >= tm2+math.abs(tmr)then tm2 = nil ret = true end; 
        return ret == true;  
    end; 
    --========================================= 
     
     
     
    --========================================= 
    local function Exit(); 
        local Ref; 
        local i = 0; 
        while true do; 
            i=i+1; 
            local retval,key,val = reaper.EnumProjExtState(0,extnameProj,i-1); 
            if not retval then break end; 
            local track = reaper.BR_GetMediaTrackByGUID(0,key); 
            if track then; 
                local visible = reaper.IsTrackVisible(track,false); 
                if not visible then; 
                    reaper.SetMediaTrackInfo_Value(track,'B_SHOWINTCP',1); 
                    Ref = true; 
                end; 
            end; 
        end; 
        if Ref then; 
            reaper.TrackList_AdjustWindows(true); 
        end; 
        reaper.SetProjExtState(0,extnameProj,'',''); 
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
                reaper.SetProjExtState(0,extnameProj,GUID,0); 
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
    local ActiveDoubleScr,stopDoubleScr; 
    local DOUBLE = 0; 
    local function loop(); 
        --reaper.ShowConsoleMsg( '1' ); 
        ----- stop Double Script ------- 
        if not ActiveDoubleScr then; 
            stopDoubleScr = (tonumber(reaper.GetExtState(ScriptWay,"stopDoubleScr"))or 0)+1; 
            reaper.SetExtState(ScriptWay,"stopDoubleScr",stopDoubleScr,false); 
            ActiveDoubleScr = true; 
        end; 
         
        local stopDoubleScr2 = tonumber(reaper.GetExtState(ScriptWay,"stopDoubleScr")); 
        if stopDoubleScr2 > stopDoubleScr then return end; 
        -------------------------------- 
         
        local ChanInProj = ChangesInProject(); 
        local tmr = timer(5); 
        if ChanInProj or tmr or DOUBLE == 1 then; 
             
            DOUBLE = math.abs(DOUBLE-1); 
             
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
                                    reaper.SetProjExtState(0,extnameProj,GUID,0); 
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
                                        local retval,val = reaper.GetProjExtState(0,extnameProj,GUID); 
                                        if retval == 1 and val ~= '' then; 
                                            reaper.SetProjExtState(0,extnameProj,GUID,''); 
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
                Clear_ifNoTrack(extnameProj); 
            end; 
            --========================================= 
        end;--CHANGES_PROJ END 
        reaper.defer(loop); 
    end; 
    --========================================= 
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
        local StateOnOff = GetSetStateOnOff(0,0); 
        if StateOnOff == 0 then; 
            loop(); 
            GetSetStateOnOff(1,1); 
            SetToggleButtonOnOff(1); 
        else; 
            local stopDoubleScr = (tonumber(reaper.GetExtState(ScriptWay,"stopDoubleScr"))or 0)+1; 
            reaper.SetExtState(ScriptWay,"stopDoubleScr",stopDoubleScr+1,false); 
            Exit(); 
            GetSetStateOnOff(1,0); 
            SetToggleButtonOnOff(0); 
        end; 
    elseif FirstRun then; 
        local StateOnOff = GetSetStateOnOff(0,0); 
        if StateOnOff == 1 then; 
            loop(); 
            SetToggleButtonOnOff(1); 
            --GetSetStateOnOff(1,1); 
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
        reaper.defer(function(); 
        Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,516,scriptPath,scriptName)end); 
    end; 
    reaper.defer(SetStartupScriptWrite); 
    ----------------------------------------------------- 
     
     
     
     
     