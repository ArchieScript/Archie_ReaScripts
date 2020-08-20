--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Split items at grid (Time Selection)
   * Author:      Archie
   * Version:     1.03
   * Описание:    Разделение элементов по сетке (выбор времени)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)$
   * Gave idea:   Archie(---)$
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [010620]
   *                  + fixed bug

   *              v.1.0 [26.01.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local IGNORE_CROSSFADE = false -- true / false; true = Ignory Crosfade


    local IGNORE_FADE = false -- true / false; true = Ignory Fade


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    -------------------------------------------------------
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then;
        reaper.MB('No selected items','Woops',0);
        no_undo() return;
    end;
    -------------------------------------------------------




    -----------------------------------------------------------
    if IGNORE_CROSSFADE ~= true then IGNORE_CROSSFADE = nil end;
    if IGNORE_FADE ~= true then IGNORE_FADE = nil end;
    ------------------------------------
    local crossfadePREF;
    if IGNORE_CROSSFADE == true then;
        crossfadePREF = reaper.GetToggleCommandStateEx(0,40041);--Toggle auto-crossfade on/off
        if crossfadePREF == 1 then;
            reaper.Main_OnCommand(40041,0);
        end;
    end;
    ------------------------------------
    local fadePREF;
    if IGNORE_FADE == true then;
        fadePREF = reaper.SNM_GetIntConfigVar("splitautoxfade",0);
        if fadePREF&8 == 0 then;
            reaper.SNM_SetIntConfigVar("splitautoxfade",(fadePREF|8));
        end;
    end;
    ------------------------------------





    --- / split / -------------------------------------------------------
    local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0); -- В(На)Аранже
    if timeSelStart == timeSelEnd then;
        reaper.Main_OnCommand(40932,0);-- Split items at timeline grid
    else;
        ----
        local selItemTimeSel;
        for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
             local item = reaper.GetSelectedMediaItem(0,i);
             local pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
             local len = reaper.GetMediaItemInfo_Value(item,'D_LENGTH');
             if pos+len>timeSelStart and pos<timeSelEnd then;
                 selItemTimeSel = true;break;
             end;
        end;
        if not selItemTimeSel then;
            local MB = reaper.MB('No selected items in time selection\nSplit items out of time selection? - Ok\n\n'..
                           'Нет выбранных элементов в выборе времени \nРазделить элементы вне выбора времени? - Ok','Woops',1);
            if MB == 1 then;
                reaper.Main_OnCommand(40932,0);-- Split items at timeline grid
            end; --1ok --2cancel
        else;
            reaper.Undo_BeginBlock();
            reaper.Main_OnCommand(40061,0);--Split items at time selection
            for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
                local item = reaper.GetSelectedMediaItem(0,i);
                local pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
                local len = reaper.GetMediaItemInfo_Value(item,'D_LENGTH');
                if pos >= timeSelEnd or pos+len <= timeSelStart then;
                    reaper.SetMediaItemInfo_Value(item,'B_UISEL',0);
                end;
            end;
            reaper.Main_OnCommand(40932,0);-- Split items at timeline grid
            reaper.Undo_EndBlock("Split items at grid (Time Selection)",-1);
        end;
    end;
    ---------------------------------------------------------------------




    ------------------------------------
    if IGNORE_CROSSFADE == true then;
        if crossfadePREF == 1 then;
            reaper.Main_OnCommand(40041,0);
        end;
    end;
    ------------------------------------
    if IGNORE_FADE == true then;
        reaper.SNM_SetIntConfigVar("splitautoxfade",fadePREF);
    end;
    ------------------------------------


    reaper.UpdateArrange();
