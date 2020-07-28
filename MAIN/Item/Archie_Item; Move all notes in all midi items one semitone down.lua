--[[
   * Category:    Item
   * Description: Move all notes in all midi items one semitone down
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Move all notes in all midi items one semitone down
   * О скрипте:   Переместить все ноты во всех midi элементах на один полутон вниз
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Ga_rY(Rmm/forum)
   * Gave idea:   Ga_rY(Rmm/forum)
   * Changelog:   + initialе / v.1.0[23122018]
--============================================================================================|
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   - Arc_Function_lua v.2.0.6 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]



    --=========================================================================================
    --/////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\\\
    --=========================================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountItem = reaper.CountMediaItems(0);
    if CountItem == 0 then no_undo() return end;


    local retval   = {};
    local sel      = {};
    local mute     = {};
    local startppq = {};
    local endppq   = {};
    local chan     = {};
    local pitch    = {};
    local vel      = {};
    local semitone = -1;
    local Undo_BegBlock;


    for i = 1,CountItem do;
        local item = reaper.GetMediaItem(0,i-1);
        local CountTake = reaper.CountTakes(item);
        for i2 = 1,CountTake do;
            local take = reaper.GetMediaItemTake(item,i2-1);
            local midi = reaper.TakeIsMIDI(take);
            if midi then;
                local ret,notecnt,ccevtcnt,textsyxevtcnt = reaper.MIDI_CountEvts(take);
                for i3 = notecnt-1,0,-1 do;
                   retval  [i3],
                   sel     [i3],
                   mute    [i3],
                   startppq[i3],
                   endppq  [i3],
                   chan    [i3],
                   pitch   [i3],
                   vel     [i3] = reaper.MIDI_GetNote(take,i3);
                   reaper.MIDI_DeleteNote(take,i3);
                end;
                for i4 = notecnt-1,0,-1 do;
                    reaper.MIDI_InsertNote(take,
                                           sel     [i4],
                                           mute    [i4],
                                           startppq[i4],
                                           endppq  [i4],
                                           chan    [i4],
                                           pitch   [i4]+semitone,
                                           vel     [i4],
                                                  true);
                end;
                reaper.MIDI_Sort(take);
                Undo_BegBlock = "Active";
            end;
        end
    end;


    reaper.UpdateArrange();

    if Undo_BegBlock == "Active" then;
        reaper.Undo_BeginBlock();
        reaper.Undo_EndBlock("Move all notes in all midi items one semitone down",-1);
    else;
        no_undo();
    end;