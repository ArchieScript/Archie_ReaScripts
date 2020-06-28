--[[
   * Category:    Grid
   * Description: Free movement of item(s) when snap to grid is on
   * Author:      Archie
   * Version:     1.08
   * AboutScript: Free movement of item(s) when snap to grid is enabled
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Свободное перемещение элементов при включенной привязке к сетке
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         http://clck.ru/EgA56
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   Alex Menco(Rmm/forum) 
   * Changelog:   

   *              +  HelpWindowWhenReRunning(Reascript task control) / v.1.04 [16022019]
   *              +  добавлен список системные требования: / v.1.03 [04122018]
   *              +  added a list of the system requirements: / v.1.03 [04122018]
   *              +! Fixed bug when deleting active item in small size / v.1.02 [14.11.18]
   *              +! Исправлена ошибка при удалении активного айтема в маленьком размере / v.1.02 [14.11.18]
   *              +! Fixed bug with not displaying tooltips in MIDI editor / v.1.01
   *              +! Исправлена ошибка с отображением всплывающих подсказок в миди-редакторе / v.1.01
   *              +  initialе / v.1.0
   ===========================================================================================|

   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.962 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.5 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   + reaper_js_ReaScriptAPI.. -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   ? Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
   ==========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================




    --===========/ПРИВЯЗКА К КУРСОРУ РЕДАКТИРОВАНИЯ/ SNAP TO EDIT CURSOR /======--

    local snapToEditCur = 1
                     -- = 0 | ЭЛЕМЕНТ НЕ БУДЕТ ПРИЛИПАТЬ К КУРСОРУ РЕДАКТИРОВАНИЯ.
                     -- = 1 | ЭЛЕМЕНТ БУДЕТ ПРИЛИПАТЬ К КУРСОРУ РЕДАКТИРОВАНИЯ.
                                            -----------------------------------
                     -- = 0 | THE ITEM WILL NOT STICK TO THE EDIT CURSOR.
                     -- = 1 | THE ITEM WILL STICK TO THE EDIT CURSOR.
                     --==============================================
            
                     
    --=========/ ПРИВЯЗКА К ВЫБОРУ ВРЕМЕНИ / SNAP TO TIME SELECTION /==========--

    local snapToLoop = 1             
                  -- = 0 | ЭЛЕМЕНТ НЕ БУДЕТ ПРИЛИПАТЬ К ВЫБОРУ ВРЕМЕНИ.
                  -- = 1 | ЭЛЕМЕНТ БУДЕТ ПРИЛИПАТЬ К ВЫБОРУ ВРЕМЕНИ. 
                                         ---------------------------
                  -- = 0 | THE ITEM WILL STICK TO THE TIME SELECTION. 
                  -- = 1 | THE ITEM WILL NOT  STICK TO THE TIME SELECTION. 
                  --======================================================


    --==================/ ПРИВЯЗКА К ЭЛЕМЕНТУ / SNAP TO ITEM /===================--
    
    local snapToitem = 3
                  -- = 0 | ОТКЛ ПРИВЯЗКУ К ЭЛЕМЕНТУ
                  -- = 1 | ЭЛЕМЕНТ БУДЕТ ПРИЛИПАТЬ ТОЛЬКО К НАЧАЛЬНЫМ ПОЗИЦИЯМ ЭЛЕМЕНТОВ.
                  -- = 2 | ЭЛЕМЕНТ БУДЕТ ПРИЛИПАТЬ ТОЛЬКО К КОНЕЧНЫМ ПОЗИЦИЯМ ЭЛЕМЕНТОВ. 
                  -- = 3 | ЭЛЕМЕНТ БУДЕТ ПРИЛИПАТЬ К НАЧАЛЬНЫМ  И КОНЕЧНЫМ ПОЗИЦИЯМ ЭЛЕМЕНТОВ  
                                                ---------------------------------------------
                  -- = 0 | OFF SNAP TO ITEM  
                  -- = 1 | THE ITEM WILL ONLY ADHERE TO THE INITIAL POSITIONS OF THE ITEM 
                  -- = 2 | THE ITEM WILL ONLY ADHERE TO THE END POSITIONS OF THE ITEM 
                  -- = 3 | THE ITEM WILL STICK TO THE START AND END POSITIONS OF THE ITEM  
                  --=====================================================================


    local StartEnd = 2
         -- = 0 | ПЕРЕМЕЩАЕМЫЕ ЭЛЕМЕНТЫ БУДУТ ПРИЛИПАТЬ ТОЛЬКО НАЧАЛЬНОЙ ПОЗИЦИЕЙ. 
         -- = 1 | ПЕРЕМЕЩАЕМЫЕ ЭЛЕМЕНТЫ БУДУТ ПРИЛИПАТЬ ТОЛЬКО КОНЕЧНОЙ ПОЗИЦИЕЙ. 
         -- = 2 | ЕСЛИ МЫШЬ В ПЕРВОЙ(ЛЕВОЙ) ПОЛОВИНЕ ЭЛЕМЕНТА, ТО ЭЛЕМЕНТЫ БУДУТ ПРИЛИПАТЬ НАЧАЛЬНОЙ ПОЗИЦИЕЙ. 
         --       ЕСЛИ МЫШЬ ВО ВТОРОЙ(ПРАВОЙ) ПОЛОВИНЕ ЭЛЕМЕНТА, ТО ЭЛЕМЕНТЫ БУДУТ ПРИЛИПАТЬ КОНЕЧНОЙ ПОЗИЦИЕЙ. 
                                       ------------------------------------------------------------------------
         -- = 0 | THE MOVED ELEMENTS WILL ONLY STICK TO THE STARTING POSITION.
         -- = 1 | THE ELEMENTS TO BE MOVED WILL STICK ONLY TO THE END POSITION.
         -- = 2 | IF THE MOUSE IS IN THE FIRST (LEFT) HALF OF THE ELEMENT, THEN THE ELEMENTS WILL STICK TO THE STARTING POSITION.
         --       IF THE MOUSE IS IN THE SECOND (RIGHT) HALF OF THE ELEMENT, THEN THE ELEMENTS WILL STICK TO THE FINAL POSITION.
         --====================================================================================================================




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	



    local SWS = Arc.SWS_API(true);
    if not SWS then Arc.no_undo() return end;
    
    local js_API = Arc.js_ReaScriptAPI(true);
    if not js_API then Arc.no_undo() return end;
    
    Arc.HelpWindowWhenReRunning(1,"FreeMovOfItemWhenSnapToGridIsOn",false);


    local function If_Equals(EqualsToThat,...);
        for _,v in ipairs {...} do;
            if v == EqualsToThat then return true end;
        end;
        return false;
    end;
    
    
    
    if not If_Equals(snapToEditCur,0,1)then snapToEditCur = 1 end;
    if not If_Equals(snapToLoop,0,1) then snapToLoop = 1 end;
    if not If_Equals(snapToitem,0,1,2,3)then snapToitem = 3 end;
    if not If_Equals(StartEnd,0,1,2)then StartEnd = 2 end;
    
    
 
    local function GetSetClosestGridLoopItemDivision(Set,item,snapToGrid,snapToEditCur,snapToLoop,snapToitem,MoveToSel,StartEnd);
        local distanceToItemStr,distanceToItemEnd,distanceToGrid_End,distanceToGrid_Str,distanceToEditCurStr,
             POS_X,END_X,moveTo,distanceToLoopSta,distanceToLoopEnd,move_it,ClosLoopEnd,ClosLoopStr,distanceToEditCurEnd,
             distanceToLoop_Sta,distanceToLoop_End,distanceToItemEnd_End,distanceToItemStr_End,POS_X_End,END_X_End;
        local tr = reaper.GetMediaItem_Track(item);
        local TrackNumb = (reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER"));
        local posItem = reaper.GetMediaItemInfo_Value(item, "D_POSITION");
        local LenItem = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
        local endItem = posItem + LenItem 
        local StrPosGrid = reaper.SnapToGrid(0,posItem);
        local endPosGrid = reaper.SnapToGrid(0,endItem);
        local Startloop,Endloop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        local EditCur = reaper.GetCursorPosition();

        if snapToGrid == 1 then;
            if StartEnd ~= 1 then;
                distanceToGrid_Str = math.abs(posItem - StrPosGrid);
            elseif StartEnd == 1 then;    
                distanceToGrid_End = math.abs(endItem - endPosGrid);
            end;
        end;

        if snapToEditCur == 1 then;
            if StartEnd ~= 1 then;
                distanceToEditCurStr = math.abs (posItem - EditCur);
            elseif StartEnd == 1 then;
                distanceToEditCurEnd = math.abs (endItem - EditCur);
            end;                
        end;

        if snapToLoop == 1 then;
            if StartEnd ~= 1 then;
                distanceToLoop_Sta = math.abs (posItem - Startloop);
                distanceToLoop_End = math.abs (posItem - Endloop);
                distanceToLoopSta = math.min(distanceToLoop_Sta,distanceToLoop_End);
                if distanceToLoopSta == distanceToLoop_End then ClosLoopStr = Endloop end;
                if distanceToLoopSta == distanceToLoop_Sta then ClosLoopStr = Startloop end;
            elseif StartEnd == 1 then;
                distanceToLoop_Sta = math.abs (endItem - Startloop);
                distanceToLoop_End = math.abs (endItem - Endloop);
                distanceToLoopEnd = math.min(distanceToLoop_Sta,distanceToLoop_End);
                if distanceToLoopEnd == distanceToLoop_End then ClosLoopEnd = Endloop end;
                if distanceToLoopEnd == distanceToLoop_Sta then ClosLoopEnd = Startloop end;
            end;
        end;

        if snapToitem > 0 and snapToitem <= 3 then;
            distanceToItemStr,distanceToItemEnd         = 9^99,9^99;
            distanceToItemStr_End,distanceToItemEnd_End = 9^99,9^99;
            for i = reaper.CountMediaItems(0)-1,0,-1 do;
                local it = reaper.GetMediaItem(0,i);
                local Sel = (reaper.IsMediaItemSelected(it)and 1 or 0);
                local tr = reaper.GetMediaItem_Track(it);
                local Number = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER");

                if not tonumber(MoveToSel) then MoveToSel = 2 end;
                if MoveToSel < 0 or MoveToSel > 1 then Sel = MoveToSel end;
                if Sel == MoveToSel then;

                    if Number > (TrackNumb-10-1) and Number < (TrackNumb+10+1) then;-- 10 tracks
                        if it ~= item then;
                            local POS = reaper.GetMediaItemInfo_Value(it, "D_POSITION");
                            local End = (reaper.GetMediaItemInfo_Value(it, "D_LENGTH")+POS);

                            if StartEnd ~= 1 then;
                            
                                if snapToitem == 1 or snapToitem == 3 then;
                                    local distanceIt_Str = math.abs (posItem - POS);
                                    if distanceIt_Str <= distanceToItemStr then;
                                        distanceToItemStr = distanceIt_Str;
                                        POS_X = POS;
                                    end;
                                end;

                                if snapToitem == 2 or snapToitem == 3 then;
                                    local distanceIt_end = math.abs (posItem - End);
                                    if distanceIt_end <= distanceToItemEnd then;
                                        distanceToItemEnd = distanceIt_end;
                                        END_X = End;
                                    end;
                                end;
                            elseif StartEnd == 1 then;  

                                if snapToitem == 1 or snapToitem == 3 then;
                                    local distanceIt_Str_End = math.abs (endItem - POS);
                                    if distanceIt_Str_End <= distanceToItemStr_End then;
                                        distanceToItemStr_End = distanceIt_Str_End;
                                        POS_X_End = POS;
                                    end;
                                end;

                                if snapToitem == 2 or snapToitem == 3 then;
                                    local distanceIt_end_End = math.abs (endItem - End);
                                    if distanceIt_end_End <= distanceToItemEnd_End then;
                                        distanceToItemEnd_End = distanceIt_end_End;
                                        END_X_End = End;
                                    end;
                                end;

                            end;
                        end;
                    end;
                end;
            end;
        end;

        local Move = math.min(distanceToGrid_Str    or 9^99,  distanceToGrid_End   or 9^99,
                              distanceToEditCurStr  or 9^99,  distanceToEditCurEnd or 9^99,
                              distanceToLoopSta     or 9^99,  distanceToLoopEnd    or 9^99,
                              distanceToItemStr     or 9^99,     distanceToItemEnd or 9^99,
                              distanceToItemStr_End or 9^99, distanceToItemEnd_End or 9^99);

        if Move == distanceToGrid_Str then moveTo = StrPosGrid end;
        if Move == distanceToGrid_End then moveTo = endPosGrid-LenItem end;

        if Move == distanceToEditCurStr then moveTo = EditCur  end;
        if Move == distanceToEditCurEnd then moveTo = EditCur-LenItem end;

        if Move == distanceToLoopSta    then moveTo = ClosLoopStr end;
        if Move == distanceToLoopEnd    then moveTo = ClosLoopEnd-LenItem end;

        if Move == distanceToItemStr then moveTo = POS_X    end;
        if Move == distanceToItemEnd then moveTo = END_X    end;

        if POS_X_End then
            if Move == distanceToItemStr_End then moveTo = POS_X_End-LenItem end;
        end
        if END_X_End then
            if Move == distanceToItemEnd_End then moveTo = END_X_End-LenItem end;
        end

        if not moveTo then moveTo = posItem end;

        if Set == 1 then;
            reaper.SetMediaItemInfo_Value(item, "D_POSITION",moveTo);
            move_it = (moveTo-posItem)
        else;
            move_it = 0.0    
        end;

        return move_it,item,StrPosGrid,endPosGrid,EditCur,Startloop,Endloop, posItem, endItem;
    end;
    ------------------------------------------------------------------------------------------




    local function MoveAllBesidesActiveOnOffset(Item,Offset);
        for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
            local Sel_it = reaper.GetSelectedMediaItem(0,i);
            if Sel_it ~= Item then;
                local Pos = reaper.GetMediaItemInfo_Value(Sel_it,"D_POSITION");
                reaper.SetMediaItemInfo_Value(Sel_it,"D_POSITION",Pos + Offset);
            end;
        end;
    end;
    ----------------------------------------------------------------------------




    local lockFal,lockTru
    local function ToDisableOnEdge(item);

        local itemPOS = reaper.GetMediaItemInfo_Value(item, "D_POSITION");
        local itemEND = (reaper.GetMediaItemInfo_Value(item, "D_LENGTH")+itemPOS);
        local start_time, end_time = reaper.GetSet_ArrangeView2( 0, 0, 0, 0 );
        local ArrangeView = (end_time - start_time)/170;
        local CurPos = reaper.BR_GetMouseCursorContext_Position();
        local Mouse = reaper.JS_Mouse_GetState(1);

        if Mouse == 0 then lockFal = nil lockTru = nil end;

        if item then;

            if not lockFal then;
                if  CurPos <= (itemPOS + ArrangeView) or
                    CurPos >= (itemEND - ArrangeView) then;
                    if Mouse == 1 then;
                        if not lockTru then;
                            lockFal = 1;
                        end;
                    end;
                end;
            end; 

            if not lockTru then;
                if  CurPos > (itemPOS + ArrangeView) and 
                    CurPos < (itemEND - ArrangeView) then;
                    if Mouse == 1 then;
                        if not lockFal then;
                            lockTru = 1;
                        end;
                    end;
                end;
            end;
        end;
        if lockFal == 1 then return false elseif lockTru == 1 then return true end;
    end;
    -------------------------------------------------------------------------------




    local posClick, x_1, x_2, y, block, blockMovecur,ActiveMouse,StartEndActive,posMouse,itemAct,itemXX;
    local function loop();

        local Context = reaper.GetCursorContext2(false);
        if Context == 1 then;
    
            local Toggle = reaper.GetToggleCommandState(1157); -- Toggle snapping
            if Toggle == 1 or ActiveMouse then;
    
                local window, segment, details = reaper.BR_GetMouseCursorContext();
                local item = reaper.BR_GetMouseCursorContext_Item();
    
                if item or itemAct then;
                    if itemAct then item = itemAct end;
                    local DisableOnEdge = ToDisableOnEdge(item)
                    local Mouse = reaper.JS_Mouse_GetState(1); 
                    if Mouse == 1 then;
    
                        if DisableOnEdge == true then;
    
                            if not block then;
                                itemAct = item
                                posClick = reaper.GetMediaItemInfo_Value(item, "D_POSITION");
                                reaper.Main_OnCommand(40753,0); -- Disable snap
                                x_1,y = reaper.GetMousePosition();
                                -----
                                if StartEnd == 2 then;
                                    local Len_It = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
                                    posMouse=reaper.BR_PositionAtMouseCursor(x_1);
                                    if posMouse < posClick + (Len_It/2) then;
                                        StartEnd = 0;
                                    else;
                                        StartEnd = 1;
                                    end;
                                    StartEndActive = "Active";
                                end;
                                -----
                                block = 1;
                                ActiveMouse = "Active";
                            end;
    
                            if not blockMovecur then; 
                                x_2,y = reaper.GetMousePosition();
                                if x_1 > x_2 then;
                                    x_2 = x_2 - 4;
                                elseif x_1 < x_2 then;
                                    x_2 = x_2 + 4;
                                end;
                                if x_1 ~= x_2 then;
                                    reaper.JS_Mouse_SetPosition(x_2, y);
                                    blockMovecur = 1;
                                end;
                            end;
                        end;
                      
                         itemXX = reaper.BR_GetMouseCursorContext_Item();
                         if itemXX then
                             local Sel = (reaper.IsMediaItemSelected(itemXX)and 1 or 0);
                             if Sel == 1 then;
                                 itemAct = itemXX;
                             end; 
                         end; 
                    else;
     
                        if block == 1 then;
                        ---
                            local item_ = reaper.BR_GetMouseCursorContext_Item();
                            if item_ then;
                                local Sel = (reaper.IsMediaItemSelected(item_)and 1 or 0);
                                if Sel == 0 then;
                                    item_ = nil;
                                end;
                            end;
                            if item_ then;
                                item = item_;
                            else;
                                if not item then item = itemAct end;
                            end;          
    
                            reaper.Main_OnCommand(40754, 0); -- Enable snap
                            local Shift = reaper.JS_Mouse_GetState(8);
                            --[[--
                            for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
                                local Sel_it_ = reaper.GetSelectedMediaItem(0,i);
                                local pos_ = reaper.GetMediaItemInfo_Value(Sel_it_, "D_POSITION");
                                if pos_ == 0 then Shift = 8 break end; 
                            end;
                            --]]--
                            if Shift ~= 8 then;
                                local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION");
                                if pos ~= posClick then;
    
                                    Offset = GetSetClosestGridLoopItemDivision(1,item,1,snapToEditCur,snapToLoop,snapToitem,0,StartEnd);
                                    ---
                                    if Offset then;
                                        MoveAllBesidesActiveOnOffset(item,Offset);
                                    end;
                                    ---
                                end;
                            end;
                            if StartEndActive then StartEnd = 2 end;
                            itemAct = nil
                            block = nil;
                        end;
                        ActiveMouse = nil;
                        blockMovecur = nil;
                        Offset = nil;
                        itemAct = nil;
                    end;
                end;
            end;
        end;
        reaper.defer(loop);
    end;
    -----------------------


    local function SetToggleButtonOnOff(numb); -- 1 = On ; 0 = Off  
        local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0);
        reaper.RefreshToolbar2(sec,cmd);
    end
    -----------------------------------


    SetToggleButtonOnOff(1);
    loop();
    reaper.atexit( SetToggleButtonOnOff );