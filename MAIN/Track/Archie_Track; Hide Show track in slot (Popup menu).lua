--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Hide Show track in slot (Popup menu).lua
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Tobbe(Cocos Forum)
   * Gave idea:   Tobbe(Cocos Forum)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   
   *              v.1.0 [101020]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    local SHIFT_X = -80;
    local SHIFT_Y = -10;
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    ---------------------------------------------------
    local _,scriptPath,secID,cmdID,_,_,_ = reaper.get_action_context();
    local section = scriptPath:match('^.*[/\\](.+)$');
    ---------------------------------------------------
    
     
    --------------------------------------
    local x,y = reaper.GetMousePosition();
    local x,y =  x+(SHIFT_X or 0),y+(SHIFT_Y or 0);
    ------
    local Ext_x,Ext_y;
    local ExtState_x_y = reaper.GetExtState(section,'Ext_x_y');
    Ext_x,Ext_y = ExtState_x_y:match('(%S+)%s*(%S+)');
    if Ext_x and Ext_y then;
        x,y = Ext_x,Ext_y;
    else;
        Ext_x,Ext_y = x,y;
    end;
    ------
    local title = 'HIDE Win_'..section;
    gfx.init(title,0,0,0,x,y);
    gfx.x,gfx.y = gfx.screentoclient(x,y);
    --
    local API_JS = reaper.APIExists('JS_Window_Find');
    if API_JS then;
        local Win = reaper.JS_Window_Find(title,true);
        if Win then;
            reaper.JS_Window_SetOpacity(Win,'ALPHA',0);
            reaper.JS_Window_Move(Win,-9999,-9999);
            gfx.x,gfx.y = gfx.screentoclient(x,y);
        end;
    else;
        gfx.quit();
        error('extension reaper_js_ReaScriptAPI64 is missing');
    end;
    ----------------------------------------------------------
    ----------
    local
    LIST,LIST2,LIST2X = {},{},{};
    ----------
    local retval,key,val = reaper.EnumProjExtState(0,section,0);
    if retval then;
        for i = 1,math.huge do;
            local retval,key,val = reaper.EnumProjExtState(0,section,i-1);
            if retval then;
                LIST2[#LIST2+1]={};
                LIST2[#LIST2].key=key;
                LIST2[#LIST2].val=val;
                LIST2X[#LIST2]=key;
            else;
                break;
            end;
        end;
    end;
    ----------
    
    LIST = {'Hide only selected tracks (slot)',
            'Hide only selected tracks and child (slot)',
            'Hide all unselect tracks (slot)'};
            
    ----------
    if #LIST2X > 0 then table.insert(LIST,'|#Show-(Ctrl+click-Open again)-(Shift+click-Remove slot)||')end;
    ----------
    local showmenu = gfx.showmenu(table.concat(LIST,'|')..table.concat(LIST2X,'|'));
    ----------
    if showmenu < #LIST then reaper.DeleteExtState(section,'Ext_x_y',false)end;
    if showmenu <= 0 then gfx.quit()no_undo()return end;
    ----------
    local retval,retvals_csv;
    ----------
    if showmenu > 0 and showmenu < #LIST then;
        ::res1::
        retval,retvals_csv = reaper.GetUserInputs('Create slot',1,'Inter Name Slot:,extrawidth=200','');
        if not retval then gfx.quit() no_undo()return end;
        retvals_csv = retvals_csv:gsub('%p','`');
        if #retvals_csv:gsub('%s','') < 1 then goto res1 end;
        ---- 
        local x1 = 1;
        local x2 = '';
        ::res2::
        for i = 1,#LIST2X do;
            if LIST2X[i]==retvals_csv:upper()..x2 then;
                x1 = x1+1;
                x2 = '('..x1..')';
                goto res2;
            end;
        end;
        retvals_csv = retvals_csv..x2;
    end;
    ----------
     
    if showmenu == 1 or showmenu == 2 then;
        ----------------------------------
        local countSelTrack = reaper.CountSelectedTracks(0);
        if countSelTrack == 0 then gfx.quit() no_undo()return end;
        
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        
        if showmenu == 2 then;
            reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELCHILDREN2'),0);--SWS: Select children of selected folder track(s)
        end;
        local t = {};
        for i = 1,reaper.CountSelectedTracks(0) do;
            local selTrack = reaper.GetSelectedTrack(0,i-1);
            reaper.SetMediaTrackInfo_Value(selTrack,'B_SHOWINTCP',0);
            local GUID = reaper.GetTrackGUID(selTrack);
            t[#t+1]=GUID;
        end;
        reaper.SetProjExtState(0,section,retvals_csv,table.concat(t));
        reaper.Main_OnCommand(40297,0);--Unselect all tracks
        
        reaper.PreventUIRefresh(-1);
        reaper.TrackList_AdjustWindows(0);
        gfx.quit();
        reaper.Undo_EndBlock('Hide only selected tracks',-1);
        ----------------------------------
    elseif showmenu == 3 then;
        ----------------------------------
        local countTrack = reaper.CountTracks(0);
        if countTrack == 0 then gfx.quit()no_undo()return end;
        
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        
        local t = {};
        for i = 1,reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            sel = reaper.GetMediaTrackInfo_Value(Track,'I_SELECTED');
            if sel == 0 then;
                reaper.SetMediaTrackInfo_Value(Track,'B_SHOWINTCP',0);
                local GUID = reaper.GetTrackGUID(Track);
                t[#t+1]=GUID;
            end;
        end;
        reaper.SetProjExtState(0,section,retvals_csv,table.concat(t));
        
        reaper.PreventUIRefresh(-1);
        reaper.TrackList_AdjustWindows(0);
        gfx.quit();
        reaper.Undo_EndBlock('Hide all unselect tracks ',-1);
        ----------------------------------
    --elseif showmenu == 4 then;
        ----------------------------------
        ----------------------------------
    --elseif showmenu == 5 then;
        ----------------------------------
        ----------------------------------
    --elseif showmenu == 6 then;
        ----------------------------------
        ----------------------------------
    elseif showmenu > #LIST then;
        ----------------------------------
        local MouseState = reaper.JS_Mouse_GetState(127);
        local MouseStateCTRL  = MouseState&4==4;
        local MouseStateSHIFT = MouseState&8==8;
         
        local retval,val = reaper.GetProjExtState(0,section,LIST2[showmenu-#LIST].key);
        if retval > 0 then;
            local t = {};
            
            for S in string.gmatch(val,"{.-}")do;
                t[#t+1]=S;
            end;
            
            if #t > 0 then;
                local tTrack = {};
                local SHOW = 0;
                for i = 1,#t do;
                    local track = reaper.BR_GetMediaTrackByGUID(0,t[i]);
                    if track then;
                        tTrack[#tTrack+1]=track;
                        local show = reaper.GetMediaTrackInfo_Value(track,'B_SHOWINTCP');
                        if show == 0 then;
                            SHOW = 1;
                        end;
                    end;
                end;
                
                if #tTrack > 0 then;
                    ---
                    if MouseStateSHIFT then SHOW = 1 end;
                    ---
                    if SHOW > 0 then;
                        reaper.Main_OnCommand(40297,0);--Unselect all tracks
                    end;
                    
                    for i = 1,#tTrack do;
                        reaper.SetMediaTrackInfo_Value(tTrack[i],'B_SHOWINTCP',SHOW);
                        reaper.SetMediaTrackInfo_Value(tTrack[i],'I_SELECTED' ,SHOW);
                    end;
                    reaper.TrackList_AdjustWindows(0);
                end;
            end;
        end;
        
        if MouseStateSHIFT then; 
            reaper.SetProjExtState(0,section,LIST2[showmenu-#LIST].key,'');
        end;
        
        if MouseStateCTRL then;
            reaper.SetExtState(section,'Ext_x_y',Ext_x ..' '.. Ext_y,false);
            gfx.quit();
            dofile(({reaper.get_action_context()})[2]);
            no_undo();
        else;
            reaper.DeleteExtState(section,'Ext_x_y',false);
        end;
        ----------------------------------   
    end;
    
    no_undo();
    
    
    
    