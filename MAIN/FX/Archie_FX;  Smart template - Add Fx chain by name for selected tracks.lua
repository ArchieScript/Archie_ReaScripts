--[[
   * Category:    Fx
   * Description: Smart template - Add Fx chain by name for selected tracks
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Smart template - Add Fx chain by name for selected tracks
   * О скрипте:   Умный шаблон - добавить цепочку Fx по имени для выбранных треков
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Дима Горелик[RMM]
   * Gave idea:   Дима Горелик[RMM]
   * Changelog:   
   *              +  initialе / v.1.0 [01032019]


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
    
    
    
    reaper.ClearConsole();
    reaper.ShowConsoleMsg( "Rus:\n"..
                           " Создать скрипт:\n"..
                           " *  Введите в первом появившемся окне сохраненную цепочку Fx, \n"..
                           " *  Во втором появившемся окне введите номер,  \n"..
                           "     Как открывать при добавлении Fx цепочку  \n"..
                           " *  0 - Не открывать \n"..
                           " *  1 - Открыть в цепочке \n"..
                           " *  2 - Открыть плавающий \n\n"..
                           "Eng:\n"..
                           " Create script\n"..
                           " * Enter the saved Fx chain in the first window that appears,\n"..
                           " * In the second window that appears, enter the number, \n"..
                           "    How to open when you add a Fx chain\n"..
                           " * 0 - Not open\n"..
                           " * 1 - To open in the chain\n"..
                           " * 2 - Open floating\n");
   
    ----
    ::Repeat::
    local
    retval,retvals_csv = reaper.GetUserInputs( "Smart template - Add Fx chain by name for selected tracks", 1,
                        "    Enter Name Saved Fx Chain:, extrawidth=87","");
    if retval == false or retvals_csv:gsub(" ","") == "" then no_undo()return end;
    
    

    --------------------------------------------------
    local
    pathChain = reaper.GetResourcePath()..'/FXChains';
    --------------------------------------------------
    
    
    local ChainWithExt,ChainWithoutExt,Saved_FxChain,i,ext;
    while(not j) do;
        i = (i or 0) + 1;
        ChainWithExt = reaper.EnumerateFiles(pathChain,i);
        if ChainWithExt then;
            if ChainWithExt:match("%.")then;
                ext = string.reverse(ChainWithExt):match(".-%."):reverse();
                if ext and ext == string.match(ext,"%.RfxChain") then;
                    ChainWithoutExt = string.reverse(ChainWithExt):gsub(".-%.","",1):reverse();
                end;
            end;     
            if ChainWithExt == retvals_csv or ChainWithoutExt == retvals_csv then;
                Saved_FxChain = retvals_csv;
            end;
        end;
        if not ChainWithExt or Saved_FxChain then i = nil goto exit1 end;
    end
    ::exit1::



    if not Saved_FxChain then;
        local MB = reaper.MB("Rus:\n"
                   .." * Отсутствует цепочка Fx с таким Именем!\n"
                   .." * Введите правильное Имя.\n\n"
                   .."Eng\n"
                   .." * Missing Fx chain with this Name!\n"
                   .." * Enter a valid Name.\n",
                   "Warning!",5);
        if MB == 4 then goto Repeat end;
        no_undo() return;
    end;
 
    
    
    if Saved_FxChain:match("%.")then;
        if string.reverse(Saved_FxChain):match(".-%."):reverse()== ".RfxChain" then;
            Saved_FxChain = Saved_FxChain:reverse():gsub(".-%.","",1):reverse();
        end;
    end;
    
    
    local
    NameScrNEXT = "Add Fx chain with Name - "..Saved_FxChain;
    --------
    
    
    
    -----------
    ::Repeat2::
    local
    retval,retvals_csv = reaper.GetUserInputs("Smart template - Add Fx chain by name for selected tracks", 1,
                        "Open Fx: No-0; chain-1; float-2;, extrawidth=87",0);
    if retval == false then no_undo()return end;
    
    
    if retvals_csv ~= "0" and retvals_csv ~= "1" and retvals_csv ~= "2" then;
        local MB = reaper.MB("Rus:\n"
                   .." * Неверные значения!!!\n"
                   .." * Введите значение от 0 до 2.\n"
                   .." * No-0; chain-1; float-2;.\n\n"
                   .."Eng\n"
                   .." * Invalid values!!!\n"
                   .." * Enter a value between 0 and 2.\n"
                   .." * No-0; chain-1; float-2;.\n\n",
                   "Warning!",5);
        if MB == 4 then goto Repeat2 end;
        no_undo() return;
    end;
    
    
    local OpenScrName;
    if retvals_csv == "0" then;
        OpenScrName = "' Not open";
    elseif retvals_csv == "1" then;
        OpenScrName = "' Open chain";
    elseif retvals_csv == "2" then;
        OpenScrName = "' Open float";
    else;
        OpenScrName = "";
    end;
    --------
    
    local
    NameScrNEXT = "Archie_FX;  Add Fx chain with Name - "..Saved_FxChain..OpenScrName.."- for selected tracks";
    local open_Fx = tonumber(retvals_csv);
    local Name_FXChains = Saved_FxChain;
    --------



    -----------
    local SCR = "--[[\n   * Description: "..NameScrNEXT.."\n   * Author:      Archie\n"..
    "   * Website:     http://forum.cockos.com/showthread.php?t=212819 \n"..
    "   *              http://rmmedia.ru/threads/134701/ \n"..
    "   * DONATION:    http://money.yandex.ru/to/410018003906628 \n"..
    "   * Customer:    Дима Горелик[RMM]\n   * Gave idea:   Дима Горелик[RMM]\n--]]"..
    "\n\n\n\n"..ScriptBeginning.."\n\n"..[[
    
    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------
    
    
    
    local function PasteFXChainByNameToSelTr(Name_FXChains,open_Fx,NameOfThisScript);
    
        local NameOfThisScript = NameOfThisScript:gsub("Archie_FX;  ","");
        local IO; 
        do;
            local Path = reaper.GetResourcePath().."/FXChains/"..Name_FXChains..".RfxChain";
            IO = io.open(Path,"r");
            if not IO then goto MB end;
            local textChain = IO:read("a");
            IO:close();
            
            
            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);
            
            local t = {};
            reaper.InsertTrackAtIndex(0,false);
        
            local firstTr = reaper.GetTrack(0,0);
            local retval,str = reaper.GetTrackStateChunk(firstTr,"",false);
            
            for var in string.gmatch(str, ".-\n") do;
                t[#t+1] = var;
                local MAINSEND = string.match (var, "MAINSEND"); 
                if MAINSEND then;
                    table.insert(t,"<FXCHAIN\n");
                    table.insert(t,textChain);
                end;
            end;
            local setChunk = table.concat(t);
            
            reaper.SetTrackStateChunk(firstTr,setChunk,false);
            
            local countSelTrack = reaper.CountSelectedTracks(0);
            local FX_Count = reaper.TrackFX_GetCount(firstTr);
            
            for i = 1, countSelTrack do;
                local selTrack = reaper.GetSelectedTrack(0,i-1);
                
                for i2=1,FX_Count do;
                    alwaysLastFx = reaper.TrackFX_GetCount(selTrack);
                    reaper.TrackFX_CopyToTrack(firstTr,i2-1,selTrack,alwaysLastFx,0);
                    if open_Fx > 1 then open_Fx = 3 end;
                    if open_Fx == 3 or open_Fx == 1 then;
                        reaper.TrackFX_Show(selTrack,alwaysLastFx,open_Fx);
                    end;
                end;
            end;
            
            reaper.DeleteTrack(firstTr);
            reaper.PreventUIRefresh(-1);
            reaper.Undo_EndBlock(NameOfThisScript,-1);
        end;
        
        ::MB:: 
        if not IO then;
            local
            MB = reaper.MB(
            "Rus:\n"..
            " * Не существует цепочки FX с именем - \n"..
            "    "..Name_FXChains.."\n\n"..
            " * Создайте новый скрипт с помощью\n"..
            "    Archie_FX;  Smart template - Add Fx chain by name for selected tracks.lua\n"..
            "   И существующей цепочки Fx! \n\n\n"..
            "Eng:\n"..
            " * There is no FX chain with a name - \n"..
            "    "..Name_FXChains.."\n\n"..
            " * Create a new script using\n"..
            "    Archie_FX;  Smart template - Add Fx chain by name for selected tracks.lua\n"..
            "   And existing Fx chain! \n\n"..
            "-----------------\n\n"..
            " * УДАЛИТЬ ДАННЫЙ СКРИПТ ? - OK\n\n"..
            " * REMOVE THIS SCRIPT ? - OK\n",
            NameOfThisScript,1);
            
            if MB == 1 then;   
                local
                filename = ({reaper.get_action_context()})[2];
                reaper.AddRemoveReaScript(false,0,filename,true);
                os.remove(filename);
            end;
            no_undo() return;
         end;
    end;
 
    PasteFXChainByNameToSelTr(]]..'"'..Name_FXChains..'"'..","..open_Fx..[[,
              "]]..NameScrNEXT..'"'..[[);]]
    ---------------------------------------
 
 
    local filename = ({reaper.get_action_context()})[2]:match("(.+)[/\\](.+)"); 
    
    
    local FileStop,i;
    while(not wh1)do;
        i = (i or 0)+1;
        local Files = reaper.EnumerateFiles(filename,i);
        if Files == NameScrNEXT or Files == NameScrNEXT..".lua" then
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
                          " * "..NameScrNEXT..".lua\n"..
                          " * Ищите в экшен листе \n\n"..
                          "Eng:\n"..
                          " * Script created \n"..
                          " * "..NameScrNEXT..".lua\n"..
                          " * Search the action list"); 
                          -----------------------------
    no_undo();