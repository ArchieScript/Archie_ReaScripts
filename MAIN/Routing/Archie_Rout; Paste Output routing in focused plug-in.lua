--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Routing
   * Description: Paste Output routing in focused plug-in
   * Author:      Archie
   * Version:     1.01
   * Описание:    Вставить маршрут вывода в сфокусированный плагин
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Дима Горелик(Rmm)
   * Gave idea:   Дима Горелик(Rmm)
   * Changelog:   v.1.0 [31.10.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    local function PasteOutput_FocusedFX_Pin(NameScript,clean,persist);--section
        local retval,tracknumber,itemnumber,fxnumber = reaper.GetFocusedFX();
        local track = reaper.GetTrack(0,tracknumber-1);
        if not track then return -1 end;

        if retval > 0 then;

            if itemnumber < 0 then;
                local t = reaper.GetExtState(NameScript,"CopyOutputPlugin");
                if t ~= "" then;
                    for var in t:gmatch("{.-}") do;
                        local OutPlug,Channel_beat = var:match("{(.-)&(.-)}");
                        reaper.TrackFX_SetPinMappings(track,fxnumber,1,OutPlug,Channel_beat,0);
                    end;
                    if clean == true then;
                        reaper.DeleteExtState(NameScript,"CopyOutputPlugin",persist);
                    end;
                end;
            else;
            ----
                local take_numb = fxnumber >> 16;
                local fx_number = fxnumber & 65535;
                local Item = reaper.GetTrackMediaItem(track,itemnumber);
                local Take = reaper.GetTake(Item,take_numb);

                local t = reaper.GetExtState(NameScript,"CopyOutputPlugin");
                if t ~= "" then;
                    for var in t:gmatch("{.-}") do;
                        local OutPlug,Channel_beat = var:match("{(.-)&(.-)}");
                        reaper.TakeFX_SetPinMappings(Take,fx_number,1,OutPlug,Channel_beat,0);
                    end;
                    if clean == true then;
                        reaper.DeleteExtState(NameScript,"CopyOutputPlugin",persist);
                    end;
                end;
                ----
            end;
        else;
            return -1;
        end;
    end;

    PasteOutput_FocusedFX_Pin("Archie_Rout;CopyOutputRoutingOfFocusedPlugIn.lua",false,false);
    reaper.defer(function()end);