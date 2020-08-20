--[[
   * Category:    FX
   * Description: Move the last FX in the selected tracks to the first position
   * Oписание:    Переместить последний FX в выбранных треках на первую позицию
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.02
   * customer :   Supa75[RMM Forum]
   * gave idea:   Supa75[RMM Forum]
--=============================================]]



    local numberFx = 1
                 -- Установите на какую позицию перемеитить FX


    --================================================================
    --/////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\
    --================================================================




    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------



    local CountSelTr = reaper.CountSelectedTracks(0);
    if CountSelTr == 0 then no_undo()return end;

    if not tonumber(numberFx)or numberFx < 1 then numberFx = 1 end;

    for i = 1,CountSelTr do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        if SelTrack then;
             local CountFX = reaper.TrackFX_GetCount(SelTrack);
             if CountFX > numberFx then;
                 reaper.TrackFX_CopyToTrack(SelTrack,CountFX-1,SelTrack,numberFx-1,1);
                 undo = 1
             end;
        end;
    end;

    if undo == 1 then;
        reaper.Undo_BeginBlock();
        reaper.Undo_EndBlock("Move last FX "..numberFx.." position",1);
    else;
        no_undo();
    end;