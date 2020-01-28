--[[
   * Category:    Track
   * Description: Smart template - Load Track template by name
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Smart template - Load Track template by name
   * О скрипте:   Умный шаблон - Загрузить шаблон трека по имени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   Ahmed5599887744112233[RMM]
   * Changelog:   
   *              v.1.03 [28.01.2020]
   *                  + Ability to enter the full path to the track template
   *                  + Возможность вписать полный путь к шаблону трека
   
   *              v.1.02 [30.07.2019]
   *                  + Added - Add a template to the selected track 
   *              v.1.01 [26.06.2019]
   *                  +! fixed bug when adding a template as the first track in the project
   *                  +! Исправлена ошибка при добавлении шаблона в качестве первого трека в проекте
   *              v.1.0 [04.03.2019]
   *                  +  initialе 
   

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




local
ScriptBeginning = [[    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
]]   
    
    
    
    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------
    


    ::Repeat::
    local
    retval,pathTemplates = reaper.GetUserInputs( "Smart template - Load Track templates by name.", 1,
                        "  Enter Name Track Templates:, extrawidth=300","nameTrackTemplates");
    if retval == false or pathTemplates:gsub(" ","") == "" then no_undo()return end;
      
    
    
    local Path1 = reaper.GetResourcePath().."/TrackTemplates/"..pathTemplates..".RTrackTemplate";
    local Path2 = reaper.GetResourcePath().."/TrackTemplates/"..pathTemplates;
    local Path3 = pathTemplates..".RTrackTemplate";
    local Path4 = pathTemplates;
    
    IO = io.open(Path1,"r");
    local 
    PathTrackTemplate = Path1;
    if not IO then;
       IO = io.open(Path2,"r");
       PathTrackTemplate = Path2;
    end;
    if not IO then;
       IO = io.open(Path3,"r");
       PathTrackTemplate = Path3;
    end;
    if not IO then;
       IO = io.open(Path4,"r");
       PathTrackTemplate = Path4;
    end;
    if not IO then;
        local MB = reaper.MB("Rus:\n"
                   .." * Отсутствует  шаблон дорожки с таким Именем!\n"
                   .." * Введите правильное Имя.\n\n"
                   .."Eng\n"
                   .." * Missing track template with this Name!\n"
                   .." * Enter a valid Name.\n",
                   "Warning!",5);
        if MB == 4 then goto Repeat end;
        no_undo() return;
    end;
    
    IO:close();
    
    
    local
    Path_Track_Template = PathTrackTemplate:gsub('\\','/');
    local
    Name_Track_Template = Path_Track_Template:match('^.+[/\\](.+).RTrackTemplate$');
    
    
    ----
    ::goto_SELECTED::
    local MB = reaper.MB("Rus:\n\n"
               .." * В следующем окне введите:\n"
               .."   0 - чтобы трек шаблон добавить как новый трек\n"
               .."   1 - чтобы заменить выделенные треки\n\n"
               .."Eng\n\n"
               .." * In the next window, enter:\n"
               .."   0 - to add the track template as a new track\n"
               .."   1 - to replace selected tracks\n",
               "Help!",1);
    if MB == 2 then no_undo() return end;
    
    local ret,SELECTED = reaper.GetUserInputs( "S.T. - Load Track templates by name.", 1,
                        " How add template",-1);
    if not ret then no_undo() return end;
    if SELECTED ~= "0" and SELECTED ~= "1" then goto goto_SELECTED end;
    SELECTED = tonumber(SELECTED);
    ----
    
    local Name_Script_NEW;
    if SELECTED == 0 then;
        Name_Script_NEW = "Archie_Track;  Load Track template with name - "..Name_Track_Template;
    elseif SELECTED == 1 then;
        Name_Script_NEW = "Archie_Track;  Load Track template for selected tracks with name - "..Name_Track_Template;
    end
    ----
    
    
    
    
    
    
    -----------
    local SCR = "--[[\n   * Description: "..Name_Script_NEW.."\n   * Author:      Archie\n"..
    "   * Website:     http://forum.cockos.com/showthread.php?t=212819 \n"..
    "   *              http://rmmedia.ru/threads/134701/ \n"..
    "   * DONATION:    http://money.yandex.ru/to/410018003906628 \n"..
    "   * Customer:    ---\n   * Gave idea:   Ahmed5599887744112233[RMM]\n--]]"..
    "\n\n\n\n"..ScriptBeginning.."\n\n"..[[
    
    
    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------
    
    
    local function LoadTrackTemplateByName(Path_Track_Template, Name_Script_NEW, SELECTED);
        
        
        local function replaceAllGuid(str);
            local var2;
            for var in str:gmatch(".-\n") do;
                local t;
                for x in var:gmatch("{.-}")do t = (t or 0)+1 end;
                for i = (t or 1), 1, -1 do;
                    var = var:gsub("{.-}",reaper.genGuid(),i);
                end;
                var2 = (var2 or "")..var;
            end;
            return var2;
        end;
        
        
            
        local IO; do;
            local Path = Path_Track_Template;
            IO = io.open(Path,"r");
            if not IO then goto MB end;
            local textTemplates = IO:read("a");
            IO:close();
        
        
            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);
            
            
            local str = string.gsub(textTemplates,"<TRACK","\n\n<TRACK").."\n\n";
                        
            
            if SELECTED == 0 then;
                -----------------
                local
                LastTouchedTrack = reaper.GetLastTouchedTrack();
                
                local trNumb;
                if LastTouchedTrack then;
                    trNumb = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"IP_TRACKNUMBER");
                    if trNumb < 0 then trNumb = 0 end;
                else;
                    trNumb = reaper.CountTracks(0);
                end;
                
                reaper.SelectAllMediaItems(0,0);
                str = replaceAllGuid(str);
                
                local several;
                for var in string.gmatch(str,"<TRACK.-\n\n") do;
                    reaper.InsertTrackAtIndex(trNumb,false);
                    local Track = reaper.GetTrack(0,trNumb);

                    str = var:gsub("\n\n","\n");
                    reaper.SetTrackStateChunk(Track,str,false);
                    
                    if not several then;
                        reaper.SetOnlyTrackSelected(Track);
                        several = true;
                    else;
                        reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",1);
                    end; 
                    trNumb = trNumb+1;
                end;
                -----------------
            elseif SELECTED == 1 then;
                ----
                str = str:match("<TRACK.-\n\n");
                local CountSelTrack = reaper.CountSelectedTracks(0);
                if CountSelTrack > 0 then;
                    reaper.SelectAllMediaItems(0,0);
                    
                    for i = 1,CountSelTrack do;
                        local SelTrack = reaper.GetSelectedTrack(0,i-1);
                        str = replaceAllGuid(str);
                        reaper.SetTrackStateChunk(SelTrack,str,false);
                    end;
                end;
                ----
            end;

            --reaper.ShowConsoleMsg( var2 )

            local Undo = Name_Script_NEW:gsub("Archie_Track;  ","");
            reaper.PreventUIRefresh(-1);
            reaper.Undo_EndBlock(Undo,-1);
        end;
        
        
        ::MB:: 
        if not IO then;
            local
            filename, scrName = ({reaper.get_action_context()})[2]:match("(.+)[/\\](.+)");
            local
            MB = reaper.MB(
            "Rus:\n"..
            " * Не существует шаблона дорожки с именем - \n"..
            "    "..Name_Script_NEW..".lua\n\n"..
            " * Создайте новый скрипт с помощью\n"..
            "    Archie_Track;  Smart template - Load Track template by name.lua\n"..
            "    И существующего шаблона дорожек! \n\n\n"..
            "Eng:\n"..
            " * There is no track template named - \n"..
            "    "..Name_Script_NEW..".lua\n\n"..
            " * Create a new script using\n"..
            "    Archie_Track;  Smart template - Load Track template by name.lua\n"..
            "    And existing track template! \n\n"..
            "-----------------\n\n"..
            " * УДАЛИТЬ ДАННЫЙ СКРИПТ ? - OK\n\n"..
            " * REMOVE THIS SCRIPT ? - OK\n",
            scrName,1);
            
            if MB == 1 then;
                reaper.AddRemoveReaScript(false,0,filename.."/"..scrName,true);
                os.remove(filename.."/"..scrName);
            end;
            no_undo() return;
        end;
    end;
    
    LoadTrackTemplateByName("]]..Path_Track_Template..[[","]]..Name_Script_NEW..[[",]]..SELECTED..[[);]]
    -----------
    
    
    
    
    
    
    
    local filePath = ({reaper.get_action_context()})[2]:match("(.+)[/\\]"); 
    
    
    local FileStop,i;
    while(not wh1)do;
        i = (i or 0)+1;
        local Files = reaper.EnumerateFiles(filePath,i-1);
        if Files == Name_Script_NEW or Files == Name_Script_NEW..".lua" then;
            FileStop = true end;
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
                             " * "..Name_Script_NEW..'.lua',
                             "Error !",1);
        if MB == 2 then no_undo() return end;
    end;
    -----
    
    
    local
    newScript = io.open(filePath.."/"..Name_Script_NEW..".lua",'w');
    newScript:write(SCR);
    newScript:close();
    reaper.AddRemoveReaScript(true,0,filePath.."/"..Name_Script_NEW..".lua",true);
    
    
    reaper.ClearConsole();
    
    reaper.ShowConsoleMsg("Rus:\n"..
                          " * Скрипт создан \n"..
                          "   "..Name_Script_NEW..".lua\n"..
                          " * Ищите в экшен листе \n\n"..
                          "Eng:\n"..
                          " * Script created \n"..
                          "   "..Name_Script_NEW..".lua\n"..
                          " * Search the action list"); 
                          -----------------------------
    no_undo();