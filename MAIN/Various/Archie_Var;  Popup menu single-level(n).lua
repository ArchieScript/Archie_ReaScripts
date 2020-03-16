--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var;  Popup menu single-level(n).lua
   * Author:      Archie
   * Version:     1.02
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
   * Extension:   
   *              Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   
   *              v.1.02 [160320]
   *                  + Redesigned 'Add Menu'
   
   *              v.1.0 [150320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local ADD_UP_DOWN = 1; -- 0/1
    
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
    local x,y = reaper.GetMousePosition();
    gfx.init('',0,0,0,x,y);
    gfx.x,gfx.y = gfx.screentoclient(x,y);
    
    if reaper.JS_Window_GetFocus then;
        local Win = reaper.JS_Window_GetFocus();
        if Win then;
            reaper.JS_Window_SetOpacity(Win,'ALPHA',0);
        end;
    end;
    ---------------------------------------------------
     
    
    
    ---------------------------------------------------
    local ExtState = reaper.GetExtState(section,'LIST');
    local nameT = {};
    local idT   = {};
    local nameTRem = {};
    for val in string.gmatch(ExtState, "{&&(.-)&&}") do;
        idT[#idT+1] = val:match('^(.+)=');
        nameT[#idT] = val:match('.*=(.+)$');
        local tog = reaper.GetToggleCommandStateEx(0,reaper.NamedCommandLookup(idT[#idT]));
        if tog == 1 then nameT[#idT] = '!'..nameT[#idT] end;
        nameTRem[#idT] = val:match('.*=(.+)$'):gsub('#','@');
    end;
    ---------------------------------------------------
    
    
    
    ---------------------------------------------------
    if ADD_UP_DOWN ~= 0 and ADD_UP_DOWN ~= 1 then ADD_UP_DOWN = 1 end;
    local showMenu,numbUpDown;
    local AddListCount;
    local AddList = "> > > >|Add||Remove|Remove All||Rename||Move|<|";
    if ADD_UP_DOWN == 0 then;--Up
        local sep; if #idT > 0 then sep = '|'else  sep = '' end;
        showMenu = gfx.showmenu(AddList..sep..table.concat(nameT,'|'));
        numbUpDown = 0;
        AddListCount = 5;
    elseif ADD_UP_DOWN == 1 then;--Down
        local sep; if #idT > 0 then sep = '||'else  sep = '' end;
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
                    
                    act = (retvals_csv:match('^.*=(.-)$')):gsub('[!<>]+$',''):gsub('^[!<>]+','');
                    if act:gsub('%s','')=='' or idCheck == 0 then goto restart end;
                    
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
                        
                        act = (retvals_csv:match('^.*=(.-)$')):gsub('[!<>]+$',''):gsub('^[!<>]+','');
                        if act:gsub('%s','')=='' or idCheck == 0 then goto restartRename end;
                        
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
    
    
    
    
    
    
    
    