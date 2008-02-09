program buildstamp;{$APPTYPE CONSOLE}

uses
  cfg,
  Windows,
  SysUtils;

var
  T, T1, T2: TextFile;
  mypath: string;
  cnt: integer;

  procedure FindFiles(APath: string);
  var
    S: TSearchRec;
    ext, nam: string;

  begin
    apath := ansilowercase(apath);
    if FindFirst(Apath + '\*.*', faHidden + faSysFile + faDirectory +
      faReadOnly + faArchive, S) = 0 then
      repeat
        nam := ansilowercase(s.Name);
        if (S.Attr and faDirectory <> 0) then
        begin
          if (nam <> '..') and (Nam <> '.') then
            if (Nam = 'plugins') or (Nam = 'scripts') or (Nam = 'usr') then

              FindFiles(Apath + '\' + Nam);
        end
        else
        begin
          ext := ansilowercase(ExtractFileExt(Nam));
          if (ext = '.txt') or (ext = '.fdc') or (ext = '.tweak') or
            (ext = '.fdp') or (ext = '.dav') or (ext = '.fdh') or
            (ext = '.fdt') or (ext = '.fds') or (ext = '.url') or
            (ext = '.fdp') or (ext = '.cpl') then
            if (nam <> 'comm.txt') and (nam <> 'directory.txt') and
              (nam <> 'lastautorun.fdh') and (nam <> '1.dav') then
            begin
              if nam = 'readme.txt' then
              begin
                writeln(t1, 'I README', ' "' + apath + '\' + Nam + '"');
                writeln(t2, 'README', '=', extractrelativepath(mypath,
                  apath + '\' + Nam));

              end
              else
              begin
                writeln(t1, 'I N', cnt, ' "' + apath + '\' + Nam + '"');
                writeln(t2, 'N', cnt, '=', extractrelativepath(mypath,
                  apath + '\' + Nam));
                Inc(cnt);
              end;
            end;
        end;
      until (FindNext(S) <> 0);
    FindClose(S);
  end;


begin
  mypath := ExtractFilePath(ParamStr(0));
  assignfile(T, mypath + 'build.inc');
  rewrite(T);
  writeln(T, 'Const BuildStamp=''', FormatDateTime('DDDD, DD.MMMM.YYYY, HH:mm:ss',
    now), ''';');
  writeln(T, 'Const BuildSTR=''', FormatDateTime('YY-MM-DD HH:mm', now), ''';');
  closefile(T);

{  assignfile(T, ExtractFilePath(ParamStr(0)) + 'comm.txt');
  rewrite(T);
  writeln(T, 'Title=��������� FDK by �ark, ������ ' + FormatDateTime('YYMMDDHHmm', now));
  writeln(T, 'Path=FDK');
  writeln(T, 'Setup="fdk.exe" -install');
  writeln(T, 'Overwrite=1');
  writeln(T, 'Text');
  writeln(T, '{');
  writeln(T, '<html>');
  writeln(T, '<head>');
  writeln(T, '<title></title>');
  writeln(T, '</head>');
  writeln(T, '<body bgcolor="black" text="white" alink="lightblue" link="lightblue" vlink="lightblue">');
  writeln(T, '<center><b><font size="4"><font color="#80FF00">FDK [Fast Disk Cleaner] by Dark</font></font></b></center>');
  writeln(T, '<center><b><font size="2"><font color="#80FF00">' +
    FormatDateTime('(������ �� DDDD, DD.MMMM.YYYY, HH:mm:ss)', now) +
    '</font></font></b></center>');
  writeln(T, '<font color="#FF0000">���� ������</b></font><br>');
  writeln(T, '�� ����������� ��� ����������� ����������� �� ���� ����� � ����,');
  writeln(T, '��� ����� ������������ �������� � ������� �� ����� ���� ��������');
  writeln(T, '�� ����������������� � ���������� ������� ����������� ��.');
  writeln(T, '<br>');
  writeln(T, '(c) 2003,2004,2005 <a href="http://www.darksoftware.narod.ru" target="_blank">Dark Software</a>');
  writeln(T, '</body>');
  writeln(T, '</html>');}
  //  writeln(T, '}');
{  writeln(T, 'Shortcut=P, "fdk.exe", "FDK by Dark", "Fast Disk Cleaner", "FDK Russian"');
  writeln(T, 'Shortcut=P, "plugins", "FDK by Dark", "������� Plugins", "������� Plugins"');
  writeln(T, 'Shortcut=P, "scripts", "FDK by Dark", "������� Scripts", "������� Scripts"');
  writeln(T, 'Shortcut=P, "usr", "FDK by Dark", "������� Usr", "������� Usr"');
  writeln(T, 'Shortcut=P, "news.txt", "FDK by Dark", "�������", "�������"');
  writeln(T, 'Shortcut=P, "readme.txt", "FDK by Dark", "����������� ������������", "����������� ������������"');
  writeln(T, 'Shortcut=P, "plugins.txt", "FDK by Dark", "���������� �� ��������� ��������", "���������� �� ��������� ��������"');
  writeln(T, 'Shortcut=P, "tasks.txt", "FDK by Dark", "���������� �� ��������� �����", "���������� �� ��������� �����"');
  writeln(T, 'Shortcut=P, "darksoftware.url ", "FDK by Dark", "���� Dark Software", "���� Dark Software"');
  writeln(T, 'Shortcut=P, "hotcd.url ", "FDK by Dark", "����� ������", "����� ������"');
  closefile(T);   }
  assignfile(T, mypath + 'header.inc');
  rewrite(T);
  writeln(T, '{$D ''FDK, ������ ', FormatDateTime('YYMMDDHHmm', now), '}');
  closefile(T);
  cnt := 0;
  assignfile(T1, mypath + 'allres.rc');
  rewrite(T1);
  assignfile(T2, mypath + 'flist.txt');
  rewrite(T2);
  findfiles(extractfiledir(mypath));
  writeln(T1, 'OTHER FLIST ', mypath + 'FLIST.TXT');
  closefile(T1);
  closefile(T2);
end.
