--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Stutter 1.2 items
   * Author:      Archie
   * Version:     1.01
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    borisuperful(Rmm)
   * Gave idea:   borisuperful(Rmm)
   * Changelog:   
   *              v.1.01 [02.10.19]
   *                  + copying automation
   
   *              v.1.0 [16.08.19]
   *                  + initialе
--]]
    
    -- *** Работает медленнее чем другие скрипты, но четко с автоматизацией
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=====================================================
    local function no_undo()reaper.defer(function()end)end;
    --=====================================================
    
      
    local MIN_LENGTH = 0.025;
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    if CountSelItem > 5000 then error("maximum items 5000. received "..CountSelItem)end;
    
    local moveEnv = reaper.GetToggleCommandStateEx(0,40070);--Env points move with media items
    local moveEnv_X;
    if moveEnv == 1 and CountSelItem > 100 then;
        local MB = reaper.MB(
                  "Rus:\nВыбрано более 100 элементов\n"..
                  "Копирование с автоматизацией займет очень много времени !!!\n"..
                  "Скопировать без автоматизации ? - Да\n"..
                  "Все равно скопировать с автоматизацией  - Нет / (очень долго !!!)\n"..
                  ("-"):rep(70).."\n\n"..
                  "Eng:\nOver 100 items selected\n"..
                  "Copying with automation will take a very long time !!!\n"..
                  "Copy without automation? - Yes"..
                 "Anyway, copy with automation - No / (very long !!!)","Advice",3);
        if MB == 2 then no_undo() return end;--cancel;
        if MB == 6 then; -- Yes
            reaper.Main_OnCommand(40070,0);--Env points move
            moveEnv_X = true;
            moveEnv = 0;
        end;     
    end;
    --clo1 = os.clock()
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    ---------------------------------------------
    local SelItemT = {};
    local SelItemT_X = {};
    for i = 1, reaper.CountSelectedMediaItems(0) do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local len = reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH");
        table.insert(SelItemT_X,SelItem);
        if len >= (MIN_LENGTH or 0.025) then;
            table.insert(SelItemT,SelItem);
        end;
    end;
    if #SelItemT == 0 then no_undo() return end;
    ----
    reaper.SelectAllMediaItems(0,0);
    -----
    local SelTrackT_X = {};
    for i = 1,reaper.CountSelectedTracks(0) do;
        table.insert(SelTrackT_X,reaper.GetSelectedTrack(0,i-1));
    end;
    ----
    local EditCursor_X = reaper.GetCursorPosition();
    local start_time_X, end_time_X = reaper.GetSet_ArrangeView2(0,0,0,0);
    local unSelTr;
    ----
    if moveEnv == 0 then;
        ---------------------------------------------
        ::RESTART::
        local len2;
        for i = #SelItemT,1,-1 do;
            local len = reaper.GetMediaItemInfo_Value(SelItemT[i],"D_LENGTH");
            if not len2 or len == len2 then;
                local trackIt = reaper.GetMediaItem_Track(SelItemT[i]);
                if not len2 then; reaper.SetOnlyTrackSelected(trackIt)end;
                local Sel = reaper.GetMediaTrackInfo_Value(trackIt,"I_SELECTED");
                if Sel == 0 then;
                    reaper.SetMediaTrackInfo_Value(trackIt,"I_SELECTED",1);
                end;
                reaper.SetMediaItemInfo_Value(SelItemT[i],"B_UISEL",1);
                reaper.SetMediaItemInfo_Value(SelItemT[i],"D_LENGTH",len/2);
                len2 = len;
                table.remove(SelItemT,i); 
            end;    
        end;
        ----
        local firstEndIt = math.huge;
        for i = 1,reaper.CountSelectedTracks(0) do;
            local track = reaper.GetSelectedTrack(0,i-1);
            for ii = 1,reaper.CountTrackMediaItems(track) do;
                local item = reaper.GetTrackMediaItem(track,ii-1);
                if reaper.GetMediaItemInfo_Value(item,"B_UISEL")==1 then;
                    local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
                    local len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
                    if pos+len < firstEndIt then firstEndIt = pos+len end; 
                end
            end;
        end;
        ----
        reaper.SetEditCurPos(firstEndIt,false,false);
        reaper.Main_OnCommand(40698,0)--C
        reaper.Main_OnCommand(40058,0)--P
        ----
        for i = 1,reaper.CountSelectedMediaItems(0) do;
            table.insert(SelItemT_X,reaper.GetSelectedMediaItem(0,i-1));
        end;
        reaper.SelectAllMediaItems(0,0);
        
        if #SelItemT > 0 then len2 = nil goto RESTART end;--/\
        ---------------------------------------------
    else;
        ---------------------------------------------
        for i = 1, #SelItemT do;
            ---- 
            local trackIt = reaper.GetMediaItem_Track(SelItemT[i]);
            if not unSelTr then;
                reaper.SetOnlyTrackSelected(trackIt);unSelTr = true;
            end;
            ----
            local Sel = reaper.GetMediaTrackInfo_Value(trackIt,"I_SELECTED");
            if Sel == 0 then;
                reaper.SetOnlyTrackSelected(trackIt);
            end;
            ----
            local pos = reaper.GetMediaItemInfo_Value(SelItemT[i],"D_POSITION");
            local len = reaper.GetMediaItemInfo_Value(SelItemT[i],"D_LENGTH");
            reaper.SetMediaItemInfo_Value(SelItemT[i],"D_LENGTH",len/2);
            reaper.SetMediaItemInfo_Value(SelItemT[i],"B_UISEL",1);
            reaper.SetEditCurPos(pos+len/2,false,false);
            reaper.Main_OnCommand(40698,0);--C
            reaper.Main_OnCommand(40058,0);--P
            table.insert(SelItemT_X,reaper.GetSelectedMediaItem(0,0));
            reaper.SelectAllMediaItems(0,0);   
        end;
        ---------------------------------------------
    end;
    ----
    reaper.SetEditCurPos(EditCursor_X,false,false);
    reaper.GetSet_ArrangeView2(0,1,0,0,start_time_X,end_time_X);
    if moveEnv_X then reaper.Main_OnCommand(40070,0)end;
    
    for i = 1, #SelItemT_X do;
        reaper.SetMediaItemInfo_Value(SelItemT_X[i],"B_UISEL",1);
    end;
    
    if #SelTrackT_X > 0 then;
        reaper.SetOnlyTrackSelected(SelTrackT_X[1]);
    else;
        reaper.SetOnlyTrackSelected(reaper.GetTrack(0,0));
        reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0,0),"I_SELECTED",0);
    end;
    
    for i = 1, #SelTrackT_X do;
        local Sel = reaper.GetMediaTrackInfo_Value(SelTrackT_X[i],"I_SELECTED");
        if Sel == 0 then;
            reaper.SetMediaTrackInfo_Value(SelTrackT_X[i],"I_SELECTED",1);
        end;
    end;  
    --clo2 = os.clock()-clo1
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Stutter 1/2 items",-1);
    --===========================================
	reaper.UpdateArrange();