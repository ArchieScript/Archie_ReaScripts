--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; selected tracks (popup menu).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Provides:    
   *              [main] .
   *              [midi_editor] .
   * Customer:    BRG(Rmm)
   * Gave idea:   BRG(Rmm)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   v.1.0 [071020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local SHIFT_X = -50; -- Отступ X
    local SHIFT_Y = 15; -- Отступ Y
    
    
    local CTRL = true;    -- true/false  (Запустить повторно с CTRL)
    
    -- SHIFT - Снять выделения со всех треков 
    
    local OPEN_AGAIN = true;
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------
    
    
    ------------------------------------------------------
    local t = {};
    local CountTracks = reaper.CountTracks(0);
    for i = 1,CountTracks do;
        local track = reaper.GetTrack(0,i-1);
        local sel = reaper.GetMediaTrackInfo_Value(track,'I_SELECTED');
        local retval,stringNeedBig = reaper.GetSetMediaTrackInfo_String(track,'P_NAME','',0);
        if stringNeedBig == '' then stringNeedBig = 'No name' end;
        if sel > 0 then j = '!' else j = '' end;
        str = j..i..'-'..'Track'..' ('..stringNeedBig..')|'
        t[#t+1]=str;
    end;
    local STR = table.concat(t);
    ---
    local MasterTrack = reaper.GetMasterTrack(0);
    local sel = reaper.GetMediaTrackInfo_Value(MasterTrack,'I_SELECTED');
    if sel > 0 then j = '!' else j = '' end;
    STR = j..(' '):rep(7)..'MASTER||'..STR;
    ------------------------------------------------------
    
    
    
    ---------------------------------------------------
    local _,scriptPath,secID,cmdID,_,_,_ = reaper.get_action_context();
    local section = scriptPath:match('^.*[/\\](.+)$');
    ---------------------------------------------------
    
    
    ---------------------------------------------------
    ---------------------------------------------------
    local x,y = reaper.GetMousePosition();
    local x,y =  x+(SHIFT_X or 0),y+(SHIFT_Y or 0);
    ---
    local clk1 = tonumber(reaper.GetExtState(section,'TGL_DBL'))or 0;
    local clk2 = os.clock();
    if math.abs(clk2-clk1) < 0.35 then no_undo() return end;
    ---
    local Ext_x,Ext_y,autocloseWNDS;
    if OPEN_AGAIN == true then;
        local ExtState_x_y = reaper.GetExtState(section,'Ext_x_y');
        Ext_x,Ext_y = ExtState_x_y:match('(%S+)%s*(%S+)');
        if Ext_x and Ext_y then;
            x,y = Ext_x,Ext_y;
        else;
            Ext_x,Ext_y = x,y;
        end;
        ----
        autocloseWNDS = reaper.SNM_GetIntConfigVar('autoclosetrackwnds',0);--0-it is allowed(on)-checked
        if autocloseWNDS ~= 0 then;
            reaper.SNM_SetIntConfigVar('autoclosetrackwnds',0);
        end;
    end;
    ---
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
    end;
    ----------------------------------------------------------
    
    
    ----------------------------------------------------------
    local showmenu = gfx.showmenu(STR);
    
    ---------------
    local MGetS = reaper.JS_Mouse_GetState(127);
    if MGetS&8 == 8 or MGetS&9 == 9 then;
        showmenu = 0;
        reaper.Main_OnCommand(40297,0);--Track: Unselect all tracks
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_TOGSELMASTER'),0);--SWS: Unselect master track
        if MGetS&4 == 4 or MGetS&5 == 5 then;
            ----
            if OPEN_AGAIN == true then;
                if autocloseWNDS and autocloseWNDS ~= 0 then;
                    reaper.SNM_SetIntConfigVar('autoclosetrackwnds',autocloseWNDS);
                end;
            end;
            ----
            dofile(({reaper.get_action_context()})[2]);return;
        end;
    
    end;
    ---------------
    
    
    ----
    if OPEN_AGAIN == true then;
        if autocloseWNDS and autocloseWNDS ~= 0 then;
            reaper.SNM_SetIntConfigVar('autoclosetrackwnds',autocloseWNDS);
        end;
    end;
    ----
    if showmenu <= 0 then;
        ----
        reaper.SetExtState(section,'TGL_DBL',os.clock(),false);
        if OPEN_AGAIN == true then;
            reaper.DeleteExtState(section,'Ext_x_y',false);
        end;
        ----
        gfx.quit()no_undo()return;
    end;
    ----------------------------------------------------
    
    
    
    if showmenu > 0 then;
        -----------
        gfx.quit();
        -----------
        -------------------------------------------------
        if CTRL == true then;
            if reaper.APIExists('JS_Mouse_GetState')then;
                local Mouse_GetState = reaper.JS_Mouse_GetState(127);
                if Mouse_GetState ~= 4 and Mouse_GetState ~= 5 then;
                    OPEN_AGAIN = nil;
                    reaper.DeleteExtState(section,'Ext_x_y',false);
                end;
            end;
        end;
        -------------------------------------------------
        
        -----------------------
        if OPEN_AGAIN == true then;
            if showmenu == 1 then;
                local MasterTrack = reaper.GetMasterTrack(0);
                local sel = reaper.GetMediaTrackInfo_Value(MasterTrack,'I_SELECTED');
                if sel > 0 then;
                    reaper.SetMediaTrackInfo_Value(MasterTrack,'I_SELECTED',0);
                else;
                    reaper.SetMediaTrackInfo_Value(MasterTrack,'I_SELECTED',1);
                end;
            elseif showmenu > 1 then;
                local Track = reaper.GetTrack(0,showmenu-2);
                local sel = reaper.GetMediaTrackInfo_Value(Track,'I_SELECTED');
                if sel > 0 then;
                    reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',0);
                else;
                    reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',1);
                end;
            end;
        else;
            if showmenu == 1 then;
                local MasterTrack = reaper.GetMasterTrack(0);
                local sel = reaper.GetMediaTrackInfo_Value(MasterTrack,'I_SELECTED');
                if sel > 0 then;
                    reaper.SetMediaTrackInfo_Value(MasterTrack,'I_SELECTED',0);
                else;
                    reaper.SetOnlyTrackSelected(MasterTrack);
                end;
            elseif showmenu > 1 then;
                local Track = reaper.GetTrack(0,showmenu-2);
                
                local sel = reaper.GetMediaTrackInfo_Value(Track,'I_SELECTED');
                if sel > 0 then;
                    reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',0);
                else;
                    reaper.SetOnlyTrackSelected(Track);
                end;
            end;
        end;
        -----------------------
        
        
        -------------------------------------------------
        if OPEN_AGAIN == true then;
            reaper.SetExtState(section,'Ext_x_y',Ext_x ..' '.. Ext_y,false);
            reaper.defer(function();
                --if secID == 0 then;
                    --reaper.Main_OnCommand(reaper.NamedCommandLookup(cmdID),0);
                    dofile(({reaper.get_action_context()})[2]);--return;
                    ---
               -- else;
                  --  reaper.MIDIEditor_OnCommand(MIDIEditor,reaper.NamedCommandLookup(cmdID));
               -- end;
            end);
        end;
        -------------------------------------------------
    end;
    
    reaper.Main_OnCommand(40913,0);--Vertical scroll selected tracks into view
    
    no_undo();
    