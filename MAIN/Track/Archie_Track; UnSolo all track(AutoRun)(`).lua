--[[      NEW INSTANCE !!! 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Track 
   * Features:    Startup 
   * Description: Track; UnSolo all track(AutoRun)(`).lua 
   * Author:      Archie 
   * Version:     1.11 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Archie(Rmm) 
   * Gave idea:   Archie(Rmm) 
   * Extension:   Reaper 6.05+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   *              Arc_Function_lua v.2.7.6+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc 
   * Changelog:    
   *              v.1.10 [270620] 
   *                  + refresh Action List off 
    
   *              v.1.07 [260520] 
   *                  + Restore Solo track (works with locked tracks) 
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
    -- DIFFERENCES-LOCK TRACKS / ОТЛИЧИЯ-БЛОКИРОВКА ТРЕКОВ 
     
     
    local STARTUP = 1;  -- 0/1  -- (Not recommended change) 
    --========================================= 
    local function MODULE(file); 
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end; 
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A; 
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
    local function GetSetSoloTrackState(set,track,state); 
        if not set or set == 0 then; 
            return reaper.GetMediaTrackInfo_Value(track,"I_SOLO"); 
        else; 
            local _,TrackChunk = reaper.GetTrackStateChunk(track,'',false); 
            local bracket,ret = 0,nil; 
            for var in string.gmatch(TrackChunk..'\n',".-\n") do; 
                if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then; 
                    bracket = bracket+1; 
                end; 
                ret = tonumber(var:match('^%s-LOCK%s+(%d*).-$')); 
                if ret or (bracket >= 2) then break end; 
            end; 
            if ret and ret >= 1 then; 
                local x,t,arg1,arg2 = 0,{},nil,nil; 
                for var in string.gmatch(TrackChunk..'\n',".-\n") do; 
                    if not arg1 and not arg2 then; 
                        arg1,arg2 = var:match('^%s-(MUTESOLO%s+%S+%s+)(%d*).-$'); 
                        if arg1 and arg2 then; 
                            var = var:gsub(arg1..arg2,arg1..state); 
                        end; 
                    end; 
                    x=x+1;t[x]=var; 
                end; 
                reaper.SetTrackStateChunk(track,table.concat(t),false); 
            else; 
               reaper.SetMediaTrackInfo_Value(track,"I_SOLO",state); 
            end; 
        end; 
    end; 
    --========================================= 
     
     
     
    --========================================= 
    local function body(); 
        local CountTrack = reaper.CountTracks(0); 
        if CountTrack == 0 then no_undo() return end; 
        local extname = 'ARCHIE_UNSOLO_ALL_TRACK_AUTORUN'; 
         
        local AnyTrSolo = reaper.AnyTrackSolo(0); 
        if AnyTrSolo then; 
            ---- 
            reaper.SetProjExtState(0,extname,'',''); 
            ----  
            reaper.Undo_BeginBlock(); 
            reaper.PreventUIRefresh(1); 
            for i = 1,reaper.CountTracks(0)do; 
                local Track = reaper.GetTrack(0,i-1); 
                local solo = GetSetSoloTrackState(0,Track,0); 
                if solo > 0 then; 
                    local GUID = reaper.GetTrackGUID(Track); 
                    GetSetSoloTrackState(1,Track,0); 
                    reaper.SetProjExtState(0,extname,GUID,solo); 
                end; 
            end; 
            reaper.PreventUIRefresh(-1); 
            reaper.Undo_EndBlock("UnSolo all track",-1); 
        else; 
            for i = 1, math.huge do; 
                local retval,key,val = reaper.EnumProjExtState(0,extname,0); 
                if retval then; 
                    reaper.SetProjExtState(0,extname,key,''); 
                    local track = reaper.BR_GetMediaTrackByGUID(0,key); 
                    if track then; 
                        if not UNDO then; 
                            reaper.Undo_BeginBlock(); 
                            reaper.PreventUIRefresh(1); 
                            UNDO = true; 
                        end; 
                        GetSetSoloTrackState(1,track,val); 
                    end; 
                else; 
                    break; 
                end; 
            end; 
            ---- 
            if UNDO then; 
                UNDO = nil; 
                reaper.PreventUIRefresh(-1); 
                reaper.Undo_EndBlock("Restore Solo track",-1); 
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
                    local AnyTrSolo = reaper.AnyTrackSolo(0); 
                    if AnyTrSolo then; 
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
     
     
     
     
     
     
     
     
     
     
     