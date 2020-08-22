--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Copy selected files from media explorer to project subdirectory
   * Author:      Archie
   * Version:     1.03
   * AboutScript: ---
   * О скрипте:   Копирование выбранных файлов из проводника мультимедиа в подкаталог проекта
   * GIF:         http://avatars.mds.yandex.net/get-pdb/1969020/73e651b5-2612-45a3-b605-c2d26fd3b5ce/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Maestro Sound(RMM)
   * Gave idea:   Maestro Sound(RMM)
   * Changelog:
   *              v.1.01[04.08.2019]
   *                  ! Fixed bug copying the same file to a directory

   *              v.1.0[02.08.2019]
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
    (+) Arc_Function_lua v.2.4.8 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
    (+) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local NAME_FOLDER = "Arc-Copy Explorer"
                       -- Введите имя созданной папки
                       -- Enter the name of the created folder


    local COPY_REQUEST = 1
                    -- = 0 Не показывать запрос о копировании
                    -- = 1 Показывать запрос о копировании
                         --------------------------------
                    -- = 0 Do not show copy request
                    -- = 1 Show copy request
                    ------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	



    local Api_js, version = Arc.js_ReaScriptAPI(true,0.989);


    local title = reaper.JS_Localize("Media Explorer","common");
    if title ~= "Media Explorer" then;
        reaper.MB("Rus:\n\nДля работы скрипта язык интерфейса должен быть\nустановлен на английский !!!\n\n\n"..
                  "Eng:\n\nFor the script to work, the interface language must be set to English !!!"
                  ,"Error",0);
        Arc.no_undo() return;
    end;


    local ToggleExplorer = reaper.GetToggleCommandStateEx(0,50124)--Media explorer: Show/hide
    if ToggleExplorer ~= 1 then;
        reaper.MB("Rus:\n\nОбозреватель мультимедиа закрыт !!!\n\n\n"..
                  "Eng:\n\nMedia Explorer is closed !!!"
                  ,"Error",0);
        Arc.no_undo() return;
    end;



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



    --------------------------------------------------------------
    --http://forum.cockos.com/showthread.php?p=2071080#post2071080
    local title = reaper.JS_Localize("Media Explorer","common");
    local hWnd = reaper.JS_Window_Find(title, true);
    if not hWnd then Arc.no_undo() return end;
    ----
    local container = reaper.JS_Window_FindChildByID(hWnd     , 0   );
    local file_LV   = reaper.JS_Window_FindChildByID(container, 1000);
    ----
    local sel_count, sel_index = reaper.JS_ListView_ListAllSelItems(file_LV);
    if sel_count == 0 then;
        reaper.MB("Rus:\n\nНет выбранных файлов !!!\n\n\nEng:\n\nNo selected file !!!","Error",0);
        Arc.no_undo() return;
    end;
    ----
    -- get selected path  from edit control inside combobox
    local combo = reaper.JS_Window_FindChildByID(hWnd, 1002);
    local edit = reaper.JS_Window_FindChildByID(combo, 1001);
    local pathSample = reaper.JS_Window_GetTitle(edit, "", 255);
    ----
    local fileName = {};
    for var in string.gmatch(sel_index, '[^,]+') do;
        fileName[#fileName+1] = reaper.JS_ListView_GetItemText(file_LV, tonumber(var), 0);
    end;
    --------------------------------------------------



    ::gotoSaveProject::;
    local retval,projfn = reaper.EnumProjects(-1,"");
    if projfn == "" then;
        local MB = reaper.MB("Rus:\n\nПроект не сохранен, Некуда копировать,  \nСохранить проект как ... ? \n\n\n"..
                            "Eng:\n\nProject not saved, there is Nowhere to copy \nSave project as ... ?"
                           ,"Save project",1);
        if MB == 2 then Arc.no_undo() return end;
        reaper.Main_SaveProject(-1,true);
        goto gotoSaveProject;
    end;


    local MB,title;
    if COPY_REQUEST == 0 then;
        MB = 1;
    else;
        title = 'Rus:\nСкопировать файл в каталог проекта в подкаталог "'..NAME_FOLDER..'" ?\n\n'..
                'Eng:\nCopy the file to the project directory in a subdirectory "'..NAME_FOLDER..'"?'
        MB = reaper.MB(title,"Copy file in directory",1);
    end;

    if MB == 1 then;
        local buf = projfn:match("(.+)[/\\]").."/"..NAME_FOLDER;

        reaper.RecursiveCreateDirectory(buf,0);
        for i = 1,#fileName do;
            copyFile(pathSample.."/"..fileName[i], buf.."/"..fileName[i]);
        end;
    end;
    Arc.no_undo();