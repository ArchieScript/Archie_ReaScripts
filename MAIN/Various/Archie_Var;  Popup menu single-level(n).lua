--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var;  Popup menu single-level(n).lua
   * Author:      Archie
   * Version:     1.04
   * Описание:    Всплывающее меню одноуровневое
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2884487/d239f177-9ceb-4af6-bcc1-e87dbd047400/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Maestro Sound(Rmm)
   * Gave idea:   Maestro Sound(Rmm)
   * Provides:    
   *              [nomain] .
   *              [main] . > Archie_Var;  Popup menu single-level(1).lua
   *              [main] . > Archie_Var;  Popup menu single-level(2).lua
   *              [main] . > Archie_Var;  Popup menu single-level(3).lua
   *              [main] . > Archie_Var;  Popup menu single-level(4).lua
   *              [main] . > Archie_Var;  Popup menu single-level(5).lua
   *              [main] . > Archie_Var;  Popup menu single-level(6).lua
   *              [main] . > Archie_Var;  Popup menu single-level(7).lua
   *              [main] . > Archie_Var;  Popup menu single-level(8).lua
   *              [main] . > Archie_Var;  Popup menu single-level(9).lua
   *              [main] . > Archie_Var;  Popup menu single-level(10).lua
   *              [main] . > Archie_Var;  Popup menu single-level(11).lua
   *              [main] . > Archie_Var;  Popup menu single-level(12).lua
   *              [main] . > Archie_Var;  Popup menu single-level(13).lua
   *              [main] . > Archie_Var;  Popup menu single-level(14).lua
   *              [main] . > Archie_Var;  Popup menu single-level(15).lua
   *              [main] . > Archie_Var;  Popup menu single-level(16).lua
   *              [main] . > Archie_Var;  Popup menu single-level(17).lua
   *              [main] . > Archie_Var;  Popup menu single-level(18).lua
   *              [main] . > Archie_Var;  Popup menu single-level(19).lua
   *              [main] . > Archie_Var;  Popup menu single-level(20).lua
   *              [main] . > Archie_Var;  Popup menu single-level(21).lua
   *              [main] . > Archie_Var;  Popup menu single-level(22).lua
   *              [main] . > Archie_Var;  Popup menu single-level(23).lua
   *              [main] . > Archie_Var;  Popup menu single-level(24).lua
   *              [main] . > Archie_Var;  Popup menu single-level(25).lua
   *              [main] . > Archie_Var;  Popup menu single-level(26).lua
   *              [main] . > Archie_Var;  Popup menu single-level(27).lua
   *              [main] . > Archie_Var;  Popup menu single-level(28).lua
   *              [main] . > Archie_Var;  Popup menu single-level(29).lua
   *              [main] . > Archie_Var;  Popup menu single-level(30).lua
   * Extension:   
   *              Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   
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
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    ---------------------------------------------------
    local scriptPath = ({reaper.get_action_context()})[2];
    local section = scriptPath:match('^.*[/\\](.+)$');
    ---------------------------------------------------
    
    
    ---------------------------------------------------
    if not tonumber(HIDE_ADD) or (HIDE_ADD ~= 0 and HIDE_ADD ~= 1) then;-- v.1.04
        local sect = 'Popup menu single-level_HIDE ADD MENU_STATE';
        HIDE_ADD = tonumber(reaper.GetExtState(sect,'State'))or 0;-- v.1.04
    end;-- v.1.04
    ---------------------------------------------------
    
    
    ---------------------------------------------------
    local x,y = reaper.GetMousePosition();
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
    local ExtState = reaper.GetExtState(section,'LIST');
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
    local AddListCount;
    local AddList = "> > > >|Add||"..LCK.."Remove|"..LCK2.."Remove All||"..LCK.."Rename||"..LCK2.."Move||> script|#"..section.."|<|<|";
    if #idT > 0 and HIDE_ADD == 1 then AddList = '' end;-- v.1.04
    if ADD_UP_DOWN == 0 then;--Up
        local sep; if #idT > 0 and AddList ~= '' then sep = '|'else  sep = '' end;
        showMenu = gfx.showmenu(AddList..sep..table.concat(nameT,'|'));
        numbUpDown = 0;
        AddListCount = 6;
    elseif ADD_UP_DOWN == 1 then;--Down
        local sep; if #idT > 0 and AddList ~= '' then sep = '||'else  sep = '' end;
        showMenu = gfx.showmenu(table.concat(nameT,'|')..sep..AddList);
        numbUpDown = #idT;
        AddListCount = 0;
    end;
    ---------------------------------------------------
    
    
    
    
    if showMenu == 0 then;
        --======================
        gfx.quit();
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
                    local act,idCheck,id;
                    ::restart::;
                    if not idCheck or idCheck == 0 or not id then id = '' end;
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
                    if act:gsub('|','')==''or act:gsub('^[#|]+','')=='' or idCheck == 0 then goto restart end;
                    
                    val = '{&&'..id..'='..act..'&&}'..val;
                end;
                
                strT[#strT+1] = val;
            end;
            reaper.SetExtState(section,'LIST',table.concat(strT),true);
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
                reaper.SetExtState(section,'LIST',table.concat(strT),true);
            end;
        end;
        gfx.quit();
        no_undo();
        --======================
    elseif showMenu == numbUpDown+3 then;--Remove All
        --======================
        if #nameTRem > 0 then;
            local MB = reaper.MB('Remove All List ?','Remove',1);
            if MB == 2 then no_undo() return end;
            reaper.DeleteExtState(section,'LIST',true);
        end;
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
                reaper.SetExtState(section,'LIST',table.concat(strT),true);
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
                reaper.SetExtState(section,'LIST',table.concat(strT),true);
            end;
            gfx.quit();
            no_undo();
        end;
        --======================           -- / Down /                             -- / Up /
    elseif showMenu > 0 and (showMenu <= #idT and ADD_UP_DOWN == 1) or (showMenu > AddListCount and ADD_UP_DOWN == 0) then;--Action
        --======================
        local function Action();
            reaper.defer(function();
                         gfx.quit();
                         local id = idT[showMenu-AddListCount];
                         
                         if tonumber(id) then;
                             reaper.Main_OnCommand(id,0);
                         else;
                             reaper.Main_OnCommand(reaper.NamedCommandLookup(id),0);
                         end;
                     end);
        end; Action();
        --======================
    end;
    
    
    
    
    
    
    
    