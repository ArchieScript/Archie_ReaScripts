--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Switch item source file on next in directory on throughout project
   * Author:      Archie
   * Version:     1.03
   * Описание:    Переключить исходный файл элемента на следующий в каталоге на протяжении всего проекта
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
   *              v.1.03 [08.02.20]
   *                  + Fix bug
   
   *              v.1.02 [08.02.20]
   *                  + Ability to disable warning window  
   *              v.1.0 [08.02.20]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local WARNING_WINDOW = true
                      -- = true   |on warning window
                      -- = false  |off warning window (Not recommend / Не рекомендуется)
                       
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.7.4",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    local NEXT_PATH = reaper.GetResourcePath()..[[/Scripts/Archie-ReaScripts/MAIN/Item/]]..
    'Archie_Item;  Switch item source file to next in folder.lua';
    
    
    local UNDO = 'Next file dir. All project';
    
    local Count_sel_item = reaper.CountSelectedMediaItems(0);
    if Count_sel_item == 0 then Arc.no_undo() return end;
    
    
    local selItemsT = {};
    local PathNameT = {};
    for i = Count_sel_item-1,0,-1 do;
        local itemSel = reaper.GetSelectedMediaItem(0,i);
        table.insert(selItemsT,itemSel);
        local take = reaper.GetActiveTake(itemSel);
        local Path,Name = Arc.GetPathAndNameSourceMediaFile_Take(take);
        if Path and Name then;
            PathNameT[Path..'/'..Name] = Path..'/'..Name;
        end;
    end;
    
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    for i = 1, reaper.CountMediaItems(0) do;
        local item = reaper.GetMediaItem(0,i-1);
        local take = reaper.GetActiveTake(item);
        local Path,Name = Arc.GetPathAndNameSourceMediaFile_Take(take);
        if Path and Name then;
            local PathName2 = Path..'/'..Name;
            if PathNameT[PathName2] then;
                if reaper.GetMediaItemInfo_Value(item,'B_UISEL')==0 then;
                    reaper.SetMediaItemInfo_Value(item,'B_UISEL',1);
                end;
            end;
        end;
    end;
    
    
    local x = 0;
    for i = 1, reaper.CountSelectedMediaItems(0)do;
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local take = reaper.GetActiveTake(item);
        local Midi_take = reaper.TakeIsMIDI(take);
        if not Midi_take then;
            x = x+1;
        end;
    end;
    
    
    local Pcall,Error,MB;
    if x > 0 then;
        if WARNING_WINDOW == true then;
            MB = reaper.MB('The replacement will be made in - '..x..' - items to the next file in the directory:\n'..
                 'Replace it exactly? -  Ok\n\n\n'..
                 'Замена будет произведена в - '..x..' - элементах на следующий файл в директории:\n'..
                 'Точно заменить ?  -  OK','Warning',1);
        else;
            MB = 1;
        end;
        if MB == 1 then; --1 ok
            Pcall,Error = pcall(dofile,NEXT_PATH);
        else;
            UNDO = '[Cancel] '..UNDO;
        end;
    end;
    
    
    reaper.SelectAllMediaItems(0,0);
    for i = 1, #selItemsT do;
        reaper.SetMediaItemInfo_Value(selItemsT[i],'B_UISEL',1);
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock(UNDO,-1);
    
    if not Pcall and Error then;
        error(Error);
    end;
    
    reaper.UpdateArrange();