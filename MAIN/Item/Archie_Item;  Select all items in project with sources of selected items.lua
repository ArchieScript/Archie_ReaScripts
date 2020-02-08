--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Select all items in project with sources of selected items
   * Author:      Archie
   * Version:     1.0
   * Описание:    Выбрать все элементы в проекте с источниками выбранных элементов
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound(Rmm)
   * Gave idea:   Maestro Sound(Rmm)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   *              Arc_Function_lua v.2.7.4+ (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [08.02.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.7.4",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then Arc.no_undo() return end;
    
    
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    local PathNameT = {};
    for i = Count_sel_item-1,0,-1 do;
        local itemSel = reaper.GetSelectedMediaItem(0,i);
        local take = reaper.GetActiveTake(itemSel);
        local Path,Name = Arc.GetPathAndNameSourceMediaFile_Take(take);
        if Path and Name then;
            PathNameT[Path..'/'..Name] = Path..'/'..Name;
        end;
    end;
    
    
    for i = 1, reaper.CountMediaItems(0) do;
        local item = reaper.GetMediaItem(0,i-1);
        local take = reaper.GetActiveTake(item);
        local Path,Name = Arc.GetPathAndNameSourceMediaFile_Take(take);
        if Path and Name then;
            local PathName2 = Path..'/'..Name;
            if PathNameT[PathName2] then;
                reaper.SetMediaItemInfo_Value(item,'B_UISEL',1);
            end;
        end;
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Select all items in project with sources of selected items',-1);
    
    reaper.UpdateArrange();
    
    
    