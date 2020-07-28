--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Fx 
   * Description: Fx; Rename all fx in selected tracks in ...(`).lua 
   * Author:      Archie 
   * Version:     1.0 
   * AboutScript: Переименовать все fx в выбранных треках  в ... 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Snjuk(Cocos forum)http://rmmedia.ru/threads/134701/post-2503922 
   * Gave idea:   Snjuk(Cocos forum) 
   * Extension:   Reaper 6.10+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   *              Arc_Function_lua v.2.8.5+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc 
   * Changelog:    
   *              v.1.0 [030720] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
    local Request = true;  -- Окно для ввода имени true/false 
     
    local new_name = 'Fx_'; -- Имя эффекта, если отключен Request 
     
    local name_numb = true   -- Добавить номер к имени true/false 
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
    --========================================= 
    local function MODULE(file); 
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end; 
        if not A.VersArcFun("2.8.6",file,'')then A.no_undo()return;end;return A; 
    end;local Arc=MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/')); 
    if not Arc then return end; 
    --local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini'; 
    --========================================= 
     
     
     
    local countSelTrack = reaper.CountSelectedTracks(0); 
    if countSelTrack == 0 then no_undo()return end; 
     
     
    local no_stop; 
    for i_tr = 1,countSelTrack do; 
        local selTrack = reaper.GetSelectedTrack(0,i_tr-1); 
        local CountFX = reaper.TrackFX_GetCount(selTrack); 
        if CountFX > 0 then; 
            no_stop = true;break; 
        end; 
    end; 
     
    if not no_stop then no_undo()return end; 
     
     
    local name; 
    if Request == 1 or Request == true then; 
        ::res::; 
        local retval, retvals_csv = reaper.GetUserInputs('name Fx',1,'name Fx:,extrawidth=250',name or ''); 
        if not retval then no_undo()return end; 
        if #retvals_csv:gsub('%s','')==0 then goto res end; 
        name = retvals_csv; 
    else; 
        name = tostring((new_name or 'Fx')); 
    end; 
     
     
     
    local UNDO; 
    for i_tr = 1,countSelTrack do; 
        local selTrack = reaper.GetSelectedTrack(0,i_tr-1); 
        local CountFX = reaper.TrackFX_GetCount(selTrack); 
        if CountFX > 0 then; 
            for i = 1,CountFX do; 
                if not UNDO then; 
                    reaper.PreventUIRefresh(1); 
                    reaper.Undo_BeginBlock(); 
                    UNDO = true; 
                end; 
                if name_numb ~= true then nn = '' else nn = i end; 
                Arc.TrackFx_Rename(selTrack,i-1,name..nn); 
            end; 
        end; 
    end; 
     
     
    if UNDO then; 
        reaper.Undo_EndBlock("Rename all fx in selected tracks in ...",-1); 
        reaper.PreventUIRefresh(-1); 
    else; 
        no_undo(); 
    end; 
     
     
     
     