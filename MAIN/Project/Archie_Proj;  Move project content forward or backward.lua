--[[
   * Category:    Project
   * Description: Move project content forward or backward*
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Move project content forward or backward
   * О скрипте:   Переместить содержимое проекта вперед или назад
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    muzicgrand[RMM]
   * Gave idea:   muzicgrand[RMM]
   * Provides:
   *              [nomain] .
   *              [main] . > Archie_Proj;  Move project content forward or backward (moving in beats)(`).lua
   *              [main] . > Archie_Proj;  Move project content forward or backward (move in seconds)(`).lua
   * Changelog:   
   *              +  initialе / v.1.0 [06042019]
   
   
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                     
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (-) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]]    
    
    
    
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    local View_Arrange = true
            --  = false | НЕ ПЕРЕМЕЩАТЬ ВИД ЗА СОДЕРЖИМЫМ                          
            --  = true  | ПЕРЕМЕСТИТЬ ВИД ЗА СОДЕРЖИМЫМ
                        -------------------------------
            --  = false | DO NOT MOVE THE VIEW FOR THE CONTENT                      
            --  = true  | MOVE VIEW BEHIND CONTENTS
            ------------------------------------------------------ 
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
     
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    local Script_Name = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");
    
    local Script_Name_Beats = "Archie_Proj;  Move project content forward or backward (moving in beats)(`).lua";
    local Script_Name_Second = "Archie_Proj;  Move project content forward or backward (move in seconds)(`).lua";
    
   
    if Script_Name ~= Script_Name_Beats and Script_Name ~= Script_Name_Second then;
        reaper.MB("Rus:\n\nНеверное имя скрипта!\nИмя должно быть одно из следующих*\n\n\n"..
                  "Eng:\n\nInvalid script name!\nThe Name must be one of the following*"..
                  "\n-----------------------\n\n\n\n"..
                  "* Name / * Имя\n\n"..Script_Name_Beats..'\n\nor\n\n'..Script_Name_Second,"ERROR",1);
        no_undo() return;
    end;
    
    
    local retval, retvals_csv,Undo;
    if Script_Name == Script_Name_Second then;
        ::X1::;
        retval, retvals_csv = reaper.GetUserInputs("Move project content",1,
                         "  Seconds:  ( << - n );  ( >> + n );,extrawidth=50","");
        if not retval then no_undo() return end;
        retvals_csv = tonumber(retvals_csv);
        if not retvals_csv then goto X1 end;
        if retvals_csv >= 0 then Undo = '+'..retvals_csv..' Second' else Undo = retvals_csv..' Second'end;
    elseif Script_Name == Script_Name_Beats then;
        
        ::X2::;
        retval, retvals_csv = reaper.GetUserInputs("Move project content",1,
                         "  Beats:  ( << - n );  ( >> + n );,extrawidth=50","");
        if not retval then no_undo() return end;
        retvals_csv = tonumber(retvals_csv);
        if not retvals_csv then goto X2 end;
        if retvals_csv >= 0 then Undo = '+'..retvals_csv..' Beats' else Undo = retvals_csv..' Beats'end;
        retvals_csv = retvals_csv*60;
        local bpm, bpi = reaper.GetProjectTimeSignature();
        retvals_csv = (retvals_csv * bpi / bpm);
    end;
    ----
    
    
    
    if retvals_csv < 0 then;
    
        ---------------------------------------
        -- start pos item ---------------------
        local i ,posIt = nil;
        local x = 10^10
        while true do;
            i = (i or -1)+1;
            local Item = reaper.GetMediaItem(0,i);
            if not Item then break end;
            local pos = reaper.GetMediaItemInfo_Value(Item, "D_POSITION");
            if pos < x then;
                posIt = pos;
                x = pos;
            end;
        end;
        ---------------------------------------
            
        -- start pos region marker ------------
        local rgn_mark_pos;
        local countRegMark = reaper.CountProjectMarkers(0);
        if countRegMark > 0 then;
            rgn_mark_pos = ({reaper.EnumProjectMarkers(0)})[3];
        end;
        ---------------------------------------
        
        -- start pos auto item ----------------
        local i,posAutoIt,posEnv = nil;
        local x = 10^10;
        while true do;
            i = (i or -1)+1;
            local track = reaper.GetTrack(0,i);
            if not track then break end;
            local CountTrEnv = reaper.CountTrackEnvelopes(track);
            for i = 1,CountTrEnv do;
                local TrEnv = reaper.GetTrackEnvelope(track,i-1);
                local CountAutoItem = reaper.CountAutomationItems(TrEnv);
                if CountAutoItem > 0 then;
                    posEnv = reaper.GetSetAutomationItemInfo(TrEnv,0,"D_POSITION",0,false);
                end;
                if posEnv and posEnv < x then;
                    posAutoIt = posEnv;
                    x = posEnv;
                end;
            end;
        end;
        ---------------------------------------
        posIt        = posIt        or 100^100;
        posAutoIt    = posAutoIt    or 100^100;
        rgn_mark_pos = rgn_mark_pos or 100^100;
        local
        minPos = math.min(posIt,rgn_mark_pos,posAutoIt);
        ------------------------------------------------
        ------------------------------------------------
        
        if minPos < math.abs(retvals_csv)then retvals_csv = minPos - minPos * 2 Undo = '!'..Undo..'!'end;
        -------------------------------------------------------------------------------------------------
    end;
    
    
    
    if retvals_csv == 0 then no_undo() return end;
    
    
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    
    local StartLoop,EndLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    
    if retvals_csv > 0 then;
        reaper.GetSet_LoopTimeRange(1,0,(retvals_csv-retvals_csv*2),0,0);
        reaper.Main_OnCommand(40200,0);
    elseif retvals_csv < 0 then;
        reaper.GetSet_LoopTimeRange(1,0,retvals_csv,0,0);
        reaper.Main_OnCommand(40201,0);
    end;
    
    local timeSelStart,timeSelEnd;
    if (retvals_csv + StartLoop) < 0 then timeSelStart = 0 else timeSelStart = retvals_csv+ StartLoop end;
    if (retvals_csv + EndLoop  ) < 0 then timeSelEnd   = 0 else timeSelEnd   = retvals_csv+ EndLoop end;
        
    reaper.GetSet_LoopTimeRange(1,0,timeSelStart,timeSelEnd,0);
    
    
    local editCur;
    local editCurPos = reaper.GetCursorPosition();
    if editCurPos + retvals_csv < 0 then editCur = 0 else editCur = editCurPos + retvals_csv end;
    
    reaper.SetEditCurPos(editCur,View_Arrange,false);
    
    
    reaper.Undo_EndBlock("Move project content: "..Undo,-1);
    reaper.PreventUIRefresh(-1);
    reaper.UpdateTimeline();