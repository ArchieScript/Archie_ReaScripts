--[[
   * Category:    Track
   * Description: Smart template - Load Track template by name
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Smart template - Load Track template by name
   * О скрипте:   Умный шаблон - Загрузить шаблон трека по имени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   Ahmed5599887744112233[RMM]
   * Changelog:   
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
    retval,retvals_csv = reaper.GetUserInputs( "Smart template - Load Track templates by name.", 1,
                        "  Enter Name Track Templates:, extrawidth=87","name");
    if retval == false or retvals_csv:gsub(" ","") == "" then no_undo()return end;
    

    ------------------------------------------------------------
    local
    pathTemplates = reaper.GetResourcePath()..'/TrackTemplates';
    ------------------------------------------------------------
    
    
    local templateWithExt,templateWithoutExt,Saved_TrackTemplates,i,ext;
    while(not j) do;
        i = (i or 0) + 1;
        templateWithExt = reaper.EnumerateFiles(pathTemplates,i-1);
        if templateWithExt then;
            if templateWithExt:match("%.")then;
                ext = string.reverse(templateWithExt):match(".-%."):reverse();
                if ext and ext == string.match(ext,"%.RTrackTemplate") then;
                    templateWithoutExt = string.reverse(templateWithExt):gsub(".-%.","",1):reverse();
                end;
            end;     
            if templateWithExt == retvals_csv or templateWithoutExt == retvals_csv then;
                Saved_TrackTemplates = retvals_csv;
            end;
        end;
        if not templateWithExt or Saved_TrackTemplates then i = nil goto exit1 end;
    end
    ::exit1::
    
    
    if not Saved_TrackTemplates then;
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
    
    
    if Saved_TrackTemplates:match("%.")then;
        if string.reverse(Saved_TrackTemplates):match(".-%."):reverse()== ".RTrackTemplate" then;
            Saved_TrackTemplates = Saved_TrackTemplates:reverse():gsub(".-%.","",1):reverse();
        end;
    end;
    
    
    local
    Name_TrTemplate = Saved_TrackTemplates;
    
    local
    NameScrNEXT = "Archie_Track;  Load Track template with name - "..Name_TrTemplate;
    ----
    
    
    
    
    -----------
    local SCR = "--[[\n   * Description: "..NameScrNEXT.."\n   * Author:      Archie\n"..
    "   * Website:     http://forum.cockos.com/showthread.php?t=212819 \n"..
    "   *              http://rmmedia.ru/threads/134701/ \n"..
    "   * DONATION:    http://money.yandex.ru/to/410018003906628 \n"..
    "   * Customer:    ---\n   * Gave idea:   Ahmed5599887744112233[RMM]\n--]]"..
    "\n\n\n\n"..ScriptBeginning.."\n\n"..[[
    
    
    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------
    
    
    local function LoadTrackTemplateByName(Name_TrTemplate,NameScrNEXT);
            
        local IO; do;
            local Path = reaper.GetResourcePath().."/TrackTemplates/"..Name_TrTemplate..".RTrackTemplate";
            IO = io.open(Path,"r");
            if not IO then goto MB end;
            local textTemplates = IO:read("a");
            IO:close();
        
        
            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);
            
            local str = string.gsub(textTemplates,"<TRACK","\n\n<TRACK").."\n\n";
     
            local
            LastTouchedTrack = reaper.GetLastTouchedTrack();
            
            
            local trNumb;
            if LastTouchedTrack then;
                trNumb = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"IP_TRACKNUMBER");
            else;
                trNumb = 0;
            end;
            
            
            local several;
            for var in string.gmatch(str,"<TRACK.-\n\n") do;
            
                reaper.InsertTrackAtIndex(trNumb,false);
                local Track = reaper.GetTrack(0,trNumb);
            
                math.randomseed(tostring(os.clock()):gsub("%.",""));
                local randFirst = math.random (9);
                local randLast  = math.random (9);
                local str = var:gsub("{.","{"..randFirst):gsub(".}",randLast.."}"):gsub("\n\n","\n");
               
                reaper.SetTrackStateChunk(Track,str,false);
                
                if not several then;
                    reaper.SetOnlyTrackSelected(Track);
                    several = true;
                else;
                    reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",1);
                end;
                
                trNumb = trNumb+1;
            
            end;
     
            local Undo = NameScrNEXT:gsub("Archie_Track;  ","");
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
            "    "..Name_TrTemplate.."\n\n"..
            " * Создайте новый скрипт с помощью\n"..
            "    Archie_Track;  Smart template - Load Track template by name.lua\n"..
            "    И существующего шаблона дорожек! \n\n\n"..
            "Eng:\n"..
            " * There is no track template named - \n"..
            "    "..Name_TrTemplate.."\n\n"..
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
    
    LoadTrackTemplateByName("]]..Name_TrTemplate..[[","]]..NameScrNEXT..[[");]]
    -----------
    
    
    
    local filename = ({reaper.get_action_context()})[2]:match("(.+)[/\\](.+)"); 
    
    
    local FileStop,i;
    while(not wh1)do;
        i = (i or 0)+1;
        local Files = reaper.EnumerateFiles(filename,i-1);
        if Files == NameScrNEXT or Files == NameScrNEXT..".lua" then;
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
                             " * "..NameScrNEXT,
                             "Error !",1);
        if MB == 2 then no_undo() return end;
    end;
    -----
    
    
    local
    newScript = io.open(filename.."/"..NameScrNEXT..".lua",'w');
    newScript:write(SCR);
    newScript:close();
    reaper.AddRemoveReaScript(true,0,filename.."/"..NameScrNEXT..".lua",true);
    
    
    reaper.ClearConsole();
    reaper.ShowConsoleMsg("Rus:\n"..
                          " * Скрипт создан \n"..
                          "   "..NameScrNEXT..".lua\n"..
                          " * Ищите в экшен листе \n\n"..
                          "Eng:\n"..
                          " * Script created \n"..
                          "   "..NameScrNEXT..".lua\n"..
                          " * Search the action list"); 
                          -----------------------------
    no_undo();