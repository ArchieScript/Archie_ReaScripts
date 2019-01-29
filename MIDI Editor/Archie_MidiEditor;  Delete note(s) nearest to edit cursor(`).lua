--[[
   * Category:    MidiEditor
   * Description: Delete note(s) nearest to edit cursor
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Delete note(s) nearest to edit cursor
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Удалить ноту(ы), ближайшую к курсору редактирования
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    borisuperful(Rmm/forum)
   * Gave idea:   borisuperful(Rmm/forum)
   * Changelog:   +  initialе / v.1.0
--===========================================================
SYSTEM  REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.96 --------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
    SWS v.2.9.7 ------------ \ http://www.sws-extension.org/index.php -\(and above \ и выше)\
    ReaPack v.1.2.2 --------- \  http://reapack.com/repos --------------\(and above \ и выше)\
    Arc_Function_lua v.2.9.7 - \ http://clck.ru/EjERc -------------------\(and above \ и выше)\
--===========================================================================================]]



    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local Move_Cursor = 0
                   -- = 1 | ПЕРЕМЕСТИТЬ КУРСОР К ПОЗИЦИИ УДАЛЯЕМОЙ НОТЫ
                   --     | MOVE THE CURSOR TO THE POSITION OF THE NOTE TO BE DELETED
                                                       ------------------------------
                   -- = 0 | НЕ ПЕРЕМЕЩАТЬ КУРСОР К ПОЗИЦИИ УДАЛЯЕМОЙ НОТЫ
                   --     | DO NOT MOVE THE CURSOR TO THE POSITION OF THE NOTE TO BE DELETED
                   --------------------------------------------------------------------------  

    local DeselectPrevious = 1
                        -- = 1 | СНЯТЬ ВЫДЕЛЕНИЕ С ПРЕДЫДУЩИХ НОТ
                        --     | TO REMOVE THE SELECTION FROM THE PREVIOUS NOTES 
                                                             -------------------
                        -- = 0 | НЕ СНИМАТЬ ВЫДЕЛЕНИЕ С ПРЕДЫДУЩИХ НОТ 
                        --     | DO NOT DESELECT THE PREVIOUS NOTES 
                        -------------------------------------------  




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.2",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================






    local MidiEditor = reaper.MIDIEditor_GetActive();
    if not MidiEditor then Arc.no_undo() return end;


    local Take = reaper.MIDIEditor_GetTake(MidiEditor);
    local retval,count_notes,ccs,sysex = reaper.MIDI_CountEvts(Take);
    if count_notes == 0 then Arc.no_undo() return end;
    
    
    reaper.Undo_BeginBlock();


    local PosCur = reaper.GetCursorPosition();
    local nearest,nearestpos = (9^99);

    for i = 1,count_notes do
        local retval,sel,muted,startppq,endppq,chan,pitch,vel = reaper.MIDI_GetNote(Take,i-1)
        local pos = reaper.MIDI_GetProjTimeFromPPQPos(Take, startppq)
        local to_note = math.abs(pos - PosCur)
        if to_note < nearest then
            nearest = to_note
            nearestpos = pos
        end   
    end
    for i = count_notes-1,0,-1 do
        local retval,sel,muted,startppq,endppq,chan,pitch,vel = reaper.MIDI_GetNote(Take,i)
        if DeselectPrevious == 1 then
            reaper.MIDI_SetNote(Take,i,0)
        end
        local pos = reaper.MIDI_GetProjTimeFromPPQPos(Take, startppq)
        if pos == nearestpos then
            reaper.MIDI_DeleteNote(Take,i)    
        end
    end
    
    if Move_Cursor == 1 then
        reaper.SetEditCurPos(nearestpos,true,false)
    end
    
    -----/ для отмены /--/ for undo /-----
    local It = reaper.GetMediaItem(0,0)
    local IsItSel = reaper.IsMediaItemSelected(It)
    reaper.SetMediaItemSelected(It,IsItSel)
    ---------------------------------------

    reaper.Undo_EndBlock( "Delete note(s) nearest to edit cursor", -1)
