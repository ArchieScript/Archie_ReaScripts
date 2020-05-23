--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   * 
   * Category:    Track
   * Features:    Startup
   * Description: Track;  Toggle Off medium mode collapse folder(AutoRun).lua
   * Author:      Archie
   * Version:     1.02
   * Описание:    Переключатель  Выключите средний режим сворачивания папки(АвтоЗапуск).lua
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Alexander Yakuba(---)
   * Gave idea:   Alexander Yakuba(---)
   * Extension:   Reaper 6.08+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.7.6+ (Repository: Archie-ReaScripts) http://clck.ru/EjERc
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
    --==== FUNCTION MODULE FUNCTION ======================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==================
    local P,F,L,A=reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions','/Arc_Function_lua.lua';L,A=pcall(dofile,P..F);if not L then
    reaper.RecursiveCreateDirectory(P,0);reaper.ShowConsoleMsg("Error - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMissing file'..
    '/ Отсутствует файл!\n'..P..F..'\n\n')return;end;if not A.VersionArc_Function_lua("2.8.0",P,"")then A.no_undo() return end;local Arc=A;--==
    --==== FUNCTION MODULE FUNCTION ===================================================▲=▲=▲======= FUNCTION MODULE FUNCTION ==================
    
    
    local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
    local extname = ScriptWay:match(".+[/\\](.+)"):upper();
    
    
    --=========================================
    local function SetToggleButtonOnOff(numb);
        --local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0);
        reaper.RefreshToolbar2(sec,cmd);
    end;
    --=========================================
    
    
    --=========================================
    local function GetSetStateOnOff(set,state);-- 0/1
        local Get = tonumber(reaper.GetExtState(extname,'ToggleState'))or 0;
        if set ~= 1 then return Get end;
        if Get ~= state and set == 1 then;
            reaper.SetExtState(extname,'ToggleState',state,true);
        end;
    end;
    --=========================================
    
    
    
    
    
    -------------------------------------------
    --=========================================
    -------------------------------------------
    
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
    local ActiveDoubleScr,stopDoubleScr;
    
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
        ---
        local ChanInProj = ChangesInProject();
        local tmr = timer(10);
        if ChanInProj or tmr then;--CHANGES_PROJ
            ---
            local CountTracks = reaper.CountTracks(0);
            if CountTracks > 0 then;
                ----
                local x,y = reaper.GetMousePosition();
                local tr, info = reaper.GetTrackFromPoint(x,y);
                if info == 0 and tr then;
                    local compact = (reaper.GetMediaTrackInfo_Value(tr,'I_FOLDERCOMPACT')==1);
                    if compact then;
                        reaper.SetMediaTrackInfo_Value(tr,'I_FOLDERCOMPACT',2);
                    end;
                end;
                ----
                reaper.defer(function();
                    for i = 1,CountTracks do;
                        local track = reaper.GetTrack(0,i-1);
                        local compact = (reaper.GetMediaTrackInfo_Value(track,'I_FOLDERCOMPACT')==1);
                        if compact then;
                            reaper.SetMediaTrackInfo_Value(track,'I_FOLDERCOMPACT',2);
                        end;
                    end;
                end);
                ---
            end;
        end;
        reaper.defer(loop);
    end;
    -------------------------------------------
    --=========================================
    -------------------------------------------
    
    
    
    
    
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
        Arc.HelpWindowWhenReRunning(2,'',false,'!');
        local StateOnOff = GetSetStateOnOff(0,0);
        if StateOnOff == 0 then;
            loop();
            GetSetStateOnOff(1,1);
            SetToggleButtonOnOff(1);
        else;
            local stopDoubleScr = (tonumber(reaper.GetExtState(ScriptWay,"stopDoubleScr"))or 0)+1;
            reaper.SetExtState(ScriptWay,"stopDoubleScr",stopDoubleScr+1,false);
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
    end;
    reaper.defer(SetStartupScriptWrite);
    -----------------------------------------------------
    
    -------------------------------------------
    --=========================================
    -------------------------------------------
    
    
    
    