--[[
   * Category:    View
   * Description: Set arrange in center when you change BPM
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Set arrange in center when you change BPM
   * О скрипте:   Установить аранжировку по центру при изменении BPM
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Zit[RMM]
   * Gave idea:   Zit[RMM]
   * Changelog:   
   *              +  [outdated] / v.1.02 [15032019]
   
   *              +  initialе / v.1.0  [12032019]


   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
    ˅ - (+) - обязательно для установки / (-) - не обязательно для установки               ||
      -------------------------------------------------------------------------------------||
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                    ||
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php               ||
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                             ||
   (+) Arc_Function_lua v.2.3.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc ||
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr ||
                                                                    http://clck.ru/Eo5Lw   ||
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                ||
      -------------------------------------------------------------------------------------||
    ˄ - (+) - required for installation / (-) - not necessary for installation             ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]
    
    

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    
    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.3.1",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================
    
    
    
    if not Arc.SWS_API(true)then;
        Arc.no_undo() return;
    end
    
    Arc.HelpWindowWhenReRunning(1,"dfgd",false);
  
    local function exit();
        Arc.SetToggleButtonOnOff(0);
        do Arc.no_undo() return end;
    end;
    
    
    local function Loop();
        
        -- ProjectState = reaper.GetProjectStateChangeCount(0);
        -- if ProjectState ~= ProjectStateX then;
            local bpm, bpi = reaper.GetProjectTimeSignature2(0);
             
            if bpm ~= bpm_x then;
        
                if bpm_x then
                
                    local cursor = reaper.GetCursorPosition();
                    local start_time, end_time = reaper.GetSet_ArrangeView2(0,0,0,0);
                    local width = (end_time - start_time) / 2;
                   
                    if start_time ~= cursor - width and end_time ~= cursor + width then;
                        
                        reaper.BR_SetArrangeView(0,cursor - width,cursor + width);
                    end;
                end;
                bpm_x = bpm;
            end;
            -- ProjectStateX = ProjectState; 
        -- end; 
        -- i=(i or 0)+1;
        reaper.defer(Loop);
    end;
    
    
    Arc.SetToggleButtonOnOff(1);
    Loop();
    reaper.atexit(exit);
  
  
    ExtState = reaper.GetExtState("section=Set arrange in center when","key=Set arrange in center when")
 
    if ExtState == "" then
        reaper.MB(
               "Rus:\n"..
               "  *  Скрипт устарел, используйте\n"..
               "  *  Archie_View;  Toggle arrange in center relative to edit cursor when change BPM.lua\n"..
               "  *  Изменений никаких не произошло, только сменилось название\n"..
               "  *  Данный Скрипт будет удален 31.04.2019\n\n"..
               "Eng\n"..
               "  * The script is outdated, use\n" ..
               "  *  Archie_View;  Toggle arrange in center relative to edit cursor when change BPM.lua\n"..
               "  * No changes have occurred, only the name has changed\n"..
               "  * This Script will be deleted. 04.31.2019 \n",
              "Set arrange in center when you change BPM",0)
    end;
    
    ValueExt = (tonumber(ExtState)or 0)+1
    if ValueExt > 4 then ValueExt = "" end
    
    reaper.SetExtState("section=Set arrange in center when","key=Set arrange in center when",ValueExt,true)