--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Open MIDI editor and zoom to content by
   * Author:      Archie
   * Version:     1.06
   * Описание:    Откройте MIDI-редактор и увеличьте масштаб содержимого
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Martin111/Archie(Rmm)
   * Gave idea:   Martin111/Archie(Rmm)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   * Provides:
   *              [main] . > Archie_Var; Open MIDI editor and zoom to content by item.lua
   *              [main] . > Archie_Var; Open MIDI editor and zoom to content by source.lua
   *              [main] . > Archie_Var; Toggle Open MIDI editor and zoom to content by item.lua
   *              [main] . > Archie_Var; Toggle Open MIDI editor and zoom to content by source.lua
   *              [main] . > Archie_Var; Open MIDI editor and zoom to content by item(Time Selection).lua
   *              [main] . > Archie_Var; Open MIDI editor and zoom to content by source(Time Selection).lua
   *              [main] . > Archie_Var; Toggle Open MIDI editor and zoom to content by item(Time Selection).lua
   *              [main] . > Archie_Var; Toggle Open MIDI editor and zoom to content by source(Time Selection).lua
   *
   * Changelog:
   *              v.1.04 [130520]
   *                  + Fixed bug

   *              v.1.03 [06.02.20]
   *                  + Time Selection
   *              v.1.02 [06.02.20]
   *                  + Toggle
   *              v.1.0 [06.02.20]
   *                  + initialе
--]]

    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local Indent = 0.10; -- Отступ

    local Vertically_Zoom = false -- true/false


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    --==============================================================
    local itemF_SourceT; -- itemLen-false/SourceLen-true
    local filename = ({reaper.get_action_context()})[2]:upper();
    if filename:match('^.*(SOURCE).-%.%s-LUA%s-$')then;
        itemF_SourceT = true;
    end;

    local TOGGLE;
    if filename:match('.+[/\\](.+)'):match('^ARCHIE_VAR;%s-TOGGLE')then;
        TOGGLE = true;
    end;

    local TimeSel;
    if filename:match('%(%s-TIME%s-SELECTION%s-%).*%.%s-LUA%s-$')then;
        TimeSel = true;
    end;

    --==============================================================


    --==============================================================
    local function OpenMIDI_editor_and_zoom_to_content(itemF_SourceT,TimeSel)-- itemF_SourceT=itemLen-false/SourceLen-true
        local ZoomProj = 40726;-- (loop selection)MIDI
        local OpenMIDI = 40153;--                 MAIN
        local ZoomCont = 40466;-- vert and gori   MIDI

        if not tonumber(Indent) then Indent = 0 end;

        reaper.Main_OnCommand(OpenMIDI,0);

        local MIDIEditor = reaper.MIDIEditor_GetActive();
        if not MIDIEditor then no_undo() return end;

        local Take = reaper.MIDIEditor_GetTake(MIDIEditor);
        local rate = reaper.GetMediaItemTakeInfo_Value(Take,'D_PLAYRATE');
        local Item = reaper.GetMediaItemTake_Item(Take);
        local posItem = reaper.GetMediaItemInfo_Value(Item, "D_POSITION");
        local lenItem = reaper.GetMediaItemInfo_Value(Item, "D_LENGTH");
        local endPosItem = posItem + lenItem;
        local StartLoop,EndLoop = reaper.GetSet_LoopTimeRange(0,1,0,0,0);
        local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        if timeSelStart==timeSelEnd then timeSelStart=math.huge timeSelEnd=math.huge end;

        local source = reaper.GetMediaItemTake_Source(Take);
        local retval,lengthIsQN = reaper.GetMediaSourceLength(source);
        local TimeFromQN = reaper.TimeMap2_QNToTime(0,retval)/rate;
        --if TimeFromQN ~= len then Indent = 0 end;


        reaper.PreventUIRefresh(1);

        if Vertically_Zoom == true then;
            reaper.MIDIEditor_OnCommand(MIDIEditor,ZoomCont);
        end;


        local TimeSelTRUE;
        if TimeSel == true then;
            if posItem < timeSelEnd and endPosItem > timeSelStart then;
                if posItem >= timeSelStart then Spos = posItem else Spos = timeSelStart end;
                if endPosItem <= timeSelEnd then Epos = endPosItem else Epos = timeSelEnd end;
                if Indent >= (Epos-Spos)/2 then Indent = 0 end;
                reaper.GetSet_LoopTimeRange(1,1,Spos+Indent,Epos-Indent,0);
                reaper.GetSet_LoopTimeRange(1,0,Spos+Indent,Epos-Indent,0);
                TimeSelTRUE = true;
            end;
        end;


        if not TimeSelTRUE then;
            if itemF_SourceT == true then;
               local EndPosSrc = (posItem+TimeFromQN);
               if EndPosSrc > endPosItem then EndPosSrc = endPosItem end;
               if Indent >= (EndPosSrc-posItem)/2 then Indent = 0 end;
               reaper.GetSet_LoopTimeRange(1,1,posItem+Indent,EndPosSrc-Indent,0);
               reaper.GetSet_LoopTimeRange(1,0,posItem+Indent,EndPosSrc-Indent,0);
            else;
                if Indent >= lenItem/2 then Indent = 0 end;
                reaper.GetSet_LoopTimeRange(1,1,posItem+Indent,endPosItem-Indent,0);
                reaper.GetSet_LoopTimeRange(1,0,posItem+Indent,endPosItem-Indent,0);
            end;
        end;


        reaper.MIDIEditor_OnCommand(MIDIEditor,ZoomProj);
        reaper.GetSet_LoopTimeRange(1,1,StartLoop,EndLoop,0);
        reaper.GetSet_LoopTimeRange(1,0,timeSelStart,timeSelEnd,0);


        reaper.PreventUIRefresh(-1);
        reaper.UpdateTimeline();
        no_undo();
    end;
    --==============================================================



    --------------------------------------------------------
    if TOGGLE == true then;
        local MIDIEditor = reaper.MIDIEditor_GetActive();
        if MIDIEditor then;
            reaper.MIDIEditor_OnCommand(MIDIEditor,2);
            no_undo();
        else;
            OpenMIDI_editor_and_zoom_to_content(itemF_SourceT,TimeSel);
        end;
    else;
        OpenMIDI_editor_and_zoom_to_content(itemF_SourceT,TimeSel);
    end;
    --------------------------------------------------------
