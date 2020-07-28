--[[
   * Category:    Options
   * Description: Options; Clear AutoRun Archie.lua
   * Author:      Archie
   * Version:     1.03
   * Описание:    Очистить автозагрузку Арчи
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Extension:
   *              Reaper 6.10+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.7.9+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   *              http://arc-website.github.io/Library_Function/Arc_Function_lua/index.html
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	


    local tId = {};
    local tName = {};
    for i = 1, math.huge do;
        local retval,nameAct,id = Arc.EnumStartupScript(i-1);
        if retval then;
            tId[#tId+1] = id;
            tName[#tId] = nameAct:gsub('_LUA$','.LUA'):gsub('_',' ');
        else;
            break;
        end;
    end;

    if #tId == 0 then Arc.no_undo()return end;


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


    local
    showMenu = gfx.showmenu(
                            '#Remove Action Archie Autorun||'..
                            table.concat(tName,'|')..
                            '||#Remove all'..
                            "||REMOVE ALL");

    if showMenu > 0 and showMenu <= #tId+1 then;
         local check_Id,check_Fun = Arc.GetStartupScript(tId[showMenu-1]);
         if check_Id then;
             local MB = reaper.MB("Rus:\nТОЧНО УДАЛИТЬ?\n\nEng:\nEXACTLY REMOVE?","Warning",1);
             if MB == 1 then;
                 reaper.defer(function()Arc.SetStartupScript("scriptName",tId[showMenu-1],nil,"ONE")end);
             end;
         end;
    elseif showMenu == #tId+3 then;
        local MB = reaper.MB("Rus:\nТОЧНО УДАЛИТЬ ВСЕ?\n\nEng:\nEXACTLY REMOVE ALL?","Warning",1);
        if MB == 1 then;
            reaper.defer(function()Arc.SetStartupScript("scriptName","",nil,"ALL")end);
        end;
    end
    gfx.quit();
    Arc.no_undo();
