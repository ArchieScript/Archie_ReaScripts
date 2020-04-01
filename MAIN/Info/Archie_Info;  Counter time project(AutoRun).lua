--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Info
   * Features:    Startup
   * Description: Info;  Counter time project(AutoRun)
   * Author:      Archie
   * Version:     1.17
   * Описание:    Счетчик времени проекта
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2837066/8ec4e155-7209-41f5-866e-28f749637c6d/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1500
   * Customer:    Archie(---)
   * Gave idea:   Alexey Razumov(Slick)http://www.youtube.com/user/cjslickmusic/videos
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0+ http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.7.6+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.15 [03.03.20]
   
   *              v.1.15 [24.02.20]
   *                  + Added: playing Time since inception of project
   *              v.1.14 [24.02.20]
   *              v.1.12 [23.02.20]
   *              v.1.11 [23.02.20]
   *                  + add reset all timers  
   *              v.1.10 [22.02.20]
   *              v.1.09 [21.02.20]
   *              v.1.08 [21.02.20]
   *              v.1.07 [21.02.20]
   *              v.1.06 [20.02.20]
   *              v.1.05 [18.02.20]
   *              v.1.04 [18.02.20]
   *              v.1.03 [17.02.20]
   *              v.1.02 [16.02.20]
   *              v.1.0  [15.02.20]
   *                  +   initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local AFK = 60; -- sec: away from keyboard
    
    
    local ZoomInOn = 0; -- zoom text (theme 2)
    
    
    local SaveDockPosWin = true
                      -- = true  | Save position dock and window
                      -- = false | Open window by center screen
                                 -------------------------------
                      -- = true  | сохранить позицию дока и окна
                      -- = false | открыть окно по центру экрана
    
    
    
    local OpenWinStartReaper = 2
                          -- = 0 | Do not open the window when starting the Reaper
                          -- = 1 | Open Always Window When Starts Reaper
                          -- = 2 | Remember previous state when closing Reaper
                                   -------------------------------------------
                          -- = 0 | Не открывайте окно при запуске Reaper
                          -- = 1 | Всегда открывать окно при запуске Reaper
                          -- = 2 | Запомнить предыдущее состояние при закрытии Reaper
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local STARTUP = 1; -- (Not recommended change)
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.7.6",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    local TOOL_TIP_REAPER_E  = 'REAPER:\nTime since Reaper launch\n';
    local TOOL_TIP_REAPER_R  = 'REAPER:\nВремя с момента запуска Reaper\n';
    local TOOL_TIP_TOTAL_E   = 'TOTAL:\nTime since the project was created (when the project is active)\n';
    local TOOL_TIP_TOTAL_R   = 'TOTAL:\nВремя с момента создания проекта (при активном состоянии проекта)\n';
    local TOOL_TIP_AFK_E     = 'AFK:\nTime spent working in the project since the project was created (in the active state of the project).When a project is idle for more than 60 seconds, the time is paused.\n';
    local TOOL_TIP_AFK_R     = 'AFK:\nВремя, затраченное на работу в проекте с момента создания проекта (в активном состоянии проекта).\nКогда проект простаивает более 60 секунд, время приостанавливается.\n'
    local TOOL_TIP_SESSION_E = 'SESSION:\nTime since the project was launched in this reaper session (when the project is active)\n';
    local TOOL_TIP_SESSION_R = 'SESSION:\nВремя с момента запуска проекта в данном сеансе reaper (при активном состоянии проекта)\n';
    local TOOL_TIP_SES_AFK_E = 'SESSION AFK:\nTime spent on the project since it was launched in this reaper session (when the project is active).\nWhen a project is idle for more than 60 seconds, the time is paused.\n';
    local TOOL_TIP_SES_AFK_R = 'SESSION AFK:\nВремя затраченное на работу проекта с момента его запуска в данном сеансе reaper (при активном состоянии проекта).\nКогда проект простаивает более 60 секунд, время приостанавливается.\n';
    local TOOL_TIP_RESET_E   = 'RESET:\nTime that is reset to detect the process from this moment.\nTo reset the time, right-click and select "Time Reset: Reset"\n'
    local TOOL_TIP_RESET_R   = 'RESET:\nВремя которое сбрасывается, чтобы засечь процесс с данного момента.\nДля того чтобы сбросить время, кликните правой кнопкой мыши и "Time Reset: Reset".\n'
    local TOOL_TIP_PLAY_E    = 'PLAY:\nPlayback time since the project was created\n'
    local TOOL_TIP_PLAY_R    = 'PLAY:\nВремя воспроизведения с момента создания проекта.\n'
    
    local TL_TP_HELP_E = TOOL_TIP_REAPER_E..TOOL_TIP_TOTAL_E..TOOL_TIP_AFK_E..TOOL_TIP_SESSION_E..TOOL_TIP_SES_AFK_E..TOOL_TIP_PLAY_E..TOOL_TIP_RESET_E;
    local TL_TP_HELP_R = TOOL_TIP_REAPER_R..TOOL_TIP_TOTAL_R..TOOL_TIP_AFK_R..TOOL_TIP_SESSION_R..TOOL_TIP_SES_AFK_R..TOOL_TIP_PLAY_R..TOOL_TIP_RESET_R;
    
    
    
    local scriptPath,scriptName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
    local extname = scriptName;
    local 
    t = {};
    
    -----------------------------
    local function TextByCenterAndResize(string,x,y,w,h,ZoomInOn,flags);
        local gfx_w = gfx.w/100*w;
        local gfx_h = gfx.h/100*h;
        local Fnt = 'Verdana';  --Tahoma  Verdana Georgia
        gfx.setfont(1,Fnt,10000);
        local lengthFontW,heightFontH = gfx.measurestr(string);
        
        local F_sizeW = gfx_w/lengthFontW*gfx.texth;
        local F_sizeH = gfx_h/heightFontH*gfx.texth;
        local F_size = math.min(F_sizeW+ZoomInOn,F_sizeH+ZoomInOn);
        if F_size < 1 then F_size = 1 end;
        gfx.setfont(1,Fnt,F_size,flags);--BOLD=98,ITALIC=105,UNDERLINE=117
        
        local lengthFont,heightFont = gfx.measurestr(string);
        gfx.x = gfx.w/100*x + (gfx_w - lengthFont)/2;
        gfx.y = gfx.h/100*y + (gfx_h- heightFont )/2;
        gfx.drawstr(string);
    end;
    -----------------------------
    
    
    
    -----------------------------
    local function sectotime(sec);
        local d = math.floor(sec/86400);
        local h = math.floor(math.fmod(sec,86400)/3600);
        local m = math.floor(math.fmod(sec,3600)/60);
        local s = math.floor(math.fmod(sec,60));
        return string.format("%d:%02d:%02d:%02d",d,h,m,s);
    end;
    -----------------------------
    
    
    
    -----------------------------
    local 
    GTSC = {};
    local function GetTransportStateChange(buf);
        buf = (buf or "");
        GTSC['Rpt'..buf] = reaper.GetSetRepeat(-1);
        GTSC['Pstn'..buf] = reaper.GetCursorPosition();
        GTSC['plst'..buf] = reaper.GetPlayState();
        if GTSC['Rpt2'..buf]~=GTSC['Rpt'..buf]then GTSC['Rpt2'..buf]=GTSC['Rpt'..buf]GTSC['X'..buf]=1 end;
        if GTSC['Pstn2'..buf]~=GTSC['Pstn'..buf]then GTSC['Pstn2'..buf]=GTSC['Pstn'..buf]GTSC['X'..buf]=1 end;
        if GTSC['plst2'..buf]~=GTSC['plst'..buf]then GTSC['plst2'..buf]=GTSC['plst'..buf]GTSC['X'..buf]=1 end;
        if GTSC['plst'..buf]==1 or GTSC['plst'..buf]==5 then GTSC['X'..buf]=1 end;
        if GTSC['X'..buf]==1 then GTSC['X'..buf]=nil return true end;
        return false;
    end;
    -----------------------------
    
    
    
    -----------------------------
    local function GetProjExtStateArc(extname,key,def);
        return tonumber(({reaper.GetProjExtState(0,extname,key)})[2])or(def or 0);
    end;
    -----------------------------
    
    
    
    -----------------------------
    local function GetExtStateArc(extname,key,def);
        return tonumber(reaper.GetExtState(extname,key))or(def or 0);
    end;
    -----------------------------
    
    
    -----------------------------
    local function CountFXAllTrack();
        local X = 0;
        for i = 1, reaper.CountTracks(0)do;
            local track = reaper.GetTrack(0,i-1);
            local FXCountTr = reaper.TrackFX_GetCount(track);
            X = X+FXCountTr;
        end;
        return X;
    end;
    -----------------------------
    
    -----------------------------
    local function CountFXMasterTrack();
        local MasterTrack = reaper.GetMasterTrack(0)
        return reaper.TrackFX_GetCount(MasterTrack);
    end;
    -----------------------------
    
    
    -----------------------------
    local sWCW;
    local function saveWinState_CloseWin(close);
        sWCW=(sWCW or 0)+1;
        if sWCW >= 30 then; sWCW=0;
            ---
            if SaveDockPosWin == true then;
                local wind = string.format("%d&&&%d&&&%d&&&%d&&&%d",gfx.dock(-1,-1,-1,-1,-1));
                if reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW')~= wind then;
                    reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW',wind,true);
                end;
            end;
            ---
        end;
        if close == true or close == 1 then;
            gfx.quit();
        end;
    end;
    
    local function RestoreWinState();
        local wind = reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW');
        if wind ~= '' and SaveDockPosWin ~= true then;
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW',true);
        end;
        local D,X,Y,W,H = wind:match('^(%d+)&&&(%d+)&&&(%d+)&&&(%d+)&&&(%d+)');
        local _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,1);
        local THEME_1 = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_1',0);
        local wDef,hDef;
        if THEME_1 == 1 then wDef=560 hDef=400 else wDef=300 hDef=280 end;
        return
        tonumber(W) or wDef,
        tonumber(H) or hDef,
        tonumber(D) or 0,
        tonumber(X) or (scr_x/2)-(wDef/2),
        tonumber(Y) or (scr_y/2)-(hDef/2);
    end;
    -----------------------------
    
    
    -----------------------------
    local function Arc_roundrect(x,y,w,h,r,g,b,a);
        local rr,gg,bb,aa=gfx.r,gfx.g,gfx.b,gfx.a;
        gfx.set(r,g,b,a);
        gfx.roundrect(gfx.w/100*x,gfx.h/100*y,gfx.w/100*w,gfx.h/100*h,0);
        gfx.r,gfx.g,gfx.b,gfx.a=rr,gg,bb,aa;
    end;
    -----------------------------
    
    
    
    --- / Всплывающая подсказка / -----------
    local ToolTip = {};
    local function SetToolTip(Str,x,y,w,h,showTip,buf);
        if showTip == 1 then;
            ToolTip.timeToShow = 1; -- time until display tooltip in number of loop
            if gfx.mouse_x > x and  gfx.mouse_y > y and gfx.mouse_x < x+w and gfx.mouse_y < y+h then;
                if gfx.mouse_x == ToolTip.x_tip and gfx.mouse_y == ToolTip.y_tip then ToolTip.tip=(ToolTip.tip or 0)+1 else ToolTip.tip=0 end;
                ToolTip.x_tip, ToolTip.y_tip = gfx.mouse_x, gfx.mouse_y;
                if ToolTip.tip == ToolTip.timeToShow then;
                    local x,y = gfx.clienttoscreen(gfx.mouse_x,gfx.mouse_y);
                    reaper.TrackCtl_SetToolTip(Str,x+20,y+10,true);
                    ToolTip.tipClean = {};
                    ToolTip.tipClean[buf] = true;
                elseif ToolTip.tip < ToolTip.timeToShow then;
                    ToolTip.tipClean = ToolTip.tipClean or {};
                    if ToolTip.tipClean[buf] == true then;
                        reaper.TrackCtl_SetToolTip("",0,0,false);
                        ToolTip.tipClean[buf] = nil;
                    end;
                end;
            end;
        end;
    end;
    
    local function CleanToolTip(buf);
        ToolTip.tipClean = ToolTip.tipClean or {};
        if ToolTip.tipClean[buf] == true then;
            reaper.TrackCtl_SetToolTip("",0,0,false);
            ToolTip.tipClean[buf] = nil;
            ToolTip.tip = math.floor((ToolTip.timeToShow / 2)+0.5);
        end;
    end;
    -----------------------------------------
    
    
    -----------------------------------------
    local function ArcLine(x,y,x2,y2,r,g,b,a);
        local r2,g2,b2,a2 = gfx.r,gfx.g,gfx.b,gfx.a;
        gfx.r,gfx.g,gfx.b,gfx.a=r or gfx.r,g or gfx.g,b or gfx.b,a or gfx.a;
        gfx.line(x,y,x2,y2);
        gfx.r,gfx.g,gfx.b,gfx.a=r2,g2,b2,a2;
        return r2,g2,b2,a2;
    end;
    -----------------------------------------
    
    
    
    ---- / Remove focus from window (useful when switching Screenset) / -----------
    local RemFocusWin = tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN',"RemFocusWin"))or 0;
    local function RemoveFocusWindow(RemFocusWin);
        if RemFocusWin == 1 then;
            --- / Снять фокус с окна / ---
            local winGuiFocus = gfx.getchar(65536)&2;
            if winGuiFocus ~= 0 then;
                if gfx.mouse_cap == 0 then;
                    local Context = reaper.GetCursorContext2(true);
                    if Context == 2 then ENV = reaper.GetSelectedTrackEnvelope(0)else ENV = nil end;
                    reaper.SetCursorContext(Context,ENV);
                    --t=(t or 0)+1;
                end;
            end;
        end;
    end;
    -------------------------------------------------------------------------------
    
    
    
    -------------------------------------------------------------------------------
    local function ResetExtState(AllSetting,Timer,RaaStartTimer);
        if AllSetting == true or AllSetting == 1 then;
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW'    , false);
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW'     , false);
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_2'         , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_1'         , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN', 'MODE_REAPER_RUN', true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN', 'MODE_TOTAL'     , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN', 'MODE_AFK'       , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN', 'MODE_SESSION'   , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN', 'MODE_SES_AFK'   , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN', 'MODE_PLAY'      , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN', 'MODE_RESET'     , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','COUNTBACK'       , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','PREFIX'          , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','TOOLTIP'         , true );
            reaper.DeleteExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN',"RemFocusWin"     , true );
        end;
        if Timer == true or Timer == 1 then;
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_TOTAL'      ,'');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK'        ,'');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_SESSION'    ,'');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK_SESSION','');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_PLAY'           ,'');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET'      ,'');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','PROJECT_STARTED'     ,'');
            t.tm_akf,t.tm_akf_ses = false;
        end;
        if RaaStartTimer == true or RaaStartTimer == 1 then; 
            reaper.DeleteExtState('REAPER_RUN','TIME_REAPER_RUN',false);
        end;
    end;
    -------------------------------------------------------------------------------
    
    
    -------------------------------------------------------------------------------
    t.strResetAllProjTimer = 
                          'Eng:\n\n'..
                          'All project timers will be reset!\n'..
                          'Are you sure you want to reset all project timers?\n'..
                          'If yes, then in the next window, enter 1\n\n\n'..
                          'Rus:\n\n'..
                          'Все таймеры проекта будут сброшены!\n'..
                          'Вы уверены, что хотите сбросить все таймеры проекта?\n'..
                          'Если да, то в следующем окне введите 1'
    
    t.strResetTimerReaStart = 
                          'Eng:\n\n'..
                          'Reaper start timer will be reset!\n'..
                          'Are you sure you want to reset it?\n\n\n'..
                          'Rus:\n\n'..
                          'Таймер запуска жнеца будет сброшен!\n'..
                          'Вы действительно хотите его сбросить?\n'
    -------------------------------------------------------------------------------
    
    
    -----------------------------
    local function main(GUI);
        
        AFK = math.abs(tonumber(AFK)or 60);
        local TIME_SEC,time1,time2;
        
         
        if GUI == true or GUI==1 then;
            
            local show_win = tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW'))or 0;
            if show_win == 0 then;
                gfx.init("Info: Counter time project",RestoreWinState());
                reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW',1,true);
                local PcallWindScr,ShowWindScr = pcall(reaper.JS_Window_Find,'Info: Counter time project',true);
                if PcallWindScr and type(ShowWindScr)=="userdata" then reaper.JS_Window_AttachTopmostPin(ShowWindScr)end;   
            else;
                saveWinState_CloseWin(true);
                reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW',0,true);
            end;
        end;
        
        
        ---------------------------
        local function loop();
            
            ----- stop Double Script -------
            if not t.ActiveDoubleScr then;
                t.stopDoubleScr = (tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN',"stopDoubleScr"))or 0)+1;
                reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN',"stopDoubleScr",t.stopDoubleScr,false);
                t.ActiveDoubleScr = true;
            end;
            
            local stopDoubleScr2 = tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN',"stopDoubleScr"));
            if stopDoubleScr2 > t.stopDoubleScr then return end;
            --------------------------------
            
            
            
            
            ------------------------------------------------------------------------
            --- / t.REAPER_RUN / ---------------------------------------------------
            local TIME_REAPER_RUN = GetExtStateArc('REAPER_RUN','TIME_REAPER_RUN');
            if TIME_REAPER_RUN == 0 then t.time1_reaRun = false TIME_REAPER_RUN = .1 end;
            
            if not t.time1_reaRun then t.time1_reaRun = os.time()-TIME_REAPER_RUN end;
            t.TIME_REAPER_RUN = (os.time()-t.time1_reaRun);
            
            reaper.SetExtState('REAPER_RUN','TIME_REAPER_RUN',t.TIME_REAPER_RUN,false);
            --- / t.REAPER_RUN / ---------------------------------------------------
            ------------------------------------------------------------------------
            
            
            ------------------------------------------------------------------------
            --- / t.TIME_rst / ------------reset 0----------------------------------
            local TIME_SEC_rst = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET');
            if TIME_SEC_rst == 0 then t.time1_rst = false TIME_SEC_rst = .1 end;
            local projUsDt_rst,projfn_rst = reaper.EnumProjects(-1,'');
            if projUsDt_rst~=t.projUsDt2_rst or projfn_rst~=t.projfn2_rst then;
                t.projUsDt2_rst,t.projfn2_rst=projUsDt_rst,projfn_rst;
                t.time1_rst = false;
                TIME_SEC_rst = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET');
            end;
            
            if not t.time1_rst then t.time1_rst = os.time()-TIME_SEC_rst end;
            t.TIME_rst = (os.time()-t.time1_rst);
            
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET',t.TIME_rst);
            --- / t.TIME_rst / -----------------------------------------------------
            ------------------------------------------------------------------------
            
            
            ------------------------------------------------------------------------
            --- / t.TIME_ttl / -----------------------------------------------------
            local TIME_SEC_ttl = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_TOTAL');
            if TIME_SEC_ttl == 0 then t.time1_ttl = false TIME_SEC_ttl = .1 end;---v1.10
            local projUsDt_ttl,projfn_ttl = reaper.EnumProjects(-1,'');
            if projUsDt_ttl~=t.projUsDt2_ttl or projfn_ttl~=t.projfn2_ttl then;
                t.projUsDt2_ttl,t.projfn2_ttl=projUsDt_ttl,projfn_ttl;
                t.time1_ttl = false;
                TIME_SEC_ttl = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_TOTAL');
            end;
            
            if not t.time1_ttl then t.time1_ttl = os.time()-TIME_SEC_ttl end;
            t.TIME_ttl = (os.time()-t.time1_ttl);
            
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_TOTAL',t.TIME_ttl);
            --- / t.TIME_ttl / -----------------------------------------------------
            ------------------------------------------------------------------------
            
            
            
            ------------------------------------------------------------------------
            --- / t.TIME_play / ----------------------------------------------------
            
            local PlyStt = reaper.GetPlayState();
            if PlyStt ~= 1 and PlyStt ~= 5 then;
                t.time1_play = false;
            end;
            
            local TIME_PLAY = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_PLAY');
            if TIME_PLAY == 0 then t.time1_play = false TIME_PLAY = .1 end;---v1.10
            local projUsDt_play,projfn_play = reaper.EnumProjects(-1,'');
            if projUsDt_play~=t.projUsDt2_play or projfn_play~=t.projfn2_play then;
                t.projUsDt2_play,t.projfn2_play=projUsDt_play,projfn_play;
                t.time1_play = false;
                TIME_PLAY = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_PLAY');
            end;
            
            if not t.time1_play then t.time1_play = os.time()-TIME_PLAY end;
            t.TIME_play = (os.time()-t.time1_play);
            
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_PLAY',t.TIME_play);
            --- / t.TIME_play / -----------------------------------------------------
            ------------------------------------------------------------------------
            
            
            
            ------------------------------------------------------------------------
            --- / t.TIME_ses / -----------------------------------------------------
            -----v.1.10-------<
            if not t.SESSIONTTL then;
                t.SESSIONTTL = GetExtStateArc('SESSIONTTL','TIME_SESSIONTTL');
                if t.SESSIONTTL == 0 then;
                    reaper.SetExtState('SESSIONTTL','TIME_SESSIONTTL',1,false);
                    reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_SESSION','');
                end;
            end;
            ------------------>
            local TIME_SEC_ses = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_SESSION');
            if TIME_SEC_ses == 0 then t.time1_ses = false TIME_SEC_ses = .1 end;---v1.10
            
            local projUsDt_ses,projfn_ses = reaper.EnumProjects(-1,'');
            if projUsDt_ses~=t.projUsDt2_ses or projfn_ses~=t.projfn2_ses then;
                t.projUsDt2_ses,t.projfn2_ses=projUsDt_ses,projfn_ses;
                t.time1_ses = false;
                local TIME_SEC_ses = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_SESSION');
            end;
            
            if not t.time1_ses then t.time1_ses = os.time()-TIME_SEC_ses end;
            t.TIME_ses = (os.time()-t.time1_ses);
            
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_SESSION',t.TIME_ses);
            --- / t.TIME_ses / -----------------------------------------------------
            ------------------------------------------------------------------------
            
            
            ------------------------------------------------------------------------
            --- / t.TIME_akf / -----------------------------------------------------
            local TIME_SEC_akf = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK');
            if TIME_SEC_akf == 0 then t.time1_akf = false TIME_SEC_akf = .1 end;---v1.10
            local ProjectState_akf = reaper.GetProjectStateChangeCount(0);
            local TranspoState_akf = GetTransportStateChange('akf');
            
            if ProjectState_akf == t.ProjectState2_akf and not TranspoState_akf then;
                if not t.tm_akf then t.tm_akf = os.time()end;
                t.tm2_akf = (os.time()-t.tm_akf);
            else;
                t.tm_akf = false;
                t.tm2_akf = false;---v1.07
            end;
            t.ProjectState2_akf=ProjectState_akf;
            
            if not t.tm2_akf or t.tm2_akf < AFK then;
                local projUsDt_akf,projfn_akf = reaper.EnumProjects(-1,'');
                if projUsDt_akf~=t.projUsDt2_akf or projfn_akf~=t.projfn2_akf then;
                    t.projUsDt2_akf,t.projfn2_akf=projUsDt_akf,projfn_akf;
                    t.ProjectState2_akf=-1;
                    t.time1_akf = false;
                    TIME_SEC_akf = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK');
                end;
                
                if not t.time1_akf then t.time1_akf = os.time()-TIME_SEC_akf end;
                t.TIME_akf = (os.time()-t.time1_akf);
                reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK',t.TIME_akf);
            else;
                t.time1_akf = false;
            end;
            
            local countB = AFK-(t.tm2_akf or 0);
            if countB <= 0 then;
                t.countBack = ' (S)'
            elseif countB > 60 then;
                t.countBack = '';
            else;
                t.countBack = ' ('..string.format("%02d",countB)..')';
            end;
            --- / t.TIME_akf / -----------------------------------------------------
            ------------------------------------------------------------------------

            
            
            
            ------------------------------------------------------------------------
            --- / t.TIME_akf_ses / -------------------------------------------------
            -----v.1.10-------<
            if not t.SESSIONAFK then;
                t.SESSIONAFK = GetExtStateArc('SESSIONAFK','TIME_SESSIONAFK');
                if t.SESSIONAFK == 0 then;
                    reaper.SetExtState('SESSIONAFK','TIME_SESSIONAFK',1,false);
                    reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK_SESSION','');
                end;
            end;
            ------------------> 
            local TIME_SEC_akf_ses = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK_SESSION');
            if TIME_SEC_akf_ses == 0 then t.time1_akf_ses = false TIME_SEC_akf_ses = .1 end;---v1.10
            
            local ProjectState_akf_ses = reaper.GetProjectStateChangeCount(0);
            local TranspoState_akf_ses = GetTransportStateChange('akf_ses');
            
            if ProjectState_akf_ses == t.ProjectState2_akf_ses and not TranspoState_akf_ses then;
                if not t.tm_akf_ses then t.tm_akf_ses = os.time()end;
                t.tm2_akf_ses = (os.time()-t.tm_akf_ses);
            else;
                t.tm_akf_ses = false;
                t.tm2_akf_ses = false;---v1.07
            end;
            t.ProjectState2_akf_ses=ProjectState_akf_ses;
            
            if not t.tm2_akf_ses or t.tm2_akf_ses < AFK then;
                local projUsDt_akf_ses,projfn_akf_ses = reaper.EnumProjects(-1,'');
                if projUsDt_akf_ses~=t.projUsDt2_akf_ses or projfn_akf_ses~=t.projfn2_akf_ses then;
                    t.projUsDt2_akf_ses,t.projfn2_akf_ses=projUsDt_akf_ses,projfn_akf_ses;
                    t.ProjectState2_akf_ses=-1;
                    t.time1_akf_ses = false;
                    TIME_SEC_akf = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK_SESSION');
                end;
                
                if not t.time1_akf_ses then t.time1_akf_ses = os.time()-TIME_SEC_akf_ses end;
                t.TIME_akf_ses = (os.time()-t.time1_akf_ses);
                
                reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK_SESSION',t.TIME_akf_ses);
            else;
                t.time1_akf_ses = false;
            end;
            
            local countB_ses = AFK-(t.tm2_akf_ses or 0);
            if countB_ses <= 0 then;
                t.countBack_ses = ' (S)'
            elseif countB_ses > 60 then;
                t.countBack_ses = '';
            else;
                t.countBack_ses = ' ('..string.format("%02d",countB_ses)..')';
            end;
            --- / t.TIME_akf_ses / -------------------------------------------------
            ------------------------------------------------------------------------
            
            
            
            ------------------------------------------------------------------------
            --- / t.PROJ_STARTED / -------------------------------------------------
            t.PROJ_STARTED = (({reaper.GetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','PROJECT_STARTED')})[2]);
            if #t.PROJ_STARTED:gsub('%s','')==0 then;
                t.PROJ_STARTED = os.date('%x / %X',os.time());
                reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','PROJECT_STARTED',t.PROJ_STARTED);
            end;
            
            t.PROJ_STARTPATH = ({reaper.EnumProjects(-1,'')})[2];
            local projpath,projnane = (t.PROJ_STARTPATH):gsub('\\','/'):match('(.+)[/\\](.+)')
            if projpath and projnane then t.PROJ_STARTPATH = '||#'..projpath..'|#'..projnane end;
            
            t.TIME_ttlInfo = ''
            if t.TIME_REAPER_RUN then t.TIME_ttlInfo = t.TIME_ttlInfo..'||#Time Reaper Started: '..sectotime(t.TIME_REAPER_RUN)..'  (D:H:M:S)' end;
            if t.TIME_ttl then t.TIME_ttlInfo = t.TIME_ttlInfo..'|#Time Total: '..sectotime(t.TIME_ttl)..'  (D:H:M:S)' end;
            if t.TIME_akf then t.TIME_ttlInfo = t.TIME_ttlInfo..'|#Time AKF: '..sectotime(t.TIME_akf)..'  (D:H:M:S)' end;
            if t.TIME_ses then t.TIME_ttlInfo = t.TIME_ttlInfo..'|#Time Session: '..sectotime(t.TIME_ses)..'  (D:H:M:S)' end;
            if t.TIME_akf_ses then t.TIME_ttlInfo = t.TIME_ttlInfo..'|#Time Session AFK: '..sectotime(t.TIME_akf_ses)..'  (D:H:M:S)' end;
            if t.TIME_rst then t.TIME_ttlInfo = t.TIME_ttlInfo..'|#Time Reset: '..sectotime(t.TIME_rst)..'  (D:H:M:S)' end;
            
            t.TIME_ttlInfo = (t.TIME_ttlInfo or '')..'||#Item Count:  '.. reaper.CountMediaItems(0);
            t.TIME_ttlInfo = (t.TIME_ttlInfo or '')..'|#Track Count:  '.. reaper.CountTracks(0);
            t.TIME_ttlInfo = (t.TIME_ttlInfo or '')..'|#Track Count Fx:  '.. CountFXAllTrack();
            t.TIME_ttlInfo = (t.TIME_ttlInfo or '')..'|#Master Track Count Fx:  '.. CountFXMasterTrack();
            
            
            PROJSTART = 'Proj creat: '..t.PROJ_STARTED
            --- / t.PROJ_STARTED / -------------------------------------------------
            ------------------------------------------------------------------------
            
            
            ----------------------------
            if (GUI==true or GUI==1) and gfx.getchar()>=0 then;
                
                RemoveFocusWindow(RemFocusWin);
                
                -----<
                t.cntLoop = (t.cntLoop or 0)+1
                if t.cntLoop > 20 then t.cntLoop = 0 end;
                local _,_,_,Wwnd,Hwnd = gfx.dock(-1,-1,-1,-1,-1);
                if  t.cntLoop                  == 0                 or
                    (t.Wwnd2 or -1)            ~= Wwnd              or
                    (t.Hwnd2 or -1)            ~= Hwnd              or
                    (t.TIME_REAPER_RUN2 or -1) ~= t.TIME_REAPER_RUN or
                    (t.TIME_ttl2 or -1)        ~= t.TIME_ttl        or
                    (t.TIME_akf2 or -1)        ~= t.TIME_akf        or
                    (t.TIME_ses2 or -1)        ~= t.TIME_ses        or
                    (t.TIME_akf_ses2 or -1)    ~= t.TIME_akf_ses    or
                    (t.TIME_play2 or -1)       ~= t.TIME_play       or
                    (t.TIME_rst2 or -1)        ~= t.TIME_rst        then;
                    
                    t.Wwnd2 = Wwnd;
                    t.Hwnd2 = Hwnd;
                    t.TIME_REAPER_RUN2 = t.TIME_REAPER_RUN;
                    t.TIME_ttl2 = t.TIME_ttl;
                    t.TIME_akf2 = t.TIME_akf;
                    t.TIME_ses2 = t.TIME_ses;
                    t.TIME_akf_ses2 = t.TIME_akf_ses;
                    t.TIME_play2 = t.TIME_play;
                    t.TIME_rst2 = t.TIME_rst;
                    --GG=(GG or 0)+1
                    --->
                
                    -----------------------------------------------------------------------------------------
                    local projUsDt_glb,projfn_glb = reaper.EnumProjects(-1,'');
                    if projUsDt_glb~=t.projUsDt2_glb or projfn_glb~=t.projfn2_glb then;
                        t.projUsDt2_glb = projUsDt_glb;
                        t.projfn2_glb  = projfn_glb;
                        t.MODE_REAPER_RUN = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_REAPER_RUN',1);
                        t.MODE_TOTAL      = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_TOTAL'     ,1);
                        t.MODE_AFK        = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_AFK'       ,1);
                        t.MODE_SESSION    = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_SESSION'   ,1);
                        t.MODE_SES_AFK    = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_SES_AFK'   ,1);
                        t.MODE_PLAY       = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_PLAY'      ,1);
                        t.MODE_RESET      = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_RESET'     ,1);
                        t.PREFIX          = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','PREFIX'         ,1);
                        t.COUNTBACK       = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','COUNTBACK'      ,1);
                        t.TOOLTIP         = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TOOLTIP'        ,1);
                        --
                        t.THEME_1         = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_1'        ,0);
                        t.THEME_2         = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_2'        ,1);
                    end;
                    
                    if t.THEME_1 == 0 and t.THEME_2 == 0 then t.THEME_2 = 1 end;
                    
                    
                    gfx.gradrect(0,0,gfx.w,gfx.h,.2,.2,.2,1);--background
                    
                    
                    
                    ---/Logo/---
                    gfx.set(.7,.7,.7,.2);
                    gfx.x,gfx.y = gfx.w-50,gfx.h-15
                    gfx.setfont(1,"Arial",15,105);
                    gfx.drawstr('Archie');
                    ------------
                    
                    ---------------------------------
                    if t.THEME_2 == 1 then;
                    
                        -------------------
                        ----THEME_2--open--
                        -------------------
                        if t.MODE_REAPER_RUN == 0 and 
                           t.MODE_TOTAL      == 0 and 
                           t.MODE_AFK        == 0 and 
                           t.MODE_SESSION    == 0 and 
                           t.MODE_SES_AFK    == 0 and
                           t.MODE_PLAY       == 0 and
                           t.MODE_RESET      == 0 then;
                           t.MODE_REAPER_RUN = 1;
                        end;
                        
                        
                        ----------
                        t.MODE = 0;
                        t.MODE = t.MODE_REAPER_RUN+t.MODE_TOTAL+t.MODE_AFK+t.MODE_SESSION+t.MODE_SES_AFK+t.MODE_PLAY+t.MODE_RESET;
                        
                        
                        gfx.set(.7,.7,.7,1);
                        
                        
                        
                        if t.MODE_REAPER_RUN == 1 then;
                            local prf = '';
                            if t.PREFIX == 1 then prf = 'Reaper: 'end;
                            local string = prf..sectotime(t.TIME_REAPER_RUN);
                            local Y = (100/t.MODE)*0;
                            TextByCenterAndResize(string, 0,Y,100,100/t.MODE, ZoomInOn,nil);
                            Arc_roundrect(0,0,100,100/t.MODE, .7,.7,.7,.1);--Separate
                            if t.TOOLTIP == 1 then;
                                SetToolTip(TOOL_TIP_REAPER_E..'\n'..TOOL_TIP_REAPER_R,0,0,gfx.w,gfx.h/t.MODE,1,'REAPER');
                            end;
                        end;
                        
                        if t.MODE_TOTAL == 1 then;
                            local prf = '';
                            if t.PREFIX == 1 then prf = 'Total: 'end;
                            local string = prf..sectotime(t.TIME_ttl);
                            local Y = (100/t.MODE)*t.MODE_REAPER_RUN;
                            TextByCenterAndResize(string, 0,Y,100,100/t.MODE, ZoomInOn,nil);
                            Arc_roundrect(0,Y,100,100/t.MODE, .7,.7,.7,.1);--Separate
                            if t.TOOLTIP == 1 then;
                                SetToolTip(TOOL_TIP_TOTAL_E..'\n'..TOOL_TIP_TOTAL_R,0,gfx.h/100*Y,gfx.w,gfx.h/t.MODE,1,'TOTAL');
                            end;
                        end;
                        
                        if t.MODE_AFK == 1 then;
                            if t.COUNTBACK == 0 then t.countBack = '' end;
                            local prf = '';
                            if t.PREFIX == 1 then prf = 'Afk: 'end;
                            local string = prf..sectotime(t.TIME_akf)..t.countBack;
                            local Y = (100/t.MODE)*(t.MODE_REAPER_RUN+t.MODE_TOTAL);
                            TextByCenterAndResize(string, 0,Y,100,100/t.MODE, ZoomInOn,nil);
                            Arc_roundrect(0,Y,100,100/t.MODE , .7,.7,.7,.1);--Separate
                            if t.TOOLTIP == 1 then;
                                SetToolTip(TOOL_TIP_AFK_E..'\n'..TOOL_TIP_AFK_R,0,gfx.h/100*Y,gfx.w,gfx.h/t.MODE,1,'AFK');
                            end;
                        end
                         
                        if t.MODE_SESSION == 1 then;
                            local prf = '';
                            if t.PREFIX == 1 then prf = 'Session: 'end;
                            local string = prf..sectotime(t.TIME_ses);
                            local Y = (100/t.MODE)*(t.MODE_REAPER_RUN+t.MODE_TOTAL+t.MODE_AFK);
                            TextByCenterAndResize(string, 0,Y,100,100/t.MODE, ZoomInOn,nil);
                            Arc_roundrect(0,Y,100,100/t.MODE , .7,.7,.7,.1);--Separate
                            if t.TOOLTIP == 1 then;
                               SetToolTip(TOOL_TIP_SESSION_E..'\n'..TOOL_TIP_SESSION_R,0,gfx.h/100*Y,gfx.w,gfx.h/t.MODE,1,'SESSION');
                            end;
                        end;
                        
                        if t.MODE_SES_AFK == 1 then;
                            if t.COUNTBACK == 0 then t.countBack_ses = '' end;
                            local prf = '';
                            if t.PREFIX == 1 then prf = 'Ses.Afk: 'end;
                            local string = prf..sectotime(t.TIME_akf_ses)..t.countBack_ses;
                            local Y = (100/t.MODE)*(t.MODE_REAPER_RUN+t.MODE_TOTAL+t.MODE_AFK+t.MODE_SESSION);
                            TextByCenterAndResize(string, 0,Y,100,100/t.MODE, ZoomInOn,nil);
                            Arc_roundrect(0,Y,100,100/t.MODE , .7,.7,.7,.1);--Separate
                            if t.TOOLTIP == 1 then;
                               SetToolTip(TOOL_TIP_SES_AFK_E..'\n'..TOOL_TIP_SES_AFK_R,0,gfx.h/100*Y,gfx.w,gfx.h/t.MODE,1,'SES_AFK');
                            end;
                        end;
                        
                        
                        if t.MODE_PLAY == 1 then;
                            local prf = '';
                            if t.PREFIX == 1 then prf = 'Play: 'end;
                            local string = prf..sectotime(t.TIME_play);
                            local Y = (100/t.MODE)*(t.MODE_REAPER_RUN+t.MODE_TOTAL+t.MODE_AFK+t.MODE_SESSION+t.MODE_SES_AFK);
                            TextByCenterAndResize(string, 0,Y,100,100/t.MODE, ZoomInOn,nil);
                            Arc_roundrect(0,Y,100,100/t.MODE , .7,.7,.7,.1);--Separate
                            if t.TOOLTIP == 1 then;
                               SetToolTip(TOOL_TIP_PLAY_E..'\n'..TOOL_TIP_PLAY_R,0,gfx.h/100*Y,gfx.w,gfx.h/t.MODE,1,'RESET');
                            end;
                        end;
                        
                         
                        if t.MODE_RESET == 1 then;
                            local prf = '';
                            if t.PREFIX == 1 then prf = 'Reset: 'end;
                            local string = prf..sectotime(t.TIME_rst);
                            local Y = (100/t.MODE)*(t.MODE_REAPER_RUN+t.MODE_TOTAL+t.MODE_AFK+t.MODE_SESSION+t.MODE_SES_AFK+t.MODE_PLAY);
                            TextByCenterAndResize(string, 0,Y,100,100/t.MODE, ZoomInOn,nil);
                            Arc_roundrect(0,Y,100,100/t.MODE , .7,.7,.7,.1);--Separate
                            if t.TOOLTIP == 1 then;
                               SetToolTip(TOOL_TIP_RESET_E..'\n'..TOOL_TIP_RESET_R,0,gfx.h/100*Y,gfx.w,gfx.h/t.MODE,1,'RESET');
                            end;
                        end;
                        -------------------
                        ----THEME_2--end---
                        -------------------
                        
                    elseif t.THEME_1 == 1 then;
                        
                        -------------------
                        ----THEME_1--open--
                        -------------------                        
                        
                        gfx.setfont(1,'Verdana',15,0);--BOLD=98,ITALIC=105,UNDERLINE=117
                        gfx.set(.7,.7,.7,1);
                        local HHH = 25;
                        local X2 = 0;
                        local YYY = 185;
                        
                        if gfx.w > 190 and t.PREFIX == 1 then;
                        
                            local pref = {'Reaper Started','Time Total','Work time Afk','Time Ttl Session','Session Afk','Play','Reset'};
                            
                            gfx.x = 5;
                            if gfx.h < YYY then gfx.y = 5 else gfx.y = HHH end;
                             
                            for i = 1,#pref do;
                                gfx.drawstr(pref[i]);
                                gfx.x = 5;
                                gfx.y = gfx.y+HHH;
                                local lengthFont,heightFont = gfx.measurestr(pref[i]);
                                if lengthFont > X2 then X2 = lengthFont end;
                            end;
                            
                            X2 = X2+10;
                            gfx.x = X2;
                            if gfx.h < YYY then gfx.y = 5 else gfx.y = HHH end;
                            for i = 1,#pref do;
                                gfx.drawstr(':');
                                gfx.x = X2;
                                gfx.y = gfx.y+HHH;
                            end;
                        end;
                        -----
                        -----
                        
                        if gfx.h >= YYY then;
                            if X2 == 0 then gfx.x = 5 else gfx.x = X2+10 end;
                            gfx.y = 5;
                            gfx.drawstr('d:  h: m: s');
                            gfx.y = HHH-5;
                            ArcLine(0,gfx.y,gfx.w,gfx.y, nil,nil,nil,.4);  
                        end; 
                        ------
                        ------
                        
                        local timeT = {sectotime(t.TIME_REAPER_RUN),
                                       sectotime(t.TIME_ttl),
                                       sectotime(t.TIME_akf)..t.countBack,
                                       sectotime(t.TIME_ses),
                                       sectotime(t.TIME_akf_ses)..t.countBack_ses,
                                       sectotime(t.TIME_play),
                                       sectotime(t.TIME_rst)};
                        
                        if X2 == 0 then X2 = 5 else X2 = X2+10 end;
                        gfx.x = X2;
                        if gfx.h < YYY then gfx.y = 5 else gfx.y = HHH end;
                        local X3 = 0;
                        for i = 1,#timeT do;
                            gfx.drawstr(timeT[i]);
                            gfx.x = X2;
                            gfx.y = gfx.y+HHH;
                            local lengthFont,heightFont = gfx.measurestr(timeT[i]);
                            if lengthFont > X3 then X3 = lengthFont end;
                        end;
                        X2 = X2+X3;
                        ------
                        ------
                        
                        
                        local descE = {
                                      'Time from Reaper launch',
                                      'Project open in active state since his creation',
                                      'Time spent only work since project created',
                                      'Project open in active state since opened reaper',
                                      'Time spent only work since opened reaper',
                                      'Playback time since the project was created',
                                      'Reset time to notch from now on',
                                     };
                        local X3 = 0;
                        gfx.x = X2;
                        if gfx.h < YYY then gfx.y = 5 else gfx.y = HHH end;
                        for i = 1,#descE do;
                            gfx.drawstr('  -  '..descE[i]);
                            gfx.x = X2;
                            gfx.y = gfx.y+HHH;
                            local lengthFont,heightFont = gfx.measurestr(descE[i]);
                            if lengthFont > X3 then X3 = lengthFont end;
                        end;
                        X2 = X2+X3;
                        ------
                        ------
                        
                        local descR = {
                                      'Время от запуска Жнеца',
                                      'Проект открыт в активном состоянии с момента его создания',
                                      'Время потраченное только на работу с момента создания проекта',
                                      'Проект открыт в активном состоянии с момента открытия Жнеца',
                                      'Время потрачено только на работу с момента открытия жнеца',
                                      'Время воспроизведения с момента создания проекта',
                                      'Сбросить время, чтобы засечь с этого момента',
                                      };
                        X2 = X2+20;
                        gfx.x = X2;
                        if gfx.h < YYY then gfx.y = 5 else gfx.y = HHH end;
                        for i = 1,#descR do;
                            gfx.drawstr('  -  '..descR[i]);
                            gfx.x = X2;
                            gfx.y = gfx.y+HHH;
                        end;
                        ------
                        ------
                        
                        --separate--
                        gfx.x = 0;
                        if gfx.h < YYY then gfx.y = HHH else gfx.y = HHH*2-5 end;
                        for i = 1,#timeT do;
                           ArcLine(0,gfx.y,gfx.w,gfx.y, nil,nil,nil,.2);
                            gfx.y = gfx.y+HHH;
                        end;
                        -----------
                        -----
                        
                        --toolTip--
                        if t.TOOLTIP == 1 then;
                            if gfx.h >= YYY then gfx.y = HHH-5 else gfx.y = 0 end;
                            local x,y,w,h = 0,gfx.y,gfx.w,HHH;
                            SetToolTip(TOOL_TIP_REAPER_E..'\n'..TOOL_TIP_REAPER_R, x,y,w,h ,1,'REAPER');
                            --gfx.gradrect(x,y,w,h,1,0,0,.5);--backTest
                            ---
                            if gfx.h >= YYY then gfx.y = (HHH*2)-5 else gfx.y = HHH end;
                            local x,y,w,h = 0,gfx.y,gfx.w,HHH;
                            SetToolTip(TOOL_TIP_TOTAL_E..'\n'..TOOL_TIP_TOTAL_R,x,y,w,h,1,'TOTAL');
                            --gfx.gradrect(x,y,w,h,1,0,0,.5);--backTest
                            ---
                            if gfx.h >= YYY then gfx.y = (HHH*3)-5 else gfx.y = HHH*2 end;
                            local x,y,w,h = 0,gfx.y,gfx.w,HHH;
                            SetToolTip(TOOL_TIP_AFK_E..'\n'..TOOL_TIP_AFK_R,x,y,w,h,1,'AFK');
                            --gfx.gradrect(x,y,w,h,1,0,0,.5);--backTest
                            --- 
                            if gfx.h >= YYY then gfx.y = (HHH*4)-5 else gfx.y = HHH*3 end;
                            local x,y,w,h = 0,gfx.y,gfx.w,HHH;
                            SetToolTip(TOOL_TIP_SESSION_E..'\n'..TOOL_TIP_SESSION_R,x,y,w,h,1,'SESSION');
                            --gfx.gradrect(x,y,w,h,1,0,0,.5);--backTest
                            --- 
                            if gfx.h >= YYY then gfx.y = (HHH*5)-5 else gfx.y = HHH*4 end;
                            local x,y,w,h = 0,gfx.y,gfx.w,HHH;
                            SetToolTip(TOOL_TIP_SES_AFK_E..'\n'..TOOL_TIP_SES_AFK_R,x,y,w,h,1,'SES_AFK');
                            --gfx.gradrect(x,y,w,h,1,0,0,.5);--backTest
                            ---
                            if gfx.h >= YYY then gfx.y = (HHH*6)-5 else gfx.y = HHH*5 end;
                            local x,y,w,h = 0,gfx.y,gfx.w,HHH;
                            SetToolTip(TOOL_TIP_PLAY_E..'\n'..TOOL_TIP_PLAY_R,x,y,w,h,1,'RESET');
                            --gfx.gradrect(x,y,w,h,1,0,0,.5);--backTest
                            --- 
                            if gfx.h >= YYY then gfx.y = (HHH*7)-5 else gfx.y = HHH*6 end;
                            local x,y,w,h = 0,gfx.y,gfx.w,HHH;
                            SetToolTip(TOOL_TIP_RESET_E..'\n'..TOOL_TIP_RESET_R,x,y,w,h,1,'RESET');
                            --gfx.gradrect(x,y,w,h,1,0,0,.5);--backTest
                        end;
                        -----------
                        ------
                        
                        
                        gfx.x = 5
                        gfx.y = HHH*(#timeT+2);
                        gfx.drawstr('Project created');
                        
                        gfx.x = 5
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr('Project path');
                        
                        gfx.x = 5
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr('Project name');
                        
                        gfx.x = 5
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr('Item count');
                        gfx.x = 5
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr('Track count');
                        gfx.x = 5
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr('Track count Fx');
                        gfx.x = 5
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr('Master Track count Fx');
                        local lengthFont,heightFont = gfx.measurestr('Master Track count Fx:');
                        ------
                        ------
                        
                        local str = '- : - ';
                        for i = 1,7 do;
                            gfx.x = lengthFont+10;
                            gfx.y = HHH*(#timeT+i+1);
                            gfx.drawstr(str);
                        end;
                        -----------
                        
                        
                        
                        local X = gfx.x+10;
                        gfx.x = X;
                        gfx.y = HHH*(#timeT+2);
                        gfx.drawstr(t.PROJ_STARTED);

                        gfx.x = X;
                        gfx.y = gfx.y+HHH;
                        local Path,Name = ({reaper.EnumProjects(-1,'')})[2]:gsub('\\','/'):match('(.+)[/\\](.+)');
                        if Path == '' or not Path then Path = 'Not saved' end;
                        gfx.drawstr(Path);
                        
                        gfx.x = X;
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr(tostring(Name));
                        
                        gfx.x = X;
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr(reaper.CountMediaItems(0));
                        
                        gfx.x = X;
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr(reaper.CountTracks(0));
                        
                        gfx.x = X;
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr(CountFXAllTrack());
                        
                        gfx.x = X;
                        gfx.y = gfx.y+HHH;
                        gfx.drawstr(CountFXMasterTrack());
                        -------------------
                        ----THEME_1--end---
                        -------------------
                    end;
                   
                    
                    ---TOOL-----------------------
                    gfx.gradrect(0,0,7,7,.4,.4,.4,.5);
                    if gfx.mouse_x <= 7 and gfx.mouse_y <= 7 then;
                        SetToolTip('ENG:\n\n'..TL_TP_HELP_E..'\n\nRUS:\n\n'..TL_TP_HELP_R,0,0,7,7,1,'ALL');
                    end; 
                    ------------------------------
                end;
                
                
                
                if gfx.mouse_cap == 2 then;
                    gfx.x = gfx.mouse_x;
                    gfx.y = gfx.mouse_y;
                    
                    local mTtl,mAfk,mRst,mpfx,mCnB,mSsAfk,mSsn,rprR,tolT,thm1,thm2,tm1B,rmvF;
                    if t.MODE_REAPER_RUN == 1 then rprR   = '!' else rprR   = ''end;
                    if t.MODE_TOTAL      == 1 then mTtl   = '!' else mTtl   = ''end;
                    if t.MODE_AFK        == 1 then mAfk   = '!' else mAfk   = ''end;
                    if t.MODE_SESSION    == 1 then mSsn   = '!' else mSsn   = ''end;
                    if t.MODE_SES_AFK    == 1 then mSsAfk = '!' else mSsAfk = ''end;
                    if t.MODE_PLAY       == 1 then mply   = '!' else mply   = ''end;
                    if t.MODE_RESET      == 1 then mRst   = '!' else mRst   = ''end;
                    if t.PREFIX          == 1 then mpfx   = '!' else mpfx   = ''end;
                    if t.COUNTBACK       == 1 then mCnB   = '!' else mCnB   = ''end;
                    if t.TOOLTIP         == 1 then tolT   = '!' else tolT   = ''end;
                    
                    if t.THEME_1         == 1 then thm1   = '!' else thm1   = ''end;
                    if t.THEME_2         == 1 then thm2   = '!' else thm2   = ''end;
                    if t.THEME_1         == 1 then tm1B   = '#' else tm1B   = ''end;
                    if RemFocusWin       == 1 then rmvF   = '!' else rmvF   = ''end;
                    
                    local
                    showmenu = gfx.showmenu('>View|'..
                                --[[01]]    thm1..'Theme 1|'..
                                --[[--]]    thm2..'>Theme 2|'..
                                --[[02]]    thm2..'Theme 2||'..
                                --[[03]]    tm1B..rprR..'Reaper Started |'..
                                --[[04]]    tm1B..mTtl..'Time Total |'..
                                --[[05]]    tm1B..mAfk..'Time AFK (time stop when you idle '..AFK..' seconds)|'..
                                --[[06]]    tm1B..mSsn..'Time Session |'..
                                --[[07]]    tm1B..mSsAfk..'Time Session AFK (time stop when you idle '..AFK..' seconds)|'..
                                --[[08]]    tm1B..mply..'Time Play |'..
                                --[[09]]    tm1B..mRst..'Time Reset||'..             
                                --[[10]]    tm1B..mCnB..'AKF - Count Back '..t.countBack..'|<||'..
                                --[[11]]    mpfx..'Prefix:|'..
                                --[[12]]    tolT..'Tool tip||'..
                                --[[13]]    rmvF..'Remove Focus Win. |<|'..
                                --[[14]]    'Time Reset: RESET  ('..sectotime(t.TIME_rst)..' > 0:00:00:00)|'..
                                --[[15]]    '>???|???|<||'..
                                --[[--]]    '>Reset all timers|'..
                                --[[16]]    'Reset all project timers ||'..
                                --[[17]]    '#Reset timer Reaper started |'..
                                            '<'..
                                            '||#INFO PROJECT:|'..
                                            '#Project created:  '..t.PROJ_STARTED..
                                            t.PROJ_STARTPATH..
                                            t.TIME_ttlInfo or '');
                    
                    if showmenu == 1 then;
                        t.THEME_2 = 0;
                        t.THEME_1 = math.abs(t.THEME_1-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_2',t.THEME_2,true);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_1',t.THEME_1,true);
                    elseif showmenu == 2 then;
                        t.THEME_2 = math.abs(t.THEME_2-1);
                        t.THEME_1 = 0;
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_2',t.THEME_2,true);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','THEME_1',t.THEME_1,true);
                    elseif showmenu == 3 then;
                        t.MODE_REAPER_RUN = math.abs(t.MODE_REAPER_RUN-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_REAPER_RUN',t.MODE_REAPER_RUN,true);
                    elseif showmenu == 4 then;
                        t.MODE_TOTAL = math.abs(t.MODE_TOTAL-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_TOTAL',t.MODE_TOTAL,true);
                    elseif showmenu == 5 then;
                        t.MODE_AFK = math.abs(t.MODE_AFK-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_AFK',t.MODE_AFK,true);
                    elseif showmenu == 6 then;
                        t.MODE_SESSION = math.abs(t.MODE_SESSION-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_SESSION',t.MODE_SESSION,true);
                    elseif showmenu == 7 then;
                        t.MODE_SES_AFK = math.abs(t.MODE_SES_AFK-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_SES_AFK',t.MODE_SES_AFK,true);
                    elseif showmenu == 8 then;
                        t.MODE_PLAY = math.abs(t.MODE_PLAY-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_PLAY',t.MODE_PLAY,true);
                    elseif showmenu == 9 then;
                        t.MODE_RESET = math.abs(t.MODE_RESET-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_RESET',t.MODE_RESET,true);
                    elseif showmenu == 10 then;
                        t.COUNTBACK = math.abs(t.COUNTBACK-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','COUNTBACK',t.COUNTBACK,true);
                    elseif showmenu == 11 then;
                        t.PREFIX = math.abs(t.PREFIX-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','PREFIX',t.PREFIX,true);
                    elseif showmenu == 12 then;
                        t.TOOLTIP = math.abs(t.TOOLTIP-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','TOOLTIP',t.TOOLTIP,true);
                    elseif showmenu == 13 then;
                        RemFocusWin = math.abs(RemFocusWin-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN',"RemFocusWin",RemFocusWin,true);
                    elseif showmenu == 14 then;
                        reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET','');
                    elseif showmenu == 15 then;
                        --reaper.ShowConsoleMsg('ENG:\n\n'..TL_TP_HELP_E..'\n\nRUS:\n\n'..TL_TP_HELP_R);
                        reaper.MB('ENG:\n\n'..TL_TP_HELP_E..'\n\nRUS:\n\n'..TL_TP_HELP_R,'HELP',0);
                    elseif showmenu == 16 then;
                        local MB = reaper.MB(t.strResetAllProjTimer,'Reset Timer',1);
                        if MB == 1 then;
                            local _, ret_csv = reaper.GetUserInputs('Key',1,'Enter key','');
                            if ret_csv == '1' then;
                                ResetExtState(nil,true,nil);
                            end;
                        end;
                    elseif showmenu == 17 then;
                        local MB = reaper.MB(t.strResetTimerReaStart,'Reset Timer Started',1);
                        if MB == 1 then;
                            ResetExtState(nil,nil,true);
                        end;
                    elseif showmenu == 18 then;
                        
                    elseif showmenu == 19 then;
                        
                    end;
                end;
                ----------------------------
                --if gfx.getchar()>=0 then;
                saveWinState_CloseWin();
                --end;
                ----------------------------
            end;
            -----------------------------------------------------------------------------
            if gfx.getchar()< 0 and not t.show_winClose then;
                t.show_winClose = true;
                local show_win = tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW'))or 0;
                if show_win ~= 0 then;
                    reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW',0,true);
                end;
            end;
            ---------------------------------------------------------------------------
            reaper.defer(loop);
        end;
        loop();
    end;
    -----------------------------
    
    
    -----------------------------
    local function TerminateAllInstances();
        local ret,val = Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,516,scriptPath,scriptName);
        if val ~= 516 then;
            --::restart::;
            reaper.MB('Eng:\nReaper restart is required for correctly script to work!\n'..
                      'Save all projects and restart Reaper!!!\n\n'..
                      'Rus:\nДля корректной работы скрипта требуется перезагрузка Reaper!\n'..
                      'Сохраните все проекты и перезапустите Reaper!!!\n'
                      ,'Script Query',0);
            reaper.MarkProjectDirty(0);
            reaper.Main_OnCommand(40004,0);--File: Quit REAPER
            --goto restart;
        end;
    end;
    -----------------------------
    
    
    
    
    
    
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
    
    
    
    if OpenWinStartReaper ~= 2 and FirstRun then;
        local show_win = tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW'))or 0;
        if show_win == 1 then;
            reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW',0,true);
        end;
        if OpenWinStartReaper == 1 and FirstRun then;
            FirstRun = nil;
        end;
    end;
      
    if OpenWinStartReaper == 2 and FirstRun then;
        FirstRun = nil;
        local show_win = tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW'))or 0;
        show_win = math.abs(show_win-1);
        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW',show_win,true);  
    end;
    
    
    
    
    reaper.Undo_BeginBlock();
    if not FirstRun then;
        main(true);
    elseif FirstRun then;
        main(nil);
    end;
    reaper.Undo_EndBlock((PROJSTART or ''),-1);
    
    
    
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
        TerminateAllInstances();
    end;
    reaper.defer(SetStartupScriptWrite);
    -----------------------------------------------------
    
    
    
    
    
    
    
    
    
    
    
    
    --Time_clearing-------------------
    reaper.defer(function()
        scriptName = 'Archie_Info;  Counter time project.lua'
        local id = Arc.GetIDByScriptName(scriptName,scriptPath);
        if id == -1 or type(id) ~= "string" then Arc.no_undo()return end;
        local check_Id, check_Fun = Arc.GetStartupScript(id);
        if check_Id then;
            Arc.SetStartupScript(scriptName,id,nil,"ONE");
    end;end);
    -----------------------------------
    
    
    
    
    
    
    