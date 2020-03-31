--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var;  Hide Show add menu (popup menu single-level).lua
   * Author:      Archie
   * Version:     1.03
   * Описание:    Скрыть показать 'меню добавления'
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1500
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.03 [310320]
   *                  No change
   
   *              v.1.0 [260320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    
    local sect = 'ARCHIE_POPUP MENU SINGLE-LEVEL__HIDE ADD MENU';
    local HIDE_ADD = tonumber(reaper.GetExtState(sect,'State'))or 0;
    
    
    if HIDE_ADD == 0 then;
        reaper.SetExtState(sect,'State',1,true);
    else;
        reaper.SetExtState(sect,'State',0,true);
    end;
    
    reaper.defer(function()end);
    
    
    