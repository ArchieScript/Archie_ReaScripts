--[[      NEW INSTANCE !!!
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Features:    Startup
   * Description: Track;  UnMute all track(AutoRun)(`).lua
   * Author:      Archie
   * Version:     1.10
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(Rmm)
   * Gave idea:   Archie(Rmm)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.8.2+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.10 [270620]
   *                  + refresh Action List off
   
   *              v.1.07 [260520]
   *                  + Restore Mute track (Doesn't pay attention to blocked tracks)
   *              v.1.06 [240520]
   *                  + No changeе
   *              v.1.04 [31.03.20]
   *                  + AutoRun
   *              v.1.0 [25.01.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    -- DIFFERENCES-LOCK TRACKS / ОТЛИЧИЯ-БЛОКИРОВКА ТРЕКОВ *** (НЕТ ОТЛИЧИЙ)
    
    
    local STARTUP = 1;  -- 0/1  -- (Not recommended change)
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.2",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
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
    local function GetLockTrackState(track);
        local _,TrackChunk = reaper.GetTrackStateChunk(track,'',false);
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
    --=========================================
    
    
    
    -------------------------------------------------------
    local function AnyTrackMute(proj);
        for i = 1,reaper.CountTracks(proj)do;
            local Track = reaper.GetTrack(proj,i-1);
            local lock = GetLockTrackState(Track);
            if lock ~= 1 then;
                local mute = reaper.GetMediaTrackInfo_Value(Track,"B_MUTE");
                if mute > 0 then return true end;
            end;
        end;
        return false;
    end;
    -------------------------------------------------------
    
    
    
    --=========================================
    local function body();
        local CountTrack = reaper.CountTracks(0);
        if CountTrack == 0 then no_undo() return end;
        local extname = 'ARCHIE_UNMUTE_ALL_TRACK_AUTORUN';
        
        local AnyTrMute = AnyTrackMute(0);
        if AnyTrMute then;
            ----
            reaper.SetProjExtState(0,extname,'','');
            ---- 
            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);
            for i = 1,reaper.CountTracks(0)do;
                local Track = reaper.GetTrack(0,i-1);
                local lock = GetLockTrackState(Track);
                if lock ~= 1 then;
                    local mute = reaper.GetMediaTrackInfo_Value(Track,"B_MUTE");
                    if mute > 0 then;
                        local GUID = reaper.GetTrackGUID(Track);
                        reaper.SetProjExtState(0,extname,GUID,mute);
                        reaper.SetMediaTrackInfo_Value(Track,"B_MUTE",0);
                    end;
                end;
            end;
            reaper.PreventUIRefresh(-1);
            reaper.Undo_EndBlock("UnMute all track",-1);
            ----
        else;
            for i = 1, math.huge do;
                local retval,key,val = reaper.EnumProjExtState(0,extname,i-1);
                if retval then;
                    local track = reaper.BR_GetMediaTrackByGUID(0,key);
                    if track then;
                        if not UNDO then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            UNDO = true;
                        end;
                        reaper.SetMediaTrackInfo_Value(track,"B_MUTE",val);
                    end;
                else;
                    break;
                end;
            end;
            reaper.SetProjExtState(0,extname,'','');
            ----
            if UNDO then;
                UNDO = nil;
                reaper.PreventUIRefresh(-1);
                reaper.Undo_EndBlock("Restore Mute track",-1);
            end;
        end;
    end;
    --=========================================
    
    
    
    --=========================================
    local x;
    local function tmr(ckl);
        x=(x or 0)+1;
        if x>=ckl then x=0 return true end;return false;   
    end;
    --=========================================
    
    
    -------------------------------------------------------
    local function refreshActionList();
        local actionList = reaper.GetToggleCommandStateEx(0,40605);
        if actionList == 1 then;
            Action(40605,40605);
        end;
    end;
    -------------------------------------------------------
    
    
    
    --=========================================
    local function background();
        
        local _,NP,sec,cmd,_,_,_ = reaper.get_action_context();
        local extnameProj = NP:match('.+[/\\](.+)');
        local ActiveDoubleScr,stopDoubleScr;
        
         
        local function loop();
            local tm = tmr(15);
            if tm then;
                ----- stop Double Script -------
                if not ActiveDoubleScr then;
                    stopDoubleScr = (tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"))or 0)+1;
                    reaper.SetExtState(extnameProj,"stopDoubleScr",stopDoubleScr,false);
                    ActiveDoubleScr = true;
                end;
                
                local stopDoubleScr2 = tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"));
                if stopDoubleScr2 > stopDoubleScr then return end;
                --------------------------------
                
                
                local ProjtState = ChangesInProject();
                if ProjtState then;
                    
                    local Repeat_Off,Repeat_On,On; 
                    local On = nil;
                    local AnyTrMute = AnyTrackMute(0);
                    if AnyTrMute then;
                        On = 1;
                    end;
                    
                    if On == 1 and not Repeat_On then;
                        if reaper.GetToggleCommandStateEx(sec,cmd)~=1 then;
                            reaper.SetToggleCommandState(sec,cmd,1);
                            reaper.RefreshToolbar2(sec,cmd);
                            --refreshActionList();
                            --reaper.SetCursorContext(0,nil);
                        end;
                        Repeat_On = true;
                        Repeat_Off = nil;
                    elseif not On and not Repeat_Off then;
                        if reaper.GetToggleCommandStateEx(sec,cmd)~=0 then;
                            reaper.SetToggleCommandState(sec,cmd,0);
                            reaper.RefreshToolbar2(sec,cmd);
                            --refreshActionList();
                            --reaper.SetCursorContext(0,nil);
                        end;
                        Repeat_Off = true;
                        Repeat_On = nil;
                    end;
                    --t=(t or 0)+1
                end;
            end;
            reaper.defer(loop);
        end;
        reaper.defer(loop);
    end;
    --=========================================
    
    
    
    
    
    -------------------------------------------
    --=========================================
    -------------------------------------------
    local scriptPath,scriptName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
    local extname = scriptName;
    
    
    ---___-----------------------------------------------
    local FirstRun;
    if STARTUP == 1 then;
        --reaper.DeleteExtState(extname,"FirstRun",false);
        FirstRun = reaper.GetExtState(extname,"FirstRun")=="";
        if FirstRun then;
            reaper.SetExtState(extname,"FirstRun",1,false);
        end;
    end;
    -----------------------------------------------------
    
    
    ---------------------
    if not FirstRun then;
        body();
        background();
    elseif FirstRun then;
        background();
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
    
    
    
    
    