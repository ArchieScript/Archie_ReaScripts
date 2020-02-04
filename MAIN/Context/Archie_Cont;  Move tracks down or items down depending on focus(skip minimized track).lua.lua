--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Context
   * Description: Move tracks down or items down depending on focus(skip minimized track)
   * Author:      Archie
   * Version:     1.0
   * Описание:    Переместить дорожки вниз или элементы вниз в зависимости от фокуса (пропустить свернутую дорожку)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [04.02.20]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    local Grp = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/MAIN';
    local TrackScr = Grp..'/Track/Archie_Track;  Move selected tracks down by one visible (skip minimized folders)(`).lua';
    local Item_Scr = Grp..'/Item/Archie_Item;  Move selected items down by one visible track(skip minimized track).lua';
    
    
    local CursorContext = reaper.GetCursorContext2(true);
    
    if CursorContext == 0 then; -- tr
        dofile(TrackScr);
        -- loadfile(TrackScr)();
    elseif CursorContext == 1 then; -- it
        dofile(Item_Scr);
    else;
        reaper.defer(function()end);
    end;
    