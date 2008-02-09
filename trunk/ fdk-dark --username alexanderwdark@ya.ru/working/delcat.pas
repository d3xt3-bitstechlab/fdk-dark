{Freeware system tuner & cleaner}
{$I-}
{$H+}

unit DelCat;

interface

function DarkKillDir(Dir: string): boolean;

implementation

uses SysUtils;

function DarkKillDir(Dir: string): boolean;
var
  Sr: SysUtils.TSearchRec;
begin
{$I-}
  if (Dir <> '') and (Dir[length(Dir)] = '\') then
    Delete(dir, length(dir), 1);
  if FindFirst(Dir + '\*.*', faDirectory + faHidden + faSysFile +
    faReadonly + faArchive, Sr) = 0 then
    repeat
      if (Sr.Name = '.') or (Sr.Name = '..') then
        continue;
      if (Sr.Attr and faDirectory <> faDirectory) then
        DeleteFile(Dir + '\' + sr.Name)
      else
        DarkKillDir(Dir + '\' + sr.Name);
    until FindNext(sr) <> 0;
  FindClose(sr);
  RemoveDir(Dir);
  DarkKillDir := (FileGetAttr(Dir) = -1);
end;

begin
end.
