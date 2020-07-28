--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Envelope
   * Description: Save envelope point selection, slot 01
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---(---)
   * Gave idea:   ---(---)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   * Changelog:   v.1.0 [25.01.20]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local Slot = 1


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------


    local T = {};
    local env = reaper.GetSelectedEnvelope(0);
    if env then;
        local CountAutoItem = reaper.CountAutomationItems(env);
        for i = -1,CountAutoItem-1 do;
            local CountEnvPoint = reaper.CountEnvelopePointsEx(env,i);
            for i2 = 0,CountEnvPoint-1 do;
                local selected = ({reaper.GetEnvelopePointEx(env,i,i2)})[6]and 1 or 0;
                T[#T+1] = i..';'..i2..';'..selected;
                -- idx_autoIt,idx_point,Sel_point;
            end;
        end;

        if reaper.HasExtState('Archie_SaveSelPoint_Slot_'..Slot,'SaveSelPoint')then;
            reaper.DeleteExtState('Archie_SaveSelPoint_Slot_'..Slot,'SaveSelPoint',false);
        end;

        local SaveSelPoint = table.concat(T,'&&&');
        Slot = tonumber(Slot);
        if not tonumber(Slot)or Slot < 0 then Slot = 1 end;
        reaper.SetExtState('Archie_SaveSelPoint_Slot_'..Slot,'SaveSelPoint',SaveSelPoint,false);
    end;

    no_undo();