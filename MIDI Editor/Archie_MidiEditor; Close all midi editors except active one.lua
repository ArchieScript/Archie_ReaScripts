--[[
   * Category:    MidiEditor
   * Description: MidiEditor; Close all midi editors except active one.lua
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.0
   * customer:    ---(---)
   * gave idea:   ---(---)
--====================================]]
    
    
    if not reaper.APIExists("JS_Localize") then;
        reaper.MB("js_ReaScriptAPI extension is required for this script.","Missing API",0);
        return;
    end;
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    local  midieditor = reaper.MIDIEditor_GetActive();
    if not midieditor then no_undo()return end;
    
    
    local ret,list = reaper.JS_MIDIEditor_ListAll();
    if ret > 1 then;
        local rea_hwnd = reaper.GetMainHwnd();
        for adr in list:gmatch("[^,]+") do;
            local hwnd = reaper.JS_Window_HandleFromAddress(adr);
            if hwnd ~= rea_hwnd then;
                if hwnd ~= midieditor then;
                    reaper.JS_Window_Destroy(hwnd);
                end;
            end;
        end;
    end;
    no_undo();
    
    
    
    
    