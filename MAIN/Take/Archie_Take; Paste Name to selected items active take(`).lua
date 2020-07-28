--[[
   * Category:    Take
   * Description: Paste Name to selected items active take
   * Author:      Archie
   * Version:     1.05
   * AboutScript: Paste Name to selected items active take
   * О скрипте:   Вставить имя в выбранных элементах в активные тейки
                  скопировать с помощью:
                        Copy Name item active take
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM)
   * Gave idea:   YuriOl(RMM)
   * Changelog:

   *              +  Fixed paths for Mac/ v.1.02 [29.01.19]
   *              +  Исправлены пути для Mac/ v.1.02 [29.01.19]
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
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local reset = 0
             -- = 0 | НЕ СБРАСЫВАТЬ СОХРАНЕНИЕ ПРИ ВОСТАНОВЛЕНИИ
             -- = 1 | СБРОСИТЬ СОХРАНЕНИЕ ПРИ ВОСТАНОВЛЕНИИ



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then no_undo() return end;


    local HasExtState = reaper.HasExtState("Archie_Take_Copy_Paste Name item active take","Name");
    if not HasExtState then no_undo() return end;

    reaper.Undo_BeginBlock();

    local Name = reaper.GetExtState("Archie_Take_Copy_Paste Name item active take","Name");
    for i = 1, Count_sel_item do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local ActiveTake = reaper.GetActiveTake(SelItem);
        reaper.GetSetMediaItemTakeInfo_String(ActiveTake,"P_NAME",Name,1);
    end;
    if reset ~= 0 then;
        reaper.DeleteExtState("Archie_Take_Copy_Paste Name item active take","Name",false);
    end;
    reaper.Undo_EndBlock('Paste Name to selected items active take',-1);
    reaper.UpdateArrange();