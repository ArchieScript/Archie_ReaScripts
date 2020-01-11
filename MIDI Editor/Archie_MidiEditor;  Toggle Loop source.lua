--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Midi Editor
   * Description: Toggle Loop source
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(***)
   * Gave idea:   Archie(***)
   * Changelog:   v.1.0 [11.01.2020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    ------------------------------------------------
    local midieditor = reaper.MIDIEditor_GetActive();
    if midieditor then;
        
        reaper.Undo_BeginBlock();
        
        local take = reaper.MIDIEditor_GetTake(midieditor);
        local item = reaper.GetMediaItemTake_Item(take);
        local loopSource = reaper.GetMediaItemInfo_Value(item,'B_LOOPSRC');
        reaper.SetMediaItemInfo_Value(item,'B_LOOPSRC',math.abs(loopSource-1));
        if math.abs(loopSource-1)==0 then Und='OFF'else Und='ON' end;
        
        reaper.Undo_EndBlock('Loop Source - '..Und,-1);
        
        reaper.UpdateArrange();
    else;
        reaper.defer(function()end);
    end;s
    ------------------------------------------------