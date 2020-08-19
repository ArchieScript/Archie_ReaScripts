--[[    NEW INSTANCE
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var; Popup menu(n).lua
   * Author:      Archie
   * Version:     2.02
   * Описание:    Всплывающее меню
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(Rmm)
   * Gave idea:   Archie(Rmm)
   * Extension:   
   *              Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   *              Arc_Function_lua v.2.9.0+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.2.02 [300720]
   *                  + +++
   
   *              v.1.0 [240720]
   *                  + initialе
--]]
    Version = 2.02;
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local HIDE_ADD = nil;
            -- = nil | Скрыть / Показать 'add menu' скриптом "Archie_Var;  Hide Show add menu (popup menu single-level).lua"
            -- = 0   | Показать 'add menu'
            -- = 1   | Скрыть 'add menu'
            ------------------------------
    
    
    local OPEN_AGAIN = true;
                  -- = true  повторно открыться  (ctrl+click)
                  -- = false повторно неоткрываться
                  ---------------------------------
    local CTRL = true;
            -- = true  повтор через (ctrl+click)
            -- = false повтор без (ctrl+click)
            ---------------------------------
    
    
    local SHIFT_X = -50;
    local SHIFT_Y = 15;
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.9.0",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
    
    
    ---------------------------------------------------
    local _,scriptPath,secID,cmdID,_,_,_ = reaper.get_action_context();
    local section = scriptPath:match('^.*[/\\](.+)$');
    ---------------------------------------------------
    
    
    
    local function main();
        ---------------------------------------------------
        ----
        ----
        local function GetSelectedActionsFromActionList();
            local hWnd_action = reaper.JS_Window_Find("Actions",true);
            if not hWnd_action then --[[reaper.MB("Please open Actions list!",'woops',0)]]return {} end;
            local restore_column_state = false;
            local hWnd_LV = reaper.JS_Window_FindChildByID(hWnd_action,1323);
            local combo = reaper.JS_Window_FindChildByID(hWnd_action,1317);
            local sectionName = reaper.JS_Window_GetTitle(combo,"");--save item text to table
            local sectionID = reaper.JS_WindowMessage_Send(combo,"CB_GETCURSEL",0,0,0,0);
            local lv_header = reaper.JS_Window_HandleFromAddress(reaper.JS_WindowMessage_Send(hWnd_LV,"0x101F",0,0,0,0)); -- 0x101F = LVM_GETHEADER
            local lv_column_count = reaper.JS_WindowMessage_Send(lv_header,"0x1200",0,0,0,0);-- 0x1200 = HDM_GETITEMCOUNT
            local third_item = reaper.JS_ListView_GetItemText(hWnd_LV,0,3);
            -- get selected count & selected indexes
            local sel_count,sel_indexes = reaper.JS_ListView_ListAllSelItems(hWnd_LV);
            if sel_count == 0 then;
                --reaper.MB("Please select one or more actions.","woops",0);
                return {};
            end;
            ----
            if lv_column_count < 4 or third_item == "" or third_item:find("[\\/:]")then;
                --show Command ID column
                reaper.JS_WindowMessage_Send(hWnd_action,"WM_COMMAND",41170,0,0,0);
                restore_column_state = true;
            end;
            local sel_act = {};
            local i = 0;
            for index in string.gmatch(sel_indexes,'[^,]+')do;
                local desc = reaper.JS_ListView_GetItemText(hWnd_LV,tonumber(index),1):gsub(".+: ","",1);
                local cmd = tostring(reaper.JS_ListView_GetItemText(hWnd_LV, tonumber(index),3))or '';
                local cmdX = reaper.NamedCommandLookup(cmd);
                if tonumber(cmdX)and cmdX~= 0 then;
                    i = i + 1;
                    sel_act[i] = {cmd = cmd,name = desc};
                end;
            end;
            if restore_column_state then;
                --reaper.JS_WindowMessage_Send(hWnd_action,"WM_COMMAND",41170,0,0,0);
            end;
            return (sel_act or {}),sectionID,sectionName;
        end;
        ----
        local function GetSelectedActionsFromActionList2();
            if reaper.APIExists('JS_Window_Find')then;
                if reaper.GetToggleCommandStateEx(0,40605)==1 then;
                    return GetSelectedActionsFromActionList();
                end;
            end;
        end;
        ----
        ----
        
        
        
        ---------------------------------
        local function CountTable(table);
            local x = 0;
            for k,v in pairs(table)do;
                x = x + 1;
            end;
            return x;
        end;
        ---------------------------------
        
        
        
        ---------------------------------
        local function deepcopy(orig);
            local orig_type = type(orig);
            local copy;
            if orig_type == 'table' then;
                copy = {};
                for orig_key, orig_value in next, orig, nil do;
                    copy[deepcopy(orig_key)] = deepcopy(orig_value);
                end;
                setmetatable(copy, deepcopy(getmetatable(orig)));
            else;
                copy = orig;
            end;
            return copy;
        end;
        ---------------------------------------------------
        
        
        
        ---------------------------------------------------
        local MIDIEditor;
        if secID == 32060 then;
            MIDIEditor = reaper.MIDIEditor_GetActive();
            if not MIDIEditor then no_undo()return end;
        end;
        ---------------------------------------------------
        
        
        ---------------------------------------------------
        ----
        local H={};
        H.sect = 'ARCHIE_POPUP MENU SINGLE-LEVEL__HIDE ADD MENU';
        if HIDE_ADD == 1 then;
            Hide_AddMenu = true;
        elseif not HIDE_ADD then;
            ----HIDE_ADD = tonumber(reaper.GetExtState(H.sect,'State'))or 0;
            local HIDE_ADD = tonumber(Arc.iniFileReadLua(H.sect,'State',ArcFileIni))or 0;
            if HIDE_ADD == 1 then;
                Hide_AddMenu = true;
            end;
        end;
        ----
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
        local title = 'HIDE Win_'..section..Version;
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
        local tbl = Arc.iniFileReadSectionLua(section,ArcFileIni);
        local t1 = {};
        local sbm = {};
        ----
        local LIST = '';
        local LIST2 = '';
        local pst;
        for i=1,#tbl do;
            if tbl[i].val:match('^[!><]+')then tbl[i].val = ' '..tbl[i].val end;
            tbl[i].key = tbl[i].key:gsub('^[%s%d]+_','');
            local val,val2;
            if tbl[i].key:match('^%s-action_')then;
                ----
                t1[#t1+1] = {};
                t1[#t1].name = tbl[i].val;
                t1[#t1].id = tbl[i].key;
                ----
                local id = (tbl[i].key:gsub('action_',''):gsub('%s',''))or '';
                local id = reaper.NamedCommandLookup(id);
                local tgl = reaper.GetToggleCommandStateEx(secID,id);
                if tgl == 1 then tgl = '!' else tgl = '' end;
                ---- 
                val = tgl..tbl[i].val;
                val2 = '#'..tgl..tbl[i].val;
                ----
                if #sbm > 0 then sbm[#sbm] = false end;
                ----
            elseif tbl[i].key:match('^%s-separator')then;
                val = '';
            elseif tbl[i].key:match('^%s-submenu_open')then;
                val = '>'..tbl[i].val;
                if #sbm > 0 then sbm[#sbm] = false end;
                sbm[#sbm+1] = true;
            elseif tbl[i].key:match('^%s-submenu_close')then;
                if sbm[#sbm] == true then;
                    pst = '#Empty|';
                    ----
                    t1[#t1+1] = {};
                    t1[#t1].name = tbl[i].val;
                    t1[#t1].id = tbl[i].key;
                    ----
                else
                    pst = '';
                end;
                table.remove(sbm,#sbm);
                val = pst..'<';
            end;
            if val then;
                LIST = LIST..val..'|';
                ----
                if not val2 then val2 = val end;
                LIST2 = LIST2..val2..'|';
            end;
        end;
        ----------------------------------------------------------
        
        
        ----------------------------------------------------------
        local
        addMenu = ''..
                  '|> > > >'..
                  '|>Add'..
                  '|Add Action|'..
                  '|Add Submenu'..
                  '|Add Separator'..
                  '|<'..
                  '|>Remove'..
                  '|Remove Action|'..
                  '|Remove Submenu'..
                  '|Remove Separator'..
                  '||>Remove all list'..
                  '|Remove all list / Script'..
                  '|<'..
                  '|<|'..
                  '|Rename'..
                  '|Block / Label'..
                  '||>Move'..
                  '|Move Action'..
                  '|Move SubMenu'..
                  '|<'..
                  '||>• script|'..
                  ' Hide Add Menu'..
                  '||# Ctrl+click - OPEN AGAIN - (New instance)'..
                  --'|---'..
                  '||# '..section..' - v.'..Version..
                  --'|---'..
                  '|<'..
                  '|<';
        if Hide_AddMenu == true and #t1>0 then addMenu = '' end;
        ----------------------------------------------------------
        
        
        ----------------------------------------------------------
        local showmenu = gfx.showmenu(LIST..addMenu);
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
            --===================================================================================================================
        if showmenu <= #t1 then;--==============================================================================================
            --===================================================================================================================
            gfx.quit();
            
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
            
            
            -------------------------------------------------
            local id = t1[showmenu].id:gsub('^s-action_','');
            id = reaper.NamedCommandLookup(id);
            ----
            if id ~= 0 then;
                if secID == 0 then;
                    Arc.Action(id);
                else;
                    reaper.MIDIEditor_OnCommand(MIDIEditor,id);
                end;
            end;
            -------------------------------------------------
            
            
            -------------------------------------------------
            if OPEN_AGAIN == true then;
                reaper.SetExtState(section,'Ext_x_y',Ext_x ..' '.. Ext_y,false);
                reaper.defer(function();
                    if secID == 0 then;
                        reaper.Main_OnCommand(reaper.NamedCommandLookup(cmdID),0);
                        --dofile(({reaper.get_action_context()})[2]);
                    else;
                        reaper.MIDIEditor_OnCommand(MIDIEditor,reaper.NamedCommandLookup(cmdID));
                    end;
                end);
            end;
            -------------------------------------------------
            
            
            
            --===================================================================================================================
        elseif showmenu == #t1+1 then; --Add Action--============================================================================
            --===================================================================================================================
            ----
            ----
            ----
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>.-[^|]+','|+%0');
            LIST = LIST:gsub('<|','+|%0');
            LIST = LIST:gsub('%#Empty%|','|')..'+';
            LIST = LIST:gsub('||','|'):gsub('||','|');
            LIST = LIST:gsub('#','♯');
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Add Action||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            ----
            ---------------------
            local AutoAct;
            local id;
            local act;
            local ActActList,indexSec,Secname = GetSelectedActionsFromActionList2();
            if secID == 0   and indexSec ~= 0 then ActActList = {} end;
            if secID==32060 and indexSec ~= 3 then ActActList = {} end;
            ---- 
            if type(ActActList)=='table' and #ActActList > 0 then;
                id  = ActActList[1].cmd;
                act = ActActList[1].name;
                if #ActActList > 1 then;
                    ----
                    local MB = reaper.MB(
                               'Eng:\nShow window for entering action - Yes\n'..
                               'Add all ('..#ActActList..') selected actions to the List - No\n\n'..
                               'Rus:\nПоказать окно для ввода действия - Да\n'..--Да 6
                               'Добавить все ('..#ActActList..') выделенных действия в Список - Нет'--Нет 7
                               ,'help Add action Popup Menu',3);
                    if MB == 2 then gfx.quit()no_undo()return end;
                    AutoAct = MB;
                end;
            end;
            ---------------------
            ----
            ----
            ----
            if AutoAct ~= 7 then;
                ActActList = nil;
                ----
                ::restart_AddAction::
                local retval,retvals_csv = reaper.GetUserInputs
                                            ('Add action',2,
                                             'Add ID Action:,Add Name Action:,extrawidth=500,separator==',
                                             (id or '')..'='..(act or ''));
                if not retval then gfx.quit()no_undo() return end;
                id,act = retvals_csv:match('(.-)=(.*)');
                id = id:gsub('[%s]','');
                act = act:gsub('|','\\');
                if act:match('^[!#><]+')then act = ' '..act end;
                if act:match('[!#><]+$')then act = act..' ' end;
                if(not id)or(#id==0)or(not act)or(#act:gsub('%s','')<1)then goto restart_AddAction end;
            end;
            ----
            ----
            ----
            ----
            local X = 0;
            local x2 = 0;
            ---
            tbl[#tbl+1]={};
            tbl[#tbl].key = 'action_LAST';
            tbl[#tbl].val = 'action_LAST';
            ---
            for i=1,math.huge do;
                if tbl[i]then;
                    if tbl[i].key:match('^%s-action_') or
                       tbl[i].key:match('^%s-submenu_')then;
                        X = X+1;
                        if X == ADD_showmenu then;
                            ----
                            if AutoAct ~= 7 and id and act then;
                                ----
                                local T = {key='action_'..id, val=act};
                                table.insert(tbl,i,T);
                                ---- 
                            elseif type(ActActList)=='table' and #ActActList > 0 then;
                                ----
                                for lst = #ActActList,1,-1 do;
                                    local act = ActActList[lst].name;
                                    if act:match('^[!#><]+')then act = ' '..act end;
                                    if act:match('[!#><]+$')then act = act..' ' end;
                                    local T = {key='action_'..ActActList[lst].cmd,val=act};
                                    table.insert(tbl,i,T);
                                end;
                                ----
                            else;
                                ----
                                gfx.quit()no_undo()return;
                                ----
                            end;
                            break;
                        end;
                    end;
                else;
                    break;
                end;
            end;
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_')or
                   tbl[i].key:match('^%s-submenu_')or
                   tbl[i].key:match('^%s-separator')then;
                    x2 = x2 + 1;
                    tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                end;
            end;
            ----
            table.remove(tbl,#tbl);
            ----
            --[[
            Arc.iniFileRemoveSectionLua(section,ArcFileIni);
            for i=1,#tbl do;
                Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
            end;
            --]]
            ----
            iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
            ----
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+2 then;--Add Submenu--============================================================================
            --===================================================================================================================
            ----
            ----
            ----
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>.-[^|]+','|+%0');
            LIST = LIST:gsub('<|','+|%0');
            LIST = LIST:gsub('%#Empty%|','|')..'+';
            LIST = LIST:gsub('||','|'):gsub('||','|');
            LIST = LIST:gsub('#','♯');
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Add Submenu||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            ----
            ::restart_AddSubmenu::
            local retval,retvals_csv = reaper.GetUserInputs
                                        ('Add Submenu',1,'Add Name Submenu:,extrawidth=500','');
            if not retval then gfx.quit()no_undo() return end;
            local name = retvals_csv:gsub('|','\\');
            if name:match('^[!#><]+')then name = ' '..name end;
            if name:match('[!#><]+$')then name = name..' ' end;
            if(not name)or(#name:gsub('%s','')<1)then goto restart_AddSubmenu end;
            ---- 
            ----
            ----
            ----
            ----
            local X = 0;
            local x2 = 0;
            ---
            tbl[#tbl+1]={};
            tbl[#tbl].key = 'action_LAST';
            tbl[#tbl].val = 'action_LAST';
            ---
            for i=1,math.huge do;
                if tbl[i]then;
                    if tbl[i].key:match('^%s-action_') or
                       tbl[i].key:match('^%s-submenu_')then;
                        X = X+1;
                        if X == ADD_showmenu then;
                            local T = {key='submenu_open', val=name};
                            table.insert(tbl,i,T);
                            local T = {key='submenu_close', val=name};
                            table.insert(tbl,i+1,T);
                        end;
                    end;
                    ---
                    if tbl[i].key:match('^%s-action_')or
                       tbl[i].key:match('^%s-submenu_')or
                       tbl[i].key:match('^%s-separator')then;
                         x2 = x2 + 1;
                         tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                    end;
                else;
                    break;
                end;
            end;
            table.remove(tbl,#tbl);
            --[[--
            Arc.iniFileRemoveSectionLua(section,ArcFileIni);
            for i=1,#tbl do;
                Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
            end;
            --]]--
            iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
            ----
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+3 then;--Add Separator--==========================================================================
            --===================================================================================================================
            ----
            ----
            ----
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>.-[^|]+','|+%0');
            LIST = LIST:gsub('<|','+|%0');
            LIST = LIST:gsub('%#Empty%|','|')..'+';
            LIST = LIST:gsub('||','|'):gsub('||','|');
            LIST = LIST:gsub('#','♯');
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            ADD_showmenu = gfx.showmenu('#Add Separator||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            ----
            ----
            ----
            local X = 0;
            local x2 = 0;
            ---
            tbl[#tbl+1]={};
            tbl[#tbl].key = 'action_LAST';
            tbl[#tbl].val = 'action_LAST';
            ---
            for i=1,math.huge do;
                if tbl[i]then;
                    if tbl[i].key:match('^%s-action_') or
                       tbl[i].key:match('^%s-submenu_')then;
                        X = X+1;
                        if X == ADD_showmenu then;
                            local T = {key='separator', val='separator'};
                            table.insert(tbl,i,T);
                        end;
                    end;
                    ---
                    if tbl[i].key:match('^%s-action_')or
                       tbl[i].key:match('^%s-submenu_')or
                       tbl[i].key:match('^%s-separator')then;
                         x2 = x2 + 1;
                         tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                    end;
                else;
                    break;
                end;
            end;
            table.remove(tbl,#tbl);
            --[[--
            Arc.iniFileRemoveSectionLua(section,ArcFileIni);
            for i=1,#tbl do;
                Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
            end;
            --]]--
            iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
            ----
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+4 then;--Remove Action--==========================================================================
            --===================================================================================================================
            ----
            ----
            ----
            LIST = LIST:gsub('%#Empty%|','||||');
            LIST = LIST:gsub('#','♯');
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Remove Action||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            ----
            ----
            local X = 0;
            local x2 = 0;
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_')then;
                    X = X+1;
                    if X == ADD_showmenu then;
                        table.remove(tbl,i);
                        break;
                    end;
                end;
            end;
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_')or
                   tbl[i].key:match('^%s-submenu_')or
                   tbl[i].key:match('^%s-separator')then;
                     x2 = x2 + 1;
                     tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                end;
            end;
            --[[--
            Arc.iniFileRemoveSectionLua(section,ArcFileIni);

            for i=1,#tbl do;
                Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
            end;
            --]]--
            iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
            ----
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+5 then;--Remove Submenu--=========================================================================
            --===================================================================================================================
            ----
            ----
            ----
            LIST = LIST2;
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>.-[^|]+','%0|-');
            LIST = LIST:gsub('<|','-|%0');
            LIST = LIST:gsub('%#Empty%|','|');
            LIST = LIST:gsub('>%s-#',function(v)return v:gsub('#','♯')end);
            ----
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Remove Submenu||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            ----
            local X=0;
            local x2;
            local x3=0;
            local xStart;
            local xEnd;
            local t = {};
            ----
            ----
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_') or
                   tbl[i].key:match('^%s-submenu_')then;
                    X = X+1;
                    if X == ADD_showmenu then;
                        x2 = i;
                        break;
                    end;
                end;
            end;
            ----
            if not x2 then gfx.quit()no_undo() return end;
            ----
            if tbl[x2].key:match('^%s-submenu_open')then;
                ----
                xStart = x2;
                for i=x2+1,#tbl do;
                    if tbl[i].key:match('^%s-submenu_open')then;
                        x3 = x3+1;
                    elseif tbl[i].key:match('^%s-submenu_close')then;
                        if x3 == 0 then;
                            xEnd = i;
                            break;
                        end;
                        x3 = x3-1;
                    end;
                end;
                ---- 
            elseif tbl[x2].key:match('^%s-submenu_close') then;
                ----
                xEnd = x2;
                for i=x2-1,0,-1 do;
                    if tbl[i].key:match('^%s-submenu_close')then;
                        x3 = x3+1;
                    elseif tbl[i].key:match('^%s-submenu_open')then;
                        if x3 == 0 then;
                            xStart = i;
                            break;
                        end;
                        x3 = x3-1;
                    end;
                end;
                ----
            else;
                gfx.quit()no_undo()return;
            end;
            ----
            ----
            if tonumber(xStart) and tonumber(xEnd)then;
                ----
                for i = 1,#tbl do;
                    if i < xStart or i > xEnd then;
                        t[#t+1]=tbl[i];
                    end;
                end;
                ----
                local x2 = 0;
                for i = 1,#t do;
                    if t[i].key:match('^%s-action_')or
                       t[i].key:match('^%s-submenu_')or
                       t[i].key:match('^%s-separator')then;
                        x2 = x2 + 1;
                        t[i].key = x2..'_'..(t[i].key):gsub('^%s*','');
                    end;
                end;
                --[[--
                Arc.iniFileRemoveSectionLua(section,ArcFileIni);
                for i=1,#t do;
                    Arc.iniFileWriteLua(section,t[i].key,t[i].val,ArcFileIni);
                end;
                --]]--
                iniFileWriteSectionLua(section,t,ArcFileIni,false,true);
            end;
            ----
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+6 then;--Remove Separator--=======================================================================
            --===================================================================================================================
            ----
            ----
            ----
            LIST = LIST2;
            if LIST:match('^%s-|%s->')then LIST = '|'..LIST end;
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            if LIST:match('^%s-|%s-#')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>','|#------|>');
            LIST = LIST:gsub('%#Empty%|','||||');
            LIST = LIST:gsub('|%s-|%s-[#]+','||');
            LIST = LIST:gsub('^[%s|]+','|');
            LIST = LIST:gsub('>%s-#',function(v)return v:gsub('#','♯')end);
            ----
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            ADD_showmenu = gfx.showmenu('#Remove Separator||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            ----
            local X = 0;
            local x2;
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_')or
                   tbl[i].key:match('^%s-submenu_open')then;
                   X = X+1;
                   if X == ADD_showmenu then;
                        x2 = i;
                        break;
                    end;
                end;
            end;
            ----
            ----
            ----
            if tonumber(x2)then;
                if tbl[x2-1].key:match('^%s-separator')then;
                    ----
                    local xx=0;
                    for i = x2-1,1,-1 do;
                        if tbl[i].key:match('^%s-separator')then;
                            xx=xx+1;
                        else;
                            break;
                        end;
                    end;
                  
                    local MB;
                    if xx > 1 then;
                        local str = 'Yes |- Delete all ('..xx..') separator !?\n'..
                                    'No |- Delete only one separator !?'
                        MB = reaper.MB(str,'Remove Separator',3);
                    end;
                  
                    MB = tonumber(MB)or 7;
                    if MB == 6 then;--Yes
                        ----
                        for i = x2-1,1,-1 do;
                            if tbl[i].key:match('^%s-separator')then;
                                table.remove(tbl,i);
                            else;
                                break;
                            end;
                        end;
                        ----
                    elseif MB == 7 then;--No
                        FFF = x2-1
                        table.remove(tbl,x2-1);
                    elseif MB == 2 then;--cancel
                       gfx.quit()no_undo() return;
                    end;
                    ----
                    ----
                    ----
                    local x2 = 0;
                    for i = 1,#tbl do;
                        if tbl[i].key:match('^%s-action_')or
                           tbl[i].key:match('^%s-submenu_')or
                           tbl[i].key:match('^%s-separator')then;
                            x2 = x2 + 1;
                            tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                        end;
                    end;
                    ----
                    --[[--
                    Arc.iniFileRemoveSectionLua(section,ArcFileIni);
                    ----
                    for i=1,#tbl do;
                        Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
                    end;
                    --]]--
                    iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
                    -----
                end;
            end;
            ----
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+7 then;--Remove all list--========================================================================
            --===================================================================================================================
            ----
            ----
            ----
            local MB = reaper.MB('Eng:\nExactly Clear entire list ???\nRus:\nТочно Очистить весь список ???','Remove all list',1);
            if MB == 1 then;--Да
                local MB = reaper.MB('Eng:\nHave you thought about Clearing it for Sure ???\nRus:\nВы хорошо подумали - Точно Очистить ???','Remove all list',1);
                if MB == 1 then;--Да
                    Arc.iniFileRemoveSectionLua(section,ArcFileIni);
                    ----
                    local MB = reaper.MB('Eng:\nRemove this Script ?\nRus:\nУдалить этот скрипт ?','Remove Script',1);
                    if MB == 1 then;--Да
                        local scriptFile = debug.getinfo(1,'S').source:gsub("^@",''):gsub("\\",'/');
                        reaper.AddRemoveReaScript(false,secID,scriptFile,true);
                        os.remove(scriptFile);
                        gfx.quit();no_undo();return;
                    else;--Нет
                        gfx.quit()no_undo()return;
                    end;
                    ----
                else;--Нет
                    gfx.quit()no_undo()return;
                end;
            else;--Нет
                gfx.quit()no_undo()return;
            end;
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+8 then;--Rename--=================================================================================
            --===================================================================================================================
            ----
            ----
            ----
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>.-[^|]+','%0| <<< Rename submenu >>> ');
            LIST = LIST:gsub('%#Empty%|','|');
            LIST = LIST:gsub('#','♯');
            ----
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Rename||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            ----
            ----
            local X = 0;
            local x2 = 0;
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_') or
                   tbl[i].key:match('^%s-submenu_open')then;
                    X = X+1;
                    if X == ADD_showmenu then;
                        ----
                        if tbl[i].key:match('^%s-submenu_open')then;
                            ----
                            if tbl[i].val:match('^.')=='#'then lbl = tbl[i].val:match('^[#]+')else lbl = '' end;
                            nm_2 = tbl[i].val:gsub('^[#]+','');
                            ----
                            ::restart_AddSubmenuRename::;
                            local retval,retvals_csv = reaper.GetUserInputs
                                                       ('Rename Submenu',1,'New Name Submenu:,extrawidth=500',nm_2 or'');
                            if not retval then gfx.quit()no_undo() return end;
                            local name = retvals_csv:gsub('|','\\');
                            if name:match('^[!#><]+')then name = ' '..name end;
                            if name:match('[!#><]+$')then name = name..' ' end;
                            if(not name)or(#name:gsub('%s','')<1)then goto restart_AddSubmenuRename end;
                            ---
                            tbl[i].val = lbl..name;
                            -------------
                            local en1 = 0;
                            for i2 = i+1,#tbl do;
                                if tbl[i2].key:match('^%s-submenu_close') and en1 == 0 then;
                                    tbl[i2].val = name;
                                    break;
                                end;
                                if tbl[i2].key:match('^%s-submenu_open')then;
                                    en1 = en1 + 1;
                                end;
                                if tbl[i2].key:match('^%s-submenu_close')then;
                                    en1 = en1 - 1;
                                end;
                            end;
                            -------------
                            ----
                        elseif tbl[i].key:match('^%s-action_')then;
                            ----
                            if tbl[i].val:match('^.')=='#'then lbl = tbl[i].val:match('^[#]+')else lbl = '' end;
                            ----
                            ::restart_AddActionRename::;
                            id_2 = tbl[i].key:gsub('^.-action_','');
                            nm_2 = tbl[i].val:gsub('^[#]+','');
                            
                            local retval,retvals_csv = reaper.GetUserInputs
                                                        ('Add action',2,
                                                         'New ID Action:,New Name Action:,extrawidth=500,separator==',
                                                         (id_2 or '')..'='..(nm_2 or ''));
                            if not retval then gfx.quit()no_undo() return end;
                            id,act = retvals_csv:match('(.-)=(.*)');
                            id = id:gsub('[%s]','');
                            act = act:gsub('|','\\');
                            if act:match('^[!#><]+')then act = ' '..act end;
                            if act:match('[!#><]+$')then act = act..' ' end;
                            if(not id)or(#id==0)or(not act)or(#act:gsub('%s','')<1)then goto restart_AddActionRename end;
                            ---- 
                            id = 'action_'..id;
                            ----
                            tbl[i].key = id;
                            tbl[i].val = lbl..act;
                            ----
                        end;
                        ----
                    end;
                end;
                ----
                if tbl[i].key:match('^%s-action_')or
                   tbl[i].key:match('^%s-submenu_')or
                   tbl[i].key:match('^%s-separator')then;
                    x2 = x2 + 1;
                    tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                end;
                ----
            end;
            --[[--
            Arc.iniFileRemoveSectionLua(section,ArcFileIni);
            ----
            for i=1,#tbl do;
                Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
            end;
            --]]--
            iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+9 then;--BLOCK / Label--==========================================================================
            --===================================================================================================================
            ----
            ----
            ----
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>.-[^|]+','%0| <<< Block / label submenu >>> ');
            LIST = LIST:gsub('%#Empty%|','|');
            LIST = LIST:gsub('#','♯');
            ----
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Block / Label||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            ----
            ----
            local X = 0;
            local x2 = 0;
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_') or
                   tbl[i].key:match('^%s-submenu_open')then;
                    X = X+1;
                    if X == ADD_showmenu then;
                        ----
                        local lbl = tbl[i].val:match('^.');
                        if lbl == '#' then;
                            tbl[i].val = tbl[i].val:gsub('^[#]+','');
                            if tbl[i].val == '' then tbl[i].val = ' ' end;
                        else;
                            tbl[i].val = '#'..tbl[i].val;
                            if tbl[i].val == '#' then tbl[i].val = '# ' end;
                        end;
                        ----
                    end;
                end;
                ----
                if tbl[i].key:match('^%s-action_')or
                   tbl[i].key:match('^%s-submenu_')or
                   tbl[i].key:match('^%s-separator')then;
                    x2 = x2 + 1;
                    tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                end;
                ----
            end;
            --[[--
            Arc.iniFileRemoveSectionLua(section,ArcFileIni);
            ----
            for i=1,#tbl do;
                Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
            end;
            --]]--
            iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+10 then;--Move action--===========================================================================
            --===================================================================================================================
            ----
            ----
            ----
            local LIST_SV = LIST;
            LIST = LIST:gsub('%#Empty%|','||||');
            LIST = LIST:gsub('#','♯');
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Move Action (What to move)||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            local X = 0;
            local x2 = 0;
            local key;
            local val;
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_')then;
                    X = X+1;
                    if X == ADD_showmenu then;
                        tbl[i].move=true;
                        key = tbl[i].key;
                        val = tbl[i].val;
                        break;
                    end;
                end;
            end;
            ----
            ----
            ----
            LIST = LIST_SV;
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>.-[^|]+','|+%0');
            LIST = LIST:gsub('<|','+|%0');
            LIST = LIST:gsub('%#Empty%|','|')..'+';
            LIST = LIST:gsub('||','|'):gsub('||','|');
            LIST = LIST:gsub('#','♯');
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Move Action (Where to move)||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            local X = 0;
            local x2 = 0;
            ----
            tbl[#tbl+1]={};
            tbl[#tbl].key = 'action_LAST';
            tbl[#tbl].val = 'action_LAST';
            ----
            for i=1,math.huge do;
                if tbl[i]then;
                    if tbl[i].key:match('^%s-action_') or
                       tbl[i].key:match('^%s-submenu_')then;
                        X = X+1;
                        if X == ADD_showmenu then;
                            ----
                            local T = {key=key,val=val};
                            table.insert(tbl,i,T);
                            ---- 
                            break;
                        end;
                    end;
                else;
                    break;
                end;
            end;
            ----
            table.remove(tbl,#tbl);
            ----
            for i=1,#tbl do;
                if CountTable(tbl[i]) == 3 then;
                    if tbl[i].move then;
                        table.remove(tbl,i);
                        break;
                    end;
                end;
            end;
            ----
            local x2 = 0;
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_')or
                   tbl[i].key:match('^%s-submenu_')or
                   tbl[i].key:match('^%s-separator')then;
                    x2 = x2 + 1;
                    tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                end;
            end;
            ----
            ----
            --[[
            Arc.iniFileRemoveSectionLua(section,ArcFileIni);
            for i=1,#tbl do;
                Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
            end;
            --]]
            ----
            iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
            ----
            ----
            gfx.quit();
            no_undo();
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+11 then;--Move Sub --=============================================================================
            --===================================================================================================================
            ----
            ----
            ----
            local LIST_SV = LIST;
            LIST = LIST2;
            if LIST:match('^%s->')then LIST = '|'..LIST end;
            LIST = LIST:gsub('|>.-[^|]+','%0| <<< Move Submenu >>> ');
            LIST = LIST:gsub('%#Empty%|','|');
            LIST = LIST:gsub('>%s-#',function(v)return v:gsub('#','♯')end);
            ----
            ----
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            ----
            local ADD_showmenu = gfx.showmenu('#Move Submenu (What to move)||'..LIST:gsub('^%s-|',''));
            ADD_showmenu = ADD_showmenu-1;
            if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
            ----
            ----
            local X=0;
            local x2;
            ----
            for i=1,#tbl do;
                if tbl[i].key:match('^%s-action_') or
                   tbl[i].key:match('^%s-submenu_open')then;
                    X = X+1;
                    if X == ADD_showmenu then;
                        x2 = i;
                        break;
                    end;
                end;
            end;
            ----
            local xStart;
            local xEnd;
            local x3=0;
            ----
            if x2 and tbl[x2].key:match('^%s-submenu_open')then;
                ----
                xStart = x2;
                for i=x2+1,#tbl do;
                    if tbl[i].key:match('^%s-submenu_open')then;
                        x3 = x3+1;
                    elseif tbl[i].key:match('^%s-submenu_close')then;
                        if x3 == 0 then;
                            xEnd = i;
                            break;
                        end;
                        x3 = x3-1;
                    end;
                end;
                ----
                ----
                if tonumber(xStart) and tonumber(xEnd)then;
                    ----
                    local t={};
                    for i = xStart,xEnd do;
                        t[#t+1]=deepcopy(tbl[i]);
                        tbl[i].move = true;
                    end;
                    ----
                    if t[1].key:match('submenu_open')and
                       t[#t].key:match('submenu_close')then;
                        ----
                        ---------------
                        ----
                        LIST = LIST_SV;
                        if LIST:match('^%s->')then LIST = '|'..LIST end;
                        LIST = LIST:gsub('|>.-[^|]+','|+%0');
                        LIST = LIST:gsub('<|','+|%0');
                        LIST = LIST:gsub('%#Empty%|','|')..'+';
                        LIST = LIST:gsub('||','|'):gsub('||','|');
                        LIST = LIST:gsub('#','♯');
                        ----
                        ----
                        local x,y = reaper.GetMousePosition();
                        local x,y = gfx.screentoclient(x,y);
                        gfx.x,gfx.y = x-50,y-20;
                        ----
                        local ADD_showmenu = gfx.showmenu('#Move Submenu (Where to move)||'..LIST:gsub('^%s-|',''));
                        ADD_showmenu = ADD_showmenu-1;
                        if ADD_showmenu <= 0 then gfx.quit()no_undo() return end;
                        ----
                        ----
                        local X = 0;
                        local x2 = 0;
                        ---
                        tbl[#tbl+1]={};
                        tbl[#tbl].key = 'action_LAST';
                        tbl[#tbl].val = 'action_LAST';
                        ----
                        ----
                        for i=1,math.huge do;
                            if tbl[i]then;
                                if tbl[i].key:match('^%s-action_') or
                                   tbl[i].key:match('^%s-submenu_')then;
                                    X = X+1;
                                    if X == ADD_showmenu then;
                                        ----
                                        if i < xStart or i > xEnd then;
                                            for ii = #t,1,-1 do;
                                                table.insert(tbl,i,t[ii]);
                                            end;
                                        else;
                                            gfx.quit()no_undo()return;
                                        end;
                                        ----
                                        break;
                                    end;
                                end;
                            else;
                                gfx.quit()no_undo()return;
                            end;
                        end;
                        ----
                        ----
                        for i=#tbl,1,-1 do;
                            if CountTable(tbl[i]) == 3 then;
                                if tbl[i].move then;
                                    table.remove(tbl,i);
                                end;
                            end;
                        end;
                        ----
                        ----
                        table.remove(tbl,#tbl);
                        ----
                        ----
                        local x2 = 0;
                        for i=1,#tbl do;
                            if tbl[i].key:match('^%s-action_')or
                               tbl[i].key:match('^%s-submenu_')or
                               tbl[i].key:match('^%s-separator')then;
                                x2 = x2 + 1;
                                tbl[i].key = x2..'_'..(tbl[i].key):gsub('^%s*','');
                            end;
                        end;
                        ----
                        --[[
                        Arc.iniFileRemoveSectionLua(section,ArcFileIni);
                        for i=1,#tbl do;
                            Arc.iniFileWriteLua(section,tbl[i].key,tbl[i].val,ArcFileIni);
                        end;
                        --]]
                        ----
                        iniFileWriteSectionLua(section,tbl,ArcFileIni,false,true);
                        ----
                        gfx.quit();
                        no_undo();
                        ----
                    else;
                        gfx.quit()no_undo()return;
                    end;
                else;
                    gfx.quit()no_undo()return;
                end;
                ----
            else;
                gfx.quit()no_undo()return;
            end;
            ----
            gfx.quit();
            no_undo();
            return;
            ----
            ----
            ----
            --===================================================================================================================
        elseif showmenu == #t1+12 then;--  --====================================================================================
            --===================================================================================================================
            ----
            ----
            ----
            local MB = reaper.MB('Eng:\n'..
                          'Hide the add Menu ?  - Ok\n'..
                          'You can restore the menu using a script\n'..
                          'Archie_Var; Hide Show add menu (popup menu).lua\n\n'..
                          'Rus:\n'..
                          'Скрыть Меню добавления ? - Ok\n'..
                          'Восстановить меню можно будет с помощью скрипта\n'..
                          'Archie_Var; Hide Show add menu (popup menu).lua'
                          ,'Help',1);
            if MB == 1 then;
                ----reaper.SetExtState(H.sect,'State',1,true);
                Arc.iniFileWriteLua(H.sect,'State',1,ArcFileIni);
            end;
            gfx.quit();
            no_undo();
            return;
            ----
            ----
            ----
            --===================================================================================================================
        end;
        ----
        ----
        ----
        gfx.quit();
        -------------------------------------------------------------------------------
        reaper.defer(function();
        local ScrPath,ScrName = debug.getinfo(1,'S').source:match('^[@](.+)[/\\](.+)');
        Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,516,ScrPath,ScrName)end);
        -------------------------------------------------------------------------------
    end;
    local function x1()end;
    --[[main(run)]];
    --=======================================================================================================================
    --=======================================================================================================================
    --=======================================================================================================================
    --=======================================================================================================================
    --=======================================================================================================================
    --=======================================================================================================================
    --=======================================================================================================================
    --=======================================================================================================================
    --=======================================================================================================================
    
    
    
    local scriptFile = debug.getinfo(1,'S').source:gsub("^@",''):gsub("\\",'/');
    local file = io.open(scriptFile,'r');
    local str;
    if file then;
        str = file:read('*a');
        file:close();
    end;
    ----
    if str then;
        -----
        str = str:match('^.-%-%-%[%[%s-main%s-%(%s-run%s-%).-%]%]')
        str = str:gsub('%-%-%[%[%s-main%s-%(%s-run%s-%).-%]%]','main(run);');
        -----
        local path = scriptFile:match('(.+)[/\\]');
        -----
        ::resSec::;
        local retval,Section_csv = reaper.GetUserInputs('Inter Section 0 = main / 1 = midi',1,'Inter Section 0 = main / 1 = midi',0);
        if not retval then no_undo()return end;
        Section_csv = tonumber(Section_csv);
        if Section_csv ~= 0 and Section_csv ~= 1 then goto resSec end;
        if Section_csv == 1 then Section_csv = 32060 end;
        -----
        ::res::;
        local retval,retvals_csv = reaper.GetUserInputs('Generate name of script',1,'Enter Tag (of least 1 symbols),extrawidth=400','');
        if not retval then no_undo()return end;
        if #retvals_csv:gsub('[%s%p]','')<1 then goto res end;
        retvals_csv = retvals_csv:gsub('%p','');
        -----
        local newScript,newFile;
        if Section_csv == 0 then;
            newScript = 'Archie_Var; Popup menu('..retvals_csv..').lua';
            local newPath = path..'/Popup menu/Main';
            reaper.RecursiveCreateDirectory(newPath,0);
            newFile = newPath..'/'..newScript;
            str = '--'..newScript..'\n'..str;
        else;
            newScript = 'Archie_MidiEditor; Popup menu('..retvals_csv..').lua';
            local newPath = path..'/Popup menu/MidiEditor';
            reaper.RecursiveCreateDirectory(newPath,0);
            newFile = newPath..'/'..newScript;
            str = '--'..newScript..'\n'..str;
        end;
        -----
        local file = io.open(newFile,'w');
        local wr = file:write(str);
        file:close();
        -----
        if type(wr)=='userdata'then;
            reaper.AddRemoveReaScript(true,Section_csv,newFile,true);
            local SecAct;
            if Section_csv == 0 then SecAct = 'Main:' else SecAct = 'MIDI Editor:' end;
            local
            msg = SecAct..'\nСкрипт:\n'..newScript..'\nСоздан успешно.\n\n'..
                  SecAct..'\nScript:\n'..newScript..'\nwas Created successfully.';
            reaper.ClearConsole();
            reaper.ShowConsoleMsg(msg);
            -----------
            if reaper.APIExists('JS_Window_Find')then;
                local winHWND = reaper.JS_Window_Find("ReaScript console output",true);
                if winHWND then;
                   reaper.JS_Window_SetPosition(winHWND,50,50,500,250);
                   reaper.JS_Window_SetForeground(winHWND);
                end;
            end;
            -----------
        end;
    end;
    no_undo();
    
    
    
    