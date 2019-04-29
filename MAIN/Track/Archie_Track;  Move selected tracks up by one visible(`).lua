--[[
   * Category:    Track
   * Description: Move selected tracks up by one visible*
   * Author:      Archie
   * Version:     1.07
   * AboutScript: Move selected tracks up by one visible*
   * О скрипте:   Переместить выбранные треки вверх на один видимый*
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1[RMM]
   * Gave idea:   smrz1[RMM]
   * Provides:    
   *              [main] . > Archie_Track;  Move selected tracks up by one visible(`).lua
   *              [main] . > Archie_Track;  Move selected tracks up by one visible (skip folders)(`).lua
   *              [main] . > Archie_Track;  Move selected tracks up by one visible (request to skip folders)(`).lua
   *              [main] . > Archie_Track;  Move selected tracks up by one visible (skip minimized folders)(`).lua
   * Changelog:   
   *              + Fixed bug when moving from folder to folder / from folder - skip folder / v.1.07 [29042019]

   *              + Scrolling Mixer / v.1.06 [11042019] 
   *              + Scrolling in place / v.1.05 [09042019]
   *              + Ignoring tracks in collapsed folders when scrolling / v.1.03 [06042019]
   *              + indent when scrolling / v.1.01 [05042019]
   *              +  initialе / v.1.0 [04042019]
  
   
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                     
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (+) Arc_Function_lua v.2.3.6 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (+*) reaper_js_ReaScriptAPI    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --| http://clck.ru/Eq5o6                                
   =======================================================================================]]
   
    
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    local Scroll = 2
             --  = 0 | OFF | ВЫКЛЮЧИТЬ СКРОЛЛИНГ \ DISABLE SCROLLING                            
             --  = 1 | ON  | ВКЛЮЧИТЬ СКРОЛЛИНГ  \ ENABLE SCROLLING
             --  = 2 | *ПРОКРУТКА НА МЕСТЕ \ SCROLLING IN PLACE; требуется/requires - reaper_js_ReaScriptAPI*)
             ------------------------------------------------------------------------------------------------- 
    
    
    local indent = 1
                -- | ОТСТУП ПРИ ПРОКРУТКЕ, (В ТРЕКАХ); Работает только при "Scroll = 1"
                -- | INDENT WHEN SCROLLING, (IN TRACKS); Works only when "Scroll = 1"
                ---------------------------------------------------------------------
    
    
    local Ignore_superCollapse = 1 -- Работает только при / Works only when  "Scroll = 1"
                             -- = 0 | НЕ ИГНОРИРОВАТЬ ТРЕКИ У СВЕРНУТЫХ ПАПОК ПРИ СКРОЛЛЕ
                             -- = 1 | ИГНОРИРОВАТЬ ТРЕКИ У СВЕРНУТЫХ ПАПОК ПРИ СКРОЛЛЕ
                                      ------------------------------------------------
                             -- = 0 | DO NOT IGNORE TRACKS IN MINIMIZED FOLDERS WHEN SCROLLING
                             -- = 1 | IGNORE TRACKS IN MINIMIZED FOLDERS WHEN SCROLLING
                             ----------------------------------------------------------
    
    
    local MixerScroll = 1
            --  = 0 | OFF | ВЫКЛЮЧИТЬ СКРОЛЛИНГ В МИКШЕРЕ \ DISABLE SCROLLING IN MIXER
            --  = 1 | ON  | ВКЛЮЧИТЬ СКРОЛЛИНГ В МИКШЕРЕ \ ENABLE SCROLLING IN MIXER
            ------------------------------------------------------------------------ 
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.3.6",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    
    if not Arc.SWS_API(true)then Arc.no_undo()return end;
    
    if not indent or type(indent)~= "number" then indent = 1 end;
    if indent >= 0 and indent <= 50 then indent = indent else indent = 1 end;
    
    local
    Script_Name = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");
    
    if not Arc.If_Equals(Script_Name,
                         "Archie_Track;  Move selected tracks up by one visible(`).lua",
                         "Archie_Track;  Move selected tracks up by one visible (skip folders)(`).lua",
                         "Archie_Track;  Move selected tracks up by one visible (request to skip folders)(`).lua",
                         "Archie_Track;  Move selected tracks up by one visible (skip minimized folders)(`).lua")then;
        reaper.MB("Rus:\n\n"..
                  " * Неверное имя скрипта !\n * Имя скрипта должно быть одно из следующих \n"..
                  "    в зависимости от задачи. \n\n\n"..
                  "Eng:\n\n * Invalid script name ! \n"..
                  " * The script name must be one of the following \n"..
                  "    depending on the task.\n"..
                  "-------\n\n\n"..
                  "Script Name: / Имя скрипта:\n\n"..
                  "   Archie_Track;  Move selected tracks up by one visible(`).lua \n\n"..
                  "   Archie_Track;  Move selected tracks up by one visible (skip folders)(`).lua \n\n"..
                  "   Archie_Track;  Move selected tracks up by one visible (request to skip folders)(`).lua\n\n"..
                  "   Archie_Track;  Move selected tracks up by one visible (skip minimized folders)(`).lua",
                  "ERROR !",0);
        Arc.no_undo() return;
    end;
    
    
    
    
    local function GetScrollTrack(track);
        if reaper.APIExists("JS_Window_FindChildByID")then;
            if type(track)~= "userdata" then error("GetScrollTrack (MediaTrack expected)",2)end; 
            local Numb = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER");
            local height;
            for i = 1,Numb-1 do;
                local Track = reaper.GetTrack(0,i-1);
                local wndh = reaper.GetMediaTrackInfo_Value( Track, "I_WNDH");
                height = (height or 0)+wndh;
            end;
            local trackview = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(),1000);
            local _, position = reaper.JS_Window_GetScrollInfo(trackview,"v");
            return (height or 0) - position;
        else;
            reaper.ShowConsoleMsg("");
            reaper.ShowConsoleMsg("требуется расширение  - 'reaper_js_ReaScriptAPI'\n"..
                                  "либо отключите скролл на месте\n\n"..
                                  "require extension is requi - reaper_js_ReaScriptAPI\n"..
                                  "or disable scroll in place");
        end;
    end;
     
    
    
    local function SetScrollTrack(track, numbPix);
        if reaper.APIExists("JS_Window_FindChildByID")then;
            if type(track)~= "userdata" then error("SetScrollTrack (MediaTrack expected)",2)end;
            local Numb = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER");
            local height;
            for i = 1,Numb-1 do;
                local Track = reaper.GetTrack(0,i-1);
                local wndh = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                height = (height or 0)+wndh;
            end;
            local trackview = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(),1000);
            local _, position = reaper.JS_Window_GetScrollInfo(trackview,"v");
            reaper.JS_Window_SetScrollPos(trackview,"v",(height or 0)-(numbPix or position));
        end;
    end;
    
    
    
    local function SetMixerScroll(tr);
        reaper.defer(function();reaper.SetMixerScroll(tr);return;end);
    end;
    
    
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then Arc.no_undo() return end;
    
    
    reaper.PreventUIRefresh(1);
    
    
    local VisibTCPGuid = {};
    for i = reaper.CountSelectedTracks(0),1,-1 do;
        local track = reaper.GetSelectedTrack(0,i-1);
        VisibTCPGuid[i] = reaper.GetTrackGUID(track);
        local VisibTCP = reaper.IsTrackVisible(track,false);
        if not VisibTCP then;
            reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",0);
        end;
    end;
    
    
    local ScrollCheck, Fol_W, NumbTr_w, Undo,wind,Guid,GetScrollTr,showFold;
    do;-->-0.1
        
        local CountSelTrack = reaper.CountSelectedTracks(0);
        if CountSelTrack == 0 then goto noSel end;
        
        
        reaper.Undo_BeginBlock();
        Undo = true;
        
        local GuidStr;
        Guid = {};
        for i = 1, reaper.CountSelectedTracks(0) do;
            local track = reaper.GetSelectedTrack(0,i-1);
            Guid[i] = reaper.GetTrackGUID(track);
            GuidStr = (GuidStr or "")..Guid[i];
            ---
            if i == 1 then;
               if Scroll == 2 then;
                   GetScrollTr = GetScrollTrack(track);
               end;
            end;
            ---
        end;
        
        
        reaper.InsertTrackAtIndex(0,false);
        local DummyDeleteTrack = reaper.GetTrack(0,0);
        
        
        
        ---- > --- / v.1.07 / --- [#1] ----------------------------------
        showFold = {};
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
            if fold == 1 then;
                local visibTCP = reaper.IsTrackVisible(Track,false);
                if not visibTCP then; 
                    local Numb = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER");
                    local Depth = reaper.GetTrackDepth(Track);
                    for i2 = Numb, reaper.CountTracks(0)-1 do;
                        local TrFol = reaper.GetTrack(0,i2);
                        local DepthFol = reaper.GetTrackDepth(TrFol);
                        if DepthFol > Depth then;
                            local visibTCPFol = reaper.IsTrackVisible(TrFol,false); 
                            if visibTCPFol == true then; 
                                reaper.SetMediaTrackInfo_Value(Track,"B_SHOWINTCP",1);  
                                showFold[#showFold+1] = Track;
                                break;  
                            end;
                        else;
                            break;
                        end;
                    end;  
                end;
            end;
        end;
        -----------------------------------------------------------------
         
        
        
        for i = 1, #Guid do;-->-1
            
            local TrackByGUID = reaper.BR_GetMediaTrackByGUID(0,Guid[i]);
            reaper.SetOnlyTrackSelected(TrackByGUID);
            local Numb = reaper.GetMediaTrackInfo_Value(TrackByGUID,"IP_TRACKNUMBER");
            
            for i4 = Numb-2,0,-1  do;-->-4
                local PreTrack = reaper.GetTrack(0,i4);
                
                if PreTrack then;-->-2
                    
                    local VisibTCP = reaper.IsTrackVisible(PreTrack,false);
                    if VisibTCP then;-->-5
                        
                        local NumbPre = reaper.GetMediaTrackInfo_Value(PreTrack,"IP_TRACKNUMBER");
                        
                        
                        local Depth = reaper.GetTrackDepth(TrackByGUID);
                        local PreDepth = reaper.GetTrackDepth(PreTrack);
                        
                        local PreGUID = reaper.GetTrackGUID(PreTrack):gsub("-","");
                        local Concurrence_Guid = string.match(GuidStr:gsub("-",""),PreGUID);
                        if not Concurrence_Guid then;-->-3
                        ----------------------------------------------
                            
                            if Script_Name == "Archie_Track;  Move selected tracks up by one visible (request to skip folders)(`).lua" then;-->-3.21
                                
                                --[--// Один запрос для всех треков перед папками //----
                                if not wind then;-->-3.1
                                    for i3 = #Guid,1,-1 do;-->-3.2
                                        local track_W = reaper.BR_GetMediaTrackByGUID(0,Guid[i3]);
                                        local Depth_W = reaper.GetTrackDepth(track_W);
                                        local Numb__W = reaper.GetMediaTrackInfo_Value(track_W,"IP_TRACKNUMBER");
                                        
                                        for i7 = Numb__W-1,0,-1 do;-->-3.3
                                            local Track_W = reaper.GetTrack(0,i7-1);
                                            if Track_W then;-->-3.4
                                                local VisibTCP_W = reaper.IsTrackVisible(Track_W,false);
                                                if VisibTCP_W then;-->-3.5
                                                
                                                    local PreGUID_W = reaper.GetTrackGUID(Track_W):gsub("-","");
                                                    local Concurrence_Guid_W = string.match(GuidStr:gsub("-",""),PreGUID_W);
                                                    if not Concurrence_Guid_W then;-->-3.6
                                                    
                                                        local PreDepth_W = reaper.GetTrackDepth(Track_W);
                                                        if PreDepth_W > Depth_W then;
                                                            wind = true;
                                                            NumbTr_w = math.ceil(Numb__W)..", "..(NumbTr_w or ""); 
                                                        end;
                                                        
                                                        break--<-3.6
                                                    end;--<-3.6
                                                end;--<-3.5
                                            end;--<-3.4
                                        end;--<-3.3
                                    end;--<-3.2
                                    
                                    if wind then;-->-4.1
                                        NumbTr_w = NumbTr_w:reverse():gsub(",", "- ",1):reverse();
                                        local text_w = "Rus:\n * Поместить трек(и) № "..NumbTr_w.."в папку(и)\n\n"..
                                                       "Eng:\n * Put the track(s) № "..NumbTr_w.."in folder(s)";
                                         local MB = reaper.MB(text_w,"Move the selected track up one.",3);
                                         if MB == 6 then Fol_W = 0 elseif MB == 2 then goto cancel end;
                                    else;--<->-4.1                  
                                        wind = true;
                                    end;--<-4.1
                                end;--<-3.1
                                if Fol_W then PreDepth = Depth end;-->|<
                            end;--<-3.21
                            --]]-- << Запрос << ---////----////--------
                            
                            
                            if Script_Name == "Archie_Track;  Move selected tracks up by one visible(`).lua" then;
                                PreDepth = Depth;
                            end;
                            
                            
                            ------
                            if Script_Name == "Archie_Track;  Move selected tracks up by one visible (skip minimized folders)(`).lua" then;
                                if PreDepth > Depth then;
                                    for i2 = NumbPre-1,0,-1 do;
                                        local PreTrack_C = reaper.GetTrack(0,i2);
                                        local PreDepth_C = reaper.GetTrackDepth(PreTrack_C);
                                        
                                        if PreDepth_C <= Depth then;--x
                                            local FoldPre_C = reaper.GetMediaTrackInfo_Value(PreTrack_C,"I_FOLDERDEPTH");
                                            if FoldPre_C == 1 then;
                                                colapse = reaper.GetMediaTrackInfo_Value(PreTrack_C,"I_FOLDERCOMPACT");
                                                if colapse ~= 2 then;
                                                    PreDepth = Depth;
                                                end;
                                            end;
                                          break;--x
                                        end;--x
                                    end;
                                end;   
                            end;
                            -------
                            
                            
                            ScrollCheck = true;
                            
                            if PreDepth <= Depth then;-->-2.1
                                reaper.ReorderSelectedTracks(NumbPre-1,0);
                            else;--<->-2.1  
                                for i2 = NumbPre-1,0,-1 do;-->-2.2
                                    local PreTrack2 = reaper.GetTrack(0,i2);
                                    --local VisibTCP2 = reaper.IsTrackVisible(PreTrack2,false);
                                    --if VisibTCP2 then;-->-2.3
                                        local PreDepth2 = reaper.GetTrackDepth(PreTrack2);
                                        if PreDepth2 <= Depth then;
                                            local PreNumb2 = reaper.GetMediaTrackInfo_Value(PreTrack2,"IP_TRACKNUMBER");
                                            local FoldPre2 = reaper.GetMediaTrackInfo_Value(PreTrack2,"I_FOLDERDEPTH");
                                            if FoldPre2 == 1 then PreNumb2 = PreNumb2-1 end;
                                            reaper.ReorderSelectedTracks(PreNumb2,0);
                                            break;
                                        end;
                                    --end;--<-2.3
                                end;--<-2.2
                            end;--<-2.1
                        end;--<-3
                        break;--<-5
                    end;--<-5
                end;--<-2
            end;--<-4
        end;--<-1
        
        ::cancel::
        
        if DummyDeleteTrack then;
            reaper.DeleteTrack(DummyDeleteTrack);
        end;
        
        
        ---- > --- / v.1.07 / --- [#1] ----------------------------------
        for i = 1,#showFold do;
            reaper.SetMediaTrackInfo_Value(showFold[i],"B_SHOWINTCP",0); 
        end;
        reaper.TrackList_AdjustWindows(true);
        --- < -----------------------------------------------------------
        
        
    end;--<-0.1
    
    ::noSel::
    
    for i = 1, #VisibTCPGuid do;
        local track = reaper.BR_GetMediaTrackByGUID(0,VisibTCPGuid[i]);
        reaper.SetTrackSelected(track,1);
    end;
    
    
    
    --------------------
    if Scroll == 2 then;
        local TrackByGUID = reaper.BR_GetMediaTrackByGUID(0,Guid[1]);
        SetScrollTrack(TrackByGUID, GetScrollTr);
    end;
    --------------------
    
    
    reaper.PreventUIRefresh(-1);
    
    
    
    --------
    if Scroll == 1 then;-->-4.1
        if ScrollCheck then;-->-4.2
            reaper.PreventUIRefresh(2);
            local TrackByGUID = reaper.BR_GetMediaTrackByGUID(0,Guid[1]);
            reaper.SetOnlyTrackSelected(TrackByGUID);
            Arc.Action(40285,40286);-->-< Go to track  
            ------------
            if Ignore_superCollapse == 1 then;
                local stop;
                local NumbPreByG = (reaper.GetMediaTrackInfo_Value(TrackByGUID,"IP_TRACKNUMBER")-2);
                for i = NumbPreByG,0,-1 do;
                     local TrackScr = reaper.GetTrack(0,i);
                     if TrackScr then;
                         local height = reaper.GetMediaTrackInfo_Value(TrackScr,"I_WNDH");
                         if height < 24 then;
                             indent = indent +1;
                         end;
                         stop = (stop or 0)+1;
                         if stop == indent then break end;
                     end;
                end;
            end;
            ------------  
            for i = 1, indent do;
                Arc.Action(40286);--< Go to track
            end;
            reaper.SetOnlyTrackSelected(reaper.BR_GetMediaTrackByGUID(0,VisibTCPGuid[1]));
            for i = 1, #VisibTCPGuid do;
                local track = reaper.BR_GetMediaTrackByGUID(0,VisibTCPGuid[i]);
                reaper.SetTrackSelected(track,1);
            end;
            reaper.PreventUIRefresh(-2);
        end;--<-4.2
    end;--<-4.1
    ----------
    
    
    ---
    if MixerScroll == 1 then;
        local firstSelTr = reaper.GetSelectedTrack(0,0);
        SetMixerScroll(firstSelTr);
    end;
    ---
    
    if Undo then;
        reaper.Undo_EndBlock(Script_Name:gsub("Archie_Track;  ","",1):gsub(".lua","",1),-1);
    else;
        Arc.no_undo();
    end;