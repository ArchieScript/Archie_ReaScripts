--[[
   * Category:    Take
   * Description: Copy Name item active take
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Copy Name item active take
   * О скрипте:   Скопировать имя элемента активного тейка
                  востановить с помощью: 
				                        Paste Name to selected items active take
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM)
   * Gave idea:   YuriOl(RMM)
   * Changelog:   +  initialе / v.1.0 [17.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.1.7 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load=reaper.GetResourcePath()..'\\Scripts\\Archie-ReaScripts\\Functions',select(2,reaper.get_action_context()):match("(.+)[\\]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.1.8",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    local SelItem = reaper.GetSelectedMediaItem(0,0);
    if not SelItem then Arc.no_undo() return end;

    reaper.Undo_BeginBlock();

    local HasExtState = reaper.HasExtState("{section_ArcԖCopy¶NameԖTake_ѨԖX}","{key_ArcԖCopyԖNaneԖTake_ѨԖX}");
    if HasExtState then;
        reaper.DeleteExtState("{section_ArcԖCopy¶NameԖTake_ѨԖX}","{key_ArcԖCopyԖNaneԖTake_ѨԖX}",false);
    end;

    local ActiveTake = reaper.GetActiveTake(SelItem);
    local _,stringNeedBig = reaper.GetSetMediaItemTakeInfo_String(ActiveTake,"P_NAME","",0);

    reaper.SetExtState("{section_ArcԖCopy¶NameԖTake_ѨԖX}","{key_ArcԖCopyԖNaneԖTake_ѨԖX}",stringNeedBig,false);

    reaper.Undo_EndBlock('Copy Name item active take',-1);
    

