--[[
   * Category:    FX
   * Description: Move the last FX in the selected items to the first position
   * Oписание:    Переместите последний FX в выбранных элементах в первую позицию
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    ---
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



    local CountSelit = reaper.CountSelectedMediaItems(0),undo;
    if CountSelit == 0 then no_undo()return end;

    if not tonumber(numberFx)or numberFx < 1 then numberFx = 1 end;

    for i = 1, CountSelit do;
        local Selitem = reaper.GetSelectedMediaItem(0,i-1);
        local Take = reaper.GetActiveTake(Selitem);
        local CountFX = reaper.TakeFX_GetCount(Take);
        if CountFX > numberFx then;
            reaper.TakeFX_CopyToTake(Take,CountFX-1,Take,numberFx-1,1);
            undo = 1;
        end;
    end;

    if undo == 1 then;
        reaper.Undo_BeginBlock();
        reaper.Undo_EndBlock("Move last FX "..numberFx.." position",1);
    else;
        no_undo();
    end;


