--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Set source for all of selected items
   * Author:      Archie
   * Version:     1.06
   * Описание:    Установить источник для всех выбранных элементов
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Maestro Sound(Rmm)
   * Gave idea:   Maestro Sound(Rmm)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   *              Arc_Function_lua v.2.7.4+ (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:
   *              v.1.0 [08.02.20]
   *                  + initialе
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
	



    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then Arc.no_undo() return end;


    local retval, filenameNeed4096 = reaper.GetUserFileNameForRead('','Set source for all of selected items','wav' )
    if retval then;

        reaper.PreventUIRefresh(1);
        reaper.Undo_BeginBlock();

        for i = 1, Count_sel_item do;
            local itemSel = reaper.GetSelectedMediaItem(0,i-1);
            local take = reaper.GetActiveTake(itemSel);
            reaper.BR_SetTakeSourceFromFile(take,filenameNeed4096,true);
        end;

        --------------------------------------------------
        local ShowStatusWindow = reaper.SNM_GetIntConfigVar("showpeaksbuild",0);
        if ShowStatusWindow == 1 then;
            reaper.SNM_SetIntConfigVar("showpeaksbuild",0);
        end;
        ---
        Arc.Action(40047);--Build missing peaks
        ---
        if ShowStatusWindow == 1 then;
            reaper.SNM_SetIntConfigVar("showpeaksbuild",1);
        end;
        --------------------------------------------------

        reaper.Undo_EndBlock('Set source for all of selected items',-1);
        reaper.PreventUIRefresh(-1);
    else;
        Arc.no_undo();
    end;

    reaper.UpdateArrange();

