--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track;  Paste track color
   * Author:      Archie
   * Version:     1.0
   * Описание:    Вставить цвет дорожки
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
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    
    
    local ExtState = reaper.GetExtState("Archie_Track_CopyPasteFSCOLOR_TRACK","COLOR_TRACK");
    if tonumber(ExtState) then;
    
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        
        for i = 1,CountSelTrack do;
            local SelTrack = reaper.GetSelectedTrack(0,i-1);
            reaper.SetMediaTrackInfo_Value(SelTrack,'I_CUSTOMCOLOR',ExtState);
        end;
        
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Paste track color',-1);
        
        reaper.UpdateArrange();
    else;
        no_undo();
    end;
    
    