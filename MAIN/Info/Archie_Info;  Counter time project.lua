--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Info
   * Features:    Startup
   * Description: Info;  Counter time project
   * Author:      Archie
   * Version:     1.0
   * Описание:    Счетчик времени проекта
   * GIF:         https://avatars.mds.yandex.net/get-pdb/2836759/57383ee6-49e1-470f-9e52-dd5a3639e496/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1500
   * Customer:    Archie(---)
   * Gave idea:   Alexey Razumov(Slick)http://www.youtube.com/user/cjslickmusic/videos
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.7.6+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [15.02.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local AFK = 60; -- sec: away from keyboard
    
    local ZoomInOn = 0; -- zoom text
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local STARTUP = 1; -- (Not recommended change)
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.7.6",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    local scriptPath,scriptName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
    local extname = scriptName;
    
    
    -----------------------------
    local function TextByCenterAndResize(string,x,y,w,h,ZoomInOn,flags);
        local gfx_w = gfx.w/100*w;
        local gfx_h = gfx.h/100*h;
        
        gfx.setfont(1,"Arial",10000);
        local lengthFontW,heightFontH = gfx.measurestr(string);
        
        local F_sizeW = gfx_w/lengthFontW*gfx.texth;
        local F_sizeH = gfx_h/heightFontH*gfx.texth;
        local F_size = math.min(F_sizeW+ZoomInOn,F_sizeH+ZoomInOn);
        if F_size < 1 then F_size = 1 end;
        gfx.setfont(1,"Arial",F_size,flags);--BOLD=98,ITALIC=105,UNDERLINE=117
        
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
    local GTSC = {};
    local function GetTransportStateChange();
        GTSC.Rpt = reaper.GetSetRepeat(-1);
        GTSC.Pstn = reaper.GetCursorPosition();
        GTSC.plst = reaper.GetPlayState();
        if GTSC.Rpt2~=GTSC.Rpt then GTSC.Rpt2=GTSC.Rpt GTSC.X=1 end;
        if GTSC.Pstn2~=GTSC.Pstn then GTSC.Pstn2=GTSC.Pstn GTSC.X=1 end;
        if GTSC.plst2~=GTSC.plst then GTSC.plst2=GTSC.plst GTSC.X=1 end;
        if GTSC.X==1 then GTSC.X=nil return true end;
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
    local sWCW;
    local function saveWinState_CloseWin(close);
        sWCW=(sWCW or 0)+1;
        if sWCW >= 30 then; sWCW=0;
            local wind = string.format("%d&&&%d&&&%d&&&%d&&&%d",gfx.dock(-1,-1,-1,-1,-1));
            if reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW')~= wind then;
                reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW',wind,false);
            end;
        end;
        if close == true or close == 1 then;
            gfx.quit();
        end;
    end;
    
    local function RestoreWinState();
        local wind = reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW');
        local D,X,Y,W,H = wind:match('^(%d+)&&&(%d+)&&&(%d+)&&&(%d+)&&&(%d+)');
        return
        tonumber(W) or 250,
        tonumber(H) or 100,
        tonumber(D) or 0,
        tonumber(X) or 15,
        tonumber(Y) or 15
    end;
    -----------------------------
    
    
    
    -----------------------------
    local function main(GUI);
        
        AFK = math.abs(tonumber(AFK)or 60);
        local TIME_SEC,time1,time2;
        local t = {};
         
        if GUI == true or GUI==1 then;
            
            local show_win = tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW'))or 0;
            if show_win == 0 then;
                gfx.init("Info: Counter time project",RestoreWinState());
                reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW',1,false);
            else;
                saveWinState_CloseWin(true);
                reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW',0,false);
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
            --- / t.TIME_rst / ------------reset 0----------------------------------
            local TIME_SEC_rst = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET');
            if TIME_SEC_rst == 0 then t.time1_rst = false end;
            local projUsDt_rst,projfn_rst = reaper.EnumProjects(-1);
            if projUsDt_rst~=t.projUsDt2_rst or projfn_rst~=t.projfn2_rst then;
                t.projUsDt2_rst,t.projfn2_rst=projUsDt_rst,projfn_rst;
                t.time1_rst = false;
                TIME_SEC_rst = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET');
            end;
            
            if not t.time1_rst then t.time1_rst = os.time()-TIME_SEC_rst end;
            t.TIME_rst = (os.time()-t.time1_rst);
            
            if t.TIME_rst == 0 then t.TIME_rst = .01 end;
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET',t.TIME_rst);
            --- / t.TIME_rst / -----------------------------------------------------
            ------------------------------------------------------------------------
            
            
            ------------------------------------------------------------------------
            --- / t.TIME_ttl / -----------------------------------------------------
            local TIME_SEC_ttl = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_TOTAL');
            local projUsDt_ttl,projfn_ttl = reaper.EnumProjects(-1);
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
            --- / t.TIME_akf / -----------------------------------------------------
            local TIME_SEC_akf = GetProjExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK');
            local ProjectState_akf = reaper.GetProjectStateChangeCount(0);
            local TranspoState_akf = GetTransportStateChange();
            
            if ProjectState_akf == t.ProjectState2_akf and not TranspoState_akf then;
                if not t.tm_akf then t.tm_akf = os.time()end;
                t.tm2_akf = (os.time()-t.tm_akf);
            else;
                t.tm_akf = false;
            end;
            t.ProjectState2_akf=ProjectState_akf;
            
            if not t.tm2_akf or t.tm2_akf < AFK then;
                local projUsDt_akf,projfn_akf = reaper.EnumProjects(-1);
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
            --- / t.PROJ_STARTED / -------------------------------------------------
            t.PROJ_STARTED = (({reaper.GetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','PROJECT_STARTED')})[2]);
            if #t.PROJ_STARTED:gsub('%s','')==0 then;
                t.PROJ_STARTED = '|#Project started:|#'..os.date('%d %b %Y / %X',os.time());
                reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','PROJECT_STARTED',t.PROJ_STARTED);
            end;
            
            t.PROJ_STARTPATH = ({reaper.EnumProjects(-1)})[2];
            local projpath,projnane = (t.PROJ_STARTPATH):gsub('\\','/'):match('(.+)[/\\](.+)')
            if projpath and projnane then t.PROJ_STARTPATH = '||#'..projpath..'|#'..projnane end;
            
            if t.TIME_ttl then t.TIME_ttlInfo = '||#Time Total: '..sectotime(t.TIME_ttl)..'  (D:H:M:S)' end;
            if t.TIME_akf then t.TIME_ttlInfo = (t.TIME_ttlInfo or '')..'|#Time AKF '..sectotime(t.TIME_akf)..'  (D:H:M:S)' end;
            
            t.TIME_ttlInfo = (t.TIME_ttlInfo or '')..'||#Item Count:  '.. reaper.CountMediaItems(0);
            t.TIME_ttlInfo = (t.TIME_ttlInfo or '')..'|#Track Count:  '.. reaper.CountTracks(0);
            --- / t.PROJ_STARTED / -------------------------------------------------
            ------------------------------------------------------------------------
            
            
            ----------------------------
            if (GUI==true or GUI==1) and gfx.getchar()>=0 then;
                
                -----------------------------------------------------------------------------------------
                if t.MODE_TOTAL == 0 and t.MODE_AFK == 0 and t.MODE_RESET == 0 then t.MODE_TOTAL = 1 end;
                
                local projUsDt_glb,projfn_glb = reaper.EnumProjects(-1);
                if projUsDt_glb~=t.projUsDt2_glb or projfn_glb~=t.projfn2_glb then;
                    t.projUsDt2_glb = projUsDt_glb;
                    t.projfn2_glb = projfn_glb;
                    t.MODE_TOTAL = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_TOTAL',1);
                    t.MODE_AFK   = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_AFK'  ,1);
                    t.MODE_RESET = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_RESET',1);
                    t.PREFIX     = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','PREFIX'    ,1);
                    t.COUNTBACK  = GetExtStateArc('ARC_COUNTER_TIMER_IN_PROJ_WIN','COUNTBACK' ,1);
                end;
                
                gfx.gradrect(0,0,gfx.w,gfx.h,.2,.2,.2,1);--background
                
                
                
                ----------
                t.MODE = 0;
                t.MODE = t.MODE_TOTAL+t.MODE_AFK+t.MODE_RESET;
                
                
                gfx.set(.7,.7,.7,.2);
                gfx.roundrect(-1,gfx.h/t.MODE,gfx.w+2,gfx.h/t.MODE, 0,1);--Separate
                
                ---/Logo/---
                gfx.x,gfx.y = gfx.w-50,gfx.h-15
                gfx.setfont(1,"Arial",15,105);
                gfx.drawstr('Archie');
                ------------
                
                
                gfx.set(.7,.7,.7,1);
                
                if t.MODE_TOTAL == 1 then;
                    local prf = '';
                    if t.PREFIX == 1 then prf = 'Total: 'end;
                    local string = prf..sectotime(t.TIME_ttl);
                    TextByCenterAndResize(string, 0,0,100,100/t.MODE, ZoomInOn,nil);
                end;
                 
                if t.MODE_AFK == 1 then;
                    if t.COUNTBACK == 0 then t.countBack = '' end;
                    local prf = '';
                    if t.PREFIX == 1 then prf = 'Afk: 'end;
                    local string = prf..sectotime(t.TIME_akf)..t.countBack;
                    TextByCenterAndResize(string, 0,(100/t.MODE)*t.MODE_TOTAL,100,100/t.MODE, ZoomInOn,nil);
                end
                
                if t.MODE_RESET == 1 then;
                    local prf = '';
                    if t.PREFIX == 1 then prf = 'Reset: 'end;
                    local string = prf..sectotime(t.TIME_rst);
                    TextByCenterAndResize(string, 0,(100/t.MODE)*(t.MODE_TOTAL+t.MODE_AFK),100,100/t.MODE, ZoomInOn,nil);
                end;
                ---
                
                
                
                if gfx.mouse_cap == 2 then;
                    gfx.x = gfx.mouse_x;
                    gfx.y = gfx.mouse_y;
                    
                    local mTtl,mAfk,mRst,mpfx,mCnB;
                    if t.MODE_TOTAL == 1 then mTtl = '!' else mTtl = ''end;
                    if t.MODE_AFK   == 1 then mAfk = '!' else mAfk = ''end;
                    if t.MODE_RESET == 1 then mRst = '!' else mRst = ''end;
                    if t.PREFIX     == 1 then mpfx = '!' else mpfx = ''end;
                    if t.COUNTBACK  == 1 then mCnB = '!' else mCnB = ''end;
                    
                    
                    local
                    showmenu = gfx.showmenu(mTtl..'Time Total |'..
                                            mAfk..'Time AFK (time stop when you idle '..AFK..' seconds)|'..
                                            mRst..'Time Reset||'..
                                            mpfx..'Prefix:|'..
                                            mCnB..'AKF - Count Back '..t.countBack..
                                            '||Time Reset: Reset  ('..sectotime(t.TIME_rst)..' > 0:00:00:00)'..
                                            '||#INFO PROJECT:|'..
                                            t.PROJ_STARTED..
                                            t.PROJ_STARTPATH..
                                            t.TIME_ttlInfo or '');
                    
                    if showmenu == 1 then;
                        t.MODE_TOTAL = math.abs(t.MODE_TOTAL-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_TOTAL',t.MODE_TOTAL,true);
                    elseif showmenu == 2 then;
                        t.MODE_AFK = math.abs(t.MODE_AFK-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_AFK',t.MODE_AFK,true);
                    elseif showmenu == 3 then;
                        t.MODE_RESET = math.abs(t.MODE_RESET-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_RESET',t.MODE_RESET,true);
                    elseif showmenu == 4 then;
                        t.PREFIX = math.abs(t.PREFIX-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','PREFIX',t.PREFIX,true);
                    elseif showmenu == 5 then;
                        t.COUNTBACK = math.abs(t.COUNTBACK-1);
                        reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','COUNTBACK',t.COUNTBACK,true);
                    elseif showmenu == 6 then;
                        reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET','');
                    elseif showmenu == 7 then;
                    
                    end
                end;
                ----------------------------
                --if gfx.getchar()>=0 then;
                saveWinState_CloseWin();
                --end;
                ----------------------------
            end;
            -----------------------------------------------------------------------------
            if gfx.getchar()< 0 then;
                local show_win = tonumber(reaper.GetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW'))or 0;
                if show_win ~= 0 then;
                    reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW',0,false);
                end;
            end;
            --[[-------------------------------------------------------------------------
            reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','STATE_WINDOW' ,'',false);
            --reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','SHOW_WINDOW' '',false);
            reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_TOTAL'   ,'',true );
            reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_AFK'     ,'',true );
            reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','MODE_RESET'   ,'',true );
            reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','PREFIX'       ,'',true );
            reaper.SetExtState('ARC_COUNTER_TIMER_IN_PROJ_WIN','COUNTBACK'    ,'',true );
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_RESET' ,'');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_TOTAL' ,'');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','TIME_SEC_AFK'   ,'');
            reaper.SetProjExtState(0,'ARC_COUNTER_TIMER_IN_PROJ_WIN','PROJECT_STARTED','');
            --]]--------------------------------------------------------------------------
            ---------
            reaper.defer(loop);
        end;
        loop();
    end;
    -----------------------------
    
    
    -----------------------------
    local function TerminateAllInstances();
        local ret,val = Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,516,scriptPath,scriptName);
        if val ~= 516 then;
            ::restart::;
            reaper.MB('Reaper restart is required for the script to work!\n'..
                      'Save all projects!!!\n'..
                      'Reaper will now complete the work to configure the script.\n\n\n'..
                      'Для работы скрипта требуется перезагрузка Reaper!\n'..
                      'Сохраните все проекты!!!\n'..
                      'Reaper сейчас завершит работу для настройки скрипта.',
                      'Script Query',0);
            reaper.MarkProjectDirty(0);
            reaper.Main_OnCommand(40004,0);--File: Quit REAPER
            goto restart;
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
    
    
    if not FirstRun then;
        main(true);
    elseif FirstRun then;
        main(nil);
    end;
    
    
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
    
    