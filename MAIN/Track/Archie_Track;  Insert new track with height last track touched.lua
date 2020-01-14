--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Insert new track with height last track touched
   * Author:      Archie
   * Version:     1.0
   * Описание:    Вставить новую дорожку с высотой последнего тронутого трека
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    AlexLazer(Rmm)
   * Gave idea:   AlexLazer(Rmm)
   * Changelog:   v.1.0 [14.01.2020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local POSITION = 0
                -- = 0 | Добавить трек под последний тронутый
                -- = 1 | Добавить трек в начало
                -- = 2 | Добавить трек в конец    
                
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local height,numb;
    
    ---------------------
    local LastTouchedTrack = reaper.GetLastTouchedTrack();
    if LastTouchedTrack then;
        height = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,'I_HEIGHTOVERRIDE');
        numb = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,'IP_TRACKNUMBER');
    end;
    ---------------------
    
    
    ---------------------
    if not numb then;
        numb = reaper.CountTracks(0);
    end;
    
    if not height then;
        height = 0;
    end;
    ---------------------
    
    
    ---------------------
    if POSITION == 1 then;
        numb = 0;
    elseif POSITION == 2 then;
        numb = reaper.CountTracks(0);
    end;
    ---------------------
    
    
    ---------------------
    reaper.Undo_BeginBlock();
    
    reaper.InsertTrackAtIndex(numb,true);
    local Track = reaper.GetTrack(0,numb);
    reaper.SetMediaTrackInfo_Value(Track,'I_HEIGHTOVERRIDE',height);
    
    reaper.TrackList_AdjustWindows(0);
    
    reaper.Undo_EndBlock('Insert new track with height last track touched',-1);
    ---------------------
    