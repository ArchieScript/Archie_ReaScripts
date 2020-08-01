--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Midi Editor
   * Description: Set length selected notes to (Show popup menu)
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.02+ http://www.reaper.fm/
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   v.1.0 [13.01.2020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local RetreatX = 80;
    local RetreatY = 30;
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------
    
    
    local function SetLengthSelectedNoteTo(midieditor,id,val);
        reaper.Undo_BeginBlock();
        reaper.MIDIEditor_OnCommand(midieditor,id);
        reaper.Undo_EndBlock((val or '')..' - Set length selected notes',-1);
    end;
    
    
    local midieditor = reaper.MIDIEditor_GetActive();
    if not midieditor then no_undo() return end;
    
    
    
    local title = '{Sel-lE45g5-ThNoT-et4ru5y-t8f2f-z2lk7o-k7k8e6-Sel}';
    gfx.init(title,5,5,0,5,5);
    
    
    if reaper.APIExists('JS_Window_Find')and
       reaper.APIExists('JS_Window_SetOpacity') then;
        local windowHWND = reaper.JS_Window_Find(title,true);
        if windowHWND then;
            reaper.JS_Window_SetOpacity(windowHWND,'ALPHA',0);
        end;
    end;
    
    
    local x, y = reaper.GetMousePosition();
    gfx.x = x - (tonumber(RetreatX) or 10);
    gfx.y = y - (tonumber(RetreatY) or 30);
    
    
    
    local str_showmenu = '#Sel notes Len||'..  -- 1   | 
                         '1             ||'..  -- 2   | 41637 -- 1
                         '1/2            |'..  -- 3   | 41635 -- 1/2
                         '1/2.           |'..  -- 4   | 41636 -- 1/2.
                         '1/2T          ||'..  -- 5   | 41634 -- 1/2T
                         '1/4            |'..  -- 6   | 41632 -- 1/4
                         '1/4.           |'..  -- 7   | 41633 -- 1/4.
                         '1/4T          ||'..  -- 8   | 41631 -- 1/4T
                         '1/8            |'..  -- 9   | 41629 -- 1/8
                         '1/8.           |'..  -- 10  | 41630 -- 1/8.
                         '1/8T          ||'..  -- 11  | 41628 -- 1/8T
                         '1/16           |'..  -- 12  | 41626 -- 1/16
                         '1/16.          |'..  -- 13  | 41627 -- 1/16.
                         '1/16T         ||'..  -- 14  | 41625 -- 1/16T
                         '1/32           |'..  -- 15  | 41623 -- 1/32
                         '1/32.          |'..  -- 16  | 41624 -- 1/32.
                         '1/32T         ||'..  -- 17  | 41622 -- 1/32T
                         '1/64           |'..  -- 18  | 41620 -- 1/64
                         '1/64.         ||'..  -- 19  | 41621 -- 1/64.
                         '1/128          |'..  -- 20  | 41618 -- 1/128
                         '1/128.         |'    -- 21  | 41619 -- 1/128.
    
    
    --------------------------------
    SHOWMENU = gfx.showmenu(str_showmenu);
    
    if SHOWMENU <= 0 then;
        no_undo() return;
    elseif SHOWMENU == 1 then;
        
    elseif SHOWMENU == 2 then;
        RRR=15
        SetLengthSelectedNoteTo(midieditor,41637,'1');
    elseif SHOWMENU == 3 then;
        SetLengthSelectedNoteTo(midieditor,41635,'1/2');
    elseif SHOWMENU == 4 then;
        SetLengthSelectedNoteTo(midieditor,41636,'1/2.');
    elseif SHOWMENU == 5 then;
        SetLengthSelectedNoteTo(midieditor,41634,'1/2T');
    elseif SHOWMENU == 6 then;
        SetLengthSelectedNoteTo(midieditor,41632,'1/4');
    elseif SHOWMENU == 7 then;
        SetLengthSelectedNoteTo(midieditor,41633,'1/4.');
    elseif SHOWMENU == 8 then;
        SetLengthSelectedNoteTo(midieditor,41631,'1/4T');
    elseif SHOWMENU == 9 then;
        SetLengthSelectedNoteTo(midieditor,41629,'1/8');
    elseif SHOWMENU == 10 then;
        SetLengthSelectedNoteTo(midieditor,41630,'1/8.');
    elseif SHOWMENU == 11 then;
        SetLengthSelectedNoteTo(midieditor,41628,'1/8T');
    elseif SHOWMENU == 12 then;
        SetLengthSelectedNoteTo(midieditor,41626,'1/16');
    elseif SHOWMENU == 13 then;
        SetLengthSelectedNoteTo(midieditor,41627,'1/16.');
    elseif SHOWMENU == 14 then;
        SetLengthSelectedNoteTo(midieditor,41625,'1/16T');
    elseif SHOWMENU == 15 then;
        SetLengthSelectedNoteTo(midieditor,41623,'1/32');
    elseif SHOWMENU == 16 then;
        SetLengthSelectedNoteTo(midieditor,41624,'1/32.');
    elseif SHOWMENU == 17 then;
        SetLengthSelectedNoteTo(midieditor,41622,'1/32T');
    elseif SHOWMENU == 18 then;
        SetLengthSelectedNoteTo(midieditor,41620,'1/64');
    elseif SHOWMENU == 19 then;
        SetLengthSelectedNoteTo(midieditor,41621,'1/64.');
    elseif SHOWMENU == 20 then;
        SetLengthSelectedNoteTo(midieditor,41618,'1/128');
    elseif SHOWMENU == 21 then;
        SetLengthSelectedNoteTo(midieditor,41619,'1/128.'); 
    elseif SHOWMENU == 22 then;
        
    elseif SHOWMENU == 23 then;
        
    elseif SHOWMENU == 24 then;
        
    elseif SHOWMENU == 25 then;
        
    elseif SHOWMENU == 26 then;
        
    elseif SHOWMENU == 27 then;
        
    elseif SHOWMENU == 28 then;
        
    elseif SHOWMENU == 29 then;
        
    elseif SHOWMENU == 30 then;
        
    end;
    no_undo();
    
    
    
    