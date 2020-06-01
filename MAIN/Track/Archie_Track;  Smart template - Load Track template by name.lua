--[[
   * Category:    Track
   * Description: Smart template - Load Track template by name
   * Author:      Archie
   * Version:     1.04
   * AboutScript: Smart template - Load Track template by name
   * О скрипте:   Умный шаблон - Загрузить шаблон трека по имени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   Ahmed5599887744112233[RMM]
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.03 [010620]
   *                  +! Rewritten algorithm
   
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
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    



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
    
    local
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
    local
    Name_Script_NEW = "Archie_Track;  Load Track template with name - "..Name_Track_Template;

    
    
    
    
    
    
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
        
        
        local IO; do;
            
            local N = ('\n'):rep(6);
            local Path = Path_Track_Template;
            IO = io.open(Path,"r");
            if not IO then goto MB end;
            local textTemplates = IO:read("a")..N;
            IO:close();
            
            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);
            
            local trackX = reaper.GetLastTouchedTrack();
            if not trackX then;
                trackX = reaper.GetTrack(0,reaper.CountTracks(0)-1);
            end;
            --
            local tbl = {};
            for var in string.gmatch(textTemplates,".-\n") do;
                if var:match('^%s-<TRACK.-')then;
                    var = N..var;
                end;
                tbl[#tbl+1] = var;
            end;
            textTemplates = table.concat(tbl);
            
            reaper.SelectAllMediaItems(0,0);
            
            local tbl = {};
            local trNumb = 0;
            local several;
            for var in string.gmatch(textTemplates,"<TRACK.-"..N)do;
                reaper.InsertTrackAtIndex(trNumb,false);
                local Track = reaper.GetTrack(0,trNumb);
                tbl[#tbl+1] = {};
                tbl[#tbl].track = Track;
                tbl[#tbl].str = var;
                trNumb = trNumb+1;
                if not several then;
                    reaper.SetOnlyTrackSelected(Track);
                    several = true;
                else;
                    reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",1);
                end;
            end;
            
            local guidNum = math.random(1000,9999);
            for i = 1,#tbl do;
                reaper.SetTrackStateChunk(tbl[i].track,tbl[i].str,false);
                local _,guid = reaper.GetSetMediaTrackInfo_String(tbl[i].track,'GUID','',false);
                local guid = guid:gsub('....%}',guidNum..'}');
                reaper.GetSetMediaTrackInfo_String(tbl[i].track,'GUID',guid,true);
                ---
                for i = 1,reaper.CountTrackMediaItems(tbl[#tbl].track) do;
                    item = reaper.GetTrackMediaItem(tbl[#tbl].track,i-1);
                    _,itemGuid = reaper.GetSetMediaItemInfo_String(item,'GUID','',0);
                    local itemGuid = itemGuid:gsub('....%}',guidNum..'}');
                    reaper.GetSetMediaItemInfo_String(item,'GUID',itemGuid,1);
                    for i2 = 1,reaper.CountTakes(item) do;
                        local take = reaper.GetMediaItemTake(item,i2-1);
                        local _,takeGuid = reaper.GetSetMediaItemTakeInfo_String(take,'GUID','',0);
                        local takeGuid = takeGuid:gsub('....%}',guidNum..'}');
                        reaper.GetSetMediaItemTakeInfo_String(take,'GUID',takeGuid,1);
                    end;
                end;
            end;
            
            local Depth = reaper.GetTrackDepth(tbl[#tbl].track);
            if Depth > 0 then;
                reaper.SetMediaTrackInfo_Value(tbl[#tbl].track,'I_FOLDERDEPTH',Depth-Depth*2);
            end;
            
            local numbX;
            if trackX then;
                numbX = reaper.GetMediaTrackInfo_Value(trackX,'IP_TRACKNUMBER');
            end;
            if not numbX then;
                numbX = reaper.CountTracks(0);
            end;
            
            if numbX~=0 then;
                reaper.ReorderSelectedTracks(numbX,0);
            end;
            
            local Undo = Name_Script_NEW:gsub("Archie_Track;  ","");
            reaper.PreventUIRefresh(-1);
            reaper.Undo_EndBlock(Undo,-1);
        end;
        -----------
        
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
    
    LoadTrackTemplateByName("]]..Path_Track_Template..[[","]]..Name_Script_NEW..[[");]];
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