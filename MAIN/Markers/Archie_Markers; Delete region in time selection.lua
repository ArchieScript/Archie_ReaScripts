--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Markers
   * Description: Markers; Delete region in time selection
   * Author:      Archie
   * Version:     1.0
   * Описание:    Удалить регион в выборе времени
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [090320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    local function RemovePartOfRegionByTime(startTime,endTime,openBlock_Undo);
        local ret = false;
        if not tonumber(startTime)then return ret end;
        if not tonumber(endTime  )then return ret end;
        if startTime == endTime   then return ret end;
        ::replay::
        local retval,num_markers,num_regions = reaper.CountProjectMarkers(0);
        if num_regions > 0 then;
            for i = retval,0,-1 do;
                local _,isrgn,pos,rgnend,name,markrgnindexnumber,color = reaper.EnumProjectMarkers3(0,i);
                if isrgn == true then;
                    if pos < endTime and rgnend > startTime then;
                        if not ret then;
                            if type(openBlock_Undo)=='function'then;
                                openBlock_Undo();
                            end;
                        end;
                        ret = true;
                        reaper.DeleteProjectMarker(0,markrgnindexnumber,true);

                        -----
                        if name == '' then name = markrgnindexnumber end;
                        -----
                        if pos < startTime and rgnend > startTime then;
                            reaper.AddProjectMarker2(0,true,pos,startTime,name,-1,color);
                        end;
                        if pos < endTime and rgnend > endTime then;
                            reaper.AddProjectMarker2(0,true,endTime,rgnend,name,-1,color);
                        end;
                        goto replay;
                    end;
                end;
            end;
        end;
        return ret;
    end;



    local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0); -- В Ар
    local RemReg = RemovePartOfRegionByTime(timeSelStart,timeSelEnd,reaper.Undo_BeginBlock);
    if RemReg then;
        reaper.Undo_EndBlock('Delete region in time selection',-1);
    else;
        no_undo();
    end;



