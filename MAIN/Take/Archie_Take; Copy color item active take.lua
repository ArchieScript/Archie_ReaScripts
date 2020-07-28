--[[ 
   * Category:    Take 
   * Description: Copy color item active take 
   * Author:      Archie 
   * Version:     1.05 
   * AboutScript: Copy color item active take 
   * О скрипте:   Скопировать цвет элемента активного дубля 
                  востановить с помощью:  
                                Paste color to selected item active take 
                                Paste color to selected item all take 
                                Reset color in all take in selected items default 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    YuriOl(RMM) 
   * Gave idea:   YuriOl(RMM) 
   * Changelog:    
    
   *              +  Fixed paths for Mac/ v.1.03 [29.01.19] 
   *              +  Исправлены пути для Mac/ v.1.03 [29.01.19] 
   *              +  initialе / v.1.0 [17.01.2019] 
    
   ===========================================================================================\ 
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------| 
   ===========================================================================================| 
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)| 
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)| 
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)| 
   - Arc_Function_lua v.2.2.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)| 
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)| 
                                                                 http://clck.ru/Eo5Lw |и выше)| 
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)| 
--===========================================================================================]] 
 
 
 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
 
 
 
 
    ----------------------------------------------------------------------------- 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end 
    ----------------------------------------------------------------------------- 
 
 
 
    local SelItem = reaper.GetSelectedMediaItem(0,0); 
    if not SelItem then no_undo() return end; 
     
    reaper.Undo_BeginBlock(); 
     
    local HasExtState = reaper.HasExtState("Archie_Take_CopyPaste Name item active take","Color"); 
    if HasExtState then; 
        reaper.DeleteExtState("Archie_Take_CopyPaste Name item active take","Color",false); 
    end; 
     
    local ActiveTake = reaper.GetActiveTake(SelItem); 
    local color = reaper.GetMediaItemTakeInfo_Value(ActiveTake,"I_CUSTOMCOLOR"); 
    if color == 0 then; 
        color = reaper.GetMediaItemInfo_Value(SelItem,"I_CUSTOMCOLOR"); 
    end; 
     
    reaper.SetExtState("Archie_Take_CopyPaste Name item active take","Color",color,false); 
     
    reaper.Undo_EndBlock('Copy color item active take',-1); 