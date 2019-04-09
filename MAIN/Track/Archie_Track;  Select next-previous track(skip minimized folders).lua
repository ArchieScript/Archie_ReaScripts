--[[
   * Category:    Track
   * Description: Select next/previous tracks(skip minimized folders)*
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Select next/previous tracks(skip minimized folders)*
   * О скрипте:   Выберите следующий/предыдущий треки(пропустить свернутые папки)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1[RMM]
   * Gave idea:   smrz1[RMM]
   * Provides:    
   *              [main] . > Archie_Track;  Select next tracks(skip minimized folders)(`).lua
   *              [main] . > Archie_Track;  Select previous tracks(skip minimized folders)(`).lua
   * Changelog:   
   *              +  initialе / v.1.0 [09042019]
   
   
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                     
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (-) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (+*) reaper_js_ReaScriptAPI    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]]
    
    
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local SCROLL = 1    --  требуется/requires - reaper_js_ReaScriptAPI*)
             --  = 0 | OFF | ВЫКЛЮЧИТЬ СКРОЛЛИНГ \ DISABLE SCROLLING
             --  = 1 | ON  | ВКЛЮЧИТЬ СКРОЛЛИНГ  \ ENABLE SCROLLING
             ------------------------------------------------------ 
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    

    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    local SelectPrev = "Archie_Track;  Select previous tracks(skip minimized folders)(`).lua";
    local SelectNext = "Archie_Track;  Select next tracks(skip minimized folders)(`).lua";
    local
    Script_Name = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");
    
    if Script_Name ~= SelectPrev and Script_Name ~= SelectNext or SelectPrev == SelectNext then;
        reaper.MB("Rus:\n\n"..
                  " * Неверное имя скрипта !\n * Имя скрипта должно быть одно из следующих \n"..
                  "    в зависимости от задачи. \n\n\n"..
                  "Eng:\n\n * Invalid script name ! \n"..
                  " * The script name must be one of the following \n"..
                  "    depending on the task.\n"..
                  "-------\n\n\n"..
                  "Script Name: / Имя скрипта:\n\n"..SelectPrev.."\n\n"..SelectNext,"ERROR",1);
        no_undo() return;
    end;
    
    
    
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
	
    
    if Script_Name == SelectNext then;--Select>>
        
        -- / SelectPrev /--
        for i = CountSelTrack-1,0,-1 do;
            local trackSel = reaper.GetSelectedTrack(0,i);
            local Numb = reaper.GetMediaTrackInfo_Value(trackSel,"IP_TRACKNUMBER");
            
            for i2 = Numb, reaper.CountTracks(0)-1 do;
                local trackX = reaper.GetTrack(0,i2);
                local height = reaper.GetMediaTrackInfo_Value(trackX,"I_WNDH");
                if height >= 24 then;--h
                    local sel = reaper.GetMediaTrackInfo_Value(trackX,"I_SELECTED");
                    if sel == 0 then;
                        reaper.SetTrackSelected(trackX,1);
                        reaper.SetTrackSelected(trackSel,0);
                    end;
                    break;--h
                end;--h
            end;
        end;
        
    elseif Script_Name == SelectPrev then;--Select<>
        
        -- / SelectNext /--
        for i = 1, CountSelTrack do;
            local trackSel = reaper.GetSelectedTrack(0,i-1);
            local Numb = reaper.GetMediaTrackInfo_Value(trackSel,"IP_TRACKNUMBER")-2;
            
            for i2 = Numb, 0,-1 do;
                local trackX = reaper.GetTrack(0,i2);
                local height = reaper.GetMediaTrackInfo_Value(trackX,"I_WNDH");
                if height >= 24 then;--h
                    local sel = reaper.GetMediaTrackInfo_Value(trackX,"I_SELECTED");
                    if sel == 0 then;
                        reaper.SetTrackSelected(trackX,1);
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
        
        if Script_Name == SelectNext then;
            Scroll = (Scroll - height);
        elseif Script_Name == SelectPrev then;
            Scroll = (Scroll + height);
        end;
        if Scroll < 0 then Scroll = 0 end;
        SetScrollTrack(track, Scroll);
    end;--Scroll<<
    
    reaper.Undo_EndBlock(Script_Name:gsub("Archie_Track;  ",""):gsub("%.lua",""),-1);
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();
    no_undo();