--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Envelope
   * Description: Restore envelope point selection, slot 01
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


    local env = reaper.GetSelectedEnvelope(0);
    if not env then no_undo() return end;


    Slot = tonumber(Slot);
    if not tonumber(Slot)or Slot < 0 then Slot = 1 end;
    local SaveSelPoint = reaper.GetExtState('Archie_SaveSelPoint_Slot_'..Slot,'SaveSelPoint');
    if SaveSelPoint == '' then no_undo() return end;


    local T = {};
    for var in (SaveSelPoint..'&&&'):gmatch('(.-)&&&')do;
        T[#T+1] = var;
    end;

    if #T > 0 then;
        reaper.Main_OnCommand(40331,0);-- Unselect all points
    end;

    for i = 1, #T do;
        local idxautoIt,idxPoint,SelPoint = T[i]:match('^(.-);(.-);(.-)$');
        local retval,time,value,shape,tension,selected=reaper.GetEnvelopePointEx(env,idxautoIt,idxPoint);
        reaper.SetEnvelopePointEx(env,idxautoIt,idxPoint,time,value,shape,tension,(SelPoint == '1'),true);
    end;

    reaper.Envelope_SortPoints(env);
    no_undo();