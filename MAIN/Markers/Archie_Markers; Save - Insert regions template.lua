--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Markers
   * Description: Markers; Save - Insert regions template.lua
   * Author:      Archie
   * Version:     1.0
   * О скрипте:   Сохранить - Вставить шаблон регионов
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Provides:
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.8.5+ (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [160620]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local DELETE_PREV_REG = -1;
                       -- = -1; Показать запрос об удалении регионов;
                       -- =  0; Не удалять уже существующие регионы;
                       -- =  1; Всегда удалять уже существующие регионы;
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then A.no_undo()return;end;return A;
    end;local Arc=MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
    
    local section = 'ARCHIE_SAVE_REGION_TEMPLATE';
    local list = Arc.iniFileReadSectionLua(section,ArcFileIni);
    
    
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
    
    
    ----------
    local str;
    if #list > 0 then;
        for i = 1,#list do;
            str = (str or '')..list[i].key..'|';
        end;
        str = '|'..str;
    else;
        str = '';
    end;
    
    str = '#Set region template|'..str..'|> Add / Remove|Add||#remove|'..str;
    ----------
    
    
    
    ----------
    local showMenu = gfx.showmenu(str);
    
    if showMenu > 1 and showMenu <= #list+1 then;
        --AA1 = (showMenu-1);
        ------
        ----
        showMenu = (showMenu-1);
        ----
        local num_MarkReg,num_markers,num_regions = reaper.CountProjectMarkers(0);
        if num_regions > 0 then;
            local MB;
            if DELETE_PREV_REG ~= 0 and DELETE_PREV_REG ~= 1 then; 
                MB = reaper.MB('Rus:\nУдалить уже существующие регионы\n\nEng:\nDelete the existing regions','Remove',3);
            end;
            if DELETE_PREV_REG == 1 then MB = 6 end;
            if MB == 6 then;--yes
                for i = num_regions,1,-1 do;
                    reaper.DeleteProjectMarker(0,i,true);
                end;
            elseif MB == 2 then;
                no_undo()return;
            end;
        end;
        ----
        str = list[showMenu].val;
        local t = {};
        for S in string.gmatch(str,"{{.-}{.-}{.-}{.-}}")do;
            local pos,rgnend,name,color = S:match("{{(.-)}{(.-)}{(.-)}{(.-)}}");
            t[#t+1] = {};
            t[#t].pos = pos;
            t[#t].rgnend = rgnend;
            t[#t].name = name;
            t[#t].color = color;
        end;
        for i = 1, #t do;
            reaper.AddProjectMarker2(0,true,t[i].pos,t[i].rgnend,t[i].name,-1,t[i].color);
        end;
        ----
        ------
    elseif showMenu == #list+2 then;--add
        --AA2 = (showMenu-1);
        ------
        ----
        local num_MarkReg,num_markers,num_regions = reaper.CountProjectMarkers(0);
        if num_regions == 0 then;
            reaper.MB('Нечего сохранять (нет ригеонов)\n\nNothing  save (no rigons)','Woops',0);
            no_undo()return;
        end;
        ---
        ::res::
        local retval,retvals_csv = reaper.GetUserInputs('Save region',1,'Name template:,extrawidth=150','');
        if not retval then no_undo()return end;
        retvals_csv = retvals_csv:gsub('%p','');
        if #retvals_csv:gsub('[%p%s]','')==0 then goto res end;
        ---
        local Read = Arc.iniFileReadLua(section,retvals_csv,ArcFileIni);
        if Read ~= '' then;
            local MB = reaper.MB(retvals_csv..'\n\nRus:\nДанное имя уже используется\n\nEng:\nThis name is already in use ','Woops',1)
            if MB == 1 then;
                goto res;
            else;
                no_undo()return;
            end;
        end;
        ---
        local str;
        for i = 1, num_MarkReg do;
            local retval,isrgn,pos,rgnend,name,markrgnindexnumber,color = reaper.EnumProjectMarkers3(0,i-1);
            if isrgn then;
                str = (str or '')..'{{'..pos..'}{'..rgnend..'}{'..name..'}{'..color..'}}';
            end;
        end;
        ---
        Arc.iniFileWriteLua(section,retvals_csv,str,ArcFileIni,false,true);
        ----
        ------
    elseif showMenu > #list+2 then;--rem
        --AA3 = (showMenu-(#list+3));
        ------
        ----
        showMenu = (showMenu-(#list+3));
        local key=list[showMenu].key;
        
        local MB = reaper.MB('Remove Template ?','Remove Template',1);
        if MB == 1 then;
            Arc.iniFileWriteLua(section,key,'',ArcFileIni,false,true);
        end;
        ----
        ------
    end;
    
    no_undo();
    
    
    
    