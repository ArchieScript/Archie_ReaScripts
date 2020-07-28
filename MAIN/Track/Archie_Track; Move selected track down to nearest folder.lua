--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Track 
   * Description: Move selected track down to nearest folder 
   * Author:      Archie 
   * Version:     1.0 
   * Описание:    Переместить выбранный трек вниз в ближайшую папку 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
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
     
     
    for i = 1,#SelTr do; 
        reaper.SetMediaTrackInfo_Value(SelTr[i],"I_SELECTED",1); 
        local numb = reaper.GetMediaTrackInfo_Value(SelTr[i],"IP_TRACKNUMBER"); 
        local fold = reaper.GetMediaTrackInfo_Value(SelTr[i],"I_FOLDERDEPTH"); 
        if fold == 1 then; 
            local Depth = reaper.GetTrackDepth(SelTr[i]); 
            for ii = numb, reaper.CountTracks(0)-1 do; 
                local Track = reaper.GetTrack(0,ii); 
                if Track then; 
                    local Depth2 = reaper.GetTrackDepth(Track); 
                    if Depth2 <= Depth then; 
                        local fold2 = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH"); 
                        if fold2 == 1 then; 
                            local numb2 = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER"); 
                            reaper.ReorderSelectedTracks(numb2,0); 
                            break; 
                        end; 
                    end; 
                end; 
            end;    
        else; 
            for ii = numb, reaper.CountTracks(0)-1 do; 
                local Track = reaper.GetTrack(0,ii); 
                if Track then; 
                    local fold2 = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH"); 
                    if fold2 == 1 then; 
                        local numb2 = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER"); 
                        reaper.ReorderSelectedTracks(numb2,0); 
                        break; 
                    end; 
                end; 
            end; 
        end; 
        reaper.SetMediaTrackInfo_Value(SelTr[i],"I_SELECTED",0); 
    end; 
     
     
    for i = 1,#SelTr do; 
        reaper.SetMediaTrackInfo_Value(SelTr[i],"I_SELECTED",1); 
    end; 
     
    reaper.Undo_EndBlock("Move selected track down to nearest folder",-1); 
    reaper.PreventUIRefresh(-1); 