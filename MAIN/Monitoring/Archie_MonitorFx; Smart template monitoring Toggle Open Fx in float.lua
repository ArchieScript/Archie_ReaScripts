--[[ 
   * Category:    Monitoring 
   * Description: Smart template monitoring Toggle Open Fx in float 
   * Author:      Archie 
   * Version:     1.02 
   * AboutScript: Smart template monitoring Toggle Open Fx in float 
   * О скрипте:   Умный шаблон мониторинга переключатель открыть плавающий Fx 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Maestro Sound[RMM] 
   * Gave idea:   Maestro Sound[RMM] 
   * Changelog:    
   *              +! Исправлена ошибка при добавлении более 10 Fx / v.1.01 [01032019] 
   *              +! Fixed bug when adding more than 10 Fx / v.1.01 [01032019] 
    
   *              +  initialе / v.1.0 [01032019] 
 
 
   --======================================================================================== 
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\ 
   ----------------------------------------------------------------------------------------|| 
   + Reaper v.5.967 +           --| http://www.reaper.fm/download.php                      || 
   - SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 || 
   - ReaPack v.1.2.2 +          --| http://reapack.com/repos                               || 
   - Arc_Function_lua v.2.3.0 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   || 
   - reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr   || 
                                                                    http://clck.ru/Eo5Lw   || 
   - Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                  || 
   ----------------------------------------------------------------------------------------|| 
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// 
   ========================================================================================]] 
     
     
     
     
   --====================================================================================== 
   --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
   --======================================================================================  
    
    
    
    
    ----------------------------------------------------------------------------- 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end 
    ----------------------------------------------------------------------------- 
    
    
    reaper.ClearConsole(); 
    reaper.ShowConsoleMsg( "Rus:\n".. 
                           " *  Введите в первом появившемся окне номера эффектов, \n".. 
                           " *  которые нужно будет открывать (Через запятую) \n".. 
                           " *  Например: 1,3,4,5,7 \n\n".. 
                           " *  Во втором появившемся окне введите номера,  \n".. 
                           " *  что сделать с эффектами при закрытии (Через запятую) \n".. 
                           " *  0 - ничего не делать с эффектом \n".. 
                           " *  1 - увести эффект в bypass \n".. 
                           " *  2 - увести эффект в offline \n".. 
                           " *  Например: 2,0,0,1,1 \n\n".. 
                           "Eng:\n".. 
                           " * Enter the effect numbers in the first window that appears,\n".. 
                           " * which will need to be opened (separated by commas)\n".. 
                           " * For example: 1,3,4,5,7\n\n".. 
                           " * In the second window that appears, enter the numbers, \n".. 
                           " * what to do with effects  when closing (separated by commas)\n".. 
                           " * 0 - nothing to do with the effect\n".. 
                           " * 1-take effect in bypass\n".. 
                           " * 2 - to take effect in offline\n".. 
                           " * For example: 2,0,0,1,1" ); 
    
    ---- 
    ::error_1::; 
    local 
    retval,retvals_csv = reaper.GetUserInputs("Smart template monitoring Toggle Open Fx in float.",1,  
                                              "   Enter number Fx by commas:,  extrawidth=87 ", "" ); 
    if not retval or retvals_csv == "" then no_undo() return end; 
     
     
    if string.match(retvals_csv,"[^,%d]+") then; 
        reaper.MB("Rus:\n".. 
                  " * Неверные значения, Введите номера Fx через запятую !\n\n"..  
                  "Eng:\n".. 
                  " * Incorrect value, Enter number Fx by commas !", 
                  "Error !",0); 
        goto error_1; 
    end; 
    
    local 
    Num_Fx = {}; 
    for var in string.gmatch (retvals_csv, "[^,]+") do; 
        Num_Fx[#Num_Fx+1] = tonumber(var); 
    end; 
    -----   
        
      
    ----- 
    ::error_2:: 
    local 
    retval,retvals_csv = reaper.GetUserInputs("Smart template monitoring Toggle Open Fx in float.", 1,  
                                              "Close: No-0: Bypass-1: Offline-2:,  extrawidth=87",""); 
    if not retval then no_undo() return end; 
    
    if retvals_csv == "" then retvals_csv = "..." end; 
    
    if string.match(retvals_csv,"[^,%d]+") then; 
        reaper.MB("Rus:\n".. 
                  " * Неверные значения!!!\n".. 
                  " * Введите номера через запятую, что сделать с Fx при закрытии\n".. 
                  " * 0 ничего: 1 Bypass: 2 Offline:\n\n".. 
                  "Eng:\n".. 
                  " * Invalid values!!!\n".. 
                  " * Enter numbers separated by commas what to do with Fx when closing\n".. 
                  " * 0 nothing: 1 Bypass: 2 Offline:", 
                  "Error !",0); 
        goto error_2; 
    end; 
    
    
    local  
    Close_NoBypassOffline = {}; 
    for var in string.gmatch (retvals_csv,"[^,]+") do; 
        Close_NoBypassOffline[#Close_NoBypassOffline+1] = tonumber(var); 
    end; 
    
    for i = 1, #Num_Fx do; 
        if not Close_NoBypassOffline[i] then Close_NoBypassOffline[i] = 0 end; 
        if Close_NoBypassOffline[i] > 2 then Close_NoBypassOffline[i] = 2 end; 
    end; 
    -----  
 
 
 
    ----- 
    local 
    bypass = string.match(table.concat(Close_NoBypassOffline,","),"1"); 
    if bypass then bypass = " bypass" else bypass = "" end; 
    local 
    offline = string.match(table.concat(Close_NoBypassOffline,","),"2"); 
    local And 
    if offline then offline = " offline" else offline = "" end; 
     
    if offline == "" and bypass == "" then And = "" else And = "and" end; 
    
     
    local 
    pathScr,NameScr = ({reaper.get_action_context()})[2]:match("(.+)[/\\](.+)"); 
    local 
    NameScrNEXT = "Archie_MonitorFx;  Toggle Open and activate float Fx - Close Fx ".. 
                         And..bypass..offline.."'Fx-"..table.concat(Num_Fx,"' ")..".lua"; 
   
  
    local FileStop,i; 
    while(not wh1)do; 
        i = (i or 0)+1; 
        local Files = reaper.EnumerateFiles(pathScr,i-1); 
        if Files == NameScrNEXT then FileStop = true end; 
        if FileStop or not Files then break end; 
    end; 
      
    if FileStop then; 
        local MB = reaper.MB("Rus:\n".. 
                             " * Такой скрипт уже существует !\n".. 
                             " * Перезаписать его ? OK\n\n".. 
                             "Eng:\n".. 
                             " * This script already exists !\n".. 
                             " * Overwrite it ? OK\n\n".. 
                             " Script: \n".. 
                             " * "..NameScrNEXT, 
                             "Error !",1); 
        if MB == 2 then no_undo() return end; 
    end; 
    ----- 
     
     
    ----- 
    local SCR = "--[[\n   * Description: "..NameScrNEXT.."\n   * Author:      Archie\n".. 
    "   * Website:     http://forum.cockos.com/showthread.php?t=212819 \n".. 
    "   *              http://rmmedia.ru/threads/134701/ \n".. 
    "   * DONATION:    http://money.yandex.ru/to/410018003906628 \n".. 
    "   * Customer:    Maestro Sound[RMM]\n   * Gave idea:   Maestro Sound[RMM]\n--]]".. 
    "\n\n\n\n\n\n"..[[ 
 
    ----------------------------------------------------------------------------- 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end 
    ----------------------------------------------------------------------------- 
     
 
    local Num_Fx = {]]..table.concat(Num_Fx,",")..[[}; 
    local Close_NoBypassOffline = {]]..table.concat(Close_NoBypassOffline,",")..[[}; 
 
    local mastTrack = reaper.GetMasterTrack(); 
    local mon,OpenFloat = (0x1000000)-1; 
     
    for i = 1, #Num_Fx do;  
        OpenFloat = reaper.TrackFX_GetFloatingWindow(mastTrack,mon+Num_Fx[i]); 
        if OpenFloat then break end; 
    end; 
     
     
    for i = 1, #Num_Fx do; 
        if not OpenFloat then; 
            local Offline = reaper.TrackFX_GetOffline(mastTrack,mon+Num_Fx[i]); 
            local bypass = reaper.TrackFX_GetEnabled(mastTrack,mon+Num_Fx[i]); 
            if Offline then; 
                reaper.TrackFX_SetOffline(mastTrack,mon+Num_Fx[i],0); 
            end; 
            if not bypass then; 
                reaper.TrackFX_SetEnabled(mastTrack,mon+Num_Fx[i],1); 
            end; 
            reaper.TrackFX_Show(mastTrack,mon+Num_Fx[i],3); 
        else; 
            if Close_NoBypassOffline[i] == 1 then; 
                reaper.TrackFX_SetEnabled(mastTrack,mon+Num_Fx[i],0); 
            elseif Close_NoBypassOffline[i] == 2 then; 
                reaper.TrackFX_SetOffline(mastTrack,mon+Num_Fx[i],1);  
            end; 
            reaper.TrackFX_Show(mastTrack,mon+Num_Fx[i],2); 
        end; 
    end; 
    no_undo();]].."\n\n\n\n" 
    ------------------------ 
 
 
 
    local 
    pathFile = io.open(pathScr.."/"..NameScrNEXT,'w'); 
    pathFile:write(SCR); 
    pathFile:close(); 
    --os.remove("d:\\"); 
    reaper.AddRemoveReaScript(true,0,pathScr.."/"..NameScrNEXT,true); 
 
    reaper.ClearConsole(); 
    reaper.ShowConsoleMsg("Rus:\n".. 
                          " * Скрипт создан \n".. 
                          " * "..NameScrNEXT.."\n".. 
                          " * Ищите в экшен листе \n\n".. 
                          "Eng:\n".. 
                          " * Script created \n".. 
                          " * "..NameScrNEXT.."\n".. 
                          " * Search the action list");  
                          ----------------------------- 
    no_undo(); 