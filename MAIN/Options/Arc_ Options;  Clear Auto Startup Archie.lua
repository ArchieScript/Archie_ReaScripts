--[[
   * Category:    Options
   * Description: Clear Auto Startup Archie
   * Author:      Archie
   * Version:     1.01
   * Описание:    Очистить автозагрузку Арчи
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Extension:   
   *              Reaper 5.983+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.6.5+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
--]]
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.6.5",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
    
              
    local MB = reaper.MB("Rus:\nТочно очистить автозагрузку ?\n\nEng\nAccurately clear startup ?","Clear Auto Startup Archie",1);
    if MB == 2 then Arc.no_undo() return end;
    if MB == 1 then;
        Arc.SetStartupScript("scriptName","",nil,"ALL");
        Arc.no_undo();
    end;