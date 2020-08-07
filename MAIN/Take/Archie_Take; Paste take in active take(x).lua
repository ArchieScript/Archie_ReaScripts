--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Take
   * Description: Take; Paste take in active take(x).lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Provides:    
   *              [nomain] .
   *              [main] . > Archie_Take; Paste take in active take.lua
   *              [main] . > Archie_Take; Paste take in active take (user request).lua
   *              [main] . > Archie_Take; Paste take in active take (copy length).lua
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.9.0+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [070820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.9.0",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
    
    
    local COPY_LENGTH = true; -- boolean
    local REQUEST = true;
    
    
    
    --=========================================
    local scrPath,scrName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
    if scrName:match('take%s-%.%s-lua')then;
        COPY_LENGTH = false;
        REQUEST = false;
    elseif scrName:match('take%s-%(%s-user%s-request%s-%)%s-%.%s-lua')then;
        COPY_LENGTH = false;
        REQUEST = true;
    elseif scrName:match('take%s-%(%s-copy%s-length%s-%)%s-%.%s-lua')then;
        COPY_LENGTH = true;
        REQUEST = false;
    else;
        reaper.MB('Неверное имя скрипта\n\nInvalid script name','woops',0);
        no_undo() return
    end;
    --=========================================
     
    
    
    if COPY_LENGTH == 1 then COPY_LENGTH = true end;
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    local x=0;
    local strX = '';
    for i = 1,math.huge do;
        local Has = reaper.HasExtState('CopyPasteActiveTakeInActiveTake',i..'_strCPATAT');
        if Has then;
            local str = reaper.GetExtState('CopyPasteActiveTakeInActiveTake',i..'_strCPATAT');
            x=0;
            strX = strX..str..'\n';
        else;
            x=x+1;
        end;
        if x >= 10 then break end; 
    end;
    str = strX;
    ----
    ----
    if type(str)~='string'or str == '' then no_undo()return end;
    ----
    ----
    if REQUEST == true then;
        local mb = reaper.MB('Copy Length ?','Paste take in active take',3);
        if mb == 2 then no_undo()return end;
        if mb == 7 then COPY_LENGTH = false end;
        if mb == 6 then COPY_LENGTH = true end;
    end;
    ----
    ----
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    ----
    ----
    local _,itemSV = Arc.Save_Selected_Items_Slot(1);
    reaper.SelectAllMediaItems(0,0);
    ----
    ----
    local t = {};
    for i = 1,#itemSV do;
        reaper.SetMediaItemSelected(itemSV[i],1);
        local track = reaper.GetMediaItem_Track(itemSV[i]);
        local pos = reaper.GetMediaItemInfo_Value(itemSV[i],'D_POSITION');
        local len = reaper.GetMediaItemInfo_Value(itemSV[i],'D_LENGTH');
        local itemNew = reaper.CreateNewMIDIItemInProj(track,pos,pos+len,false);
        Arc.Action(40129);--Delete active take from items
        reaper.SetItemStateChunk(itemNew,str,false);
        reaper.SetMediaItemInfo_Value(itemNew,'D_POSITION',pos);
        if COPY_LENGTH ~= true then;
            reaper.SetMediaItemInfo_Value(itemNew,'D_LENGTH',len);
        end;
        Arc.Action(40543);--Implode items on same track into takes
        ----
        local item = reaper.GetSelectedMediaItem(0,0);
        t[#t+1]=item;
        ----
        reaper.SelectAllMediaItems(0,0);
    end;
    
    for i = 1,#t do;
        reaper.SetMediaItemSelected(t[i],1);
    end;
    
    reaper.Undo_EndBlock('Paste take in active take',-1);
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();
    
    
    