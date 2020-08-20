--[[
   * Category:    Options
   * Description: Reset ReaScript task control for all scripts
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Reset 'ReaScript task control' for all scripts
   * О скрипте:   ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    ---
   * Gave idea:   ---
   * Changelog:   +  initialе / v.1.0 [220219]
   ==========================================================================================


   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
   + Reaper v.5.965 +           --| http://www.reaper.fm/download.php                      ||
   - SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 ||
   - ReaPack v.1.2.2 +          --| http://reapack.com/repos                               ||
   + Arc_Function_lua v.2.2.9 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   ||
   - reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr   ||
                                                                    http://clck.ru/Eo5Lw   ||
   ? Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                  ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]




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
	




    -------------------------------
    --260 on\off; 516 new; 4 reset;
    -------------------------------

    local pathFile = reaper.GetResourcePath().."/reaper-kb.ini";
    local openFile = io.open(pathFile,"r");
    if not openFile then Arc.no_undo() return end;


    if reaper.MB(
             "Rus:\n"..
             " * Точно сбросить 'ReaScript task control' для всех скриптов ?\n"..
             " * Все сохранения будут удалены !\n"..
             " * Чтобы изменения вступили в силу, перезагрузите Reaper.\n"..
             "Eng:\n"..
             " * Exactly reset 'ReaScript task control' for all scripts ?\n"..
             " * All saves will be deleted !\n"..
             " * Restart Reaper for the changes to take effect."
             ,"Warning !",1)
    == 1 then;

        local str = {};

        for var in openFile:lines()do;
            str[#str+1] = string.gsub(var,"SCR %d+","SCR 4",1);
        end;

        openFile:close();

        openFile = io.open(pathFile,"w");
        for i = 1,#str do;
            openFile:write(str[i].."\n");
        end;
        openFile:close();
        Arc.no_undo();
    else;
        Arc.no_undo() return;
    end;