--[[   --TERMINATE INSTANCES--
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Toggle Auto height selected tracks.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 5.13+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.3.0.2+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [170820]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local HEIGHT = 80;
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.9.9",file,'')then A.no_undo()return;end;return A;
    end;local Arc=MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --========================================= 
    
    
    HEIGHT = math.abs(tonumber(HEIGHT)or 80);
    local _,extname,sec,cmd,_,_,_ = reaper.get_action_context();
    local scriptPath,scriptName = extname:match('(.+)[/\\](.+)');
    local StateChangeCount2,numbFirstSel2,UIRefresh;
    
    
    local function numbFirstSelTr();
        local CountSelTrack = reaper.CountSelectedTracks(0);
        local numb;
        if CountSelTrack>0 then;
            local tr = reaper.GetSelectedTrack(0,0);
            numb = reaper.GetMediaTrackInfo_Value(tr,'IP_TRACKNUMBER');
        end;
        return (numb or 0)+CountSelTrack;
    end;
    
    
    local function loop();
        -------------------------------
        local StateChangeCount = reaper.GetProjectStateChangeCount(0);
        local numbFirstSel = numbFirstSelTr();
        if StateChangeCount ~= StateChangeCount2 or numbFirstSel~=numbFirstSel2 then;
            StateChangeCount2 = StateChangeCount;
            numbFirstSel2 = numbFirstSel;
            ----
            local CountSelTrack = reaper.CountSelectedTracks(0);
            for i = 1,CountSelTrack do;
                local SelTrack = reaper.GetSelectedTrack(0,i-1);
                local height = reaper.GetMediaTrackInfo_Value(SelTrack,'I_TCPH');
                if height < HEIGHT then;
                    local GUID = reaper.GetTrackGUID(SelTrack);
                    local retval,val = reaper.GetProjExtState(0,extname,GUID);
                    if retval == 0 and val == '' then;
                        if not UIRefresh then;
                            reaper.PreventUIRefresh(1);
                            UIRefresh = true;
                        end;
                        reaper.SetMediaTrackInfo_Value(SelTrack,'I_HEIGHTOVERRIDE',HEIGHT);
                        reaper.SetProjExtState(0,extname,GUID,height);
                        reaper.TrackList_AdjustWindows(false);
                    end;
                end;
            end;
            -----
            -----
            local CountTrack = reaper.CountTracks(0);
            for i = 1,CountTrack do;
                local track = reaper.GetTrack(0,i-1);
                local sel = reaper.GetMediaTrackInfo_Value(track,'I_SELECTED');
                if sel == 0 then;
                    local GUID = reaper.GetTrackGUID(track);
                    local retval,val = reaper.GetProjExtState(0,extname,GUID);
                    if retval > 0 and val ~= '' then;
                        local height = reaper.GetMediaTrackInfo_Value(track,'I_TCPH');
                        if height == HEIGHT then;
                            if not UIRefresh then;
                                reaper.PreventUIRefresh(1);
                                UIRefresh = true;
                            end;
                            reaper.SetMediaTrackInfo_Value(track,'I_HEIGHTOVERRIDE',val);
                            reaper.TrackList_AdjustWindows(false);
                        end;
                        reaper.SetProjExtState(0,extname,GUID,'');
                    end;
                end;
            end;
            -------------------------------
            if UIRefresh then;
                reaper.PreventUIRefresh(-1);
                UIRefresh = false;
            end;
        -----------------------------------
        end;
        reaper.defer(loop);
    end;
    -----------------------------------
    
    
    
    -----------------------------------
    local function exit();
        Arc.GetSetToggleButtonOnOff(0,1);
        reaper.SetProjExtState(0,extname,'','');
    end;
    -----------------------------------
    
    
    -----------------------------------
    reaper.defer(function()
        loop()
        Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,260,scriptPath,scriptName)
        --TERMINATE INSTANCES--
    end);
    Arc.GetSetToggleButtonOnOff(1,1);
    reaper.atexit(exit);
    -----------------------------------
    
    
    
    