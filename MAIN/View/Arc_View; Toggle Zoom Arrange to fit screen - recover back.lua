--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Description: Toggle Zoom Arrange to fit screen - recover back
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Switch to zoom in the arrange window to fit the screen - restore back
   * О скрипте:   Переключатель масштабировать окно аранжировки по размеру экрана - восстановить обратно
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(RMM)
   * Gave idea:   Krikets(RMM)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.5.2+   Repository - (Archie-ReaScripts)  http://clck.ru/EjERc
   * Changelog:   v.1.0 [06.09.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
                             -- ДЛЯ ТОЧНОСТИ УСТАНОВИТЕ ОТСТУПЫ ПОД СВОЙ МОНИТОР
                             -- FOR ACCURACY, INSTALL WASTE UNDER YOUR MONITOR
    local INDENT_START = -0.5
    local INDENT_END   =  0.5
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.5.2",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    
    -------
    local View2;
    local function loop();
        
        local start_View,end_View = reaper.GetSet_ArrangeView2(0,0,0,0);
        if end_View - start_View ~= View2 then;
            View2 = end_View - start_View;
            
            local ProjectLength = reaper.GetProjectLength(0);
            local Toggle = reaper.GetToggleCommandStateEx(sectionID,cmdID);
            
            --if ProjectLength == (end_View+INDENT_START)-(start_View+INDENT_END) then;
            if ProjectLength-1e-7 < ((end_View+INDENT_START)-(start_View+INDENT_END))and
               ProjectLength+1e-7 >=((end_View+INDENT_START)-(start_View+INDENT_END))then;
                if Toggle ~= 1 then;
                    reaper.SetToggleCommandState(sectionID,cmdID,1);--t=(t or 0)+1
                    reaper.RefreshToolbar2(sectionID,cmdID);
                end;
            else;
                if Toggle ~= 0 then;
                    reaper.SetToggleCommandState(sectionID,cmdID,0);--t2=(t2 or 0)+1
                    reaper.RefreshToolbar2(sectionID,cmdID);
                end;
            end;
        end;
        reaper.defer(loop);
    end;
    -------
    
    
    ----------
    --reaper.DeleteExtState( "section","FirstRun",false);
    local FirstRun = reaper.GetExtState("section","FirstRun")=="";
    reaper.SetExtState("section","FirstRun",1,false);
    -----------
    
    loop();
    
    
    
    if not FirstRun then;
        local start_View,end_View = reaper.GetSet_ArrangeView2(0,0,0,0);
        local ProjectLength = reaper.GetProjectLength(0);
        
        if ProjectLength-0.0000001 < ((end_View+INDENT_START)-(start_View+INDENT_END))and
            ProjectLength+0.0000001 >=((end_View+INDENT_START)-(start_View+INDENT_END))then
            
            local start_View2,end_View2 = reaper.GetExtState("section","viewArrangeSave"):match("(.+)&&&(.+)");
            reaper.GetSet_ArrangeView2(0,1,0,0, start_View2 or 0,end_View2 or ProjectLength);
        else;
          reaper.SetExtState("section","viewArrangeSave",start_View.."&&&"..end_View,false);
          reaper.GetSet_ArrangeView2(0,1,0,0, 0+INDENT_START, ProjectLength+INDENT_END);
        end;
    end;
    
    
    local scriptPath,scriptName = filename:match("(.+)[/\\](.+)");
    local id = Arc.GetIDByScriptName(scriptName,scriptPath);
    if id == -1 or type(id) ~= "string" then Arc.no_undo()return end;
    Arc.StartupScript(scriptName,id);