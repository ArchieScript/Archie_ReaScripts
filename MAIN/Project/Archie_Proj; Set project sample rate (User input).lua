--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Project
   * Description: Proj; Set project sample rate (User input)
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Валерий Бадьянов(Rmm)
   * Gave idea:   Валерий Бадьянов(Rmm)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [290320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    local function no_undo()reaper.defer(function()end)end;

    ::rest::;
    local retval = reaper.GetSetProjectInfo(0,'PROJECT_SRATE',0,0);
    local ret,retvals_csv = reaper.GetUserInputs('Set sample rate',1,'Set sample rate:,extrawidth=100',retval);
    if not ret then return no_undo() end;
    local retvals_csv = tonumber(retvals_csv);
    if not retvals_csv then return no_undo() end;
    if retvals_csv < 8000 or retvals_csv > 192000 then goto rest end;

    if retvals_csv ~= retval then;
        reaper.GetSetProjectInfo(0,'PROJECT_SRATE',retvals_csv,1);
        reaper.Audio_Quit();
        reaper.Audio_Init();
        reaper.UpdateArrange();
    end;

    no_undo();


