--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var;  Popup menu single-level(n).lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Всплывающее меню одноуровневое
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2883552/9cbd63df-b720-4a4c-a725-ddfde7cbc2d0/orig
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
   *              v.1.0 [150320]
   *                  + initialе
--]]
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
    local sep; if #idT > 0 then sep = '|'else  sep = '' end;
    local showMenu = gfx.showmenu("> > > >|Add||Remove|Remove All||Rename|<|"..sep..table.concat(nameT,'|'));
    
    if showMenu == 0 then;
        --======================
        gfx.quit();
        no_undo();
        --======================
    elseif showMenu == 1 then;--Add
        --======================
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
        
        act = (retvals_csv:match('^.*=(.-)$')):gsub('[!<>]+$',''):gsub('^[!<>]+','')--:gsub('|','');
        if act:gsub('%s','')=='' or idCheck == 0 then goto restart end;
        
        local LIST = ExtState..'{&&'..id..'='..act..'&&}'; 
        reaper.SetExtState(section,'LIST',LIST,true);
        gfx.quit();
        no_undo();
       --======================
    elseif showMenu == 2 then;--Remove
        --======================
        local x,y = reaper.GetMousePosition();
        local x,y = gfx.screentoclient(x,y);
        gfx.x,gfx.y = x-150,y-20;
        local showMenu = gfx.showmenu(table.concat(nameTRem,'|'));
        if showMenu > 0 then;
            local MB = reaper.MB('Remove Action from List ?','Remove',1);
            if MB == 2 then no_undo() return end;
            local x = 0;
            local strT = {};
            for val in string.gmatch(ExtState,"{&&.-&&}") do;
                x=x+1;
                if x == showMenu then val = '' end;
                strT[#strT+1] = val;
            end;
            reaper.SetExtState(section,'LIST',table.concat(strT),true);
        end;
        gfx.quit();
        no_undo();
        --======================
    elseif showMenu == 3 then;--Remove All
        --======================
        local MB = reaper.MB('Remove All List ?','Remove',1);
        if MB == 2 then no_undo() return end;
        reaper.DeleteExtState(section,'LIST',true);
        gfx.quit();
        no_undo();
        --======================
    elseif showMenu == 4 then;--Rename
        --======================
        local x,y = reaper.GetMousePosition();
        local x,y = gfx.screentoclient(x,y);
        gfx.x,gfx.y = x-150,y-20;
        local showMenu = gfx.showmenu(table.concat(nameTRem,'|'));
        if showMenu > 0 then;
            local x = 0;
            local strT = {};
            for val in string.gmatch(ExtState,"{&&.-&&}") do;
                x=x+1;
                if x == showMenu then;
                    ----
                    local act,idCheck,id;
                    ::restartRename::;
                    
                    if not id  then id  = val:match('^[{&&]*(.-)=')end;
                    if not act then act = val:match('^.*=(.-)[&&}]*$')end;
                    
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
                    
                    act = (retvals_csv:match('^.*=(.-)$')):gsub('[!<>]+$',''):gsub('^[!<>]+','')--:gsub('|','');
                    if act:gsub('%s','')=='' or idCheck == 0 then goto restartRename end;
                    
                    val = '{&&'..id..'='..act..'&&}'; 
                    ----
                end; 
                strT[#strT+1] = val;
            end;
            reaper.SetExtState(section,'LIST',table.concat(strT),true);
        end;
        gfx.quit();
        no_undo();
        --======================
    elseif showMenu >= 5 then;--Action
        --======================
        reaper.defer(function();
                         gfx.quit();
                         local id = idT[showMenu-4];
                         
                         if tonumber(id) then;
                             reaper.Main_OnCommand(id,0);
                         else;
                             reaper.Main_OnCommand(reaper.NamedCommandLookup(id),0);
                         end;
                     end);
        --======================
    end;
    
    
    
    
    
    
    
    
    
    
    