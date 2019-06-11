--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   * Category:    Mixer
   * Description: Set height of rec-armed tracks MCP to height master track
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   Установить высоту треков с подготовленной записью MCP на высоту мастер-трека
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2074318/e710a573-7a3d-4019-8989-30f8d0bff86a/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM)
   * Gave idea:   YuriOl(RMM)
   * Changelog:   +  initialе / v.1.0 [12.06.19]

   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php                     
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (+) Arc_Function_lua v.2.4.4 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]] 
    
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.4",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
    
    
    
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;
    
    
    reaper.PreventUIRefresh(1);
    
    local MasterTrack = reaper.GetMasterTrack(0);
    local Masterheigth = Arc.GetSetHeigthMCPTrack(MasterTrack,nil,0);
    
    for i = 1, CountTrack do;
        local Track = reaper.GetTrack(0,i-1);
        local rec = reaper.GetMediaTrackInfo_Value(Track,"I_RECARM");
        if rec == 1 then;
            local heigth = Arc.GetSetHeigthMCPTrack(Track,nil,0);
            if heigth ~= Masterheigth then;
                Arc.GetSetHeigthMCPTrack(Track,Masterheigth,1);
            end;
        end;
    end;
    Arc.no_undo();
    reaper.PreventUIRefresh(-1);