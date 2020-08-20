--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Insert item under mouse cursor
   * Author:      Archie
   * Version:     1.02
   * Описание:    Вставить элемент под курсор мыши
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    YuriOl(Rmm)
   * Gave idea:   YuriOl(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [05.02.20]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local TACT = 1; -- длина элемента в тактах  1-100


    local Envelope = true
                -- = true  Добавить элемент, если мышь под огибающей трека
                -- = false Не добавлять элемент, если мышь под огибающей трека


    local Time_Selection = true -- true / false
                      -- = true  Если мышь в выборе времени, то добавить элемент по выбору времени
                      -- = false Игнорировать выбор времени



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    local itemNew;
    local tr,info = reaper.GetTrackFromPoint(reaper.GetMousePosition());
    local num_cursor = reaper.BR_PositionAtMouseCursor(true);
    if Envelope == true then info=0 end;
    if tr and num_cursor >= 0 and tr~=reaper.GetMasterTrack(0) and info==0 then;
        reaper.Undo_BeginBlock();
        local start_time,end_time = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        if Time_Selection ~= true then start_time = end_time end;
        if num_cursor < start_time or num_cursor > end_time then;
            if not tonumber(TACT)or TACT <= 0 or TACT >= 100 then TACT = 1 end;
            local buf = reaper.format_timestr_pos(num_cursor,'',2):match('%d+');
            local Start_Pos = reaper.parse_timestr_pos(buf..'.0.0',2);
            local End_Pos = reaper.parse_timestr_pos(buf+TACT..'.0.0',2);
            itemNew = reaper.CreateNewMIDIItemInProj(tr,Start_Pos,End_Pos,false);
        else;
            itemNew = reaper.CreateNewMIDIItemInProj(tr,start_time,end_time,false);
        end;
        if itemNew then;
            local take = reaper.GetActiveTake(itemNew);
            local Track = reaper.GetMediaItemTrack(itemNew);
            local _,name = reaper.GetSetMediaTrackInfo_String(Track,'P_NAME',0,false);
            reaper.GetSetMediaItemTakeInfo_String(take,'P_NAME',name,1);
            reaper.SetMediaItemSelected(itemNew,1);
            reaper.UpdateItemInProject(itemNew);
        end;
        reaper.Undo_EndBlock('Insert item under mouse cursor',-1);
    end;

