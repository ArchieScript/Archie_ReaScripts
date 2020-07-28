--[[ 
   * Category:    Track 
   * Description: Select next-previous track(skip minimized folders)(skip folders)* 
   * Author:      Archie 
   * Version:     1.07 
   * AboutScript: Select next-previous track(skip minimized folders)(skip folders)* 
   * О скрипте:   Выберите следующий/предыдущий трек(пропустить свернутые папки)(пропустить папки) 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    smrz1[RMM] 
   * Gave idea:   smrz1[RMM] 
   * Provides:     
   *              [main] . > Archie_Track; Select next tracks(skip minimized folders)(`).lua 
   *              [main] . > Archie_Track; Select previous tracks(skip minimized folders)(`).lua 
   *              [main] . > Archie_Track; Select next tracks(skip folders)(`).lua 
   *              [main] . > Archie_Track; Select previous tracks(skip folders)(`).lua 
   * Changelog:    
   *              v.1.06 [22.05.19] 
   *                  + Add script ...(skip folders) 
                       
   *              v.1.04 [22.05.19] 
   *                  + SCROLLING WITH the INDENT 
   *                  + ПРОКРУТКА С ОТСТУПОМ   
   *              v.1.03 [10042019] 
   *                  +  Added a mixer scroll 
   *              v.1.0 [09042019] 
   *                  +  initialе 
    
    
   --======================================================================================= 
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:          
   (+) - required for installation      | (+) - обязательно для установки 
   (-) - not necessary for installation | (-) - не обязательно для установки 
   ----------------------------------------------------------------------------------------- 
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                      
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                               
   (-) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   
   (+*) reaper_js_ReaScriptAPI    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw     
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                 
   =======================================================================================]] 
     
     
     
     
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    local SCROLL = 1 
             --  = 0 | OFF | ВЫКЛЮЧИТЬ ПРОКРУТКУ  
             --  = 1 | ПРОКРУТКА НА МЕСТЕ * 
             --  = 2 | ПРОКРУТКА С ОТСТУПОМ В ТРЕКАХ(необходимо установать indent) 
                       ----------------------------------------------------------- 
             --  = 0 | OFF | DISABLE SCROLLING 
             --  = 1 | SCROLLING IN PLACE * 
             --  = 2 | SCROLLING WITH the INDENT IN the TRACKS (you must ustanoviti indent) 
             ------------------------------------------------------------------------------ 
    -- * требуется/requires - reaper_js_ReaScriptAPI 
    ------------------------------------------------ 
     
     
     
    local indent = 2  -- кол-во треков; number of tracks; 
                -- | ОТСТУП ПРИ ПРОКРУТКЕ,(В ТРЕКАХ); Работает только при "SCROLL = 2" 
                -- | INDENT WHEN SCROLLING,(IN TRACKS); Works only when "SCROLL = 2" 
                ------------------------------------------------------------------- 
     
     
     
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
	 
 
     
     
     
    local SelectPrev  = "Archie_Track; Select previous tracks(skip minimized folders)(`).lua"; 
    local SelectNext  = "Archie_Track; Select next tracks(skip minimized folders)(`).lua"; 
    local SelectPrev2 = "Archie_Track; Select previous tracks(skip folders)(`).lua"; 
    local SelectNext2 = "Archie_Track; Select next tracks(skip folders)(`).lua"; 
     
    local 
    Script_Name = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)"); 
     
    if Script_Name ~= SelectPrev and Script_Name ~= SelectNext and Script_Name ~= SelectPrev2 and Script_Name ~= SelectNext2 then; 
        reaper.MB("Rus:\n\n".. 
                  " * Неверное имя скрипта !\n * Имя скрипта должно быть одно из следующих \n".. 
                  "    в зависимости от задачи. \n\n\n".. 
                  "Eng:\n\n * Invalid script name ! \n".. 
                  " * The script name must be one of the following \n".. 
                  "    depending on the task.\n".. 
                  "-------\n\n\n".. 
                  "Script Name: / Имя скрипта:\n\n"..SelectPrev.."\n\n"..SelectNext.."\n\n"..SelectPrev2.."\n\n"..SelectNext2,"ERROR",1); 
        no_undo() return; 
    end; 
     
     
    if not Arc.SWS_API(true)then Arc.no_undo() return end; 
     
     
    local CountSelTrack = reaper.CountSelectedTracks(0); 
    if CountSelTrack == 0 then no_undo() return end; 
     
     
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
                                  "или отключите прокрутку\n".. 
                                  "require extension is requi - reaper_js_ReaScriptAPI\n".. 
                                  "or disable scrolling\n"); 
            return false; 
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
            return true; 
        end; 
        return false; 
    end; 
     
     
    reaper.PreventUIRefresh(1); 
    reaper.Undo_BeginBlock(); 
   
     
    if Script_Name == SelectNext or Script_Name == SelectNext2 then;--Select>> 
         
        -- / SelectNext /-- 
         
        for i = CountSelTrack-1,0,-1 do; 
            local trackSel = reaper.GetSelectedTrack(0,i); 
            local Numb = reaper.GetMediaTrackInfo_Value(trackSel,"IP_TRACKNUMBER");  
            local Depth = reaper.GetTrackDepth(trackSel); 
             
            for i2 = Numb, reaper.CountTracks(0)-1 do; 
                local trackX = reaper.GetTrack(0,i2); 
                local height = reaper.GetMediaTrackInfo_Value(trackX,"I_WNDH"); 
                 
                if Script_Name == SelectNext2 then; 
                    local Depth2 = reaper.GetTrackDepth(trackX); 
                    if Depth2 > Depth then height = 0 end; 
                end; 
                 
                if height >= 24 then;--h 
                    local sel = reaper.GetMediaTrackInfo_Value(trackX,"I_SELECTED"); 
                    if sel == 0 then; 
                        --reaper.SetTrackSelected(trackX,1); 
                        reaper.SetMediaTrackInfo_Value(trackX,"I_SELECTED",1); 
                        reaper.SetTrackSelected(trackSel,0); 
                    end; 
                    break;--h 
                end;--h 
            end; 
        end; 
         
    elseif Script_Name == SelectPrev or Script_Name == SelectPrev2 then;--Select<> 
         
        -- / SelectPrev /-- 
         
        for i = 1, CountSelTrack do; 
            local trackSel = reaper.GetSelectedTrack(0,i-1); 
            local Numb = reaper.GetMediaTrackInfo_Value(trackSel,"IP_TRACKNUMBER")-2; 
            local Depth = reaper.GetTrackDepth(trackSel); 
             
            for i2 = Numb, 0,-1 do; 
                local trackX = reaper.GetTrack(0,i2); 
                local height = reaper.GetMediaTrackInfo_Value(trackX,"I_WNDH"); 
                 
                if Script_Name == SelectPrev2 then; 
                    local Depth2 = reaper.GetTrackDepth(trackX); 
                    if Depth2 > Depth then height = 0 end; 
                end; 
                 
                if height >= 24 then;--h 
                    local sel = reaper.GetMediaTrackInfo_Value(trackX,"I_SELECTED"); 
                    if sel == 0 then; 
                        --reaper.SetTrackSelected(trackX,1); 
                        reaper.SetMediaTrackInfo_Value(trackX,"I_SELECTED",1); 
                        reaper.SetTrackSelected(trackSel,0); 
                    end; 
                    break;--h 
                end;--h 
            end; 
        end; 
    end;--Select<< 
     
     
     
     
    if SCROLL == 1 then--Scroll>> 
         
        local track = reaper.GetSelectedTrack(0,0); 
        local height = reaper.GetMediaTrackInfo_Value(track,"I_WNDH"); 
        local Fold = reaper.GetMediaTrackInfo_Value(track,"I_FOLDERDEPTH"); 
        if Fold == 1 then; 
            local Depth = reaper.GetTrackDepth(track); 
            local Numb = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER"); 
            for i = Numb, reaper.CountTracks(0)-1 do; 
                local track = reaper.GetTrack(0,i); 
                local DepthChild = reaper.GetTrackDepth(track); 
                if DepthChild > Depth then; 
                    local h = reaper.GetMediaTrackInfo_Value(track,"I_WNDH"); 
                    if h < 24 then; 
                        height = (height or 0)+reaper.GetMediaTrackInfo_Value(track,"I_WNDH"); 
                    else; 
                        break; 
                    end; 
                else; 
                    break; 
                end; 
            end;   
        end; 
         
         
        local track = reaper.GetSelectedTrack(0,0); 
        local Scroll = GetScrollTrack(track); 
         
        if Script_Name == SelectNext or Script_Name == SelectNext2 then; 
            Scroll = (Scroll - height); 
        elseif Script_Name == SelectPrev or Script_Name == SelectPrev2 then; 
            Scroll = (Scroll + height); 
        end; 
        if Scroll < 0 then Scroll = 0 end; 
        SetScrollTrack(track, Scroll); 
     
    elseif SCROLL == 2 then; 
         
        Arc.SaveSelTracksGuidSlot_SWS(1); 
         
        local Toggle = reaper.GetToggleCommandStateEx(0,40221); 
        if Toggle == 1 then; 
            Arc.Action(40221); 
        end 
            
        if Script_Name == SelectNext or Script_Name == SelectNext2 then; 
            local Track = reaper.GetSelectedTrack(0,reaper.CountSelectedTracks(0)-1); 
            reaper.SetOnlyTrackSelected(Track); 
            Arc.Action(40286,40285);--<--> Go to track 
            local stop; 
            local Numb = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER"); 
            for i = Numb, reaper.CountTracks(0)-1 do; 
                local Track = reaper.GetTrack(0,i); 
                if Track then; 
                    local Visible = reaper.IsTrackVisible(Track,false); 
                    if Visible then; 
                        local height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH"); 
                        if height < 24 then; 
                            indent = indent +1; 
                        end; 
                        stop = (stop or 0)+1; 
                        if stop == indent then break end; 
                    end; 
                end; 
            end; 
            for i = 1, indent do; 
                Arc.Action(40285);--> Go to track    
            end; 
            ------------------ 
        elseif Script_Name == SelectPrev or Script_Name == SelectPrev2 then; 
           
            local Track = reaper.GetSelectedTrack(0,0); 
            reaper.SetOnlyTrackSelected(Track); 
            Arc.Action(40285,40286);-->-< Go to track  
            local stop; 
            local Numb = (reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER")-2); 
            for i = Numb,0,-1 do; 
                local Track = reaper.GetTrack(0,i); 
                if Track then; 
                    local Visible = reaper.IsTrackVisible(Track,false); 
                    if Visible then; 
                        local height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH"); 
                        if height < 24 then; 
                            indent = indent +1; 
                        end; 
                        stop = (stop or 0)+1; 
                        if stop == indent then break end; 
                    end; 
                end; 
            end; 
            for i = 1, indent do; 
                Arc.Action(40286);--< Go to track 
            end; 
        end; 
         
        if Toggle == 1 then; 
            Arc.Action(40221); 
        end 
         
        Arc.RestoreSelTracksGuidSlot_SWS(1,true);  
    end;--Scroll<< 
     
     
    ---/ MixerScroll /---------------------------------- 
    local Toggle = reaper.GetToggleCommandStateEx(0,40221); 
    if Toggle == 1 then; 
        reaper.SetMixerScroll(reaper.GetSelectedTrack(0,0)); 
    end; 
    ---------------------------------------------------- 
     
    reaper.Undo_EndBlock(Script_Name:gsub("Archie_Track;  ",""):gsub("%.lua",""),-1); 
    reaper.PreventUIRefresh(-1); 
    reaper.UpdateArrange(); 
    no_undo(); 