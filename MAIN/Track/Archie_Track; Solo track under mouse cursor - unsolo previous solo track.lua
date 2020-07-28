--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Track 
   * Description: Solo track under mouse cursor - unsolo previous solo track 
   * Author:      Archie 
   * Version:     1.0 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Алексей Левин(VK) 
   * Gave idea:   Алексей Левин(VK) 
   * Extension:   Reaper 6.04+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   * Changelog:    
   *              v.1.0 [24.02.20] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    local x, y = reaper.GetMousePosition(); 
    local track, info = reaper.GetTrackFromPoint(x,y); 
    if not track or info ~= 0 then no_undo() return end; 
     
     
    reaper.Undo_BeginBlock(); 
    reaper.PreventUIRefresh(1); 
     
     
    local GUID = reaper.GetTrackGUID(track); 
    reaper.SetMediaTrackInfo_Value(track,'I_SOLO',1); 
     
    ------- 
    local ExtState = reaper.GetExtState('AlexeyLevinVKSOLOWheel','guide'); 
    local trackGuid = reaper.BR_GetMediaTrackByGUID(0,ExtState); 
     
    if trackGuid then; 
        reaper.SetMediaTrackInfo_Value(trackGuid,'I_SOLO',0); 
        reaper.DeleteExtState('AlexeyLevinVKSOLOWheel','guide',false); 
    end; 
    ------- 
     
    reaper.SetExtState('AlexeyLevinVKSOLOWheel','guide',GUID,false); 
     
     
    reaper.PreventUIRefresh(1); 
    reaper.Undo_EndBlock('Solo track under mouse cursor - unsolo previous solo track',-1); 
     
     
     
     
     