--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Take
   * Description: Take; Copy Active take.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
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
    
    
    local item = reaper.GetSelectedMediaItem(0,0);
    if not item then no_undo() return end;
    -----
    -----
    local x=0;
    for i = 1,math.huge do;
       local Has = reaper.HasExtState('CopyPasteActiveTakeInActiveTake',i..'_strCPATAT');
       if Has then;
           reaper.DeleteExtState('CopyPasteActiveTakeInActiveTake',i..'_strCPATAT',false);
            x=0;
       else;
           x=x+1;
       end;
       if x >= 10 then break end;
    end;
    -----
    -----
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    local st = 9^9;
    Arc.Save_Selected_Items_Slot(1);
    
    reaper.SelectAllMediaItems(0,0);
    
    reaper.SetMediaItemSelected(item,1);
    
    local retval,str = reaper.GetItemStateChunk(item,'',false);
    
    local track = reaper.GetTrack(0,0);
    
    local itemNew = reaper.CreateNewMIDIItemInProj(track,st,st+1,false);
    
    reaper.SelectAllMediaItems(0,0);
    reaper.SetMediaItemSelected(itemNew,1);
    
    reaper.SetItemStateChunk(itemNew,str,false);
    
    Arc.Action(40131);--Crop to active take in items
    
    local retval, str = reaper.GetItemStateChunk(itemNew,'',false);
    
    reaper.DeleteTrackMediaItem(track,itemNew);
    
    Arc.Restore_Selected_Item_Slot(1,true,false,true);
    
    for var in (str..'\n'):gmatch("(.-)\n")do;
       i=(i or 0)+1;
       reaper.SetExtState('CopyPasteActiveTakeInActiveTake',i..'_strCPATAT',var,false);
    end;
    
    reaper.Undo_EndBlock('Copy Active take',-1);
    reaper.PreventUIRefresh(-1);
    
    
    