--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Auto add icon to track depending on MIDI send
   * Author:      Archie
   * Version:     1.02
   * Описание:    Автоматическое добавление иконки на трек в зависимости от посыла миди
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Steven Berkovec(VK)
   * Gave idea:   Steven Berkovec(VK)
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   * Changelog:   v.1.0 [12.11.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  ОПИСАНИЕ  \\\\\\\\\\\\  DESCRIPTION  ////////////  ОПИСАНИЕ  \\\\\\\\\\\\
    --======================================================================================


    -- Описание:
    -- Создать папку с именем "MidiOut_Icon" в папке Data
    -- т.е. ...Reaper.../Data/MidiOut_Icon/
    -- и положить иконки в эту папку.
    -- Создаем иконки с именем "Midi_1_2.png"
    -- цифры это номер посыла от 0 до 16, 0 это all,
    -- ( Midi_0_2.png / Midi_16_16.png ).
    -- http://avatars.mds.yandex.net/get-pdb/2105707/63fe397f-36e1-4ebd-a6e8-b5aaa67e8586/s800
    -- Скрипт работает в фоне (при запуске рипера запускаем скрипт один раз и больше не трогаем его).
    -- Все - далее если с трека будет отправлен посыл миди, то на этот трек будет добавлена соответствующая иконка.
    -- Скрипт полезен для работы с мульти инструментами, где в виде иконок делать подсказки миди посыла.

    -- Description:
    -- Create folder with name "MidiOut_Icon" in the folder Data
    -- i.e. ...Reaper.../Data/MidiOut_Icon/
    -- and put the icons in this folder.
    -- Create icons with the name "Midi_1_2.png"
    -- digits is the send number from 0 to 16, 0 is all,
    -- ( Midi_0_2.png / Midi_16_16.png ).
    -- http://avatars.mds.yandex.net/get-pdb/2105707/63fe397f-36e1-4ebd-a6e8-b5aaa67e8586/s800
    -- The script works in the background (at startup reaper run script once and no longer touch it).
    -- All-next, if a MIDI message is sent from a track, the corresponding icon will be added to this track.
    -- The script is useful for working with multi tools, where in the form of icons to do tips midi send.



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    local IconPath = reaper.GetResourcePath().."/Data/MidiOut_Icon/";


    --============================================
    local function UNPACK_I_RECINPUT_MIDI(value);
        if (value >> 5) > 48 then return end;
        local channel = value & 31;
        local input = (value >> 5) & 31;
        return channel, input;
    end;
    --============================================


    --============================================
    local function ADD_ICON_TRACK(idx);
        local track = reaper.GetTrack(0,idx);
        if track then;

            local NumSend = reaper.GetTrackNumSends(track,0);
            if NumSend > 0 then;
                local flags = reaper.GetTrackSendInfo_Value(track,0,0,"I_MIDIFLAGS");
                local chan,val = UNPACK_I_RECINPUT_MIDI(flags);

                chan = tonumber(chan);
                val = tonumber(val);

                if chan and val then;
                    if chan >= 0 and chan <= 16 then;
                        if val >= 0 and val <= 16 then;

                            local ICON = IconPath.."Midi_"..chan.."_"..val..".png";

                            local file = io.open(ICON,"rb");
                            if file then;
                                file:close();

                                local _,preFile = reaper.GetSetMediaTrackInfo_String(track,"P_ICON",0,0);
                                if preFile:gsub("%p","")~= ICON:gsub("%p","")then;
                                    GTT =(GTT or 0)+1
                                    reaper.GetSetMediaTrackInfo_String(track,"P_ICON",ICON,1);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    --============================================


    local ProjState2;

    local function loop();

        local ProjState = reaper.GetProjectStateChangeCount(0);
        if ProjState ~= ProjState2 then;
            ProjState2 = ProjState;
            ----
            local CountTrack = reaper.CountTracks(0);
            if CountTrack > 0 then;

                for t = 1,CountTrack do;
                    ADD_ICON_TRACK(t-1);
                end;
            end;
        end;
        reaper.defer(loop);
    end;

    reaper.defer(loop);