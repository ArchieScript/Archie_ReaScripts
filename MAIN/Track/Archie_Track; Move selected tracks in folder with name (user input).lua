--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Move selected tracks in folder with name (user input)
   * Author:      Archie
   * Version:     1.03
   * Описание:    Переместить выбранные треки в папку с именем (ввод пользователем)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    J T(Rmm)
   * Gave idea:   J T(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   * Changelog:
   *              v.1.02 [10.12.19]
   *                  Add: Insert folder, if it does not exist.

   *              v.1.0 [09.12.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local TrName = -1
              -- = -1 | показать окно ввода
              -- Или введите имя = "Temp"


    local InsertFolder = true
                    -- = true  | Если не существует папки с таким именем, то создать новую папку
                    -- = false | Не создавать новую папку


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;

    if type(TrName)~='string' then TrName = -1 end;

    if TrName == -1 then;
        local scrName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
        local value = reaper.GetExtState(scrName,"FoldNameMove");
        local retval, retvals_csv = reaper.GetUserInputs("Move selected tracks in folder",1,"Name Folder,extrawidth=200",value);
        if not retval then no_undo() return end;
        reaper.SetExtState(scrName,"FoldNameMove",retvals_csv,true);
        TrName = retvals_csv;
    end;


    local CountTrack = reaper.CountTracks(0);
    local Undo;

    for i = 1, CountTrack do;
        local Track = reaper.GetTrack(0,i-1);
        local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
        if fold == 1 then;
            local retval, stringNeedBig = reaper.GetSetMediaTrackInfo_String(Track,"P_NAME",0,0);
            if TrName == stringNeedBig then;
                local numb = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER");
                reaper.Undo_BeginBlock();
                reaper.ReorderSelectedTracks(numb,0);
                reaper.Undo_EndBlock("Move selected tracks in folder "..TrName,-1);
                Undo = true;
                break;
            end;
        end;
    end;


    if InsertFolder == true then;
        if not Undo then;
            reaper.Undo_BeginBlock();
            local CountTrack = reaper.CountTracks(0);
            reaper.InsertTrackAtIndex(CountTrack,true);
            local Track = reaper.GetTrack(0,CountTrack);
            reaper.GetSetMediaTrackInfo_String(Track,"P_NAME",TrName,1);
            reaper.ReorderSelectedTracks(CountTrack+1,1);
            reaper.Undo_EndBlock("Move selected tracks in folder "..TrName,-1);
            Undo = true;
        end;
    end;


    if not Undo then;
        no_undo();
    end;