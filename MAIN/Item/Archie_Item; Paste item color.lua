--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Paste item color
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [030320]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local reset = 0 
             -- = 0 | НЕ СБРАСЫВАТЬ СОХРАНЕНИЕ ПРИ ВОСТАНОВЛЕНИИ
             -- = 1 | СБРОСИТЬ СОХРАНЕНИЕ ПРИ ВОСТАНОВЛЕНИИ
                
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then no_undo() return end;
    
    local HasExtState = reaper.HasExtState("Archie_Take_CopyPaste Name item active take","Color");
    if not HasExtState then no_undo() return end;
    
    reaper.Undo_BeginBlock();
    
    local Col = reaper.GetExtState("Archie_Take_CopyPaste Name item active take","Color");
    
    for i = 1, Count_sel_item do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        reaper.SetMediaItemInfo_Value(SelItem,"I_CUSTOMCOLOR",Col);
    end;
    
    if reset ~= 0 then;
        reaper.DeleteExtState("Archie_Take_CopyPaste Name item active take","Color",false);
    end;
    
    reaper.Undo_EndBlock('Paste item color',-1);
    reaper.UpdateArrange();
    
    
    
    