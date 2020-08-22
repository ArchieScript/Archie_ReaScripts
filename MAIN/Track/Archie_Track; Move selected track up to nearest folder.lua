--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Move selected track up to nearest folder
   * Author:      Archie
   * Version:     1.02
   * Описание:    Переместить выбранный трек вверх в ближайшую папку
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    SKlogic(Rmm)
   * Gave idea:   SKlogic(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [01.12.19]
   *                  + initialе
--]]

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;


    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();


    local SelTr = {};
    for i = CountSelTrack-1,0,-1 do;
        table.insert(SelTr,reaper.GetSelectedTrack(0,i));
        reaper.SetMediaTrackInfo_Value(SelTr[#SelTr],"I_SELECTED",0);
    end;


    for i = #SelTr,1,-1 do;

        reaper.SetMediaTrackInfo_Value(SelTr[i],"I_SELECTED",1);
        local Depth = reaper.GetTrackDepth(SelTr[i]);
        local numb = reaper.GetMediaTrackInfo_Value(SelTr[i],"IP_TRACKNUMBER");

        if Depth > 0 then;
            ----
            local Parent = 0;
            for ii = numb-2,0,-1 do;
                local Track = reaper.GetTrack(0,ii);
                local Depth2 = reaper.GetTrackDepth(Track);
                if Depth2 <= Depth then;

                    local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
                    if fold == 1 then;
                        Parent = Parent + 1;
                        if Parent > 1 then;
                            local numb2 = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER");
                            reaper.ReorderSelectedTracks(numb2,0);
                            break;
                        end;
                    end;
                end;
            end;
            ----
        else;
            ----
            for ii = numb-2,0,-1 do;
                local Track = reaper.GetTrack(0,ii);
                local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
                if fold == 1 then;
                    local numb2 = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER");
                    reaper.ReorderSelectedTracks(numb2,0);
                    break;
                end;
            end;
            ----
        end;
        reaper.SetMediaTrackInfo_Value(SelTr[i],"I_SELECTED",0);
    end;


    for i = 1,#SelTr do;
        reaper.SetMediaTrackInfo_Value(SelTr[i],"I_SELECTED",1);
    end;

    reaper.Undo_EndBlock("Move selected track up to nearest folder",-1);
    reaper.PreventUIRefresh(-1);
