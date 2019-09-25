--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Features:    Startup
   * Description: Insert track receive from all tracks
   * Author:      Archie
   * Version:     1.0
   * Описание:    Вставить трек - прием со всех треков
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(Rmm)
   * Gave idea:   Krikets(Rmm)
   * Extension:   Reaper 5.983+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.6.5+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   v.1.0 [26.09.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    local TCP_LAYOUT = "bc --- Small Media" 
                    -- Название лейаута TCP
                    -- Name of TCP layout
                    ---------------------
    
    
    local MCP_LAYOUT = ""
                    -- Название лейаута MCP
                    -- Name of MCP layout
                    ---------------------
    
    
    local R,G,B = 0,0,0
               -- Цвет трека в rgb (по умолчанию R,G,B = -1,-1,-1)
               -- Track color in rgb (default R, G, B = -1, -1,-1)
               ---------------------------------------------------
    
    
    local NAME_TRACK = "Receives"
                    -- Имя трека
                    -- Name track
                    -------------
    
    
    local SEND_VOLUME_DB = -150
                         -- Уровень посыла в db
                         -- Send level in db
                         -------------------
    
    
    local SEND_MODE = 0
                   -- 0 Post-Fader(Post-Pan)
                   -- 1 Pre-Fx 
                   -- 3 Pre-Fader(Post-Fx)
                   -----------------------
    
    
    local TRACK_NUMBERING = 1
                         -- 1 Добавлять цифру к имени / 0 Не добавлять цифру к имени
                         -- 1 Add digit to name / 0 Do not add digit to name
                         ---------------------------------------------------
    
    
    local SEND_ON = 1
                 -- 0 Делать посылы со всех треков кроме возвратных только на созданный трек возврат
                 -- 1 Делать посылы со всех треков кроме возвратных на все треки возвраты
                 -- 0 To do sending with all tracks except return only on created by track a return
                 -- 1 To do the sends from all tracks except the return tracks on all returns
                 ----------------------------------------------------------------------------
    
    
    
    local SEND_ON_AUTO = 1
                    -- = 0 Не отправлять все новые треки в треки получатели*
                    -- = 1 Отправлять все новые треки в треки получатели*
                    -- = 0 Do not send all new tracks to tracks Receives*
                    -- = 1 Send all new tracks to tracks Receives*
                    --   * Работает только при SEND_ON = 1 / STARTUP = 1
                    --   * Works only when SEND_ON = 1 / STARTUP = 1
                    ------------------------------------------------
    
    
    local STARTUP = 1;
                    --   * Работает только при SEND_ON = 1 / STARTUP = 1
                    --   * Works only when SEND_ON = 1 / STARTUP = 1
                    ------------------------------------------------
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
  
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.6.5",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    if reaper.CountTracks(0)==0 then Arc.no_undo() return end;
    
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    local extname = filename:match(".+[/\\](.+)");
    
    
    local function clean();
        for i = 1, math.huge do;
            local ret,key,value = reaper.EnumProjExtState(0,"IS_RETURN_TRACK",i-1);
            if not ret then break end;
            local tr = reaper.BR_GetMediaTrackByGUID(0,key);
            local time = os.time();
            if not tr then;
                if tonumber(value)and tonumber(value) == 0 then;
                    reaper.SetProjExtState(0,"IS_RETURN_TRACK",key,time);
                elseif tonumber(value)and tonumber(value)+3600 < time then;
                    reaper.SetProjExtState(0,"IS_RETURN_TRACK",key,"");
                elseif not tonumber(value) then;
                    reaper.SetProjExtState(0,"IS_RETURN_TRACK",key,0)
                end;
            else;
                if tonumber(value) ~= 0 then reaper.SetProjExtState(0,"IS_RETURN_TRACK",key,0)end;
            end;
        end;
    end;
    
    
    
    local function body();
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        
        reaper.InsertTrackAtIndex(0,false);
        local TrackFirst = reaper.GetTrack(0,0);
        reaper.SetOnlyTrackSelected(TrackFirst);
        local GUID = reaper.GetTrackGUID(TrackFirst);
        reaper.SetProjExtState(0,"IS_RETURN_TRACK",GUID,0);
        reaper.GetSetMediaTrackInfo_String(TrackFirst,"P_TCP_LAYOUT",TCP_LAYOUT,1);
        reaper.GetSetMediaTrackInfo_String(TrackFirst,"P_MCP_LAYOUT",MCP_LAYOUT,1);
        reaper.GetSetMediaTrackInfo_String(TrackFirst,"P_NAME",NAME_TRACK,1);
        if R < 0 or G < 0 or B < 0 or R > 255 or G > 255 or B > 255 then;
            reaper.SetMediaTrackInfo_Value(TrackFirst,"I_CUSTOMCOLOR",0);
        else;
            reaper.SetMediaTrackInfo_Value(TrackFirst,"I_CUSTOMCOLOR",reaper.ColorToNative(R,G,B)|0x1000000);
        end;
        
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local GUID = reaper.GetTrackGUID(Track);
            
            local retval, val = reaper.GetProjExtState(0,"IS_RETURN_TRACK",GUID);
            if retval == 0 then;
                
                if SEND_VOLUME_DB < -150 then SEND_VOLUME_DB = -150 end;
                if SEND_VOLUME_DB > 12 then SEND_VOLUME_DB = 12 end;
                if SEND_MODE~=0 and SEND_MODE~=1 and SEND_MODE~=3 then SEND_MODE=0 end;
                
                if SEND_ON == 1 then;
                    local Send;
                    for ii = 1, math.huge do;
                        local ret,key,_ = reaper.EnumProjExtState(0,"IS_RETURN_TRACK",ii-1);
                        if not ret then break end;
                        local trRet = reaper.BR_GetMediaTrackByGUID(0,key);
                        if trRet then;
                            for s = 1,reaper.GetTrackNumSends(trRet,-1) do;
                                local TrackSend = reaper.GetTrackSendInfo_Value(trRet,-1,s-1,"P_SRCTRACK");
                                if TrackSend == Track then Send = true break end;
                            end;
                            if not Send then;
                                local sendidx = reaper.CreateTrackSend(Track,trRet);
                                reaper.SetTrackSendInfo_Value(Track,0,sendidx,"D_VOL",10^(SEND_VOLUME_DB/20)); 
                                reaper.SetTrackSendInfo_Value(Track,0,sendidx,"I_SENDMODE",SEND_MODE);
                           end;
                           Send = nil;
                        end;  
                    end;
                else;
                    local sendidx = reaper.CreateTrackSend(Track,TrackFirst);
                    reaper.SetTrackSendInfo_Value(Track,0,sendidx,"D_VOL",10^(SEND_VOLUME_DB/20));
                    reaper.SetTrackSendInfo_Value(Track,0,sendidx,"I_SENDMODE",SEND_MODE);
                end;
            end;
        end;
        
        clean();
        
        ----- / Нумерация треков / -----
        if TRACK_NUMBERING == 1 then;
            local numb_T = {};
            local Track_T = {};
            for i = 1, reaper.CountTracks(0) do;
                local Track = reaper.GetTrack(0,i-1);
                local ret,name = reaper.GetSetMediaTrackInfo_String(Track,"P_NAME","",0);
                if #NAME_TRACK:gsub("%s","") > 0 and name:match("^%s-"..NAME_TRACK.."%s-%d-%s-$") then;
                    Track_T[#Track_T+1] = Track
                    numb = tonumber(name:match(NAME_TRACK.."%s-(%d+)%s-$"));
                    if numb then numb_T[numb] = true end;
                end;
            end;
            local n;
            for i = #Track_T,1,-1 do;
                local ret,name = reaper.GetSetMediaTrackInfo_String(Track_T[i],"P_NAME","",0);
                if #NAME_TRACK:gsub("%s","") > 0 and name:match("^%s-"..NAME_TRACK.."%s-$") then;
                    n = (n or -1)+1;
                    if n > 0 then;
                        for i2 = 1, math.huge do;
                            if not numb_T[i2] then;
                                reaper.GetSetMediaTrackInfo_String(Track_T[i],"P_NAME",name:gsub("%s-$","").." "..i2,1);
                                numb_T[i2]=true;
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        --------------------------------
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock("Insert track receive from all tracks",-1);
        ----------------------------------------------------------------------
    end;
    
    
    local stopDoubleScr,ActiveDoubleScr;
    local CountTrack2,ProjectState2;
    local function loop();
        
        ----- stop Double Script -------
        if not ActiveDoubleScr then;
            stopDoubleScr = (tonumber(reaper.GetExtState(extname,"stopDoubleScr"))or 0)+1;
            reaper.SetExtState(extname,"stopDoubleScr",stopDoubleScr,false);
            ActiveDoubleScr = true;
        end;
        
        local stopDoubleScr2 = tonumber(reaper.GetExtState(extname,"stopDoubleScr"));
        if stopDoubleScr2 > stopDoubleScr then return end;
        --------------------------------
        
        local firstSaveTrRet = reaper.EnumProjExtState(0,"IS_RETURN_TRACK",0);
        if not firstSaveTrRet and FirstRun then return end;
        if firstSaveTrRet then;
            
            local ProjectState = reaper.GetProjectStateChangeCount(0);
            if ProjectState ~= ProjectState2 then;
                ProjectState2 = ProjectState;
                
                local CountTrack = reaper.CountTracks(0);
                if CountTrack ~= CountTrack2 then;
                    CountTrack2 = CountTrack;
                    --T=(T or 0)+1--*
                    --reaper.ShowConsoleMsg(tostring(T.."\n") )--*
                    ----------------
                    for i = 1, reaper.CountTracks(0) do;
                        local Track = reaper.GetTrack(0,i-1);
                        local GUID = reaper.GetTrackGUID(Track);
                        local retval, val = reaper.GetProjExtState(0,"IS_RETURN_TRACK",GUID);
                        if retval == 0 then;
                            local Send;
                            for ii = 1, math.huge do;
                                local ret,key,_ = reaper.EnumProjExtState(0,"IS_RETURN_TRACK",ii-1);
                                if not ret then break end;
                                local trRet = reaper.BR_GetMediaTrackByGUID(0,key);
                                if trRet then;
                                    for s = 1,reaper.GetTrackNumSends(trRet,-1) do;
                                        local TrackSend = reaper.GetTrackSendInfo_Value(trRet,-1,s-1,"P_SRCTRACK");
                                        if TrackSend == Track then Send = true break end;
                                    end;
                                    if not Send then;
                                        reaper.PreventUIRefresh(1);
                                        local sendidx = reaper.CreateTrackSend(Track,trRet);
                                        reaper.PreventUIRefresh(-1);
                                    end;
                                    Send = nil;
                                end;  
                            end;
                        end; 
                    end; 
                    ---------------
                    clean();
                end;
            end;
        end;
        reaper.defer(loop);
    end;
    
    
    
    
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
    
    
    if SEND_ON == 1 then;
        if SEND_ON_AUTO == 1 then;
            loop();
        end;
    end;
    
    
    if not FirstRun then;
        if SEND_ON_AUTO == 1 then;
            Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false,"/ "..extname);
        end;
        body();
    end;
    
    
    ---___-----------------------------------------------
    local scriptPath,scriptName = filename:match("(.+)[/\\](.+)");
    local id = Arc.GetIDByScriptName(scriptName,scriptPath);
    if id == -1 or type(id) ~= "string" then Arc.no_undo()return end;
    local check_Id, check_Fun = Arc.GetStartupScript(id);
    
    if STARTUP == 1 and SEND_ON_AUTO == 1 and SEND_ON == 1 then;
        if not check_Id then;
            Arc.SetStartupScript(scriptName,id);
        end;
    elseif STARTUP ~= 1 or SEND_ON_AUTO ~= 1 or SEND_ON ~= 1 then;
        if check_Id then;
            Arc.SetStartupScript(scriptName,id,nil,"ONE");
        end;
    end;
    -----------------------------------------------------