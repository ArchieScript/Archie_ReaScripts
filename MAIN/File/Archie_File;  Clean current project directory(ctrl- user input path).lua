--[[    http://forum.cockos.com/showthread.php?t=230600
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    File
   * Description: File;  Clean current project directory(ctrl- user input path).lua
   * Author:      Archie / Meo-Ada Mespotine
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Provides:
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   
   *              v.1.0 [010720]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------
    function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------
    
    if not reaper.APIExists('JS_Mouse_GetState')then reaper.MB("Missing extension 'js_ReaScriptAPI'",'Error',0)no_undo()return end;
    
    if reaper.GetPlayState()&4==4 then;
        reaper.MB("Eng:\nYou shouldn't record when using this action.\n\n"..
                  "Rus:\nВы не должны записывать при использовании этого действия"
        ,"Oops",0);
    else;
        ----
        local MouseState = reaper.JS_Mouse_GetState(127);
        if MouseState == 4 or MouseState == 5 then;
            -------------------------------------------------------------
            local sep;
            if reaper.GetOS():match('Win')then sep = '\\'else sep = '/'end;
            local projfn = ({reaper.EnumProjects(-1)})[2]:gsub("[/\\]",sep):match('(.+)'..sep..'.+$')or
                             reaper.GetProjectPathEx(0,""):gsub('[\\/]',sep);
            ::res::;
            local retval,CleanPath = reaper.GetUserFileNameForRead(projfn..sep,"Select Path to be cleaned","");
            if not retval then no_undo()return end;
            CleanPath = CleanPath:gsub("[\\/]",sep):match("(.*)"..sep);
            
            if not CleanPath:match(projfn)then;
                local MB = reaper.MB(CleanPath..'\n\n\n'..
                  "Eng:\nYour chosen path has nothing to do with this project!\n"..
                  "Are you sure you want to delete files on this path?\n\n"..
                  "Rus:\nВыбранный вами путь не имеет ничего общего с этим проектом!\n"..
                  "Вы уверены что хотите удалить файлы по данному пути ?","Oops",6);
                --(3=cancel2;no7;yes6;)(6=продолжить11;повторить10;отмена2);
                if MB == 2 then no_undo()return end;
                if MB == 10 then goto res end;
                if MB == 11 then;
                    MB = reaper.MB(CleanPath..'\n\n\n'..
                                   'Eng:\nAre you sure you want to delete this?\n\n'..
                                   'Rus:\nВы точно в этом уверены, что хотите удалить это?'
                                   ,'Oops',1)
                    if MB == 2 then no_undo()return end;
                end;
            end;
            
            if retval == true then;
                local Aretval,AvaluestrNeedBig = reaper.GetSetProjectInfo_String(0,"RECORD_PATH","",false);
                local Bretval, BvaluestrNeedBig = reaper.GetSetProjectInfo_String(0,"RECORD_PATH",CleanPath,true);
                reaper.Main_OnCommand(40098,0);
                local Cretval, CvaluestrNeedBig = reaper.GetSetProjectInfo_String(0,"RECORD_PATH",AvaluestrNeedBig,true);
            end;
            -------------------------------------------------------------
        else;
            reaper.Main_OnCommand(40098,0);
        end;
    end;
    no_undo();
    
    
    