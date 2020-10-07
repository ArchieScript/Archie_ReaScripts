--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Go to next track - track solo in solo exclusive
   * Author:      Archie
   * Version:     1.03
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Vax(Rmmm)
   * Gave idea:   Vax(Rmmm)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   * Changelog:   v.1.0 [041219]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local NOSCROLLING = false; -- true/false
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
     
    ---------------------------------------------------------------------
    ---------------------------------------------------------------------
    local function Woops1();
        reaper.MB("Требуется расширение  - 'reaper_js_ReaScriptAPI'\n"..
              "или включите прокрутку\n"..
           "require extension is requi - reaper_js_ReaScriptAPI\n"..
       "or enable scrolling\n",'',0);
    end;
    ---------------------------------------------------------------------
    
    ---------------------------------------------------------------------
    local function GetScrollTrack(track);
        if reaper.APIExists("JS_Window_FindChildByID")then;
            if type(track)~= "userdata" then error("GetScrollTrack (MediaTrack expected)",2)end;
            local Numb = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER");
            local height;
            for i = 1,Numb-1 do;
                local Track = reaper.GetTrack(0,i-1);
                local wndh = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                height = (height or 0)+wndh;
            end;
            local trackview = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(),1000);
            local _, position = reaper.JS_Window_GetScrollInfo(trackview,"v");
            return (height or 0) - position;
        else;
            Woops1();
            return false;
        end;
    end;
    ---------------------------------------------------------------------
    
    --------------------------------------------------------------------- 
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
        else;
            Woops1();
            return false;
        end;
        return false;
    end;
    ---------------------------------------------------------------------
    ---------------------------------------------------------------------
    
     
     
     
    

    reaper.PreventUIRefresh(1);

    local LastTouchedTrack = reaper.GetLastTouchedTrack();
    if LastTouchedTrack then;
        
        local GetScroll;
        if NOSCROLLING == true then;
            GetScroll = GetScrollTrack(LastTouchedTrack);
        end;
        
        reaper.Main_OnCommand(40285,0);
        local NewTrack = reaper.GetLastTouchedTrack();

        local Solo = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"I_SOLO");
        if Solo ~= 0 then;
            reaper.SetMediaTrackInfo_Value(NewTrack,"I_SOLO",1);
            for i = 1, reaper.CountTracks(0) do;
                local Track = reaper.GetTrack(0,i-1);
                if Track ~= NewTrack then;
                    local Solo = reaper.GetMediaTrackInfo_Value(Track,"I_SOLO");
                    if Solo ~= 0 then;
                        reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",0);
                    end;
                end;
            end;
        end;
        
        if NOSCROLLING == true then;
            SetScrollTrack(LastTouchedTrack,GetScroll);
        end;
        
    end;

    reaper.PreventUIRefresh(-1);
