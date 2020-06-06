--[[    NEW INSTANCE
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var;  Popup menu single-level(n).lua
   * Author:      Archie
   * Version:     1.17
   * Описание:    Всплывающее меню одноуровневое
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2884487/d239f177-9ceb-4af6-bcc1-e87dbd047400/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Maestro Sound(Rmm)
   * Gave idea:   Maestro Sound(Rmm)
   * Extension:   
   *              Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   
   *              v.1.17 [060620]
   *                  + Fixed a bug reopen, if ctrl let go before what completed action
   *                  + Saving the list when updating the script (just create a new script using 
   *                    "Archie_Var;  Popup menu single-level(n).lua" with the same name and select save list
   *                    Only relevant if the list was created in version 1.15+

   *              v.1.16 [040620]
   *                  + Fixed bug when opening plugin windows
   *              v.1.15 [020620]
   *                  + Open again
   *              v.1.14 [250420]
   *                  ! Fixed bug Ext State
   *              v.1.12 [190420]
   *                  + Storing the list directly in the script (relevant for newly created scripts)
   *              v.1.11 [130420]
   *                  + Add multiple actions at once
   *              v.1.10 [130420]
   *                  AutoFill the form when adding an action (before clicking add, select an action in the actions list)
   *              v.1.09 [120420]
   *                  + Automatically creating copies with the desired label in the script name
   *              v.1.08 [310320]
   *                  No change  
   *              v.1.05 [260320]
   *                  ! Fixed bug
   *              v.1.04 [260320]
   *                  + Add 'hide add menu': Archie_Var;  Hide Show add menu (popup menu single-level).lua
   *              v.1.03 [170320]
   *                  ! Fixed bug
   *                  + Protection from spec characters 
   *              v.1.02 [160320]
   *                  + Redesigned 'Add Menu'
   *              v.1.0 [150320]
   *                  + initialе
--]]
    Version = 1.17;
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local ADD_UP_DOWN = 1; -- 0/1  
                   -- = 0 | Меню добавления вверху
                   -- = 1 | Меню добавления внизу
                   ------------------------------
    
    
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
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    --======================================================|v.1.12
    --===(v.1.14 | Ext State | ====================================
    local function GetStrFile(scrFile);
        local scriptFile = scrFile or (debug.getinfo(1,'S').source:gsub("^@",''):gsub("\\",'/'));
        local file = io.open(scriptFile,'r');
        if not file then;
            io.open(scriptFile,'w'):close();
            file = io.open(scriptFile,'r');
        end;
        local str = file:read('a');
        file:close();
        return str,scriptFile;
    end;
    ---
    local function GetList(key,scrFile);
        key=tostring(key);
        if not key or key:gsub(' ','') == '' then return '' end;
        return(GetStrFile(scrFile):match('%-%-%[%=%[%s-'..key..'%s-%=%s-%{%s-%[%s-%[(.-)%]%s-%]%s-%}%s-%]%s-%=%s-%]')or''):gsub("\n",'');
    end;
    ---
    local function SetList(key,value,scrFile);
        key=tostring(key)value=tostring(value);local StrNew;
        if not key or key:gsub(' ','') == '' then return false end;
        if not value then return false end;
        local StrFile,scriptFile = GetStrFile(scrFile);
        local list = (StrFile:match('%-%-%[%=%[%s-'..key..'%s-%=%s-%{%s-%[%s-%[.-%]%s-%]%s-%}%s-%]%s-%=%s-%]'));
        if list then;
            if value:gsub(' ','') == '' then;
                StrNew = StrFile:gsub(list:gsub('%p','%%%0')..'%s*\n*','',1);
            else;
                StrNew = StrFile:gsub(list:gsub('%p','%%%0'),'--[=['..key..'={[['..value..']]}]=]',1);
            end;
        else;
            if value:gsub(' ','') ~= '' then;
                StrNew = '--[=['..key..'={[['..value..']]}]=]\n'..StrFile;
            end;
        end;
        if StrNew and StrFile ~= StrNew then;
            local file = io.open(scriptFile,'w');
            file:write(StrNew);
            file:close();
            return true;
        else;
            return false;
        end;
    end; 
    ---
    local function DelList(key,scrFile);
        key=tostring(key);local StrNew;
        if not key or key:gsub(' ','') == '' then return false end;
        local StrFile,scriptFile = GetStrFile(scrFile);
        local list = (StrFile:match('%-%-%[%=%[%s-'..key..'%s-%=%s-%{%s-%[%s-%[.-%]%s-%]%s-%}%s-%]%s-%=%s-%]%s*\n*'));
        if list then;
            StrNew = StrFile:gsub(list:gsub('%p','%%%0'),'',1);
        end;
        if StrNew and StrNew ~= StrFile then;
            local file = io.open(scriptFile,'w');
            file:write(StrNew);
            file:close();
            return true;
        else;
            return false;
        end;
    end;
    --=== | Ext State | v.1.14)====================================
    --=============================================================
    
    
    
    local function main();
        
        -- (v.1.10-------------------------------------
        local function GetSelActionsActList();
            --http://forum.cockos.com/showthread.php?p=2270516#post2270516
            local function GetSelectedActionsFromActionList()
                local hWnd_action = reaper.JS_Window_Find("Actions", true)
                if not hWnd_action then return end
                local hWnd_LV = reaper.JS_Window_FindChildByID(hWnd_action, 1323)
                if reaper.JS_ListView_GetItemText(hWnd_LV, 0, 3) == "" then
                    --reaper.MB("Please, enable 'Show action IDs' in Actions list", "Right-click Action List window", 0)
                    return
                end
                -- get selected count & selected indexes
                local sel_count, sel_indexes = reaper.JS_ListView_ListAllSelItems(hWnd_LV)
                if sel_count == 0 then
                    --reaper.MB("Please select one or more actions.", "No actions are selected", 0)
                    return
                end
                local selected_actions = {}
                local i = 0
                for index in string.gmatch(sel_indexes, '[^,]+') do
                    i = i + 1
                    local desc = reaper.JS_ListView_GetItemText(hWnd_LV, tonumber(index), 1)
                    local cmd = reaper.JS_ListView_GetItemText(hWnd_LV, tonumber(index), 3)
                    selected_actions[i] = {cmd = cmd, name = desc:gsub(".+: ", "", 1)}
                end
                return selected_actions
            end
            -----
            local cmd,name,selected_actions;
            if reaper.APIExists('JS_Window_Find')then;
                selected_actions = GetSelectedActionsFromActionList()or {};
                if selected_actions[1]then cmd  = selected_actions[1].cmd  end;
                if selected_actions[1]then name = selected_actions[1].name end;
            end;
            return cmd or '', name or '', selected_actions;
        end;
        -- v.1.10)-------------------------------------
        
        
        ---------------------------------------------------
        local scriptPath = ({reaper.get_action_context()})[2];
        local section = scriptPath:match('^.*[/\\](.+)$');
        ---------------------------------------------------
        
        
        ---------------------------------------------------
        local H = {};
        local hdblock = '#';
        if not tonumber(HIDE_ADD) or (HIDE_ADD ~= 0 and HIDE_ADD ~= 1) then;-- v.1.04
            H.sect = 'ARCHIE_POPUP MENU SINGLE-LEVEL__HIDE ADD MENU';
            HIDE_ADD = tonumber(reaper.GetExtState(H.sect,'State'))or 0;-- v.1.04
            hdblock = '';
        end;-- v.1.04
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
        gfx.init('',0,0,0,x,y);
        gfx.x,gfx.y = gfx.screentoclient(x,y);
        
        local API_JS = reaper.APIExists('JS_Window_GetFocus');
        if API_JS then;
            local Win = reaper.JS_Window_GetFocus();
            if Win then;
                reaper.JS_Window_SetOpacity(Win,'ALPHA',0);
            end;
        end;
        ---------------------------------------------------
        
        
        
        ---------------------------------------------------
        --local ExtState = reaper.GetExtState(section,'LIST');
        local ExtState = GetList('LIST');--v.1.12;
        local t        = {};
        local nameT    = {};
        local idT      = {};
        local nameTRem = {};
        local stop;
        for val in string.gmatch(ExtState, "{&&(.-)&&}") do;
            idT[#idT+1] = val:match('^(.+)=');
            nameT[#idT] = val:match('.*=(.+)$');
            local nmXS = nameT[#idT]:match('^[|#!<>]+')or'';
            nameT[#idT] = nameT[#idT]:gsub('^[|#!<>]+','');
            local nmXE = nameT[#idT]:match('.(|)%s-$')or'';
            nameT[#idT] = nameT[#idT]:gsub('|','');
            if nameT[#idT]:match('^[<>|#!]+')then nameT[#idT]=' '..nameT[#idT]end;
            if nameT[#idT]==''then stop=true end;
            if nmXS:match('#')then nameT[#idT] = '#'..(nameT[#idT]or '')end;
            if nmXS:match('|')then nameT[#idT] = '|'..(nameT[#idT]or '')end;
            nameT[#idT] = nameT[#idT]..nmXE;
            
            if stop then;
                nameT[#idT] = nil;
                idT[#idT] = nil;
            else;
                nameTRem[#idT] = nameT[#idT];
                if nmXS:match('#')then nameTRem[#idT] = nameT[#idT]:gsub('#','@',1)end;
                local nameT2 = nameT[#idT];
                local tog = reaper.GetToggleCommandStateEx(0,reaper.NamedCommandLookup(idT[#idT]));
                if tog == 1 then;
                    nameT[#idT] = nameT[#idT]:gsub('^[#|]*','%0!');
                end;
                
                t[#t+1]="{&&"..idT[#idT]..'='..nameT2.."&&}";
            end; 
            stop=nil;  
        end;
        ExtState = table.concat(t);
        t = nil;
        ---------------------------------------------------
        
        
        
        ---------------------------------------------------
        if ADD_UP_DOWN ~= 0 and ADD_UP_DOWN ~= 1 then ADD_UP_DOWN = 1 end;
        local LCK,LCK2;
        if #nameTRem==0 then LCK  = '#'else LCK  = ''end;
        if #nameTRem <2 then LCK2 = '#'else LCK2 = ''end;
        local showMenu,numbUpDown;
        ------
        Version = ' - v.'..(Version or '?.??');
        local AddList = "> > > >|Add||"..LCK.."Remove|".."Remove All / Script||"..LCK.."Rename||"..LCK2.."Move||>• script|"..hdblock.."Hide Add Menu||# Ctrl+click - OPEN AGAIN - (New instance)||#"..section..' '..Version.."|<|<|";--8
        local AddListCount = 8; -- AddList Count
        ------
        if #idT > 0 and HIDE_ADD == 1 then AddList = '' end;-- v.1.04
        if ADD_UP_DOWN == 0 then;--Up
            local sep; if #idT > 0 and AddList ~= '' then sep = '|'else  sep = '' end;
            showMenu = gfx.showmenu(AddList..sep..table.concat(nameT,'|'));
            if AddList == '' then;
                numbUpDown = #idT;
                AddListCount = 0;
            else;
                numbUpDown = 0;
                AddListCount = AddListCount;
            end;
        elseif ADD_UP_DOWN == 1 then;--Down
            local sep; if #idT > 0 and AddList ~= '' then sep = '||'else  sep = '' end;
            showMenu = gfx.showmenu(table.concat(nameT,'|')..sep..AddList);
            numbUpDown = #idT;
            AddListCount = 0;
        end;
        ---------------------------------------------------
        
        
        if OPEN_AGAIN == true then;
            if autocloseWNDS and autocloseWNDS ~= 0 then;
                reaper.SNM_SetIntConfigVar('autoclosetrackwnds',autocloseWNDS);
            end;
        end;
        
        
        if showMenu == 0 then;
            --======================
            gfx.quit();
            ----
            reaper.SetExtState(section,'TGL_DBL',os.clock(),false);
            if OPEN_AGAIN == true then;
                reaper.DeleteExtState(section,'Ext_x_y',false);
            end;
            ----
            no_undo();
            --======================
        elseif showMenu == numbUpDown+1 then;--Add
            --======================
            
            local x,y = reaper.GetMousePosition();
            local x,y = gfx.screentoclient(x,y);
            gfx.x,gfx.y = x-50,y-20;
            
            local showMenu;
            if #nameTRem > 0 then;
                showMenu = gfx.showmenu('#Add action. Over||'..table.concat(nameTRem,'|')..'|+');
            else;
                showMenu = 2;
            end;
            
            if showMenu > 0 then;
                local x = 1;
                local strT = {};
                for val in string.gmatch(ExtState..'{&&=x=&&}',"{&&.-&&}") do;
                    if val == '{&&=x=&&}' then val = '' end;
                    x=x+1;
                    if x == showMenu then;
                        ----
                        local act,idCheck,id,tblAct,tblAutoAct;
                        ---
                        id,act,tblAct  = GetSelActionsActList();--1.10
                        if type(tblAct)=='table' and #tblAct > 1 then;--1.11
                            local MB = reaper.MB(
                            'Eng:\nShow window for entering action - OK\n'..
                            'Add selected actions to List - Cancel\n\n'..
                            'Rus:\nПоказать окно для ввода действия - ОК\n'..
                            'Добавить выделенные действия в Список - Отмена'
                            ,'help Add action Popup Menu',1);--1.11
                            if MB == 2 then tblAutoAct = tblAct end;--1.11
                        end;
                        ---
                        if not tblAutoAct then;--1.11
                        --- ---- --- --- ---
                            ::restart::;
                            if idCheck == 0 or not id then id = '' end;
                            local retval,retvals_csv = reaper.GetUserInputs('Add action',2,'Add  ID  Action:,'..
                                                                                           'Add  Name  Action:,'..
                                                                                           'extrawidth=350,'..
                                                                                           'separator==',id..'='..(act or ''));
                            if not retval then no_undo() return end;
                            
                            id = retvals_csv:match('(.-)='):gsub('%s','');
                            if not tonumber(id)then;
                                idCheck = reaper.NamedCommandLookup(id);
                            else;
                                idCheck = tonumber(id);
                            end;
                            
                            act = (retvals_csv:match('^.*=(.-)$')):gsub('^[!<>]+','');
                            if act:gsub('|','')==''or act:gsub('^[#|]+','')=='' then act = nil end;
                            if not act or idCheck == 0 then goto restart end;
                            
                            val = '{&&'..id..'='..act..'&&}'..val;
                            ---- --- --- ---
                        else;--(1.11
                            local strAct;
                            for t = 1,#tblAutoAct do;
                                strAct = (strAct or '')..'{&&'..tblAutoAct[t].cmd..'='..tblAutoAct[t].name..'&&}'
                            end;
                            val = strAct..val;
                        end;--1.11)
                    end;
                    
                    strT[#strT+1] = val;
                end;
                --reaper.SetExtState(section,'LIST',table.concat(strT),true);
                SetList('LIST',table.concat(strT));-- v.1.12;
            end;
            gfx.quit();
            no_undo();
           --======================
        elseif showMenu == numbUpDown+2 then;--Remove
            --======================
            if #nameTRem > 0 then;
                local x,y = reaper.GetMousePosition();
                local x,y = gfx.screentoclient(x,y);
                gfx.x,gfx.y = x-50,y-20;
                local showMenu = gfx.showmenu('#Remove||'..table.concat(nameTRem,'|'));
                if showMenu > 0 then;
                    local MB = reaper.MB('Remove Action from List ?','Remove',1);
                    if MB == 2 then no_undo() return end;
                    local x = 1;
                    local strT = {};
                    for val in string.gmatch(ExtState,"{&&.-&&}") do;
                        x=x+1;
                        if x == showMenu then val = nil end;
                        strT[#strT+1] = val;
                    end;
                    --reaper.SetExtState(section,'LIST',table.concat(strT),true);
                    SetList('LIST',table.concat(strT));-- v.1.12;
                end;
            end;
            gfx.quit();
            no_undo();
            --======================
        elseif showMenu == numbUpDown+3 then;--Remove All
            --======================
            if #nameTRem > 0 then;
                local MB = reaper.MB('Remove All List ?','Remove',1);
                if MB == 2 then gfx.quit()no_undo()return end;
                --reaper.DeleteExtState(section,'LIST',true);
                DelList('LIST');-- v.1.12;
            end;
            ----
            local MB = reaper.MB('Remove Script ?','Remove Script',1);
            if MB == 2 then gfx.quit()no_undo()return end;
            local scriptFile = debug.getinfo(1,'S').source:gsub("^@",''):gsub("\\",'/');
            reaper.AddRemoveReaScript(false,0,scriptFile,true);
            os.remove(scriptFile);
            ----
            gfx.quit();
            no_undo();
            --======================
        elseif showMenu == numbUpDown+4 then;--Rename
            --======================
            if #nameTRem > 0 then;
                local x,y = reaper.GetMousePosition();
                local x,y = gfx.screentoclient(x,y);
                gfx.x,gfx.y = x-50,y-20;
                local showMenu = gfx.showmenu('#Rename||'..table.concat(nameTRem,'|'));
                if showMenu > 0 then;
                    local x = 1;
                    local strT = {};
                    for val in string.gmatch(ExtState,"{&&.-&&}") do;
                        x=x+1;
                        if x == showMenu then;
                            ----
                            local act,idCheck,id;
                            ::restartRename::;
                            
                            if not id  then id  = val:match('^[{&&]*(.-)=')end;
                            if not act then act = val:match('^.*=(.-)[&&}]*$')end;
                            
                            local retval,retvals_csv = reaper.GetUserInputs('Rename action',2,'Rename  ID  Action:,'..
                                                                                           'Rename  Name  Action:,'..
                                                                                           'extrawidth=350,'..
                                                                                           'separator==',id..'='..(act or ''));
                            if not retval then no_undo() return end;
                            
                            id = retvals_csv:match('(.-)='):gsub('%s','');
                            if not tonumber(id)then;
                                idCheck = reaper.NamedCommandLookup(id);
                            else;
                                idCheck = tonumber(id);
                            end;
                            
                            act = (retvals_csv:match('^.*=(.-)$')):gsub('^[!<>]+','');
                            if act:gsub('|','')==''or act:gsub('^[#|]+','')=='' or idCheck == 0 then goto restartRename end;
                            val = '{&&'..id..'='..act..'&&}';
                            ----
                        end; 
                        strT[#strT+1] = val;
                    end;
                    --reaper.SetExtState(section,'LIST',table.concat(strT),true);
                    SetList('LIST',table.concat(strT));-- v.1.12;
                end;
            end;
            gfx.quit();
            no_undo();
            --======================
        elseif showMenu == numbUpDown+5 then;--Move
            --======================
            if #nameTRem > 1 then;
                local x,y = reaper.GetMousePosition();
                local x,y = gfx.screentoclient(x,y);
                gfx.x,gfx.y = x-50,y-20;
                local showMenu = gfx.showmenu('#What to Move||'..table.concat(nameTRem,'|'));
                if showMenu > 0 then;
                    table.remove(nameTRem,showMenu-1); 
                    local x = 1;
                    local strT = {};
                    local moveX;
                    for val in string.gmatch(ExtState,"{&&.-&&}") do;
                        x=x+1;
                        if x == showMenu then moveX = val; val = nil end;
                        strT[#strT+1] = val;
                    end;
                    ---
                    local showMenu = gfx.showmenu('#Where to Move. Over||'..table.concat(nameTRem,'|')..'|+');
                    if showMenu == 0 then no_undo() return end;
                    
                    for i = 1,#strT +1 do;
                        if showMenu-1 == i then strT[i] = moveX..(strT[i]or'') end;
                    end;
                    --reaper.SetExtState(section,'LIST',table.concat(strT),true);
                    SetList('LIST',table.concat(strT));-- v.1.12;
                end;
                gfx.quit();
                no_undo();
            end;
            --======================
        elseif showMenu == numbUpDown+6 then;--Hide Add Menu
            --======================
            local MB = reaper.MB('Eng:\n'..
                           'Hide the add Menu ?  - Ok\n'..
                           'You can restore the menu using a script\n'..
                           'Archie_Var;  Hide Show add menu (popup menu single-level).lua\n\n'..
                           'Rus:\n'..
                           'Скрыть Меню добавления ? - Ok\n'..
                           'Восстановить меню можно будет с помощью скрипта\n'..
                           'Archie_Var;  Hide Show add menu (popup menu single-level).lua'
                           ,'Help',1);
            if MB == 1 then;
                reaper.SetExtState(H.sect,'State',1,true);
            end;
            gfx.quit();
            no_undo();
            --======================
        --elseif showMenu == numbUpDown+7 then;
            --====================== 
            
            --======================           -- / Down /                             -- / Up /
        elseif showMenu > 0 and (showMenu <= #idT and ADD_UP_DOWN == 1) or (showMenu > AddListCount and ADD_UP_DOWN == 0) then;--Action
            --======================
            local function Action();
                reaper.defer(function();
                             gfx.quit();
                             local id = idT[showMenu-AddListCount];
                             
                             ----
                             if CTRL == true then;
                                 if reaper.APIExists('JS_Mouse_GetState')then;
                                     local Mouse_GetState = reaper.JS_Mouse_GetState(127);
                                     if Mouse_GetState ~= 4 and Mouse_GetState ~= 5 then;
                                         OPEN_AGAIN = nil;
                                     end;
                                 end;
                             end;
                             ----
                             if tonumber(id) then;
                                 reaper.Main_OnCommand(id,0);
                             else;
                                 reaper.Main_OnCommand(reaper.NamedCommandLookup(id),0);
                             end;
                             ----
                             if OPEN_AGAIN == true then;
                                 reaper.SetExtState(section,'Ext_x_y',Ext_x ..' '.. Ext_y,false);
                                 reaper.defer(function();
                                   reaper.Main_OnCommand(reaper.NamedCommandLookup(({reaper.get_action_context()})[4]),0);
                                   --dofile(({reaper.get_action_context()})[2]);
                                 end);
                             end;
                             ----
                         end);
            end; Action();
            --======================
        end;
    end;
    --main();
    --======================================================================
    --======================================================================
    --======================================================================
    --======================================================================
    --======================================================================
    
    
    
    local scriptFile = debug.getinfo(1,'S').source:gsub("^@",''):gsub("\\",'/');
    local file = io.open(scriptFile,'r');
    local str;
    if file then;
        str = file:read('*a');
        file:close();
    end;
    ---- 
    if str then;
        local t = {};
        for S in string.gmatch(str,".-\n")do;
            if S:match('^%s-%-%-%s-main%s-%(%s-%)')then S=S:gsub('^[%-%s]+','')S='    '..S end;
            t[#t+1] = S;
            if S:match('^%s-main%s-%(%s-%)')then break end;
        end;
        str = table.concat(t);
        -----
        local path = scriptFile:match('(.+)[/\\]');
        ::res::
        local retval,retvals_csv = reaper.GetUserInputs('Generate name of script',1,'Enter Tag (of least 1 symbols),extrawidth=250','');
        if not retval then no_undo()return end;
        if #retvals_csv:gsub('[%s%p]','')<1 then goto res end;
        retvals_csv = retvals_csv:gsub('%p','');
        local newScript = 'Archie_Var;  Popup menu single-level('..retvals_csv..').lua'
        local newFile = path..'/'..newScript;
        str = '--'..newScript..'\n'..str;
        ------
        local LIST,MB_W;
        local file = io.open(newFile,'r');
        if file then;
            file:close();
            LIST = GetList('LIST',newFile);
            if LIST ~= "" then;
                local strMb =
                "Rus:\nОбновить скрипт сохраняя список - Да\nОбновить скрипт Не сохраняя список - Нет\n\n"..
                "Eng:\nUpdate script by saving the list - Yes\nUpdate script Without saving the list - No\n";
                MB_W = reaper.MB(strMb,'Update popup list - '..retvals_csv,3);
                if MB_W == 2 then;no_undo()return;end;
            end;
        end;
        -----
        local file = io.open(newFile,'w');
        local wr = file:write(str);
        file:close();
        if MB_W == 6 then;
            SetList('LIST',LIST,newFile);
        end;
        if type(wr)=='userdata'then;
            reaper.AddRemoveReaScript(true,0,newFile,true);
            local
            msg = 'Скрипт\n'..newScript..'\nСоздан успешно.\n\n'..
                  'Script\n'..newScript..'\nwas Created successfully.';
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
    
    
    