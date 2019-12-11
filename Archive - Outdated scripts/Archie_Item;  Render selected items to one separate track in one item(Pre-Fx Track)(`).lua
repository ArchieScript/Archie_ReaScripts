-- NoIndex: true
--[[
   * Category:    Item
   * Description: Render selected items to one separate track in one item(Pre-Fx Track)
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Render selected items to one separate track in one item(Pre-Fx Track)
   *              Analog Studio one "Mixdown selection", only understands time selection and Pre-Fx Track
   * О скрипте:   Рендеринг выбранных элементов на одну отдельную дорожку в один файл(перед эффектами на треке)
   *              Аналог Студия один "Mixdown selection", только понимает выбор времени и перед эффектами на треке
   * GIF:         http://archiescript.github.io/ReaScriptSiteGif/html/RenderSelIemsToSingleTrackInSingleFile.html
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   Zerocool(RMM)
   * Changelog:   +  initialе / v.1.0 [210219]
   ==========================================================================================
   
   
   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
   + Reaper v.5.965 +           --| http://www.reaper.fm/download.php                      ||
   + SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 ||
   - ReaPack v.1.2.2 +          --| http://reapack.com/repos                               ||
   + Arc_Function_lua v.2.2.9 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   ||
   - reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr   ||
                                                                    http://clck.ru/Eo5Lw   ||
   ? Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                  ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]
   
   
   
   
   --======================================================================================
   --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
   --======================================================================================
    
    
    
    local Selected_Item = 1;
                    --  = 0 - ОСТАВИТЬ ВЫДЕЛЕНИЕ НА ПРЕДЫДУЩИХ ЭЛЕМЕНТАХ.
                    --  = 1 - ВЫДЕЛИТЬ ТОЛЬКО ОТРЕНДЕРЕННЫЙ ЭЛЕМЕНТ.
                    --  = 2 - ВЫДЕЛИТЬ ОТРЕНДЕРЕННЫЙ ЭЛЕМЕНТ И ОСТАВИТЬ ВЫДЕЛЕНИЕ НА ПРЕДЫДУЩИХ ЭЛЕМЕНТАХ.
                              ----------------------------------------------------------------------------
                    --  = 0 - TO LEAVE THE SELECTION TO THE PREVIOUS ELEMENTS.
                    --  = 1 - SELECT ONLY THE RENDERED ELEMENT.
                    --  = 2 - SELECT THE RENDERED ELEMENT AND LEAVE THE SELECTION ON THE PREVIOUS ELEMENTS.
                    ---------------------------------------------------------------------------------------
    
    
    
    local Selected_Track = 0;
                     --  = 0 - ОСТАВИТЬ ВЫДЕЛЕНИЕ НА ПРЕДЫДУЩИХ ТРЕКАХ.
                     --  = 1 - ВЫДЕЛИТЬ ОТРЕНДЕРЕННЫЙ ТРЕК И ОСТАВИТЬ ВЫДЕЛЕНИЕ НА ПРЕДЫДУЩИХ ТРЕКАХ.
                     --  = 2 - ВЫДЕЛИТЬ ТОЛЬКО ОТРЕНДЕРЕННЫЙ ТРЕК.
                               ----------------------------------
                     --  = 0 - TO LEAVE THE SELECTION TO THE PREVIOUS TRACKS.
                     --  = 1 - SELECT THE RENDERED TRACK AND LEAVE THE SELECTION ON THE PREVIOUS TRACKS.
                     --  = 2 - SELECT ONLY THE RENDERED TRACK.
                     ---------------------------------------- 
    
    
    
    local Send = 0;
            -- = 0 - РЕНДЕРИТЬ БЕЗ ПОСЫЛОВ
            -- = 1 - РЕНДЕРИТЬ С ПОСЫЛАМИ (БУДЬТЕ ОСТОРОЖНЫ С ПАПКАМИ)
                     -------------------------------------------------
            -- = 0 - RENDER WITHOUT SEND
            -- = 1 - RENDER WITH SEND (BE CAREFUL WITH THE FOLDERS)
            -------------------------------------------------------
    
    
    
    local Mute_Item = 1;
                 -- = 0 - НЕ ОТКЛЮЧАТЬ ЗВУК НА ПРЕДЫДУЩИХ ЭЛЕМЕНТАХ
                 -- = 1 - ОТКЛЮЧИТЬ ЗВУК НА ПРЕДЫДУЩИХ ЭЛЕМЕНТАХ
                          --------------------------------------
                 -- = 0 - DO NOT MUTE PREVIOUS ITEMS
                 -- = 1 - MUTE PREVIOUS ITEMS
                 ----------------------------
    
    
    
    local Mute_Solo_Track = 1;
                       -- = 0 - НЕ ИГНОРИРОВАТЬ MUTE / SOLO НА ТРЕКАХ
                       -- = 1 - ИГНОРИРОВАТЬ MUTE / SOLO НА ТРЕКАХ
                                ----------------------------------
                       -- = 0 - NOT IGNORE MUTE / SOLO UPON TRACKS
                       -- = 1 - IGNORE MUTE / SOLO UPON TRACKS
                       ---------------------------------------
    
    
    
    
   --======================================================================================
   --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
   --======================================================================================
    
    
    
    
    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.9",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================
    
    
    
    
    Selected_Item = tonumber(Selected_Item) or 1;
    Selected_Track = tonumber(Selected_Track) or 0;
    Send = tonumber(Send) or 0;
    Mute_Item = tonumber(Mute_Item) or 1;
    Mute_Solo_Track = tonumber(Mute_Solo_Track) or 1;
    
    
    local SWS = Arc.SWS_API(true);
    if not SWS then Arc.no_undo() return end;
    
    
    local countSelItem = reaper.CountSelectedMediaItems(0);
    if countSelItem == 0 then reaper.MB(
        "Rus:\n * Нет выбранных элементов !\n"..
        "Eng:\n * No selected items !",
        "Warning !!!",0);
        Arc.no_undo() return;
    end;
    
    
    local startLoop,endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    local Active,timeSelect;
    
    
    if startLoop ~= endLoop then;
        timeSelect = true;
        for i = 1, countSelItem do;
            local selItem = reaper.GetSelectedMediaItem(0,i-1);
            local positiIt = reaper.GetMediaItemInfo_Value(selItem,"D_POSITION");
            local endPosIt = Arc.GetMediaItemInfo_Value(selItem,"D_END");
            if positiIt < endLoop and endPosIt > startLoop then;
                Active = true;
                break;
            end;
        end;
    end;
    
    
    if not Active and timeSelect then;
        local mB = reaper.MB(
        "RUS:\n"..
        " * Отсутствуют выделенные элементы в выборе времени !\n"..
        " * Игнорировать выбор времени ?\n\n"..
        "Eng:\n"..
        " * No items selected in time selection !\n"..
        " * Ignore time selectuon ?"..
        "","Warning !!!",3);
        if mB == 2 then Arc.no_undo() return end;
        if mB == 6 then Active = nil  end;
        if mB == 7 then Active = true end;
    end;   -- 2-cancel, 6-yes, 7-no;
    
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    
    if not Active then;
        local PosFirstIt,EndLastIt = Arc.GetPositionOfFirstSelectedItemAndEndOfLast();   
        reaper.GetSet_LoopTimeRange(1,0,PosFirstIt,EndLastIt,0);
    end;
    ----
    
    Arc.SaveSelTracksGuidSlot(1);
    local MoveTrackIt = reaper.GetSelectedMediaItem(0,0);
    
    local m_It = {};
    if Mute_Item == 1 then;
        for i = 1, reaper.CountSelectedMediaItems(0) do;
            m_It[#m_It+1] = reaper.GetSelectedMediaItem(0,i-1);
        end;
    end;
    
    local lastTrack = reaper.GetTrack(0,reaper.CountTracks(0)-1);
    local lastFold = reaper.GetMediaTrackInfo_Value(lastTrack,"I_FOLDERDEPTH");
    local lastDepth = reaper.GetTrackDepth(lastTrack);
    local lastDepth = Arc.invert_number(lastDepth);
    reaper.SetMediaTrackInfo_Value(lastTrack,"I_FOLDERDEPTH",lastDepth);
    
    
    reaper.InsertTrackAtIndex(reaper.CountTracks(0),false);
    local trackR = reaper.GetTrack(0,reaper.CountTracks(0)-1);
    local volR = reaper.GetMediaTrackInfo_Value(trackR,"D_VOL");
    if volR ~= 1 then;
        reaper.SetMediaTrackInfo_Value(trackR,"D_VOL",1);
    end;
    reaper.SetMediaTrackInfo_Value(trackR,"I_FOLDERDEPTH",1);
    
    
    local CountTracks = reaper.CountTracks(0);
    for i = CountTracks-1,0,-1 do;
        local track = reaper.GetTrack(0,i);
        local countTrItem = reaper.CountTrackMediaItems(track);
        for i2 = 1, countTrItem do;
            local trItem = reaper.GetTrackMediaItem(track,i2-1);
            local sel = reaper.GetMediaItemInfo_Value(trItem,"B_UISEL");
            if sel == 1 then;
                reaper.InsertTrackAtIndex(reaper.CountTracks(0),false);
                local tr_x = reaper.GetTrack(0,reaper.CountTracks(0)-1);
                local retval, str = reaper.GetTrackStateChunk(track,"",false);
                reaper.SetTrackStateChunk(tr_x,str,false);
                local fold_x = reaper.GetMediaTrackInfo_Value(tr_x,"I_FOLDERDEPTH");
                if fold_x ~= 0 then;
                    reaper.SetMediaTrackInfo_Value(tr_x,"I_FOLDERDEPTH",0);
                end;
                
                --- IgnoreMuteTrack > ---
                if Mute_Solo_Track == 1 then;
                    local solo_x = reaper.GetMediaTrackInfo_Value(tr_x,"I_SOLO");
                    local mute_x = reaper.GetMediaTrackInfo_Value(tr_x,"B_MUTE");
                    if solo_x ~= 0 then;
                        reaper.SetMediaTrackInfo_Value(tr_x,"I_SOLO",0);
                    end;
                    if mute_x ~= 0 then;
                        reaper.SetMediaTrackInfo_Value(tr_x,"B_MUTE",0);
                    end;
                end;
                --- --------------- < ---
                
                --- FX > ----------------
                local FX_Count = reaper.TrackFX_GetCount(tr_x);
                for i3 = 1, FX_Count do;
                    reaper.TrackFX_SetEnabled(tr_x,i3-1,0);
                end;
                --- --------------- < ---
                
                Arc.RemoveAllItemTr_Sel(tr_x,0);
                
                Arc.RemoveAllSendTr(tr_x,0);
                Arc.RemoveAllSendTr(tr_x,-1);
                
                --- Send > --------------
                if Send == 1 then;
                    local CountSend = reaper.GetTrackNumSends(track,0);-- < 0 receives,0 = send;
                    for i4 = 1, CountSend do;
                        local sendTrack = reaper.BR_GetMediaTrackSendInfo_Track(track,0,i4-1,1);
                        
                        local retval, strSend = reaper.GetTrackStateChunk(sendTrack,"",false);
                        reaper.InsertTrackAtIndex(reaper.CountTracks(0),false);
                        local tr_Send_x = reaper.GetTrack(0,reaper.CountTracks(0)-1);
                        reaper.SetTrackStateChunk(tr_Send_x,strSend,false);
                        
                        local fold_Send_x = reaper.GetMediaTrackInfo_Value(tr_Send_x,"I_FOLDERDEPTH");
                        if fold_Send_x ~= 0 then;
                            reaper.SetMediaTrackInfo_Value(tr_Send_x,"I_FOLDERDEPTH",0);
                        end;
                        Arc.RemoveAllSendTr(tr_Send_x,0);
                        Arc.RemoveAllSendTr(tr_Send_x,-1);
                        
                        reaper.CreateTrackSend(tr_x,tr_Send_x);
                        Arc.RemoveAllItemTr_Sel(tr_Send_x,2);-- 2=All
                    end;
                end;
                --- --------------- < ---
                break;
            end;
        end;
    end;
    
    
    reaper.SetOnlyTrackSelected(trackR);
    Arc.Action(41716);--Rend P - f
    
    
    local numbTrackR = reaper.GetMediaTrackInfo_Value(trackR,"IP_TRACKNUMBER");
    local CountTracks = reaper.CountTracks(0);
    for i = CountTracks-1, numbTrackR-1,-1 do;
        local track = reaper.GetTrack(0,i);
        reaper.DeleteTrack(track);
    end;
    
    
    local lastTrack_R = reaper.GetTrack(0,reaper.CountTracks(0)-1);
    if lastTrack_R ~= lastTrack then;
        --- RenameTr/It > ----------
        reaper.GetSetMediaTrackInfo_String(lastTrack_R,"P_NAME","RendSelItOneTrackOneIt",1);
        local item = reaper.GetTrackMediaItem(lastTrack_R,0);
        local take = reaper.GetActiveTake(item);
        reaper.GetSetMediaItemTakeInfo_String(take,"P_NAME","RendSelItOneTrackOneIt",1);
        --- --------------- < ---
        --- MoveTr > ------------
        local MoveTrack = reaper.GetMediaItem_Track(MoveTrackIt);
        if MoveTrack then;
            local numbTrMove = reaper.GetMediaTrackInfo_Value(MoveTrack,"IP_TRACKNUMBER");
            reaper.ReorderSelectedTracks(numbTrMove-1,0);
        end;
        --- --------------- < ---
        --- Sel_It > ------------
        if Selected_Item == 1 then;
            reaper.SelectAllMediaItems(0,0);
            local item = reaper.GetTrackMediaItem(lastTrack_R,0);
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
        elseif Selected_Item == 2 then
            local item = reaper.GetTrackMediaItem(lastTrack_R,0);
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
        end;
        --- --------------- < ---
        --- Mute_It > -----------
        if Mute_Item == 1 then;
            for i = 1, #m_It do;
                reaper.SetMediaItemInfo_Value(m_It[i],"B_MUTE",1);
            end;
        end;
        --- --------------- < ---
        --- Sel_Tr > ------------
        if Selected_Track == 0 then;
            Arc.RestoreSelTracksGuidSlot(1,true);
        elseif Selected_Track == 1 then;
            Arc.RestoreSelTracksGuidSlot(1,true);
            reaper.SetMediaTrackInfo_Value(lastTrack_R,"I_SELECTED",1);
        end;
        --- --------------- < ---
    else;
        Arc.RestoreSelTracksGuidSlot(1,true);
    end;
    
    
    reaper.SetMediaTrackInfo_Value(lastTrack,"I_FOLDERDEPTH",lastFold);
    -------------
    
    if not Active then;
        reaper.GetSet_LoopTimeRange(1,0,startLoop,endLoop,0);
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Render selected items to one separate track in one item(Pre-Fx Track)",-1);
    reaper.UpdateArrange();