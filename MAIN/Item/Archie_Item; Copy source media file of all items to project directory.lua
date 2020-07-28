--[[ 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Item 
   * Description: Copy source media file of all items to project directory (all take) 
   * Author:      Archie 
   * Version:     1.0 
   * AboutScript: --- 
   * О скрипте:   Скопировать исходный медиа файл у всех элементов в каталог проекта (все тейки) 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Maestro Sound(Rmm) 
   * Gave idea:   Maestro Sound(Rmm) 
   * Changelog:   v.1.0 [04.08.19] 
   *                  + initialе 
 
    -- Тест только на windows  /  Test only on windows. 
    --======================================================================================= 
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:          
    (+) - required for installation      | (+) - обязательно для установки 
    (-) - not necessary for installation | (-) - не обязательно для установки 
    ----------------------------------------------------------------------------------------- 
    (+) Reaper v.5.981 +            --| http://www.reaper.fm/download.php 
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php 
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos 
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw     
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6 
    =======================================================================================]]   
     
     
     
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
     
    local NAME_FOLDER = -1 
                   -- = -1 Путь для сохранения медиафайлов,  
                   --      который установлен в настройках проекта 
                   --      иначе введите имя папки.  
                   --      Например: NAME_FOLDER = "My sample" 
                           ----------------------------------- 
                   -- = -1 The path to save media files, 
                   --      which is set in the project settings 
                   --      otherwise enter the name of the folder. 
                   --      For example: NAME_FOLDER = "My sample" 
                   --------------------------------------------- 
     
     
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
     
    local function copyFile(file1,file2); 
        local in_file = io.open(file1,"rb"); 
        if not in_file then return false end; 
        local in_str = in_file:read("*a"); 
        in_file:close(); 
        ----/Один и тот же файл/---- 
        local check_file = io.open(file2,"rb"); 
        if check_file then; 
            local check_file_str = check_file:read("*a"); 
            check_file:close(); 
            if in_str == check_file_str then; 
                return -1, file2; 
            end; 
        end; 
        ---------------------------- 
        local x,i = file2; 
        while true do; 
            i = (i or 0)+1; 
            local check_file = io.open(file2,"r"); 
            if not check_file then break end; 
            check_file:close(); 
            file2 = x; 
            local pach, name = file2:match("(.+)[/\\](.+)"); 
            local name_no_extension = name:match("(.+)%..-$") or name:match(".+$"); 
            local extension = name:match(".+(%..-)$"); 
            file2 = pach.."/"..name_no_extension.."_"..i..extension; 
        end; 
        ---- 
        local out_file = io.open(file2,"wb"); 
        if not out_file then return false end; 
        out_file:write(in_str); 
        out_file:close(); 
        return true, file2; 
    end; 
     
     
    local function slash(); 
        return ({reaper.get_action_context()})[2]:match("[\\/]"); 
    end; 
     
     
    local function GetPathSourceMediaFile_TakeEx(take); 
        if reaper.TakeIsMIDI(take)then return false,false end; 
        local source = reaper.GetMediaItemTake_Source(take); 
        local filenamebuf = reaper.GetMediaSourceFileName(source,""); 
        if filenamebuf == "" then 
            source = reaper.GetMediaSourceParent(source); 
        end; 
        filenamebuf = reaper.GetMediaSourceFileName(source,""); 
        local Path,Name = filenamebuf:match("(.+)[/\\](.+)"); 
        return Path,Name; 
    end; 
     
     
     
     
    local CountItem = reaper.CountMediaItems(0); 
    if CountItem == 0 then no_undo() return end; 
     
     
    ::gotoSaveProject::; 
    local retval,projfn = reaper.EnumProjects(-1,""); 
    if projfn == "" then; 
        local MB = reaper.MB("Rus:\n\nПроект не сохранен, Некуда копировать,  \nСохранить проект как ... ? \n\n\n".. 
                            "Eng:\n\nProject not saved, there is Nowhere to copy \nSave project as ... ?" 
                           ,"Save project",1); 
        if MB == 2 then no_undo() return end; 
        reaper.Main_SaveProject(-1,true); 
        goto gotoSaveProject; 
    end; 
    local NewPath; 
    local Proj_Path = projfn:match("(.+)[/\\]"); 
    if type(NAME_FOLDER) == "string" and #NAME_FOLDER > 0 then; 
        NewPath = Proj_Path..slash()..NAME_FOLDER; 
    else; 
        NewPath = reaper.GetProjectPath(""); 
    end; 
    reaper.RecursiveCreateDirectory(NewPath,0); 
     
     
     
    for i = 1, CountItem do; 
        local Item = reaper.GetMediaItem(0,i-1); 
        local CountTake = reaper.CountTakes(Item); 
        for i2 = 1, CountTake do; 
            local Take = reaper.GetMediaItemTake(Item,i2-1); 
            local Path, Name = GetPathSourceMediaFile_TakeEx(Take); 
            if Path and Name and Path ~= NewPath then; 
                -----  
                if not Path:match(Proj_Path) then;--Если файл не в папке с проектом 
                     
                    local _,nameTake = reaper.GetSetMediaItemTakeInfo_String(Take,"P_NAME",0,0); 
                     
                    local ret,newPath = copyFile(Path..slash()..Name, NewPath..slash()..Name); 
                    if ret and newPath then; 
                        reaper.BR_SetTakeSourceFromFile2(Take,newPath,false,true); 
                         
                        if Name == nameTake then; 
                            Name = newPath:match(".+[/\\](.+)"); 
                            reaper.GetSetMediaItemTakeInfo_String(Take,"P_NAME",Name,1); 
                        end; 
                         
                    end; 
                end;---- 
                ---- 
            end; 
        end; 
    end; 
     
    no_undo(); 