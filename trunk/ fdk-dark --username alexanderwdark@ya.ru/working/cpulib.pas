unit cpulib;

interface

uses
  SysUtils,
  cxCpu40, fdcfuncs;

procedure cpuinfo;

implementation


procedure OutputFeatureSet(Cpu: byte; FeatureSet: TFeatureSet);
var
  j,max: byte;
  Features: ICpuFeatureSet;
  Feature: ICpuFeature;
const
  cFeatureSet_Names: array[fsStandard..fsPowerManagement] of string =
    ('Стандартные функции',
    'Расширения стандартных функций',
    'Расширеные функции',
    'Управление электропитанием');
begin
  add('');
  Features := TCpuFeatureSet.Create(Cpu, FeatureSet);
  if Features.Available.AsBoolean then
  begin
    add(cFeatureSet_Names[FeatureSet] + ':');
    add(Pad('Мнемоника', 12) + Pad('Описание', 50) + 'Доступно');
   add(Pad('--------', 12) + Pad('-----------', 50) + '---------');
    for j := 0 to 31 do
    begin
      Feature := Features.ByIndex(j);
      if (Feature <> nil) and (Feature.Mnemonic <> RsCpu_Feature_ResMnemonic) then
        add(Pad(Feature.Mnemonic, 12) + Pad(Feature.Name, 50) + Pad(Feature.Available.FormatYesNo, 25));
    Feature :=nil;
    end;
  end;
  Features := nil;
end;

procedure OutputCache(Cpu: byte; Level: TCacheLevel; Cache: ICpuCache);
const
  cCache_Names: array[clLevel1Code..clTrace] of string = ('Уровень 1 Код:',
    'Уроыень 1 Данные:',
    'Уровень 1 Унифицированый:',
    'Уровень 2:',
    'Уровень 3:',
    'Трэйс:');
var
  s: string;
begin
  s := Pad(cCache_Names[Level], 30);
  if Cache.Available.AsBoolean then
  begin
    s := s + (Cache.Size.FormatBytes + ', ');
    if Cache.Associativity.Value.AsNumber = 0 then
      s := s + ('Отключен, ')
    else
      s := s + (Cache.Associativity.Name + ' ассоциативность, ');
    s := s + (Cache.LineSize.FormatBytes + ' канал');
  end
  else
    s := s + ('(Информация не доступна)');
  add(s);
end;

procedure cpuinfo;
var
  i: integer;
var
  s: TFeatureSet;

begin
  add('----------- Процессоры --------------');
  add(Pad('Доступные процессоры:', 24) + cxCpu.ProcessorCount.Available.AsString);
  add(Pad('Виртуальные процессоры:', 24) + cxCpu.ProcessorCount.Logical.AsString);
  add('');
  for i := 1 to cxCpu.ProcessorCount.Available.AsNumber do
  begin
    // Processor name
    add('Процессор #' + IntToStr(i));
    add('------------');
    add(' ' + cxCpu[i].Name.AsString + ' (' + cxCpu[i].Speed.Normalised.FormatMhz + ')');
    if cxCpu[i].Serial.Available.AsBoolean then
      add(' [' + cxCpu[i].Serial.Formatted + ']');

    // Processor signature
    add('');
    add(' Сигнатура:');
    add(' ----------');
    add(Pad('Производитель', 16) + cxCpu[i].Vendor.Signature);
    add(Pad('Тип', 16) + cxCpu[i].Signature.CpuType.Value.FormatHex);
    add(Pad('Семья', 16) + cxCpu[i].Signature.Family.Value.FormatHex);
    add(Pad('Модель', 16) + cxCpu[i].Signature.Model.Value.FormatHex);
    add(Pad('Степпинг', 16) + cxCpu[i].Signature.Stepping.Value.FormatHex);
    add(Pad('Марка', 16) + cxCpu[i].Signature.Brand.Value.FormatHex);

    // Processor cache
    add('');
    add(' Кэш:');
    add(' ------------------');
    OutputCache(i, clLevel1Code, cxCpu[i].Cache.Level1.Code);
    OutputCache(i, clLevel1Data, cxCpu[i].Cache.Level1.Data);
    OutputCache(i, clLevel1Unified, cxCpu[i].Cache.Level1.Unified);
    OutputCache(i, clLevel2, cxCpu[i].Cache.Level2);
    OutputCache(i, clLevel3, cxCpu[i].Cache.Level3);
    OutputCache(i, clTrace, cxCpu[i].Cache.Trace);

    // Processor feature sets
    for s := fsStandard to fsPowerManagement do
      OutputFeatureSet(i, s);

    add('');
  end;
end;

end.
