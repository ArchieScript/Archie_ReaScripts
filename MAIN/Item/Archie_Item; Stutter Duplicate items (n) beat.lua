--[[ 
     Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Item 
   * Description: Stutter Duplicate items (n) beat 
   * Author:      Archie 
   * Version:     1.01 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    ---(---) 
   * Gave idea:   ---(---) 
   * Provides:     
   *              [main] . > Archie_Item; Stutter Duplicate items 1 beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.2 beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.2T beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.4 beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.4T beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.8 beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.8T beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.16 beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.16T beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.32 beat.lua 
   *              [main] . > Archie_Item; Stutter Duplicate items 1.32T beat.lua 
   * Changelog:    
   *              v.1.01 [02.10.19] 
   *                  + copying automation 
    
   *              v.1.0 [18.08.19] 
   *                  + initialе 
--]] 
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    --===================================================== 
    local function no_undo()reaper.defer(function()end)end; 
    --===================================================== 
     
     
    local scrNameT = { 
                      "Archie_Item; Stutter Duplicate items 1 beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.2 beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.2T beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.4 beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.4T beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.8 beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.8T beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.16 beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.16T beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.32 beat.lua", 
                      "Archie_Item; Stutter Duplicate items 1.32T beat.lua" 
                     }; 
     
     
    local scrName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)"); 
     
     
    if scrName == scrNameT[1] then; 
        division = (4/ 1)       --1     beat 
    elseif scrName == scrNameT[2] then; 
        division = (4/ 2)       --1/2   beat 
    elseif scrName == scrNameT[3] then; 
        division = (4/(2*1.5))  --1/2T  beat 
    elseif scrName == scrNameT[4] then; 
        division = (4/ 4)       --1/4   beat 
    elseif scrName == scrNameT[5] then; 
        division = (4/(4*1.5))  --1/4T  beat 
    elseif scrName == scrNameT[6] then; 
        division = (4/ 8)       --1/8   beat 
    elseif scrName == scrNameT[7] then; 
        division = (4/(8*1.5))  --1/8T  beat  
    elseif scrName == scrNameT[8] then; 
        division = (4/ 16)      --1/16  beat 
    elseif scrName == scrNameT[9] then; 
        division = (4/(16*1.5)) --1/16T beat 
    elseif scrName == scrNameT[10] then; 
        division = (4/ 32)      --1/32  beat 
    elseif scrName == scrNameT[11] then; 
        division = (4/(32*1.5)) --1/32T beat 
    else; 
        reaper.MB("Eng:\n* Invalid script name\n* The script name must be one of the following\n\n".. 
                  "Rus:\n* Неверное имя скрипта\n* Имя скрипта должно быть одно из следующих\n".. 
                  ("-"):rep(50).."\n\n\n".. 
                  table.concat(scrNameT,"\n"), 
                  "Error",0); 
        no_undo() return; 
    end; 
     
    local Undo = scrName:match("^%s-Archie_Item;%s-(%S.+)%.lua$")or""; 
     
     
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
    for i = 1, reaper.CountSelectedMediaItems(0) do; 
        table.insert(SelItemT,reaper.GetSelectedMediaItem(0,i-1)); 
    end; 
     
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
        -------------------------------------------------- 
        local firstEndIt = math.huge; 
        for i = #SelItemT,1,-1 do; 
            local trackIt = reaper.GetMediaItem_Track(SelItemT[i]); 
            if not unSelTr then; 
                reaper.SetOnlyTrackSelected(trackIt);unSelTr = true; 
            end; 
            ---- 
            local Sel = reaper.GetMediaTrackInfo_Value(trackIt,"I_SELECTED"); 
            if Sel == 0 then; 
                reaper.SetMediaTrackInfo_Value(trackIt,"I_SELECTED",1); 
            end; 
            ----- 
            local pos = reaper.GetMediaItemInfo_Value(SelItemT[i],"D_POSITION");  
            local beat = reaper.TimeMap_timeToQN_abs(0,pos); 
            local TimeNext = reaper.TimeMap_QNToTime_abs(0,beat+division); 
            reaper.SetMediaItemInfo_Value(SelItemT[i],"D_LENGTH",TimeNext-pos); 
            if TimeNext < firstEndIt then firstEndIt = TimeNext end; 
        end; 
        ---- 
        reaper.SetEditCurPos(firstEndIt,false,false); 
        reaper.Main_OnCommand(40698,0)--C 
        reaper.Main_OnCommand(40058,0)--P 
        ------------------------------------------------------ 
    else; 
        ------------------------------------------------------ 
        local SelItemT_X = {}; 
        reaper.SelectAllMediaItems(0,0); 
        for i = 1,#SelItemT do; 
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
            local beat = reaper.TimeMap_timeToQN_abs(0,pos); 
            local TimeNext = reaper.TimeMap_QNToTime_abs(0,beat+division); 
            reaper.SetMediaItemInfo_Value(SelItemT[i],"D_LENGTH",TimeNext-pos); 
            reaper.SetMediaItemInfo_Value(SelItemT[i],"B_UISEL",1); 
            reaper.SetEditCurPos(TimeNext,false,false); 
            reaper.Main_OnCommand(40698,0)--C 
            reaper.Main_OnCommand(40058,0)--P 
            local firstIt = reaper.GetSelectedMediaItem(0,0); 
            table.insert(SelItemT_X,firstIt); 
            reaper.SetMediaItemInfo_Value(firstIt,"B_UISEL",0); 
        end; 
        ---- 
        for i = 1,#SelItemT_X do; 
            reaper.SetMediaItemInfo_Value(SelItemT_X[i],"B_UISEL",1);  
        end; 
        ------------------------------------------------------ 
    end; 
     
    reaper.SetEditCurPos(EditCursor_X,false,false); 
    reaper.GetSet_ArrangeView2(0,1,0,0,start_time_X,end_time_X); 
    if moveEnv_X then reaper.Main_OnCommand(40070,0)end; 
     
    reaper.Undo_EndBlock(Undo,-1); 
    reaper.PreventUIRefresh(-1); 
    --clo2 = os.clock()-clo1 
    --====================== 
    reaper.UpdateArrange(); 