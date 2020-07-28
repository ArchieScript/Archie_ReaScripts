--[[ 
   * Category:    Info 
   * Description: Learn what script are used in custom actions and cycle action 
   * Author:      Archie 
   * Version:     1.03 
   * AboutScript: Learn what script are used in custom actions and cycle action 
   * О скрипте:   Узнайте, какие сценарии используются в настраиваемых действиях и цикл действиях 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Supa75/smrz1(RMM) 
   * Gave idea:   Supa75/smrz1(RMM) 
   * Changelog:   
   *              +! Fixed incompatibility with Mac os / v.1.03 [27022019] 
   *              +! Исправлена несовместимость с Mac os / v.1.03 [27022019] 
    
   *              +! Fixed a pop-up error in the absence of a file "S&M_Cyclactions.ini" / v.1.02 [16.02.2019] 
   *              +! Устранена всплывающая ошибка при отсутствии файла "S&M_Cyclactions.ini" / v.1.02 [16.02.2019] 
   
   *              +  initialе / v.1.0 [17.01.2019] 
 
   ===========================================================================================\ 
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------| 
   ===========================================================================================| 
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)| 
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)| 
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)| 
   - Arc_Function_lua v.2.1.6 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)| 
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)| 
                                                                 http://clck.ru/Eo5Lw |и выше)| 
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)| 
--===========================================================================================]] 
 
 
 
 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --======================================================================================  
 
 
 
 
    ------------------------------------------------------------------------------ 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end; 
    ------------------------------------------------------------------------------ 
 
 
    function GetScriptNameByID(id); 
        local Path = reaper.GetResourcePath()..'/reaper-kb.ini'; 
        local file = io.open(Path,'r'); 
        if not file then no_undo() return end; 
        local text = file:read('a');file:close(); 
        return text:match(id:match('[^_](%S+)')..'%s"Custom:%s(.-)"');   
    end; 
 
 
    function GetScriptNameByCastom(); 
        local kb_ini = reaper.GetResourcePath()..'/reaper-kb.ini'; 
        local file = io.open(kb_ini,'r'); 
        if not file then no_undo() return end; 
        local line_T,TableCast,TabCastom,Nil = {},{},{}; 
        for var in file:lines() do; 
            table.insert(line_T,var); 
        end; 
        ---- 
        for i = 1, #line_T do; 
            if line_T[i]:match('ACT')then; 
                for NameScript in string.gmatch(line_T[i],"%S+") do; 
                    local double = nil; 
                    if string.sub(NameScript,0,1) == "_" then; 
                        local NameByID = GetScriptNameByID(NameScript); 
                        if NameByID then; 
                            for i2 = 1, #TableCast do; 
                                if NameByID == TableCast[i2]then; 
                                   double = 1 break; 
                                end; 
                            end; 
                            if not double then; 
                                table.insert(TableCast,NameByID); 
                                if #TabCastom+1 < 10 then Nil = "00" elseif #TabCastom+1 >= 10 and #TabCastom+1 < 100 then Nil = "0" else Nil = ""end; 
                                table.insert(TabCastom,Nil..#TabCastom+1 .." - "..NameByID); 
                            end; 
                        end; 
                    end; 
                end; 
            end; 
        end; 
        return TabCastom; 
    end; 
 
 
    local function GetScriptNameByCycle(); 
        local kb_ini = reaper.GetResourcePath()..'/S&M_Cyclactions.ini'; 
        local file = io.open(kb_ini,'r'); 
        if not file then no_undo() return end; 
        local text = file:read('a'); 
        file:close(); 
        local TableCicle,TableCycle,Nil = {},{}; 
        ---------------------------------- 
        for S in string.gmatch (text, "[^|]+") do; 
            if string.sub(S,0,1) == "_" then 
                local NameByID = GetScriptNameByID(S); 
                if NameByID then; 
                    local double = nil; 
                    for i2 = 1, #TableCicle do; 
                        if NameByID == TableCicle[i2]then; 
                           double = 1 break; 
                        end; 
                    end; 
                    if not double then; 
                        table.insert(TableCicle,NameByID); 
                        if #TableCycle+1 < 10 then Nil = "00" elseif #TableCycle+1 >= 10 and #TableCycle+1 < 100 then Nil = "0" else Nil = ""end; 
                        table.insert(TableCycle,Nil..#TableCycle+1 .." - "..NameByID); 
                    end; 
                end; 
            end; 
        end; 
        return TableCycle; 
    end; 
 
 
    local Castom = GetScriptNameByCastom() or {}; 
    local Cycle = GetScriptNameByCycle() or {}; 
    local header = "[Archie_UsedScriptsInActions:]\n\n".. 
                   "Скрипты использующиеся в пользовательских действиях и в цикл действиях:\n".. 
                   "Scripts used in custom actions and cycle actions:\n\n\n";    
    table.insert(Castom,1,header.."CASTOM ACTION: ".. #Castom.."-Scripts\n"); 
    table.insert(Cycle,1,"\n\n\nCYCLE ACTION: "..#Cycle.."-Scripts\n"); 
    local CastList = table.concat(Castom,"\n");  
    local CyclList = table.concat(Cycle,"\n"); 
    ---------------------- 
    local path = reaper.GetResourcePath()..'/Archie_UsedScriptsInActions.ini'; 
    local ini = io.open(path,'w'); 
    ini:write(CastList..CyclList); 
    ini:close(); 
 
    local OS,cmd = reaper.GetOS(); 
    if OS == "OSX32" or OS == "OSX64" then; 
        cmd = os.execute('open "'..path..'"'); 
    else; 
        cmd = os.execute('start "" '..path); 
    end; 
    if not cmd then; 
        reaper.ClearConsole();  
        reaper.ShowConsoleMsg(CastList..CyclList); 
    end; 
     
    no_undo(); 