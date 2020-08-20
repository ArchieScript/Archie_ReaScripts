--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Context
   * Description: Set focus on track panels
   * Author:      Archie
   * Version:     1.02
   * Описание:    Установите фокус на трек панель
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    https://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   * Changelog:   v.1.0 [05.02.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local ToolTip = true -- всплывающая подсказка (= true on) / (= false off)



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    local Tip;
    local CursorContext = reaper.GetCursorContext2(true);
    if CursorContext ~= 0 then; -- tr
        reaper.SetCursorContext(0,nil);
        Tip = 'Set focus on track panels';
    else;
        Tip = 'Focus on track';
    end;


    if ToolTip == true then;
        local x, y = reaper.GetMousePosition();
        reaper.TrackCtl_SetToolTip(Tip,x+20,y-20,0);
    end;


    reaper.defer(function()end);


	