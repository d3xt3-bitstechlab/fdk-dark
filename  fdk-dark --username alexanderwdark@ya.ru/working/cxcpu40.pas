unit cxCpu40;

interface

uses
  Classes, SysUtils, Windows;

const
  RsCpu_Format_True  = 'Äà';
  RsCpu_Format_False = 'Íåò';
  RsCpu_Format_Yes   = 'Äà';
  RsCpu_Format_No    = 'Íåò';
  RsCpu_Format_On    = 'Äà';
  RsCpu_Format_Off   = 'Íåò';

  RsCpu_Format_Integer = '%d';

  RsCpu_Format_Hex = '$%1.8x';

  RsCpu_Format_Bytes  = '%d áàéò';
  RsCpu_Format_KBytes = '%1.1n Êá';
  RsCpu_Format_MBytes = '%1.1n Ìá';
  RsCpu_Format_GBytes = '%1.1n Ãá';

  RsCpu_Format_Mhz = '%d ÌÃö';
  RsCpu_Format_Ghz = '%1.1n ÃÃö';

type
  ICpuboolean = interface
    ['{D34AD555-2CF5-4E92-B386-686008F03F41}']
    function AsBoolean: boolean;

    function FormatYesNo: string;
  end;

  TCpuboolean = class(TInterfacedObject, ICpuboolean)
  private
    fValue: boolean;
  public
    constructor Create(Value: boolean);
    destructor Destroy; override;

    function AsBoolean: boolean;

    function FormatYesNo: string;
    function FormatTrueFalse: string;
    function FormatOnOff: string;
  end;

  ICpuWord = interface
    ['{DE266303-9F21-44F8-A839-2096DB26CD9E}']
    function HiByte: byte;
    function LoByte: byte;

    function Value: word;
  end;

  TCpuWord = class(TInterfacedObject, ICpuWord)
  private
    fWord: word;
  public
    constructor Create(Value: word);
    destructor Destroy; override;

    function HiByte: byte;
    function LoByte: byte;
    function Value: word;
  end;

  ICpuNumber = interface
    ['{A1013670-1034-4493-97F4-1E421855EB94}']
    function AsNumber: longword;
    function AsString: string;

    function HiWord: ICpuWord;
    function LoWord: ICpuWord;

    function CountBitsOn: byte;
    function IsBitActive(Bit: byte): ICpuboolean;

    function FormatBytes: string;
    function FormatHex: string;
    function FormatMhz: string;
    function FormatString: string;
  end;

  TCpuNumber = class(TInterfacedObject, ICpuNumber)
  private
    fValue: longword;
  public
    constructor Create(Value: longword);
    destructor Destroy; override;

    function AsNumber: longword;
    function AsString: string;

    function HiWord: ICpuWord;
    function LoWord: ICpuWord;

    function CountBitsOn: byte;
    function IsBitActive(Bit: byte): ICpuboolean;

    function FormatBytes: string;
    function FormatHex: string;
    function FormatMhz: string;
    function FormatString: string;
  end;

  TCpuNumberFormat = (cnfBytes, cnfHex, cnfMhz, cnfString);

function CpuFormatNumber(Value: longword; Format: TCpuNumberFormat): string;

function CpuFormatboolean(Value: boolean): string;

//--------------------------------------------------------------------------------------------------------
// Processor affinity functions
//--------------------------------------------------------------------------------------------------------

const
  RsCpu_Library_Kernel   = 'KERNEL32.DLL';
  RsCpu_Library_Function = 'SetProcessAffinityMask';

type
  ICpuAffinity = interface
    ['{51581B4D-BF14-46F3-BD0A-40C19E425B9A}']
  end;

  TCpuAffinity = class(TInterfacedObject, ICpuAffinity)
  private
    fProcess:     longword;
    fAffinity:    longword;
    fOldAffinity: longword;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;
  end;

type
  TcxSetProcessAffinityMask = function(hProcess: THandle;
    dwProcessAffinityMask: longword): longbool; stdcall;

function CpuSetAffinity(Cpu: byte): ICpuAffinity;

//--------------------------------------------------------------------------------------------------------
// Cpuid execution routines
//--------------------------------------------------------------------------------------------------------

const
  cReg_Eax = 0;
  cReg_Ebx = 1;
  cReg_Ecx = 2;
  cReg_Edx = 3;

  cCpuid_EFlags = $00200000;
  cCpuid_OpCode = $0000A20F;

  cStd_MaximumLevel = $00000000;
  cStd_VendorSignature = $00000000;
  cStd_Signature    = $00000001;
  cStd_FeatureSet   = $00000001;
  cStd_CacheTlbs    = $00000002;
  cStd_SerialNumber = $00000003;

  cExt_MaximumLevel   = $80000000;
  cExt_Signature      = $80000001;
  cExt_FeatureSet     = $80000001;
  cExt_MarketingName1 = $80000002;
  cExt_MarketingName2 = $80000003;
  cExt_MarketingName3 = $80000004;
  cExt_Level1Cache    = $80000005;
  cExt_Level2Cache    = $80000006;
  cExt_PowerManagement = $80000007;
  cExt_AA64Information = $80000008;
  cExt_Unsupported    = $80000099;  // Dummy command for unsuported features

  cTmx_MaximumLevel   = $80860000;
  cTmx_Signature      = $80860001;
  cTmx_SoftwareVersion = $80860002;
  cTmx_MarketingName1 = $80860003;
  cTmx_MarketingName2 = $80860004;
  cTmx_MarketingName3 = $80860005;
  cTmx_MarketingName4 = $80860006;
  cTmx_Operation      = $80860007;

  cCmd_Standard0 = 0;

type
  TCpuidExecutionLevel = (celStandard, celExtended, celTransmeta);

  TCpuidResult = record
    Eax: longword;
    Ebx: longword;
    Ecx: longword;
    Edx: longword;
  end;

  ICpuid = interface
    ['{CA8D4D57-6BF4-4608-960D-670376601885}']
    function Cpu: byte;
    function Command: longword;
    function Iterations: integer;

    function AsString: string;

    function Supported: ICpuboolean;

    function Eax: ICpuNumber;
    function Ebx: ICpuNumber;
    function Ecx: ICpuNumber;
    function Edx: ICpuNumber;
  end;

  TCpuid = class(TInterfacedObject, ICpuid)
  private
    fCpu:     byte;
    fCommand: longword;
    fIterations: integer;
    fResult:  TCpuidResult;
  public
    constructor Create(Cpu: byte; Command: longword; Iterations: integer = 1); overload;
    constructor Create(Cpu: byte; Command: longword; Iterations: integer;
      Result: TCpuidResult); overload;
    destructor Destroy; override;

    function Cpu: byte;
    function Command: longword;
    function Iterations: integer;

    function AsString: string;

    function Supported: ICpuboolean;

    function Eax: ICpuNumber;
    function Ebx: ICpuNumber;
    function Ecx: ICpuNumber;
    function Edx: ICpuNumber;
  end;

function CpuIsCpuidSupported: boolean; overload;
function CpuIsCpuidSupported(Cpu: byte): boolean; overload;

function CpuGetCommandLevel(Command: longword): TCpuidExecutionLevel;

function CpuGetMaximumCommand(Level: TCpuidExecutionLevel): longword; overload;
function CpuGetMaximumCommand(Cpu: byte; Level: TCpuidExecutionLevel): longword;
  overload;

function CpuIsCpuidCommandSupported(Command: longword): boolean; overload;
function CpuIsCpuidCommandSupported(Cpu: byte; Command: longword): boolean; overload;

function CpuGetCpuidResult: TCpuidResult; assembler; register;

function CpuExecuteCpuid(Command: longword; Iterations: integer): TCpuidResult;
  overload;
function CpuExecuteCpuid(Cpu: byte; Command: longword;
  Iterations: integer): TCpuidResult; overload;

//--------------------------------------------------------------------------------------------------------
// CPUID Information Functions
//--------------------------------------------------------------------------------------------------------

type
  ICpuidInformation = interface
    ['{5E5E930B-9FCD-424C-8894-A80ED26F9C73}']
    function Available: ICpuboolean;
    function MaximumCommand: ICpuNumber;
  end;

  TCpuidInformation = class(TInterfacedObject, ICpuidInformation)
  private
    fCpu: byte;
    fExecutionLevel: TCpuidExecutionLevel;

    fCpuid: ICpuid;
  public
    constructor Create(Cpu: byte; Level: TCpuidExecutionLevel);
    destructor Destroy; override;

    function Available: ICpuboolean;
    function MaximumCommand: ICpuNumber;
  end;

  IProcessorCpuid = interface
    ['{8106B2AF-AF31-4774-9F97-1D19C1FE2CE3}']
    function Standard: ICpuidInformation;
    function extended: ICpuidInformation;
    function Transmeta: ICpuidInformation;
  end;

  TProcessorCpuid = class(TInterfacedObject, IProcessorCpuid)
  private
    fCpu: byte;

  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Standard: ICpuidInformation;
    function extended: ICpuidInformation;
    function Transmeta: ICpuidInformation;
  end;

function CpuIsCpuidAvailable(Cpu: byte;
  CpuidExecutionLevel: TCpuidExecutionLevel): boolean;
function CpuGetCpuidMaximumCommand(Cpu: byte;
  CpuidExecutionLevel: TCpuidExecutionLevel): longword;

//--------------------------------------------------------------------------------------------------------
// Processor signature functions
//--------------------------------------------------------------------------------------------------------

const
  cType_OemRetail = 0;
  cType_OverDrive = 1;

  cFamily_486 = 4;
  cFamily_P5  = 5;
  cFamily_P6  = 6;
  cFamily_P7  = 7;

  cBrand_Unknown = 0;
  cBrand_Celeron = 1;
  cBrand_P3      = 2;
  cBrand_P3Xeon  = 3;  // If signature = $000006B1 then 'Intel Celeron® processor'
  cBrand_P3Alt   = 4;
  cBrand_P3Mobile = 6;
  cBrand_CeleronM = 7;
  cBrand_P4      = 8;  // If signature > $00000F13 then 'Intel® Geniune processor'
  cBrand_P4Alt   = 9;
  cBrand_CeleronA = 10;
  cBrand_Xeon    = 11; // If signature < $00000F13 then 'Intel® Xeon™ processor MP'
  cBrand_XeonMP  = 12;
  cBrand_P4Mobile = 14;
  cBrand_CeleronMAlt = 15;

  cBrand_OpteronUP = 3;
  cBrand_Opteron2P = 4;
  cBrand_OpteronMP = 5;

  cExtend_Fields = 15;

type
  TCpuSignatureField = (csfType, csfFamily, csfModel, csfStepping, csfBrand);

  ICpuSignatureInformation = interface
    ['{89610B21-D70A-4548-BB7D-19B67849FD2B}']
    function Value: ICpuNumber;
    function extended: ICpuboolean;
  end;

  TCpuSignatureInformation = class(TInterfacedObject, ICpuSignatureInformation)
  private
    fValue: ICpuNumber;
    fField: TCpuSignatureField;
  public
    constructor Create(Value: longword; Field: TCpuSignatureField);
    destructor Destroy; override;

    function Value: ICpuNumber;
    function extended: ICpuboolean;
  end;

  IProcessorSignature = interface
    ['{89644EBE-DFB3-4BEE-9CBD-8F7F7F73F682}']
    function CpuType: ICpuSignatureInformation;
    function Family: ICpuSignatureInformation;
    function Model: ICpuSignatureInformation;
    function Stepping: ICpuSignatureInformation;
    function Brand: ICpuSignatureInformation;
    function Generic: string;
    function Value: ICpuNumber;
  end;

  TProcessorSignature = class(TInterfacedObject, IProcessorSignature)
  private
    fCpu: byte;

    fCpuid: ICpuid;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;
    function CpuType: ICpuSignatureInformation;
    function Family: ICpuSignatureInformation;
    function Model: ICpuSignatureInformation;
    function Stepping: ICpuSignatureInformation;
    function Brand: ICpuSignatureInformation;
    function Generic: string;
    function Value: ICpuNumber;
  end;

function CpuGetSignatureType(Cpu: byte): integer;
function CpuGetSignatureFamily(Cpu: byte): integer;
function CpuGetSignatureModel(Cpu: byte): integer;
function CpuGetSignatureStepping(Cpu: byte): integer;
function CpuGetSignatureBrand(Cpu: byte): integer;

//--------------------------------------------------------------------------------------------------------
// Processor Vendor functions
//--------------------------------------------------------------------------------------------------------

type
  TCpuVendor = (cvNone, cvUnknown, cvIntel, cvAmd, cvCyrix, cvIDT,
    cvNexGen, cvUMC, cvRise, cvTransmeta);

  TFeatureAvailability = (faCommon, faIntel, faAmd, faCyrix);
  TVendorCacheDetect   = (vcdStandard, vcdExtended, vcdCombined);

  IProcessorVendor = interface
    ['{BDF60067-73A7-4EF6-A95F-41005D921E54}']
    function Signature: string;
    function Name: string;
    function FeatureStyle: TFeatureAvailability;
    function CacheDetect: TVendorCacheDetect;
    function VendorType: TCpuVendor;
  end;

  TProcessorVendor = class(TInterfacedObject, IProcessorVendor)
  private
    fCpu:    byte;
    fVendor: TCpuVendor;

    procedure GetVendor;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Signature: string;
    function Name: string;
    function FeatureStyle: TFeatureAvailability;
    function CacheDetect: TVendorCacheDetect;
    function VendorType: TCpuVendor;
  end;

  TCpuVendorInfo = record
    Signature: string;
    Prefix:    string;
    Name:      string;
    FeatureAvailability: TFeatureAvailability;
    CacheDetect: TVendorCacheDetect;
  end;

const
  cVendorNames: array[cvUnknown..cvTransmeta] of TCpuVendorInfo = (
    (Signature: 'BadCpuVendor'; Prefix: 'Unknown '; Name: 'Unknown Vendor';
    FeatureAvailability: faCommon; CacheDetect: vcdStandard),
    (Signature: 'GenuineIntel'; Prefix: 'Intel '; Name: 'Intel Corporation';
    FeatureAvailability: faIntel; CacheDetect: vcdStandard),
    (Signature: 'AuthenticAMD'; Prefix: 'AMD '; Name: 'Advanced Micro Devices';
    FeatureAvailability: faAmd; CacheDetect: vcdExtended),
    (Signature: 'CyrixInstead'; Prefix: 'Cyrix '; Name: 'Via Technologies Inc';
    FeatureAvailability: faCyrix; CacheDetect: vcdCombined),
    (Signature: 'CentaurHauls'; Prefix: 'Via '; Name: 'Via Technologies Inc';
    FeatureAvailability: faCommon; CacheDetect: vcdExtended),
    (Signature: 'NexGenDriven'; Prefix: 'NexGen '; Name: 'NexGen Inc';
    FeatureAvailability: faCommon; CacheDetect: vcdStandard),
    (Signature: 'UMC UMC UMC '; Prefix: 'UMC ';
    Name: 'United Microelectronics Corp';
    FeatureAvailability: faCommon; CacheDetect: vcdStandard),
    (Signature: 'RiseRiseRise'; Prefix: 'Rise '; Name: 'Rise Technology';
    FeatureAvailability: faCommon; CacheDetect: vcdStandard),
    (Signature: 'GenuineTMx86'; Prefix: 'Transmeta '; Name: 'Transmeta';
    FeatureAvailability: faAmd; CacheDetect: vcdExtended)
    );

function CpuGetVendor(Cpu: byte): TCpuVendor;
function CpuGetVendorSignature(Cpu: byte): string;
function CpuGetVendorName(Cpu: byte): string;
function CpuGetVendorFeatureStyle(Cpu: byte): TFeatureAvailability;
function CpuGetVendorCacheDetect(Cpu: byte): TVendorCacheDetect;

//--------------------------------------------------------------------------------------------------------
// Processor Feature Set functions
//--------------------------------------------------------------------------------------------------------

const
  RsCpu_Feature_ResMnemonic = 'RES';
  RsCpu_Feature_Res = 'Reserved or unused';

  RsCpu_Feature_FPU     = 'Floating point unit';
  RsCpu_Feature_VME     = 'Virtual mode extension';
  RsCpu_Feature_DE      = 'Debugging extensions';
  RsCpu_Feature_PSE     = 'Page size extension';
  RsCpu_Feature_TSC     = 'Time stamp counter';
  RsCpu_Feature_MSR     = 'Machine specific registers';
  RsCpu_Feature_PAE     = 'Physical address exception';
  RsCpu_Feature_MCE     = 'Machine check exception';
  RsCpu_Feature_CX8     = 'CMPXCHG8 instrucion support';
  RsCpu_Feature_APIC    = 'APIC hardware support';
  RsCpu_Feature_SEP     = 'Fast system call';
  RsCpu_Feature_MTRR    = 'Memory type range registers';
  RsCpu_Feature_PGE     = 'Page global enable';
  RsCpu_Feature_MCA     = 'Machine check architecture';
  RsCpu_Feature_CMOV    = 'Conditional move support';
  RsCpu_Feature_PAT     = 'Page attribute table';
  RsCpu_Feature_PSE36   = '36-bit page size extension';
  RsCpu_Feature_PSN     = 'Processor serial number';
  RsCpu_Feature_CLFSH   = 'CLFLUSH instruction support';
  RsCpu_Feature_DS      = 'Debug store';
  RsCpu_Feature_ACPI    = 'Thermal monitor and software controlled clock';
  RsCpu_Feature_MMX     = 'MMX architecture support';
  RsCpu_Feature_MMXPLUS = 'Extended MMX architecture';
  RsCpu_Feature_FXSR    = 'Fast floating point save';
  RsCpu_Feature_SSE     = 'Streaming SIMD instruction support';
  RsCpu_Feature_SSE2    = 'Streaming SIMD extensions 2';
  RsCpu_Feature_SS      = 'Self snoop';
  RsCpu_Feature_HTT     = 'Hyper-Threading technology';
  RsCpu_Feature_TM      = 'Thermal monitor support';
  RsCpu_Feature_3DNOW   = '3DNow! extensions';
  RsCpu_Feature_3DNOWPLUS = 'Extended 3DNow! extensions';
  RsCpu_Feature_MP      = 'Multi processor enabled';
  RsCpu_Feature_DTES    = 'Debug trace and EMON store MSR';
  RsCpu_Feature_LM      = 'AA-64 Long mode';
  RsCpu_Feature_IA64    = 'IA-64';
  RsCpu_Feature_SBF     = 'Signal break on FERR';
  RsCpu_Feature_NX      = 'No Execute Page Protections';
  RsCpu_Feature_TS      = 'Temperature Sensor';
  RsCpu_Feature_FID     = 'Frequency Id Control';
  RsCpu_Feature_VID     = 'Voltage Id Control';
  RsCpu_Feature_TTP     = 'Thermal Trip';
  RsCpu_Feature_STC     = 'Software Thermal Control';
  RsCpu_Feature_TM2     = 'Thermal Monitor 2';
  RsCpu_Feature_EST     = 'Enhanced SpeedStep Technology';
  RsCpu_Feature_CID     = 'Context Id';

type
  TFeatureSet = (fsUnknown, fsStandard, fsStandardEx, fsExtended, fsPowerManagement);

  TFeatureDetail = record
    Index:    byte;
    Mnemonic: string;
    Name:     string;
    Info:     TFeatureAvailability;
    Level:    set of TFeatureSet;
  end;

const
  cFeatureRegisterContent = 50;
  cMaxFeatures = 48;
  cFeatureDetails: array[0..cMaxFeatures - 1] of TFeatureDetail = (
    (Index: 0; Mnemonic: 'FPU'; Name: RsCpu_Feature_FPU;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 0; Mnemonic: 'TS'; Name: RsCpu_Feature_TS; Info: faAmd;
    Level: [fsPowerManagement]),
    (Index: 1; Mnemonic: 'VME'; Name: RsCpu_Feature_VME;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 1; Mnemonic: 'FID'; Name: RsCpu_Feature_FID;
    Info: faAmd; Level: [fsPowerManagement]),
    (Index: 2; Mnemonic: 'DE'; Name: RsCpu_Feature_DE;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 2; Mnemonic: 'VID'; Name: RsCpu_Feature_VID;
    Info: faAmd; Level: [fsPowerManagement]),
    (Index: 3; Mnemonic: 'PSE'; Name: RsCpu_Feature_PSE;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 3; Mnemonic: 'TPP'; Name: RsCpu_Feature_TTP;
    Info: faAmd; Level: [fsPowerManagement]),
    (Index: 4; Mnemonic: 'TSC'; Name: RsCpu_Feature_TSC;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 4; Mnemonic: 'TM'; Name: RsCpu_Feature_TM; Info: faAmd;
    Level: [fsPowerManagement]),
    (Index: 5; Mnemonic: 'MSR'; Name: RsCpu_Feature_MSR;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 5; Mnemonic: 'STC'; Name: RsCpu_Feature_STC;
    Info: faAmd; Level: [fsPowerManagement]),
    (Index: 6; Mnemonic: 'PAE'; Name: RsCpu_Feature_PAE;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 7; Mnemonic: 'MCE'; Name: RsCpu_Feature_MCE;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 7; Mnemonic: 'TM2'; Name: RsCpu_Feature_TM2;
    Info: faCommon; Level: [fsStandardEx]),
    (Index: 8; Mnemonic: 'CX8'; Name: RsCpu_Feature_CX8;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 8; Mnemonic: 'EST'; Name: RsCpu_Feature_EST;
    Info: faCommon; Level: [fsStandardEx]),
    (Index: 9; Mnemonic: 'APIC'; Name: RsCpu_Feature_APIC;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 10; Mnemonic: 'CID'; Name: RsCpu_Feature_CID;
    Info: faCommon; Level: [fsStandardEx]),
    (Index: 11; Mnemonic: 'SEP'; Name: RsCpu_Feature_SEP;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 12; Mnemonic: 'MTRR'; Name: RsCpu_Feature_MTRR;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 13; Mnemonic: 'PGE'; Name: RsCpu_Feature_PGE;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 14; Mnemonic: 'MCA'; Name: RsCpu_Feature_MCA;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 15; Mnemonic: 'CMOV'; Name: RsCpu_Feature_CMOV;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 16; Mnemonic: 'PAT'; Name: RsCpu_Feature_PAT;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 17; Mnemonic: 'PSE36'; Name: RsCpu_Feature_PSE36;
    Info: faCommon; Level: [fsStandard]),
    (Index: 18; Mnemonic: 'PSN'; Name: RsCpu_Feature_PSN;
    Info: faCommon; Level: [fsStandard]),
    (Index: 19; Mnemonic: 'CLFSH'; Name: RsCpu_Feature_CLFSH;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 19; Mnemonic: 'MP'; Name: RsCpu_Feature_MP; Info: faAmd;
    Level: [fsExtended]),
    (Index: 20; Mnemonic: 'NX'; Name: RsCpu_Feature_NX; Info: faAmd;
    Level: [fsExtended]),
    (Index: 20; Mnemonic: 'NX'; Name: RsCpu_Feature_NX;
    Info: faCyrix; Level: [fsExtended]),
    (Index: 21; Mnemonic: 'DTES'; Name: RsCpu_Feature_DTES;
    Info: faCommon; Level: [fsStandard]),
    (Index: 22; Mnemonic: 'ACPI'; Name: RsCpu_Feature_ACPI;
    Info: faCommon; Level: [fsStandard]),
    (Index: 22; Mnemonic: 'MMX+'; Name: RsCpu_Feature_MMXPLUS;
    Info: faAmd; Level: [fsExtended]),
    (Index: 23; Mnemonic: 'MMX'; Name: RsCpu_Feature_MMX;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 24; Mnemonic: 'FXSR'; Name: RsCpu_Feature_FXSR;
    Info: faCommon; Level: [fsStandard, fsExtended]),
    (Index: 24; Mnemonic: 'MMX+'; Name: RsCpu_Feature_MMXPLUS;
    Info: faCyrix; Level: [fsExtended]),
    (Index: 25; Mnemonic: 'SSE'; Name: RsCpu_Feature_SSE;
    Info: faCommon; Level: [fsStandard]),
    (Index: 26; Mnemonic: 'SSE2'; Name: RsCpu_Feature_SSE2;
    Info: faCommon; Level: [fsStandard]),
    (Index: 27; Mnemonic: 'SS'; Name: RsCpu_Feature_SS;
    Info: faCommon; Level: [fsStandard]),
    (Index: 28; Mnemonic: 'HTT'; Name: RsCpu_Feature_HTT;
    Info: faCommon; Level: [fsStandard]),
    (Index: 29; Mnemonic: 'TM'; Name: RsCpu_Feature_TM;
    Info: faCommon; Level: [fsStandard]),
    (Index: 29; Mnemonic: 'LM'; Name: RsCpu_Feature_LM; Info: faAmd;
    Level: [fsExtended]),
    (Index: 29; Mnemonic: 'LM'; Name: RsCpu_Feature_LM;
    Info: faCyrix; Level: [fsExtended]),
    (Index: 30; Mnemonic: 'IA-64'; Name: RsCpu_Feature_IA64;
    Info: faCommon; Level: [fsStandard]),
    (Index: 30; Mnemonic: '3DNOW+'; Name: RsCpu_Feature_3DNOWPLUS;
    Info: faAmd; Level: [fsExtended]),
    (Index: 31; Mnemonic: 'SBF'; Name: RsCpu_Feature_SBF;
    Info: faCommon; Level: [fsStandard]),
    (Index: 31; Mnemonic: '3DNOW'; Name: RsCpu_Feature_3DNOW;
    Info: faAmd; Level: [fsExtended])
    );

  cFeature_Ts     = 0;
  cFeature_Fpu    = 0;
  cFeature_Vme    = 1;
  cFeature_Fid    = 1;
  cFeature_De     = 2;
  cFeature_Vid    = 2;
  cFeature_Pse    = 3;
  cFeature_Ttp    = 3;
  cFeature_Tsc    = 4;
  cFeature_TmAmd  = 4;
  cFeature_Msr    = 5;
  cFeature_Stc    = 5;
  cFeature_Pae    = 6;
  cFeature_Mce    = 7;
  cFeature_Cx8    = 8;
  cFeature_Apic   = 9;
  cFeature_SepK6  = 10;
  cFeature_Sep    = 11;
  cFeature_Mtrr   = 12;
  cFeature_Pge    = 13;
  cFeature_Mca    = 14;
  cFeature_Cmov   = 15;
  cFeature_Pat    = 16;
  cFeature_Pse36  = 17;
  cFeature_Psn    = 18;
  cFeature_Mobile = 18;
  cFeature_Mp     = 19;   // AMD Multi-processor
  cFeature_Clfsh  = 19;
  cFeature_Nx     = 20;
  cFeature_Ds     = 21;
  cFeature_Acpi   = 22;
  cFeature_MmxAmd = 22;   // AMD MMX extensions
  cFeature_Mmx    = 23;
  cFeature_Fxsr   = 24;
  cFeature_MmxVia = 24;   // Cyrix/Via MMX extensions
  cFeature_Sse    = 25;
  cFeature_Sse2   = 26;
  cFeature_Ss     = 27;
  cFeature_Htt    = 28;
  cFeature_Tm     = 29;
  cFeature_Lm     = 29;
  cFeature_Ia64   = 30;
  cFeature_3dNowX = 30;
  cFeature_3dNow  = 31;
  cFeature_Pbe    = 31;
  cFeature_Tm2    = 57;
  cFeature_Est    = 58;
  cFeature_Cid    = 60;
  cFeature_Res    = 255;

type
  IFeatureSetDefinition = interface
    ['{0B144673-3BB4-4A10-84C2-969305D9F1FD}']
    function MnemonicToBitIndex(Mnemonic: string): byte;
    function FeatureCount: ICpuNumber;
  end;

  TFeatureSetDefinition = class(TInterfacedObject, IFeatureSetDefinition)
  private
    fCpu: byte;
    fFeatureLevel: TFeatureSet;
    fFeatureStyle: TFeatureAvailability;
    fAvailableFeatures: array[0..31] of TFeatureDetail;
    fFeatureCount: integer;
  protected
    procedure GetAvailableFeatures;
  public
    constructor Create(Cpu: byte; Level: TFeatureSet);
    destructor Destroy; override;

    function MnemonicToBitIndex(Mnemonic: string): byte;
    function BitIndexToResource(BitIndex: byte): byte;
    function FeatureCount: ICpuNumber;
  end;

  ICpuFeature = interface
    ['{E9839DDC-FD8D-4D79-BF89-C85FE5F54EB2}']
    function BitIndex: byte;
    function Mnemonic: string;
    function Name: string;
    function Available: ICpuboolean;
  end;

  TUnknownFeature = class(TInterfacedObject, ICpuFeature)
  public
    constructor Create;
    destructor Destroy; override;

    function BitIndex: byte;
    function Mnemonic: string;
    function Name: string;
    function Available: ICpuboolean;
  end;

  TCpuFeature = class(TInterfacedObject, ICpuFeature)
  private
    fCpu: byte;

    fIndex:      byte;
    fFeatureSet: TFeatureSet;
  public
    constructor Create(Cpu: byte; Index: integer; FeatureSet: TFeatureSet);
    destructor Destroy; override;

    function BitIndex: byte;
    function Mnemonic: string;
    function Name: string;
    function Available: ICpuboolean;
  end;

  ICpuFeatureSet = interface
    ['{BE12A2FD-F96D-4754-BE17-90E0640E24AD}']
    function Available: ICpuboolean;
    function Count: ICpuNumber;
    function ByIndex(Feature: byte): ICpuFeature;
    function ByName(Mnemonic: string): ICpuFeature;
  end;

  TCpuFeatureSet = class(TInterfacedObject, ICpuFeatureSet)
  private
    fCpu: byte;

    fSet: TFeatureSet;
    fDefinition: TFeatureSetDefinition;
  public
    constructor Create(Cpu: byte; FeatureSet: TFeatureSet);
    destructor Destroy; override;

    function Available: ICpuboolean;
    function Count: ICpuNumber;
    function ByIndex(Feature: byte): ICpuFeature;
    function ByName(Mnemonic: string): ICpuFeature;
  end;

  IProcessorFeatures = interface
    ['{9984FB6A-0598-4535-A5DB-0B3E07C3F179}']
    function Standard: ICpuFeatureSet;
    function StandardEx: ICpuFeatureSet;
    function extended: ICpuFeatureSet;
    function Power: ICpuFeatureSet;

    function ByName(Mnemonic: string): ICpuFeature;
  end;

  TProcessorFeatures = class(TInterfacedObject, IProcessorFeatures)
  private
    fCpu: byte;

  protected
    function FeatureLevel(Mnemonic: string): TFeatureSet;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Standard: ICpuFeatureSet;
    function StandardEx: ICpuFeatureSet;
    function extended: ICpuFeatureSet;
    function Power: ICpuFeatureSet;

    function ByName(Mnemonic: string): ICpuFeature;
  end;

function CpuIsFeatureSupported(Cpu: byte; Level: TFeatureSet; Feature: byte): boolean;
  overload;
function CpuIsFeatureSupported(Cpu: byte; Level: TFeatureSet;
  Mnemonic: string): boolean; overload;

function CpuGetFeatureSupport(Cpu: byte; Mnemonic: string): boolean;
function CpuGetFeatureIndex(Mnemonic: string): integer;
function CpuGetFeatureMnemonic(Index: byte): string;
function CpuGetFeatureName(Index: byte): string;

//--------------------------------------------------------------------------------------------------------
// Processor serial number functions
//--------------------------------------------------------------------------------------------------------

const
  RsCpu_Serial_Format = '%1.8x';

const
  // Pentium III Model number supporting the PSN feature
  cModel_MinPsn = 7;

type
  IProcessorSerial = interface
    ['{32A2653B-6B5D-4337-A4DA-50ABDA435450}']
    function Available: ICpuboolean;
    function Formatted: string;
    function Value: string;
  end;

  TProcessorSerial = class(TInterfacedObject, IProcessorSerial)
  private
    fCpu: byte;

    fCpuid1: ICpuid;
    fCpuid2: ICpuid;

    function Nibble(Value: longword): string;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Available: ICpuboolean;
    function Formatted: string;
    function Value: string;
  end;

function CpuIsSerialSupported(Cpu: byte): boolean;

function CpuGetSerialNumber(Cpu: byte): string;
function CpuGetSerialFormat(Cpu: byte): string;



//--------------------------------------------------------------------------------------------------------
// Processor errata
//--------------------------------------------------------------------------------------------------------

type
  IProcessorErrata = interface
    ['{AB5C614B-4D0F-4177-94FD-37930BE39048}']
    function FDivError: ICpuboolean;
    function DuronCache: ICpuboolean;
  end;

  TProcessorErrata = class(TInterfacedObject, IProcessorErrata)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function FDivError: ICpuboolean;
    function DuronCache: ICpuboolean;
  end;

function CpuIsFDivBugPresent(Cpu: byte): boolean;
function CpuIsDuronCacheBugPresent(Cpu: byte): boolean;

//--------------------------------------------------------------------------------------------------------
// Processor name class
//--------------------------------------------------------------------------------------------------------

const
  // Generic part names
  RsCpu_Generic_Name = 'x86 Family %d Model %d Stepping %d';
  // Intel part names
  RsCpu_Intel_Generic = 'Intel Geniune Processor';
  RsCpu_Intel_486DX = 'Intel 80486DX';
  RsCpu_Intel_486SX = 'Intel 80486SX';
  RsCpu_Intel_486DX2 = 'Intel 80486DX2';
  RsCpu_Intel_486DX4 = 'Intel 80486DX4';
  RsCpu_Intel_P5    = 'Intel Pentium';
  RsCpu_Intel_P5MMX = 'Intel Pentium MMX';
  RsCpu_Intel_P5OverDrive = 'Intel Pentium Overdrive';
  RsCpu_Intel_P5LV  = 'Intel Mobile Pentium';
  RsCpu_Intel_PPro  = 'Intel Pentium Pro';
  RsCpu_Intel_PII   = 'Intel Pentium II';
  RsCpu_Intel_PIIOverDrive = 'Intel Pentium II Overdrive';
  RsCpu_Intel_PIIXeon = 'Intel Pentium II Xeon';
  RsCpu_Intel_PIIMobile = 'Intel Mobile Pentium II';
  RsCpu_Intel_Celeron = 'Intel Celeron';
  RsCpu_Intel_MobileCeleron = 'Intel Mobile Celeron';
  RsCpu_Intel_PIII  = 'Intel Pentium III';
  RsCpu_Intel_PIIIXeon = 'Intel Pentium III Xeon';
  RsCpu_Intel_PIIIMobile = 'Intel Mobile Pentium III';
  RsCpu_Intel_P4    = 'Intel Pentium 4';
  RsCpu_Intel_P4Mobile = 'Intel Mobile Pentium 4';
  RsCpu_Intel_Xeon  = 'Intel Xeon';
  RsCpu_Intel_XeonMP = 'Intel Xeon MP';
  // AMD part names
  RsCpu_Amd_486DX2  = 'AMD AM486DX2';
  RsCpu_Amd_486DX4  = 'AMD AM486DX4';
  RsCpu_Amd_5X86    = 'AMD AM5x86';
  RsCpu_Amd_K5      = 'AMD K5';
  RsCpu_Amd_K6      = 'AMD K6';
  RsCpu_Amd_K62     = 'AMD K6 2';
  RsCpu_Amd_K63     = 'AMD K6 III';
  // Cyrix/Via part names
  RsCpu_Cyrix_MediaGX = 'Cyrix Media GX';
  RsCpu_Cyrix_Cx5x86 = 'Cyrix Cx5x86';
  RsCpu_Cyrix_6x86  = 'Cyrix 6x86';
  RsCpu_Cyrix_GXm   = 'Cyrix GXm';
  RsCpu_Cyrix_6x86MX = 'Cyrix 6x86MX';
  RsCpu_Cyrix_M2    = 'Cyrix M2';
  RsCpu_Cyrix_WinChip = 'Via Cyrix III';
  // IDT part names
  RsCpu_Idt_WinChip = 'IDT WinChip';
  RsCpu_Idt_WinChip2 = 'IDT WinChip 2';
  RsCpu_Idt_WinChip3 = 'IDT WinChip 3';
  // NexGen part names
  RsCpu_NexGen_Nx586 = 'NexGen Nx586';
  // UMC part names
  RsCpu_Umc_U5D     = 'UMC U5D';
  RsCpu_Umc_U5S     = 'UMC U5S';
  // Rise part names
  RsCpu_Rise_mP6    = 'Rise iDragon';
  RsCpu_Rise_mP6II  = 'Rise iDragon II';
  // Transmeta part names
  RsCpu_Transmeta_Crusoe = 'Transmeta Crusoe';

const
  cCache_Celeron = 131072;   // 128 * 1024   (128Kb)
  cCache_Xeon    = 1048576;  // 1024 * 1024  (1Mb)

  cBrand_XeonCel = 1713;    // $000006B1
  cBrand_IntelMp = 3859;    // $00000F13

type
  ICpuName = interface
    ['{1DB31043-BF40-469B-8FB0-5A31975A2B1C}']
    function Name: string;
  end;

  TProcessorNameDetect = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TUnknownProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TIntelProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
    function GetBrandName: string;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TAmdProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TCyrixProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TIdtProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TNexGenProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TUmcProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TRiseProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  TTransmetaProcessorLookup = class(TInterfacedObject, ICpuName)
  private
    fCpu: byte;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Name: string;
  end;

  IProcessorName = interface
    ['{56301CB6-0B6B-4E31-BFF8-0B0E0029EB5A}']
    function AsString: string;
    function FromLookup: ICpuboolean;
  end;

  TProcessorName = class(TInterfacedObject, IProcessorName)
  private
    fCpu: byte;
    fUseLookup: boolean;
    fTransmetaCpu: boolean;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function AsString: string;
    function FromLookup: ICpuboolean;
  end;

function CpuGetFullName(Cpu: byte): string;
function CpuIsNameFromLookup(Cpu: byte): boolean;


//--------------------------------------------------------------------------------------------------------
// Processor cache information
//--------------------------------------------------------------------------------------------------------

type
  TCacheLevel = (clLevel1Code, clLevel1Data, clLevel1Unified, clLevel2,
    clLevel3, clTrace);

  TCacheAssociativity = (caNone, caDirect, ca2Way, ca4Way, ca8Way, ca16Way, caFull);

  TCacheDescriptorInfo = record
    Descriptor: byte;
    Level:    TCacheLevel;
    Associativity: TCacheAssociativity;
    Size:     integer;
    LineSize: integer;
  end;

const
  cAssociativityInfo: array[caNone..caFull] of byte = (0, 1, 2, 4, 6, 8, 15);
  cAssociativityDescription: array[caNone..caFull] of string =
    ('None', 'Direct', '2-Way', '4-Way',
    '8-Way',
    '16-Way', 'Full');

  cMaxDescriptors = 36;
  cDescriptorInfo: array[0..cMaxDescriptors - 1] of TCacheDescriptorInfo = (
    (Descriptor: $06; Level: clLevel1Code; Associativity: ca4Way;
    Size: 8; LineSize: 32),
    (Descriptor: $08; Level: clLevel1Code; Associativity: ca4Way;
    Size: 16; LineSize: 32),
    (Descriptor: $30; Level: clLevel1Code; Associativity: ca8Way;
    Size: 32; LineSize: 64),

    (Descriptor: $0A; Level: clLevel1Data; Associativity: ca2Way;
    Size: 8; LineSize: 32),
    (Descriptor: $0C; Level: clLevel1Data; Associativity: ca4Way;
    Size: 16; LineSize: 32),
    (Descriptor: $2C; Level: clLevel1Data; Associativity: ca8Way;
    Size: 32; LineSize: 64),
    (Descriptor: $66; Level: clLevel1Data; Associativity: ca4Way;
    Size: 8; LineSize: 64),
    (Descriptor: $67; Level: clLevel1Data; Associativity: ca4Way;
    Size: 16; LineSize: 64),
    (Descriptor: $68; Level: clLevel1Data; Associativity: ca4Way;
    Size: 32; LineSize: 64),

    (Descriptor: $39; Level: clLevel2; Associativity: ca4Way;
    Size: 128; LineSize: 64),
    (Descriptor: $3B; Level: clLevel2; Associativity: ca2Way;
    Size: 128; LineSize: 64),
    (Descriptor: $3C; Level: clLevel2; Associativity: ca4Way;
    Size: 256; LineSize: 64),
    (Descriptor: $40; Level: clLevel2; Associativity: caNone;
    Size: 0; LineSize: 0),
    (Descriptor: $41; Level: clLevel2; Associativity: ca4Way;
    Size: 128; LineSize: 32),
    (Descriptor: $42; Level: clLevel2; Associativity: ca4Way;
    Size: 256; LineSize: 32),
    (Descriptor: $43; Level: clLevel2; Associativity: ca4Way;
    Size: 512; LineSize: 32),
    (Descriptor: $44; Level: clLevel2; Associativity: ca4Way;
    Size: 1024; LineSize: 32),
    (Descriptor: $45; Level: clLevel2; Associativity: ca4Way;
    Size: 2048; LineSize: 32),
    (Descriptor: $79; Level: clLevel2; Associativity: ca8Way;
    Size: 128; LineSize: 64),
    (Descriptor: $7A; Level: clLevel2; Associativity: ca8Way;
    Size: 256; LineSize: 64),
    (Descriptor: $7B; Level: clLevel2; Associativity: ca8Way;
    Size: 512; LineSize: 64),
    (Descriptor: $7C; Level: clLevel2; Associativity: ca8Way;
    Size: 1024; LineSize: 64),
    (Descriptor: $82; Level: clLevel2; Associativity: ca8Way;
    Size: 256; LineSize: 32),
    (Descriptor: $83; Level: clLevel2; Associativity: ca8Way;
    Size: 512; LineSize: 32),
    (Descriptor: $84; Level: clLevel2; Associativity: ca8Way;
    Size: 1024; LineSize: 32),
    (Descriptor: $85; Level: clLevel2; Associativity: ca8Way;
    Size: 2048; LineSize: 32),
    (Descriptor: $86; Level: clLevel2; Associativity: ca4Way;
    Size: 512; LineSize: 64),
    (Descriptor: $87; Level: clLevel2; Associativity: ca8Way;
    Size: 1024; LineSize: 64),

    (Descriptor: $22; Level: clLevel3; Associativity: ca4Way;
    Size: 512; LineSize: 64),
    (Descriptor: $23; Level: clLevel3; Associativity: ca8Way;
    Size: 1024; LineSize: 64),
    (Descriptor: $25; Level: clLevel3; Associativity: ca8Way;
    Size: 2048; LineSize: 64),
    (Descriptor: $29; Level: clLevel3; Associativity: ca8Way;
    Size: 4096; LineSize: 64),
    (Descriptor: $40; Level: clLevel3; Associativity: caNone;
    Size: 0; LineSize: 0),

    (Descriptor: $70; Level: clTrace; Associativity: ca8Way;
    Size: 12; LineSize: 0),
    (Descriptor: $71; Level: clTrace; Associativity: ca8Way;
    Size: 16; LineSize: 0),
    (Descriptor: $72; Level: clTrace; Associativity: ca8Way;
    Size: 32; LineSize: 0)
    );

type
  TCacheDescriptors = array[1..16] of longword;

  TCacheSegment = (csCode, csData, csUnified);

  ICpuCacheDescriptors = interface
    ['{A582BF81-9597-43F9-90EE-35173C8476AE}']
    function ByIndex(Index: integer): longword;
    function ValueExists(Value: longword): ICpuboolean;
  end;

  TCpuCacheDescriptors = class(TInterfacedObject, ICpuCacheDescriptors)
  private
    fCpu:    byte;
    fLevel:  TCacheLevel;
    fValues: TCacheDescriptors;
    function ValidDescriptor(Value: longword): boolean;
  protected
    procedure DecodeDescriptor(Value: ICpuNumber; Index: integer);
    procedure SetDescriptors;
  public
    constructor Create(Cpu: byte; Level: TCacheLevel);
    destructor Destroy; override;

    function ByIndex(Index: integer): longword;
    function ValueExists(Value: longword): ICpuboolean;
  end;

  ICpuCacheAssociativity = interface
    ['{61F2FE7E-95AC-4EE5-82CA-1BD0374EBE76}']
    function Value: ICpuNumber;
    function Name: string;
  end;

  TCpuCacheAssociativity = class(TInterfacedObject, ICpuCacheAssociativity)
  private
    fValue: TCacheAssociativity;
  public
    constructor Create(Value: TCacheAssociativity);
    destructor Destroy; override;

    function Value: ICpuNumber;
    function Name: string;
  end;

  ICpuCache = interface
    ['{D1AF660F-7BD9-4DBC-9259-DBC56E506912}']
    function Associativity: ICpuCacheAssociativity;
    function Available: ICpuboolean;
    function LineSize: ICpuNumber;
    function Size: ICpuNumber;
  end;

  TCacheByDescriptor = class(TInterfacedObject, ICpuCache)
  private
    fCpu:   byte;
    fLevel: TCacheLevel;
    fDescriptors: ICpuCacheDescriptors;
  public
    constructor Create(Cpu: integer; Level: TCacheLevel);
    destructor Destroy; override;

    function Associativity: ICpuCacheAssociativity;
    function Available: ICpuboolean;
    function LineSize: ICpuNumber;
    function Size: ICpuNumber;
  end;

  TCacheByExtendedCpuid = class(TInterfacedObject, ICpuCache)
  private
    fCpu:   byte;
    fLevel: TCacheLevel;
    fCacheValue: ICpuid;
  public
    constructor Create(Cpu: byte; Level: TCacheLevel);
    destructor Destroy; override;

    function Associativity: ICpuCacheAssociativity;
    function Available: ICpuboolean;
    function LineSize: ICpuNumber;
    function Size: ICpuNumber;
  end;

  ICpuSegmentedCache = interface
    ['{0B7B1571-B49E-4819-BD4F-0AC858D6FA4A}']
    function Code: ICpuCache;
    function Data: ICpuCache;
    function Unified: ICpuCache;
  end;

  TCpuSegmentedCache = class(TInterfacedObject, ICpuSegmentedCache)
  private
    fCpu:      byte;
    fExtended: boolean;
  public
    constructor Create(Cpu: byte; extended: boolean);
    destructor Destroy; override;

    function Code: ICpuCache;
    function Data: ICpuCache;
    function Unified: ICpuCache;
  end;

  IProcessorCache = interface
    ['{7E0E0625-0F0B-46EA-A933-2FEAC4838D91}']
    function Level1: ICpuSegmentedCache;
    function Level2: ICpuCache;
    function Level3: ICpuCache;
    function Trace: ICpuCache;
  end;

  TProcessorCache = class(TInterfacedObject, IProcessorCache)
  private
    fCpu:      byte;
    fExtended: boolean;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Level1: ICpuSegmentedCache;
    function Level2: ICpuCache;
    function Level3: ICpuCache;
    function Trace: ICpuCache;
  end;

function CpuIsCacheAvailable(Cpu: byte; CacheLevel: TCacheLevel): boolean;
function CpuGetCacheAssociativity(Cpu: byte;
  CacheLevel: TCacheLevel): TCacheAssociativity;
function CpuGetCacheLineSize(Cpu: byte; CacheLevel: TCacheLevel): integer;
function CpuGetCacheSize(Cpu: byte; CacheLevel: TCacheLevel): integer;


//--------------------------------------------------------------------------------------------------------
// Processor speed information
//--------------------------------------------------------------------------------------------------------

const
  RsCpu_Mapping_1100 = '1100+';
  RsCpu_Mapping_1200 = '1200+';
  RsCpu_Mapping_1300 = '1300+';
  RsCpu_Mapping_1400 = '1400+';
  RsCpu_Mapping_1500 = '1500+';
  RsCpu_Mapping_1600 = '1600+';
  RsCpu_Mapping_1700 = '1700+';
  RsCpu_Mapping_1800 = '1800+';
  RsCpu_Mapping_1900 = '1900+';
  RsCpu_Mapping_2000 = '2000+';
  RsCpu_Mapping_2100 = '2100+';
  RsCpu_Mapping_2200 = '2200+';
  RsCpu_Mapping_2400 = '2400+';
  RsCpu_Mapping_2500 = '2500+';
  RsCpu_Mapping_2600 = '2600+';
  RsCpu_Mapping_2700 = '2700+';
  RsCpu_Mapping_2800 = '2800+';
  RsCpu_Mapping_3000 = '3000+';
  RsCpu_Mapping_3200 = '3200+';

type
  TMappingInfo = record
    Frequency: integer;
    Mapping:   string;
  end;

const
  cBenchmarkDelay = 250;

  cMaxFrequencies = 12;
  cCpuFrequencies: array[0..cMaxFrequencies - 1] of integer =
    (0, 17, 20, 33, 50, 60, 66, 67, 80, 83, 90, 100);

  cMax256Mappings = 18;
  cAmd256Mappings: array[0..cMax256Mappings - 1] of TMappingInfo = (
    (Frequency: 950; Mapping: RsCpu_Mapping_1100),
    (Frequency: 1000; Mapping: RsCpu_Mapping_1200),
    (Frequency: 1100; Mapping: RsCpu_Mapping_1300),
    (Frequency: 1200; Mapping: RsCpu_Mapping_1400),
    (Frequency: 1300; Mapping: RsCpu_Mapping_1500),
    (Frequency: 1333; Mapping: RsCpu_Mapping_1500),
    (Frequency: 1400; Mapping: RsCpu_Mapping_1600),
    (Frequency: 1467; Mapping: RsCpu_Mapping_1700),
    (Frequency: 1500; Mapping: RsCpu_Mapping_1800),
    (Frequency: 1533; Mapping: RsCpu_Mapping_1800),
    (Frequency: 1600; Mapping: RsCpu_Mapping_1900),
    (Frequency: 1667; Mapping: RsCpu_Mapping_2000),
    (Frequency: 1733; Mapping: RsCpu_Mapping_2100),
    (Frequency: 1800; Mapping: RsCpu_Mapping_2200),
    (Frequency: 2000; Mapping: RsCpu_Mapping_2400),
    (Frequency: 2083; Mapping: RsCpu_Mapping_2600),
    (Frequency: 2167; Mapping: RsCpu_Mapping_2700),
    (Frequency: 2250; Mapping: RsCpu_Mapping_2800)
    );

  cMax512Mappings = 16;
  cAmd512Mappings: array[0..cMax512Mappings - 1] of TMappingInfo = (
    (Frequency: 1300; Mapping: RsCpu_Mapping_1700),
    (Frequency: 1400; Mapping: RsCpu_Mapping_1800),
    (Frequency: 1467; Mapping: RsCpu_Mapping_1900),
    (Frequency: 1533; Mapping: RsCpu_Mapping_2000),
    (Frequency: 1600; Mapping: RsCpu_Mapping_2100),
    (Frequency: 1667; Mapping: RsCpu_Mapping_2200),
    (Frequency: 1800; Mapping: RsCpu_Mapping_2400),
    (Frequency: 1833; Mapping: RsCpu_Mapping_2500),
    (Frequency: 1867; Mapping: RsCpu_Mapping_2500),
    (Frequency: 1917; Mapping: RsCpu_Mapping_2600),
    (Frequency: 2000; Mapping: RsCpu_Mapping_2600),
    (Frequency: 2083; Mapping: RsCpu_Mapping_2800),
    (Frequency: 2100; Mapping: RsCpu_Mapping_3000),
    (Frequency: 2133; Mapping: RsCpu_Mapping_2800),
    (Frequency: 2167; Mapping: RsCpu_Mapping_3000),
    (Frequency: 2200; Mapping: RsCpu_Mapping_3200)
    );

type
  TCpuSpeedThread = class(TThread)
  private
    fCpuSpeed: double;
    function GetCpuSpeed: longword;
    function RdTsc: int64;
  protected
    function GetProcessorSpeed: double;
    procedure Execute; override;
  public
    constructor Create;
    property CpuSpeed: longword Read GetCpuSpeed;
  end;

  IProcessorSpeed = interface
    ['{E7579AF4-7BC0-434F-BC3F-E521D8A28D79}']
    function RawSpeed: ICpuNumber;
    function Normalised: ICpuNumber;
    function Mapping: string;
  end;

  TProcessorSpeedInformation = class(TInterfacedObject, IProcessorSpeed)
  private
    fCpu:      byte;
    fRawSpeed: longword;
    fNormalisedSpeed: longword;
    procedure GetCpuSpeed;
    function NormaliseSpeed(Value: longword): longword;
  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;
    function RawSpeed: ICpuNumber;
    function Normalised: ICpuNumber;
    function Mapping: string;
  end;

function CpuGetRawSpeed(Cpu: byte): integer;
function CpuGetNormalisedSpeed(Cpu: byte): integer;
function CpuGetAmdMapping(Cpu: byte): string;

//--------------------------------------------------------------------------------------------------------
// Processor count
//--------------------------------------------------------------------------------------------------------

const
  cHyperthread_Logical = $00FF0000;

type
  IProcessorCount = interface
    ['{91847D4E-35C0-4F76-B116-E908E692780B}']
    function Available: ICpuNumber;
    function Logical: ICpuNumber;
  end;

  TProcessorCount = class(TInterfacedObject, IProcessorCount)
  private
    function SupportsHyperThreading(Cpu: byte): boolean;
    function LogicalProcessorCount(Cpu: byte): byte;
  public
    constructor Create;
    destructor Destroy; override;
    function Available: ICpuNumber;
    function Logical: ICpuNumber;
  end;

function CpuGetProcessorCount: byte;
function CpuGetVirtualCount: byte;

//--------------------------------------------------------------------------------------------------------
// Processor information
//--------------------------------------------------------------------------------------------------------

type
  IProcessorInformation = interface
    ['{4BCBA360-5FE4-4EDC-A027-ED0FDED6C598}']
    function Cache: IProcessorCache;
    function Cpuid: IProcessorCpuid;
    function Errata: IProcessorErrata;
    function Features: IProcessorFeatures;
    function Name: IProcessorName;
    function Serial: IProcessorSerial;
    function Signature: IProcessorSignature;
    function Speed: IProcessorSpeed;
    function Vendor: IProcessorVendor;
  end;

  TProcessorInformation = class(TInterfacedObject, IProcessorInformation)
  private
    fCpu: byte;

  public
    constructor Create(Cpu: byte);
    destructor Destroy; override;

    function Cache: IProcessorCache;
    function Cpuid: IProcessorCpuid;
    function Errata: IProcessorErrata;
    function Features: IProcessorFeatures;
    function Name: IProcessorName;
    function Serial: IProcessorSerial;
    function Signature: IProcessorSignature;
    function Speed: IProcessorSpeed;
    function Vendor: IProcessorVendor;

    property Cpu: byte Read fCpu;
  end;

//--------------------------------------------------------------------------------------------------------
// cxCpu base class
//--------------------------------------------------------------------------------------------------------

type
  TCachedCpuidResult = record
    Iterations: integer;
    Result:     TCpuidResult;
  end;

  TcxCpu = class
  private
    fSmp: boolean;

    function GetProcessor(Value: integer): IProcessorInformation;
  public
    constructor Create;
    destructor Destroy; override;

    function ProcessorCount: IProcessorCount;
    function Version: ICpuNumber;

    // Result cache (4.2)

    property Processors[Index: integer]: IProcessorInformation Read GetProcessor;
      default;
    property SmpActive: boolean Read fSmp;
  end;

procedure SetDynSetProcessAffinity;

const
  cToolkit_Version = 4301;

var
  DynSetProcessAffinity: TcxSetProcessAffinityMask;

  CpuidCommand: longword;
  fcxCpu: TcxCpu;

// Singleton function (r4.2)
function cxCpu: TcxCpu;

implementation

{ TCpuWord }

constructor TCpuWord.Create(Value: word);
begin
  inherited Create;

  fWord := Value;
end;

destructor TCpuWord.Destroy;
begin
  inherited;
end;

function TCpuWord.HiByte: byte;
begin
  Result := fWord shr 8;
end;

function TCpuWord.LoByte: byte;
begin
  Result := byte(fWord);
end;

function TCpuWord.Value: word;
begin
  Result := fWord;
end;

{ TCpuNumber }

function TCpuNumber.AsNumber: longword;
begin
  Result := fValue;
end;

function TCpuNumber.AsString: string;
begin
  Result := IntToStr(fValue);
end;

function TCpuNumber.CountBitsOn: byte;
var
  i: integer;
  c: byte;
begin
  c := 0;
  for i := 0 to 31 do
    if IsBitActive(i).AsBoolean then
      Inc(c);
  Result := c;
end;

constructor TCpuNumber.Create(Value: longword);
begin
  inherited Create;

  fValue := Value;
end;

destructor TCpuNumber.Destroy;
begin
  inherited;
end;

function TCpuNumber.FormatBytes: string;
const
  Kbyte = 1024;
  MByte = 1048576;
  GByte = 1073741824;
begin
  case fValue of
    0..KByte - 1:
      Result := Format(RsCpu_Format_Bytes, [fValue]);
    KByte..MByte - 1:
      Result := Format(RsCpu_Format_KBytes, [fValue / KByte]);
    MByte..GByte - 1:
      Result := Format(RsCpu_Format_MBytes, [fValue / MByte]);
    else
      Result := Format(RsCpu_Format_GBytes, [fValue / GByte]);
  end;
end;

function TCpuNumber.FormatHex: string;
begin
  Result := Format(RsCpu_Format_Hex, [fValue]);
end;

function TCpuNumber.FormatMhz: string;
const
  Mhz = 1000;
begin
  case fValue of
    0..Mhz - 1:
      Result := Format(RsCpu_Format_Mhz, [fValue]);
    else
      Result := Format(RsCpu_Format_GHz, [fValue / Mhz]);
  end;
end;

function TCpuNumber.FormatString: string;
begin
  Result := char(LoWord.LoByte) + char(LoWord.HiByte) + char(HiWord.LoByte) +
    char(HiWord.HiByte);
end;


function TCpuNumber.HiWord: ICpuWord;
begin
  Result := TCpuWord.Create(fValue shr 16);
end;

function TCpuNumber.IsBitActive(Bit: byte): ICpuboolean;
begin
  Result := TCpuboolean.Create((fValue and (1 shl Bit)) <> 0);
end;

function TCpuNumber.LoWord: ICpuWord;
begin
  Result := TCpuWord.Create(word(fValue));
end;

{ TCpuboolean }

function TCpuboolean.AsBoolean: boolean;
begin
  Result := fValue;
end;

constructor TCpuboolean.Create(Value: boolean);
begin
  inherited Create;

  fValue := Value;
end;

destructor TCpuboolean.Destroy;
begin
  inherited;
end;

function TCpuboolean.FormatTrueFalse: string;
const
  cboolean_Results: array[False..True] of string =
    (RsCpu_Format_False, RsCpu_Format_True);
begin
  Result := cboolean_Results[fValue];
end;

function TCpuboolean.FormatYesNo: string;
const
  cboolean_Results: array[False..True] of string = (RsCpu_Format_No, RsCpu_Format_Yes);
begin
  Result := cboolean_Results[fValue];
end;

function TCpuboolean.FormatOnOff: string;
const
  cboolean_Results: array[False..True] of string = (RsCpu_Format_Off, RsCpu_Format_On);
begin
  Result := cboolean_Results[fValue];
end;

function CpuFormatNumber(Value: longword; Format: TCpuNumberFormat): string;
var
  CpuNumber: ICpuNumber;
begin
  CpuNumber := TCpuNumber.Create(Value);
  case Format of
    cnfBytes:
      Result := CpuNumber.FormatBytes;
    cnfHex:
      Result := CpuNumber.FormatHex;
    cnfMhz:
      Result := CpuNumber.FormatMhz;
    cnfString:
      Result := CpuNumber.FormatString;
  end;
end;

function CpuFormatboolean(Value: boolean): string;
var
  Cpuboolean: ICpuboolean;
begin
  Cpuboolean := TCpuboolean.Create(Value);
  Result     := Cpuboolean.FormatYesNo;
end;

{ TProcessorAffinity }

constructor TCpuAffinity.Create(Cpu: byte);
var
  SystemAffinity: longword;
begin
  inherited Create;

  if cxCpu.SmpActive then
    if Cpu in [0..31] then
    begin
      fProcess := GetCurrentProcess;
      GetProcessAffinityMask(fProcess, fOldAffinity, SystemAffinity);

      if Cpu > cxCpu.ProcessorCount.Available.AsNumber - 1 then
        Cpu := 0;

      fAffinity := 1 shl Cpu;
      if Assigned(DynSetProcessAffinity) then
        DynSetProcessAffinity(fProcess, fAffinity);
      Sleep(0);
    end;
end;

destructor TCpuAffinity.Destroy;
begin
  if Assigned(DynSetProcessAffinity) then
    DynSetProcessAffinity(fProcess, fOldAffinity);
  inherited;
end;

function CpuSetAffinity(Cpu: byte): ICpuAffinity;
begin
  Result := TCpuAffinity.Create(Cpu);
end;

{ TCpuid }

function TCpuid.AsString: string;
begin
  Result := Eax.FormatString + Ebx.FormatString + Ecx.FormatString + Edx.FormatString;
end;

function TCpuid.Command: longword;
begin
  Result := fCommand;
end;

function TCpuid.Cpu: byte;
begin
  Result := fCpu;
end;

constructor TCpuid.Create(Cpu: byte; Command: longword; Iterations: integer);
var
  Affinity: ICpuAffinity;
begin
  // Add cache controller code here

  inherited Create;

  fCpu     := Cpu;
  fCommand := Command;
  fIterations := Iterations;

  if cxCpu.SmpActive then
    Affinity := TCpuAffinity.Create(Cpu);
  if Supported.AsBoolean then
    fResult := CpuExecuteCpuid(fCommand, Iterations)
  else
  begin
    fResult.Eax := 0;
    fResult.Ebx := 0;
    fResult.Ecx := 0;
    fResult.Edx := 0;
  end;
end;

constructor TCpuid.Create(Cpu: byte; Command: longword; Iterations: integer;
  Result: TCpuidResult);
begin
  inherited Create;

  fCpu     := Cpu;
  fCommand := Command;
  fIterations := Iterations;
  fResult  := Result;
end;

destructor TCpuid.Destroy;
begin
  inherited;
end;

function TCpuid.Eax: ICpuNumber;
begin
  Result := TCpuNumber.Create(fResult.Eax);
end;

function TCpuid.Ebx: ICpuNumber;
begin
  Result := TCpuNumber.Create(fResult.Ebx);
end;

function TCpuid.Ecx: ICpuNumber;
begin
  Result := TCpuNumber.Create(fResult.Ecx);
end;

function TCpuid.Edx: ICpuNumber;
begin
  Result := TCpuNumber.Create(fResult.Edx);
end;

function TCpuid.Iterations: integer;
begin
  Result := fIterations;
end;

function TCpuid.Supported: ICpuboolean;
begin
  Result := TCpuboolean.Create(CpuIsCpuidCommandSupported(fCpu, fCommand));
end;

function CpuIsCpuidSupported: boolean; overload;
asm
  PUSHFD
  POP       EAX
  MOV       EDX, EAX
  xor       EAX, cCpuid_EFlags
  PUSH      EAX
  POPFD
  PUSHFD
  POP       EAX
  xor       EAX, EDX
  JZ        @exit
  MOV       AL, true
  @exit:
end;

function CpuIsCpuidSupported(Cpu: byte): boolean; overload;
var
  Affinity: ICpuAffinity;
begin
  if cxCpu.SmpActive then
    Affinity := TCpuAffinity.Create(Cpu);
  Result := CpuIsCpuidSupported;
end;

function CpuGetCommandLevel(Command: longword): TCpuidExecutionLevel;
begin
  case Command of
    cStd_MaximumLevel..cStd_SerialNumber:
      Result := celStandard;
    cExt_MaximumLevel..cExt_AA64Information:
      Result := celExtended;
    cTmx_MaximumLevel..cTmx_Operation:
      Result := celTransmeta;
    else
      Result := celStandard;
  end;
end;

function CpuGetMaximumCommand(Level: TCpuidExecutionLevel): longword; overload;
begin
  case Level of
    celStandard:
      Result := CpuExecuteCpuid(cStd_MaximumLevel, 1).Eax;
    celExtended:
      Result := CpuExecuteCpuid(cExt_MaximumLevel, 1).Eax;
    celTransmeta:
      Result := CpuExecuteCpuid(cTmx_MaximumLevel, 1).Eax;
    else
      Result := 0;
  end;
end;

function CpuGetMaximumCommand(Cpu: byte; Level: TCpuidExecutionLevel): longword;
  overload;
var
  Affinity: ICpuAffinity;
begin
  if cxCpu.SmpActive then
    Affinity := TCpuAffinity.Create(Cpu);
  Result := CpuGetMaximumCommand(Level);
end;

function CpuIsCpuidCommandSupported(Command: longword): boolean; overload;
begin
  Result := Command <= CpuGetMaximumCommand(CpuGetCommandLevel(Command));
end;

function CpuIsCpuidCommandSupported(Cpu: byte; Command: longword): boolean; overload;
var
  Affinity: ICpuAffinity;
begin
  if cxCpu.SmpActive then
    Affinity := TCpuAffinity.Create(Cpu);
  Result := CpuIsCpuidCommandSupported(Command);
end;

function CpuGetCpuidResult: TCpuidResult; assembler; register;
asm
  PUSH      EBX
  PUSH      EDI
  MOV       EDI, EAX
  MOV       EAX, CpuidCommand
  DW        cCpuid_OpCode
  STOSD
  MOV       EAX, EBX
  STOSD
  MOV       EAX, ECX
  STOSD
  MOV       EAX, EDX
  STOSD
  POP       EDI
  POP       EBX
end;

function CpuExecuteCpuid(Command: longword; Iterations: integer): TCpuidResult; overload;
var
  i: integer;
begin
  CpuidCommand := Command;
  for i := 0 to Iterations - 1 do
    Result := CpuGetCpuidResult;
end;

function CpuExecuteCpuid(Cpu: byte; Command: longword;
  Iterations: integer): TCpuidResult; overload;
var
  Affinity: ICpuAffinity;
begin
  if cxCpu.SmpActive then
    Affinity := TCpuAffinity.Create(Cpu);
  Result := CpuExecuteCpuid(Command, Iterations);
end;

{ TCpuidInformation }

function TCpuidInformation.Available: ICpuboolean;
begin
  Result := TCpuboolean.Create(fCpuid.Supported.AsBoolean);
end;

constructor TCpuidInformation.Create(Cpu: byte; Level: TCpuidExecutionLevel);
begin
  inherited Create;

  fCpu := Cpu;
  fExecutionLevel := Level;

  case fExecutionLevel of
    celStandard:
      fCpuid := TCpuid.Create(fCpu, cStd_MaximumLevel);
    celExtended:
      fCpuid := TCpuid.Create(fCpu, cExt_MaximumLevel);
    celTransmeta:
      fCpuid := TCpuid.Create(fCpu, cTmx_MaximumLevel);
    else
      fCpuid := TCpuid.Create(fCpu, cStd_MaximumLevel);
  end;
end;

destructor TCpuidInformation.Destroy;
begin
  inherited;
end;

function TCpuidInformation.MaximumCommand: ICpuNumber;
begin
  Result := TCpuNumber.Create(fCpuid.Eax.AsNumber);
end;

{ TProcessorCpuidInformation }

constructor TProcessorCpuid.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TProcessorCpuid.Destroy;
begin
  inherited;
end;

function TProcessorCpuid.extended: ICpuidInformation;
begin
  Result := TCpuidInformation.Create(fCpu, celExtended);
end;

function TProcessorCpuid.Standard: ICpuidInformation;
begin
  Result := TCpuidInformation.Create(fCpu, celStandard);
end;

function TProcessorCpuid.Transmeta: ICpuidInformation;
begin
  Result := TCpuidInformation.Create(fCpu, celTransmeta);
end;

function CpuIsCpuidAvailable(Cpu: byte;
  CpuidExecutionLevel: TCpuidExecutionLevel): boolean;
var
  CpuidInformation: ICpuidInformation;
begin
  CpuidInformation := TCpuidInformation.Create(Cpu, CpuidExecutionLevel);
  Result := CpuidInformation.Available.AsBoolean;
end;

function CpuGetCpuidMaximumCommand(Cpu: byte;
  CpuidExecutionLevel: TCpuidExecutionLevel): longword;
var
  CpuidInformation: ICpuidInformation;
begin
  CpuidInformation := TCpuidInformation.Create(Cpu, CpuidExecutionLevel);
  Result := CpuidInformation.MaximumCommand.AsNumber;
end;

{ TCpuSignatureInformation }

constructor TCpuSignatureInformation.Create(Value: longword; Field: TCpuSignatureField);
begin
  inherited Create;

  fValue := TCpuNumber.Create(Value);
  fField := Field;
end;

destructor TCpuSignatureInformation.Destroy;
begin
  inherited;
end;

function TCpuSignatureInformation.extended: ICpuboolean;
begin
  case fField of
    csfFamily:
      Result := TCpuboolean.Create((fValue.AsNumber shr 8 and $F) >= $F);
    csfModel:
      Result := TCpuboolean.Create((fValue.AsNumber shr 4 and $F) >= $F);
    else
      Result := TCpuboolean.Create(False);
  end;
end;

function TCpuSignatureInformation.Value: ICpuNumber;
begin
  case fField of
    csfType:
      Result := TCpuNumber.Create(fValue.AsNumber shr 12 and 3);
    csfFamily:
      if extended.AsBoolean then
        Result := TCpuNumber.Create((fValue.AsNumber shr 20 and $FF) +
          (fValue.AsNumber shr 8 and $F))
      else
        Result := TCpuNumber.Create(fValue.AsNumber shr 8 and $F);
    csfModel:
      if extended.AsBoolean then
        Result := TCpuNumber.Create((fValue.AsNumber shr 16 and $F) +
          (fValue.AsNumber shr 4 and $F))
      else
        Result := TCpuNumber.Create(fValue.AsNumber shr 4 and $F);
    csfStepping:
      Result := TCpuNumber.Create(fValue.AsNumber and $F);
    csfBrand:
      Result := TCpuNumber.Create(fValue.AsNumber);
    else
      Result := TCpuNumber.Create(0);
  end;
end;

{ TProcessorSignature }

function TProcessorSignature.Brand: ICpuSignatureInformation;

  function IsAmdOpteron: boolean;
  begin
    Result := (cxCpu[fCpu].Vendor.VendorType = cvAmd) and
      (Family.Value.AsNumber = 15) and (Model.Value.AsNumber > 4);
  end;

var
  OpteronCpuid: ICpuid;
begin
  if IsAmdOpteron then
  begin
    if fCpuid.Ebx.AsNumber = 0 then
    begin
      OpteronCpuid := TCpuid.Create(fCpu, cExt_Signature);
      Result := TCpuSignatureInformation.Create(OpteronCpuid.Ebx.AsNumber, csfBrand);
    end
    else
      Result := TCpuSignatureInformation.Create(fCpuid.Ebx.Loword.LoByte, csfBrand);
  end
  else
    Result := TCpuSignatureInformation.Create(fCpuid.Ebx.Loword.LoByte, csfBrand);
end;

function TProcessorSignature.CpuType: ICpuSignatureInformation;
begin
  Result := TCpuSignatureInformation.Create(fCpuid.Eax.AsNumber, csfType);
end;

constructor TProcessorSignature.Create(Cpu: byte);
begin
  inherited Create;

  fCpu   := Cpu;
  fCpuid := TCpuid.Create(fCpu, cStd_Signature);
end;

destructor TProcessorSignature.Destroy;
begin
  inherited;
end;

function TProcessorSignature.Family: ICpuSignatureInformation;
begin
  Result := TCpuSignatureInformation.Create(fCpuid.Eax.AsNumber, csfFamily);
end;

function TProcessorSignature.Generic: string;
begin
  Result := Format(RsCpu_Generic_Name, [Family.Value.AsNumber,
    Model.Value.AsNumber, Stepping.Value.AsNumber]);
end;

function TProcessorSignature.Model: ICpuSignatureInformation;
begin
  Result := TCpuSignatureInformation.Create(fCpuid.Eax.AsNumber, csfModel);
end;

function TProcessorSignature.Stepping: ICpuSignatureInformation;
begin
  Result := TCpuSignatureInformation.Create(fCpuid.Eax.AsNumber, csfStepping);
end;

function TProcessorSignature.Value: ICpuNumber;
begin
  Result := TCpuNumber.Create(fCpuid.Eax.AsNumber);
end;

function CpuGetSignatureType(Cpu: byte): integer;
begin
  Result := cxCpu[Cpu].Signature.CpuType.Value.AsNumber;
end;

function CpuGetSignatureFamily(Cpu: byte): integer;
begin
  Result := cxCpu[Cpu].Signature.Family.Value.AsNumber;
end;

function CpuGetSignatureModel(Cpu: byte): integer;
begin
  Result := cxCpu[Cpu].Signature.Model.Value.AsNumber;
end;

function CpuGetSignatureStepping(Cpu: byte): integer;
begin
  Result := cxCpu[Cpu].Signature.Stepping.Value.AsNumber;
end;

function CpuGetSignatureBrand(Cpu: byte): integer;
begin
  Result := cxCpu[Cpu].Signature.Brand.Value.AsNumber;
end;

{ TProcessorVendor }

function TProcessorVendor.CacheDetect: TVendorCacheDetect;
begin
  Result := cVendorNames[fVendor].CacheDetect;
end;

constructor TProcessorVendor.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
  GetVendor;
end;

destructor TProcessorVendor.Destroy;
begin
  inherited;
end;

function TProcessorVendor.FeatureStyle: TFeatureAvailability;
begin
  Result := cVendorNames[fVendor].FeatureAvailability;
end;

procedure TProcessorVendor.GetVendor;
var
  i:     TCpuVendor;
  Cpuid: ICpuid;
  Vid:   string;
begin
  Cpuid := TCpuid.Create(fCpu, cStd_VendorSignature);
  Vid   := Cpuid.Ebx.FormatString + Cpuid.Edx.FormatString + Cpuid.Ecx.FormatString;

  fVendor := cvUnknown;
  for i := cvUnknown to cvTransmeta do
    if cVendorNames[i].Signature = Vid then
    begin
      fVendor := i;
      Exit;
    end;
end;

function TProcessorVendor.Name: string;
begin
  Result := cVendorNames[fVendor].Name;
end;

function TProcessorVendor.Signature: string;
begin
  Result := cVendorNames[fVendor].Signature;
end;

function TProcessorVendor.VendorType: TCpuVendor;
begin
  Result := fVendor;
end;

function CpuGetVendor(Cpu: byte): TCpuVendor;
begin
  Result := cxCpu[Cpu].Vendor.VendorType;
end;

function CpuGetVendorSignature(Cpu: byte): string;
begin
  Result := cxCpu[Cpu].Vendor.Signature;
end;

function CpuGetVendorName(Cpu: byte): string;
begin
  Result := cxCpu[Cpu].Vendor.Name;
end;

function CpuGetVendorFeatureStyle(Cpu: byte): TFeatureAvailability;
begin
  Result := cxCpu[Cpu].Vendor.FeatureStyle;
end;

function CpuGetVendorCacheDetect(Cpu: byte): TVendorCacheDetect;
begin
  Result := cxCpu[Cpu].Vendor.CacheDetect;
end;

{ TFeatureSetDefinition }

function TFeatureSetDefinition.BitIndexToResource(BitIndex: byte): byte;
begin
  Result := fAvailableFeatures[BitIndex].Index;
end;

constructor TFeatureSetDefinition.Create(Cpu: byte; Level: TFeatureSet);
begin
  inherited Create;

  fCpu := Cpu;
  fFeatureLevel := Level;
  fFeatureStyle := cxCpu[fCpu].Vendor.FeatureStyle;
  fFeatureCount := 0;
  GetAvailableFeatures;
end;

destructor TFeatureSetDefinition.Destroy;
begin
  inherited;
end;

function TFeatureSetDefinition.FeatureCount: ICpuNumber;
begin
  Result := TCpuNumber.Create(fFeatureCount);
end;

procedure TFeatureSetDefinition.GetAvailableFeatures;
var
  i: byte;
begin
  // Predefine available features
  for i := Low(fAvailableFeatures) to High(fAvailableFeatures) do
    fAvailableFeatures[i].Index := 255;

  // Get common features
  for i := 0 to cMaxFeatures - 1 do
    if (cFeatureDetails[i].Info = faCommon) and (fFeatureLevel in
      cFeatureDetails[i].Level) then
    begin
      fAvailableFeatures[cFeatureDetails[i].Index] := cFeatureDetails[i];
      fAvailableFeatures[cFeatureDetails[i].Index].Index := i;
    end;

  // Overwrite vendor specific features
  if fFeatureStyle <> faCommon then
    for i := 0 to cMaxFeatures - 1 do
      if (cFeatureDetails[i].Info = fFeatureStyle) and
        (fFeatureLevel in cFeatureDetails[i].Level) then
      begin
        fAvailableFeatures[cFeatureDetails[i].Index] := cFeatureDetails[i];
        fAvailableFeatures[cFeatureDetails[i].Index].Index := i;
      end;

  // Count available features
  for i := Low(fAvailableFeatures) to High(fAvailableFeatures) do
    if fAvailableFeatures[i].Index < 255 then
      Inc(fFeatureCount);
end;

function TFeatureSetDefinition.MnemonicToBitIndex(Mnemonic: string): byte;
var
  i:    byte;
  Pref: TFeatureAvailability;
begin
  Result := 255;
  Pref   := cxCpu[fCpu].Vendor.FeatureStyle;

  if Pref in [faAmd, faCyrix] then
  begin
    // Amd and Cyrix/Via use different bits for extended MMX
    if UpperCase(Mnemonic) = 'MMX+' then
    begin
      if cxCpu[fCpu].Vendor.VendorType = cvAmd then
        Result := cFeature_MmxAmd;
      if cxCpu[fCpu].Vendor.VendorType = cvCyrix then
        Result := cFeature_MmxVia;
    end;

    // Amd K5 (model 0) use bit 9 (APIC) to report PGE support
    if UpperCase(Mnemonic) = 'PGE' then
      if (cxCpu[fCpu].Vendor.VendorType = cvAmd) and
        (cxCpu[fCpu].Signature.Family.Value.AsNumber = 5) and
        (cxCpu[fCpu].Signature.Model.Value.AsNumber = 0) then
        Result := cFeature_Apic;

    // Amd K6 use reserved bit 10 to report SEP support
    if UpperCase(Mnemonic) = 'SEP' then
      if (cxCpu[fCpu].Vendor.VendorType = cvAmd) and
        (cxCpu[fCpu].Signature.Family.Value.AsNumber = 6) then
        Result := cFeature_SepK6;
  end;

  if Result > cMaxFeatures then
    for i := Low(fAvailableFeatures) to High(fAvailableFeatures) do
      if fAvailableFeatures[i].Mnemonic = UpperCase(Mnemonic) then
      begin
        Result := i;//fAvailableFeatures[i].Index;
        Break;
      end;
end;

{ TUnknownFeature }

function TUnknownFeature.Available: ICpuboolean;
begin
  Result := TCpuboolean.Create(False);
end;

function TUnknownFeature.BitIndex: byte;
begin
  Result := cFeature_Res;
end;

constructor TUnknownFeature.Create;
begin
  inherited Create;
end;

destructor TUnknownFeature.Destroy;
begin
  inherited;
end;

function TUnknownFeature.Mnemonic: string;
begin
  Result := RsCpu_Feature_ResMnemonic;
end;

function TUnknownFeature.Name: string;
begin
  Result := RsCpu_Feature_Res;
end;

{ TCpuFeature }

function TCpuFeature.Available: ICpuboolean;
var
  Cpuid: ICpuid;
begin
  case fFeatureSet of
    fsExtended:
      Cpuid := TCpuid.Create(fCpu, cExt_FeatureSet);
    fsPowerManagement:
      Cpuid := TCpuid.Create(fCpu, cExt_PowerManagement);
    else
      Cpuid := TCpuid.Create(fCpu, cStd_FeatureSet);
  end;

  if Cpuid.Supported.AsBoolean then
  begin
    if fFeatureSet <> fsStandardEx then
      Result := TCpuboolean.Create((Cpuid.Edx.AsNumber and (1 shl BitIndex)) <> 0)
    else
      Result := TCpuboolean.Create((Cpuid.Ecx.AsNumber and (1 shl BitIndex)) <> 0);
  end
  else
    Result := TCpuboolean.Create(False);
end;

function TCpuFeature.BitIndex: byte;
begin
  Result := cFeatureDetails[fIndex].Index;
end;

constructor TCpuFeature.Create(Cpu: byte; Index: integer; FeatureSet: TFeatureSet);
begin
  inherited Create;

  fCpu   := Cpu;
  fFeatureSet := FeatureSet;
  fIndex := Index;
end;

destructor TCpuFeature.Destroy;
begin
  inherited;
end;

function TCpuFeature.Mnemonic: string;
begin
  Result := cFeatureDetails[fIndex].Mnemonic;
end;

function TCpuFeature.Name: string;
begin
  Result := cFeatureDetails[fIndex].Name;
end;

{ TCpuFeatureSet }

function TCpuFeatureSet.Available: ICpuboolean;
begin
  case fSet of
    fsStandard, fsStandardEx:
      Result := TCpuboolean.Create(cxCpu[fCpu].Cpuid.Standard.MaximumCommand.AsNumber >=
        cStd_FeatureSet);
    fsExtended:
      Result := TCpuboolean.Create(cxCpu[fCpu].Cpuid.extended.MaximumCommand.AsNumber >=
        cExt_FeatureSet);
    fsPowerManagement:
      Result := TCpuboolean.Create(cxCpu[fCpu].Cpuid.extended.MaximumCommand.AsNumber >=
        cExt_PowerManagement);
    else
      Result := TCpuboolean.Create(False);
  end;
end;

function TCpuFeatureSet.ByIndex(Feature: byte): ICpuFeature;
begin
  if fDefinition.fAvailableFeatures[Feature].Index < cFeature_Res then
    Result := TCpuFeature.Create(fCpu, fDefinition.BitIndexToResource(Feature), fSet)
  else
    Result := TUnknownFeature.Create;
end;

function TCpuFeatureSet.ByName(Mnemonic: string): ICpuFeature;
  { Fixed range check error in Delphi 4 - F. Quointeau (8 Jan 2004) }
var
  Index: byte;
begin
  Index := fDefinition.MnemonicToBitIndex(Mnemonic);
  if Index < 255 then
    Result := ByIndex(Index)
  else
    Result := TUnknownFeature.Create;
end;

function TCpuFeatureSet.Count: ICpuNumber;
begin
  if Available.AsBoolean then
    Result := fDefinition.FeatureCount
  else
    Result := TCpuNumber.Create(0);
end;

constructor TCpuFeatureSet.Create(Cpu: byte; FeatureSet: TFeatureSet);
begin
  inherited Create;

  fCpu := Cpu;
  fSet := FeatureSet;
  fDefinition := TFeatureSetDefinition.Create(fCpu, fSet);
end;

destructor TCpuFeatureSet.Destroy;
begin
  fDefinition.Free;
  inherited;
end;

{ TProcessorFeatures }

function TProcessorFeatures.ByName(Mnemonic: string): ICpuFeature;
begin
  Result := (TCpuFeatureSet.Create(fCpu, FeatureLevel(Mnemonic)) as
    ICpuFeatureSet).ByName(Mnemonic);
end;

constructor TProcessorFeatures.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TProcessorFeatures.Destroy;
begin
  inherited;
end;

function TProcessorFeatures.extended: ICpuFeatureSet;
begin
  Result := TCpuFeatureSet.Create(fCpu, fsExtended);
end;

function TProcessorFeatures.FeatureLevel(Mnemonic: string): TFeatureSet;
var
  i:  integer;
  fi: integer;
begin
  fi     := -1;
  Result := fsUnknown;
  for i := 0 to cMaxFeatures - 1 do
    if cFeatureDetails[i].Mnemonic = UpperCase(Mnemonic) then
    begin
      fi := i;
      Break;
    end;

  if fi >= 0 then
    for i := Ord(fsStandard) to Ord(fsPowerManagement) do
      if TFeatureSet(i) in cFeatureDetails[fi].Level then
      begin
        Result := TFeatureSet(i);
        Break;
      end;
end;

function TProcessorFeatures.Power: ICpuFeatureSet;
begin
  Result := TCpuFeatureSet.Create(fCpu, fsPowerManagement);
end;

function TProcessorFeatures.Standard: ICpuFeatureSet;
begin
  Result := TCpuFeatureSet.Create(fCpu, fsStandard);
end;

function TProcessorFeatures.StandardEx: ICpuFeatureSet;
begin
  Result := TCpuFeatureSet.Create(fCpu, fsStandardEx);
end;

function CpuIsFeatureSupported(Cpu: byte; Level: TFeatureSet; Feature: byte): boolean;
  overload;
var
  FeatureSet: ICpuFeatureSet;
begin
  FeatureSet := TCpuFeatureSet.Create(Cpu, Level);
  Result     := FeatureSet.ByIndex(Feature).Available.AsBoolean;
end;

function CpuIsFeatureSupported(Cpu: byte; Level: TFeatureSet; Mnemonic: string): boolean;
  overload;
var
  FeatureSet: ICpuFeatureSet;
begin
  FeatureSet := TCpuFeatureSet.Create(Cpu, Level);
  Result     := FeatureSet.ByName(Mnemonic).Available.AsBoolean;
end;

function CpuGetFeatureSupport(Cpu: byte; Mnemonic: string): boolean;
begin
  Result := cxCpu[Cpu].Features.ByName(Mnemonic).Available.AsBoolean;
end;

function CpuGetFeatureIndex(Mnemonic: string): integer;
var
  i: integer;
begin
  Result := 255;
  if Result > cMaxFeatures then
    for i := Low(cFeatureDetails) to High(cFeatureDetails) do
      if cFeatureDetails[i].Mnemonic = UpperCase(Mnemonic) then
      begin
        Result := i;
        Break;
      end;
end;

function CpuGetFeatureMnemonic(Index: byte): string;
begin
  Result := cFeatureDetails[Index].Mnemonic;
end;

function CpuGetFeatureName(Index: byte): string;
begin
  Result := cFeatureDetails[Index].Name;
end;

{ TProcessorSerial }

function TProcessorSerial.Available: ICpuboolean;
begin
  Result := TCpuboolean.Create(cxCpu[fCpu].Features.Standard.ByIndex(
    cFeature_Psn).Available.AsBoolean);
end;

constructor TProcessorSerial.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;

  fCpuid1 := TCpuid.Create(fCpu, cStd_SerialNumber);
  fCpuid2 := TCpuid.Create(fCpu, cStd_SerialNumber);
end;

destructor TProcessorSerial.Destroy;
begin
  inherited;
end;

function TProcessorSerial.Formatted: string;
begin
  if cxCpu[fCpu].Vendor.VendorType <> cvTransmeta then
    Result := Nibble(fCpuid1.Eax.AsNumber) + '-' + Nibble(fCpuid2.Edx.AsNumber) +
      '-' + Nibble(fCpuid2.Ecx.AsNumber)
  else
    Result := Nibble(fCpuid1.Ebx.AsNumber);
end;

function TProcessorSerial.Nibble(Value: longword): string;
var
  HexValue: string;
begin
  HexValue := Format(RsCpu_Serial_Format, [Value]);
  Result   := Copy(HexValue, 0, 4) + '-' + Copy(HexValue, 5, 4);
end;

function TProcessorSerial.Value: string;
begin
  if cxCpu[fCpu].Vendor.VendorType <> cvTransmeta then
    Result := Format(RsCpu_Serial_Format, [fCpuid1.Eax.AsNumber]) +
      Format(RsCpu_Serial_Format, [fCpuid2.Edx.AsNumber]) +
      Format(RsCpu_Serial_Format, [fCpuid2.Ecx.AsNumber])
  else
    Result := Format(RsCpu_Serial_Format, [fCpuid1.Ebx.AsNumber]);
end;

function CpuIsSerialSupported(Cpu: byte): boolean;
begin
  Result := cxCpu[Cpu].Serial.Available.AsBoolean;
end;

function CpuGetSerialNumber(Cpu: byte): string;
begin
  Result := cxCpu[Cpu].Serial.Value;
end;

function CpuGetSerialFormat(Cpu: byte): string;
begin
  Result := cxCpu[Cpu].Serial.Formatted;
end;

{ TProcessorUsage }




{ TProcessorErrata }

constructor TProcessorErrata.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TProcessorErrata.Destroy;
begin
  inherited;
end;

function TProcessorErrata.DuronCache: ICpuboolean;
begin
  Result := TCpuboolean.Create((cxCpu[fCpu].Vendor.VendorType = cvAmd) and
    (cxCpu[fCpu].Signature.Family.Value.AsNumber = 6) and
    (cxCpu[fCpu].Signature.Model.Value.AsNumber = 3) and
    (cxCpu[fCpu].Signature.Stepping.Value.AsNumber = 0));
end;

function TProcessorErrata.FDivError: ICpuboolean;
const
  N1: real = 4195835.0;
  N2: real = 3145727.0;
begin
  Result := TCpuboolean.Create((((N1 / N2) * N2) - N1) <> 0.0);
end;

function CpuIsFDivBugPresent(Cpu: byte): boolean;
begin
  Result := cxCpu[Cpu].Errata.FDivError.AsBoolean;
end;

function CpuIsDuronCacheBugPresent(Cpu: byte): boolean;
begin
  Result := cxCpu[Cpu].Errata.DuronCache.AsBoolean;
end;

{ TProcessorNameDetect }

constructor TProcessorNameDetect.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TProcessorNameDetect.Destroy;
begin
  inherited;
end;

function TProcessorNameDetect.Name: string;
var
  LoCommand: longword;
  HiCommand: longword;
  Command:   longword;
begin
  if cxCpu[fCpu].Vendor.VendorType <> cvTransmeta then
  begin
    LoCommand := cExt_MarketingName1;
    HiCommand := cExt_MarketingName3;
  end
  else
  begin
    LoCommand := cTmx_MarketingName1;
    HiCommand := cTmx_MarketingName4;
  end;

  Result := '';
  for Command := LoCommand to HiCommand do
    Result := Result + (TCpuid.Create(fCpu, Command) as ICpuid).AsString;
end;

{ TUnknownProcessorLookup }

constructor TUnknownProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TUnknownProcessorLookup.Destroy;
begin
  inherited;
end;

function TUnknownProcessorLookup.Name: string;
begin
  Result := cVendorNames[cvUnknown].Prefix + Format(RsCpu_Generic_Name,
    [cxCpu[fCpu].Signature.Family.Value.AsNumber,
    cxCpu[fCpu].Signature.Model.Value.AsNumber,
    cxCpu[fCpu].Signature.Stepping.Value.AsNumber]);
end;

{ TIntelProcessorLookup }

constructor TIntelProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TIntelProcessorLookup.Destroy;
begin
  inherited;
end;

function TIntelProcessorLookup.GetBrandName: string;
var
  Signature: longword;
  BrandIdentifier: longword;
begin
  Result := '';

  BrandIdentifier := cxCpu[fCpu].Signature.Brand.Value.AsNumber;
  Signature := cxCpu[fCpu].Signature.Value.AsNumber;

  if BrandIdentifier <> cBrand_Unknown then
  begin
    case BrandIdentifier of
      cBrand_Celeron, cBrand_CeleronA:
        Result := RsCpu_Intel_Celeron;

      cBrand_P3, cBrand_P3Alt:
        Result := RsCpu_Intel_PIII;

      cBrand_P3Xeon:
        if Signature <> cBrand_XeonCel then
          Result := RsCpu_Intel_PIIIXeon
        else
          Result := RsCpu_Intel_Celeron;

      cBrand_P3Mobile:
        Result := RsCpu_Intel_PIIIMobile;

      cBrand_CeleronM, cBrand_CeleronMAlt:
        Result := RsCpu_Intel_MobileCeleron;

      cBrand_P4, cBrand_P4Alt:
        if Signature >= cBrand_IntelMp then
          Result := RsCpu_Intel_Generic
        else
          Result := RsCpu_Intel_P4;

      cBrand_P4Mobile:
        if Signature < cBrand_IntelMp then
          Result := RsCpu_Intel_Xeon
        else
          Result := RsCpu_Intel_P4Mobile;

      cBrand_Xeon:
        if Signature < cBrand_IntelMp then
          Result := RsCpu_Intel_XeonMP
        else
          Result := RsCpu_Intel_Xeon;

      cBrand_XeonMP:
        Result := RsCpu_Intel_XeonMP;

    end;
  end
  else
    Result := '';
end;

function TIntelProcessorLookup.Name: string;
var
  Family:   longword;
  Model:    longword;
  Stepping: longword;
  L2Cache:  longword;
begin
  Result := GetBrandName;
  if Length(Result) > 0 then
    Exit;

  Family   := cxCpu[fCpu].Signature.Family.Value.AsNumber;
  Model    := cxCpu[fCpu].Signature.Model.Value.AsNumber;
  Stepping := cxCpu[fCpu].Signature.Stepping.Value.AsNumber;

  if Family = cFamily_486 then
    case Model of
      4:
        Result := RsCpu_Intel_486SX;
      7:
        Result := RsCpu_Intel_486DX2;
      8:
        Result := RsCpu_Intel_486DX4;
      else
        Result := cVendorNames[cvIntel].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Family = cFamily_P5 then
    case Model of
      0, 1, 2, 7:
        Result := RsCpu_Intel_P5;
      3:
        Result := RsCpu_Intel_P5OverDrive;
      4:
        Result := RsCpu_Intel_P5MMX;
      else
        Result := cVendorNames[cvIntel].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Family = cFamily_P6 then
  begin
    L2Cache := cxCpu[fCpu].Cache.Level2.Size.AsNumber;

    case Model of
      0, 1:
        Result := RsCpu_Intel_PPro;
      3:
        if cxCpu[fCpu].Signature.CpuType.Value.AsNumber = cType_OverDrive then
          Result := RsCpu_Intel_PIIOverDrive
        else
          Result := RsCpu_Intel_PII;
      5:
        if L2Cache < cCache_Celeron then
          Result := RsCpu_Intel_Celeron
        else if L2Cache < cCache_Xeon then
          Result := RsCpu_Intel_PII
        else
          Result := RsCpu_Intel_PIIXeon;
      6:
        if L2Cache < cCache_Celeron then
        begin
          if cxCpu[fCpu].Features.Standard.ByIndex(
            cFeature_Psn).Available.AsBoolean then
            Result := RsCpu_Intel_MobileCeleron
          else
            Result := RsCpu_Intel_Celeron;
        end
        else
          Result := RsCpu_Intel_PIIMobile;
      7:
        if L2Cache < cCache_Xeon then
          Result := RsCpu_Intel_PIII
        else
          Result := RsCpu_Intel_PIIIXeon;
      else
        Result := cVendorNames[cvIntel].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;
  end;
  if Length(Result) = 0 then
    Result := cVendorNames[cvIntel].Prefix + Format(RsCpu_Generic_Name,
      [Family, Model, Stepping]);
end;

{ TAmdProcessorLookup }

constructor TAmdProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TAmdProcessorLookup.Destroy;
begin
  inherited;
end;

function TAmdProcessorLookup.Name: string;
var
  Family:   longword;
  Model:    longword;
  Stepping: longword;
begin
  Result   := '';
  Family   := cxCpu[fCpu].Signature.Family.Value.AsNumber;
  Model    := cxCpu[fCpu].Signature.Model.Value.AsNumber;
  Stepping := cxCpu[fCpu].Signature.Stepping.Value.AsNumber;

  if Family = cFamily_486 then
    case Model of
      3, 7, 8, 9:
        Result := RsCpu_Amd_486DX2;
      14, 15:
        Result := RsCpu_Amd_5X86;
      else
        Result := cVendorNames[cvAmd].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Family = cFamily_P5 then
    case Model of
      0..3:
        Result := RsCpu_Amd_K5;
      6, 7:
        Result := RsCpu_Amd_K6;
      8:
        Result := RsCpu_Amd_K62;
      9, $D:
        Result := RsCpu_Amd_K63;
      else
        Result := cVendorNames[cvAmd].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Length(Result) = 0 then
    Result := cVendorNames[cvAmd].Prefix + Format(RsCpu_Generic_Name,
      [Family, Model, Stepping]);

end;

{ TCyrixProcessorLookup }

constructor TCyrixProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TCyrixProcessorLookup.Destroy;
begin
  inherited;
end;

function TCyrixProcessorLookup.Name: string;
var
  Family:   longword;
  Model:    longword;
  Stepping: longword;
begin
  Result   := '';
  Family   := cxCpu[fCpu].Signature.Family.Value.AsNumber;
  Model    := cxCpu[fCpu].Signature.Model.Value.AsNumber;
  Stepping := cxCpu[fCpu].Signature.Stepping.Value.AsNumber;

  if Family = cFamily_486 then
    case Model of
      4:
        Result := RsCpu_Cyrix_MediaGX;
      9:
        Result := RsCpu_Cyrix_Cx5x86;
      else
        Result := cVendorNames[cvCyrix].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Family = cFamily_P5 then
    case Model of
      2:
        Result := RsCpu_Cyrix_6x86;
      4:
        Result := RsCpu_Cyrix_GXm;
      else
        Result := cVendorNames[cvCyrix].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Family = cFamily_P6 then
    case Model of
      0:
        Result := RsCpu_Cyrix_6x86MX;
      5:
        Result := RsCpu_Cyrix_M2;
      6..8:
        Result := RsCpu_Cyrix_WinChip;
      else
        Result := cVendorNames[cvCyrix].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Length(Result) = 0 then
    Result := cVendorNames[cvCyrix].Prefix + Format(RsCpu_Generic_Name,
      [Family, Model, Stepping]);
end;

{ TIdtProcessorLookup }

constructor TIdtProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TIdtProcessorLookup.Destroy;
begin
  inherited;
end;

function TIdtProcessorLookup.Name: string;
var
  Family:   longword;
  Model:    longword;
  Stepping: longword;
begin
  Result   := '';
  Family   := cxCpu[fCpu].Signature.Family.Value.AsNumber;
  Model    := cxCpu[fCpu].Signature.Model.Value.AsNumber;
  Stepping := cxCpu[fCpu].Signature.Stepping.Value.AsNumber;

  if Family = cFamily_P5 then
    case Model of
      4:
        Result := RsCpu_Idt_WinChip;
      8:
        Result := RsCpu_Idt_WinChip2;
      9:
        Result := RsCpu_Idt_WinChip3;
      else
        Result := cVendorNames[cvIDT].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Length(Result) = 0 then
    Result := cVendorNames[cvIDT].Prefix + Format(RsCpu_Generic_Name,
      [Family, Model, Stepping]);
end;

{ TNexGenProcessorLookup }

constructor TNexGenProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TNexGenProcessorLookup.Destroy;
begin
  inherited;
end;

function TNexGenProcessorLookup.Name: string;
var
  Family:   longword;
  Model:    longword;
  Stepping: longword;
begin
  Result   := '';
  Family   := cxCpu[fCpu].Signature.Family.Value.AsNumber;
  Model    := cxCpu[fCpu].Signature.Model.Value.AsNumber;
  Stepping := cxCpu[fCpu].Signature.Stepping.Value.AsNumber;

  if Family = cFamily_P5 then
    case Model of
      0:
        Result := RsCpu_NexGen_Nx586;
      else
        Result := cVendorNames[cvNexGen].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Length(Result) = 0 then
    Result := cVendorNames[cvNexGen].Prefix + Format(RsCpu_Generic_Name,
      [Family, Model, Stepping]);
end;

{ TUmcProcessorLookup }

constructor TUmcProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TUmcProcessorLookup.Destroy;
begin
  inherited;
end;

function TUmcProcessorLookup.Name: string;
var
  Family:   longword;
  Model:    longword;
  Stepping: longword;
begin
  Result   := '';
  Family   := cxCpu[fCpu].Signature.Family.Value.AsNumber;
  Model    := cxCpu[fCpu].Signature.Model.Value.AsNumber;
  Stepping := cxCpu[fCpu].Signature.Stepping.Value.AsNumber;

  if Family = cFamily_486 then
    case Model of
      1:
        Result := RsCpu_Umc_U5D;
      2:
        Result := RsCpu_Umc_U5D;
      else
        Result := cVendorNames[cvUMC].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Length(Result) = 0 then
    Result := cVendorNames[cvUMC].Prefix + Format(RsCpu_Generic_Name,
      [Family, Model, Stepping]);
end;

{ TRiseProcessorLookup }

constructor TRiseProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TRiseProcessorLookup.Destroy;
begin
  inherited;
end;

function TRiseProcessorLookup.Name: string;
var
  Family:   longword;
  Model:    longword;
  Stepping: longword;
begin
  Result   := '';
  Family   := cxCpu[fCpu].Signature.Family.Value.AsNumber;
  Model    := cxCpu[fCpu].Signature.Model.Value.AsNumber;
  Stepping := cxCpu[fCpu].Signature.Stepping.Value.AsNumber;

  if Family = cFamily_P5 then
    case Model of
      0:
        Result := RsCpu_Rise_mP6;
      2:
        Result := RsCpu_Rise_mP6II;
      else
        Result := cVendorNames[cvRise].Prefix +
          Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
    end;

  if Length(Result) = 0 then
    Result := cVendorNames[cvRise].Prefix + Format(RsCpu_Generic_Name,
      [Family, Model, Stepping]);
end;

{ TTransmetaProcessorLookup }

constructor TTransmetaProcessorLookup.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TTransmetaProcessorLookup.Destroy;
begin
  inherited;
end;

function TTransmetaProcessorLookup.Name: string;
var
  Family:   longword;
  Model:    longword;
  Stepping: longword;
begin
  Family   := cxCpu[fCpu].Signature.Family.Value.AsNumber;
  Model    := cxCpu[fCpu].Signature.Model.Value.AsNumber;
  Stepping := cxCpu[fCpu].Signature.Stepping.Value.AsNumber;

  Result := cVendorNames[cvTransmeta].Prefix +
    Format(RsCpu_Generic_Name, [Family, Model, Stepping]);
end;

{ TProcessorName }

function TProcessorName.AsString: string;
begin
  if not fUseLookup then
    Result := Trim((TProcessorNameDetect.Create(fCpu) as ICpuName).Name)
  else
    case cxCpu[fCpu].Vendor.VendorType of
      cvIntel:
        Result := (TIntelProcessorLookup.Create(fCpu) as ICpuName).Name;
      cvAmd:
        Result := (TAmdProcessorLookup.Create(fCpu) as ICpuName).Name;
      cvCyrix:
        Result := (TCyrixProcessorLookup.Create(fCpu) as ICpuName).Name;
      cvIDT:
        Result := (TIdtProcessorLookup.Create(fCpu) as ICpuName).Name;
      cvNexGen:
        Result := (TNexGenProcessorlookup.Create(fCpu) as ICpuName).Name;
      cvUMC:
        Result := (TUmcProcessorLookup.Create(fCpu) as ICpuName).Name;
      cvRise:
        Result := (TRiseProcessorLookup.Create(fCpu) as ICpuName).Name;
      cvTransmeta:
        Result := (TTransmetaProcessorLookup.Create(fCpu) as ICpuName).Name;
      else
        Result := (TUnknownProcessorLookup.Create(fCpu) as ICpuName).Name;
    end;
end;

constructor TProcessorName.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;

  fTransmetaCpu := cxCpu[fCpu].Vendor.VendorType = cvTransmeta;
  if not fTransmetaCpu then
  begin
    fUseLookup := cxCpu[fCpu].Cpuid.extended.MaximumCommand.AsNumber <
      cExt_MarketingName3;
  end
  else
    fUseLookup := cxCpu[fCpu].Cpuid.extended.MaximumCommand.AsNumber <
      cTmx_MarketingName4;
end;

destructor TProcessorName.Destroy;
begin
  inherited;
end;

function TProcessorName.FromLookup: ICpuboolean;
begin
  Result := TCpuboolean.Create(fUseLookup);
end;

function CpuGetFullName(Cpu: byte): string;
begin
  Result := cxCpu[Cpu].Name.AsString;
end;

function CpuIsNameFromLookup(Cpu: byte): boolean;
begin
  Result := cxCpu[Cpu].Name.FromLookup.AsBoolean;
end;

{ TCpuCacheDescriptors }

function TCpuCacheDescriptors.ByIndex(Index: integer): longword;
begin
  Result := fValues[Index];
end;

constructor TCpuCacheDescriptors.Create(Cpu: byte; Level: TCacheLevel);
begin

  fCpu   := Cpu;
  fLevel := Level;

  SetDescriptors;
end;

procedure TCpuCacheDescriptors.DecodeDescriptor(Value: ICpuNumber; Index: integer);
begin
  if ValidDescriptor(Value.AsNumber) then
  begin
    fValues[Index * 4 - 3] := Value.LoWord.LoByte;
    fValues[Index * 4 - 2] := Value.LoWord.HiByte;
    fValues[Index * 4 - 1] := Value.HiWord.LoByte;
    fValues[Index * 4]     := Value.HiWord.HiByte;
  end;
end;

destructor TCpuCacheDescriptors.Destroy;
begin
  inherited;
end;

procedure TCpuCacheDescriptors.SetDescriptors;
var
  CacheValue: ICpuid;
begin
  if cxCpu[fCpu].Vendor.VendorType = cvIntel then
    CacheValue := TCpuid.Create(fCpu, cStd_CacheTlbs,
      (TCpuid.Create(fCpu, cStd_CacheTlbs) as ICpuid).Eax.LoWord.LoByte)
  else if fLevel in [clLevel1Code..clLevel1Unified, clTrace] then
    CacheValue := TCpuid.Create(fCpu, cExt_Level1Cache)
  else
    CacheValue := TCpuid.Create(fCpu, cExt_Level2Cache);

  DecodeDescriptor(CacheValue.Eax, 1);
  DecodeDescriptor(CacheValue.Ebx, 2);
  DecodeDescriptor(CacheValue.Ecx, 3);
  DecodeDescriptor(CacheValue.Edx, 4);
end;

function TCpuCacheDescriptors.ValidDescriptor(Value: longword): boolean;
begin
  Result := (Value and (1 shl 31)) = 0;
end;

function TCpuCacheDescriptors.ValueExists(Value: longword): ICpuboolean;
var
  i: integer;
  f: boolean;
begin
  f := False;
  for i := Low(fValues) to High(fValues) do
    if not f then
      f := fValues[i] = Value;

  Result := TCpuboolean.Create(f);
end;

{ TCpuCacheAssociativity }

constructor TCpuCacheAssociativity.Create(Value: TCacheAssociativity);
begin
  inherited Create;

  fValue := Value;
end;

destructor TCpuCacheAssociativity.Destroy;
begin
  inherited;
end;

function TCpuCacheAssociativity.Name: string;
begin
  Result := cAssociativityDescription[fValue];
end;

function TCpuCacheAssociativity.Value: ICpuNumber;
begin
  Result := TCpuNumber.Create(cAssociativityInfo[fValue]);
end;

{ TCacheByDescriptor }

function TCacheByDescriptor.Associativity: ICpuCacheAssociativity;
var
  i: integer;
begin
  if not Available.AsBoolean then
  begin
    Result := TCpuCacheAssociativity.Create(caNone);
    Exit;
  end;

  Result := TCpuCacheAssociativity.Create(caNone);
  for i := Low(cDescriptorInfo) to High(cDescriptorInfo) do
    if cDescriptorInfo[i].Level = fLevel then
    begin
      Result := TCpuCacheAssociativity.Create(cDescriptorInfo[i].Associativity);
      Break;
    end;
end;

function TCacheByDescriptor.Available: ICpuboolean;
begin
  Result := TCpuboolean.Create(Size.AsNumber > 0);
end;

constructor TCacheByDescriptor.Create(Cpu: integer; Level: TCacheLevel);
begin
  inherited Create;

  fCpu   := Cpu;
  fLevel := Level;
  fDescriptors := TCpuCacheDescriptors.Create(fCpu, fLevel);
end;

destructor TCacheByDescriptor.Destroy;
begin
  inherited;
end;

function TCacheByDescriptor.LineSize: ICpuNumber;
var
  i: integer;
  s: integer;
begin
  if not Available.AsBoolean then
  begin
    Result := TCpuNumber.Create(0);
    Exit;
  end;

  s := 0;
  for i := Low(cDescriptorInfo) to High(cDescriptorInfo) do
    if (cDescriptorInfo[i].Level = fLevel) and
      (fDescriptors.ValueExists(cDescriptorInfo[i].Descriptor).AsBoolean) then
      s := cDescriptorInfo[i].LineSize;
  Result := TCpuNumber.Create(s);
end;

function TCacheByDescriptor.Size: ICpuNumber;
var
  i: integer;
  s: integer;
begin
  s := 0;
  for i := Low(cDescriptorInfo) to High(cDescriptorInfo) do
    if (cDescriptorInfo[i].Level = fLevel) and
      (fDescriptors.ValueExists(cDescriptorInfo[i].Descriptor).AsBoolean) then
      s := cDescriptorInfo[i].Size * 1024;
  Result := TCpuNumber.Create(s);
end;

{ TCacheByExtendedCpuid }

function TCacheByExtendedCpuid.Associativity: ICpuCacheAssociativity;
var
  i: TCacheAssociativity;
  AssociativityValue: byte;
begin
  if not Available.AsBoolean then
  begin
    Result := TCpuCacheAssociativity.Create(caNone);
    Exit;
  end;

  case fLevel of
    clLevel1Code:
      AssociativityValue := fCacheValue.Edx.HiWord.LoByte;
    clLevel1Data:
      AssociativityValue := fCacheValue.Ecx.HiWord.LoByte;
    clLevel2:
    begin
      if (cxCpu[fCpu].Vendor.VendorType = cvAmd) and
        (cxCpu[fCpu].Signature.Family.Value.AsNumber = 6) then
        AssociativityValue := cAssociativityInfo[ca16Way]
      else
        AssociativityValue := fCacheValue.Ecx.HiWord.LoByte; // ????
    end;
    else
      AssociativityValue := 0;
  end;
  for i := caNone to caFull do
    if AssociativityValue = cAssociativityInfo[i] then
      Result := TCpuCacheAssociativity.Create(TCacheAssociativity(i));
end;

function TCacheByExtendedCpuid.Available: ICpuboolean;
begin
  Result := TCpuboolean.Create(Size.AsNumber > 0);
end;

constructor TCacheByExtendedCpuid.Create(Cpu: byte; Level: TCacheLevel);
begin
  inherited Create;

  fCpu   := Cpu;
  fLevel := Level;

  case Level of
    clLevel1Code, clLevel1Data:
      fCacheValue := TCpuid.Create(fCpu, cExt_Level1Cache);
    clLevel2:
      fCacheValue := TCpuid.Create(fCpu, cExt_Level2Cache);
    else
      fCacheValue := TCpuid.Create(Cpu, cExt_Unsupported);
  end;
end;

destructor TCacheByExtendedCpuid.Destroy;
begin
  inherited;
end;

function TCacheByExtendedCpuid.LineSize: ICpuNumber;
begin
  if not Available.AsBoolean then
  begin
    Result := TCpuNumber.Create(0);
    Exit;
  end;

  case fLevel of
    clLevel1Code:
      Result := TCpuNumber.Create(fCacheValue.Edx.LoWord.LoByte);
    clLevel1Data, clLevel2:
      Result := TCpuNumber.Create(fCacheValue.Ecx.LoWord.LoByte);
    else
      Result := TCpuNumber.Create(0);
  end;
end;

function TCacheByExtendedCpuid.Size: ICpuNumber;
begin
  case fLevel of
    clLevel1Code:
      Result := TCpuNumber.Create(fCacheValue.Edx.HiWord.HiByte * 1024);
    clLevel1Data:
      Result := TCpuNumber.Create(fCacheValue.Ecx.HiWord.HiByte * 1024);
    clLevel2:
      if cxCpu[fCpu].Vendor.VendorType = cvIDT then
        Result := TCpuNumber.Create(fCacheValue.Ecx.HiWord.HiByte * 1024)
      else
        Result := TCpuNumber.Create(fCacheValue.Ecx.HiWord.Value * 1024);
    else
      Result := TCpuNumber.Create(0);
  end;
end;

{ TCpuSegmentedCache }

function TCpuSegmentedCache.Code: ICpuCache;
begin
  if not fExtended then
    Result := TCacheByDescriptor.Create(fCpu, clLevel1Code)
  else
    Result := TCacheByExtendedCpuid.Create(fCpu, clLevel1Code);
end;

constructor TCpuSegmentedCache.Create(Cpu: byte; extended: boolean);
begin
  inherited Create;

  fCpu      := Cpu;
  fExtended := extended;
end;

function TCpuSegmentedCache.Data: ICpuCache;
begin
  if not fExtended then
    Result := TCacheByDescriptor.Create(fCpu, clLevel1Data)
  else
    Result := TCacheByExtendedCpuid.Create(fCpu, clLevel1Data);
end;

destructor TCpuSegmentedCache.Destroy;
begin
  inherited;
end;

function TCpuSegmentedCache.Unified: ICpuCache;
begin
  if not fExtended then
    Result := TCacheByDescriptor.Create(fCpu, clLevel1Unified)
  else
    Result := TCacheByExtendedCpuid.Create(fCpu, clLevel1Unified);
end;

{ TProcessorCache }

constructor TProcessorCache.Create(Cpu: byte);
begin
  inherited Create;

  fCpu      := Cpu;
  fExtended := cxCpu[fCpu].Vendor.CacheDetect = vcdExtended;
end;

destructor TProcessorCache.Destroy;
begin
  inherited;
end;

function TProcessorCache.Level1: ICpuSegmentedCache;
begin
  Result := TCpuSegmentedCache.Create(fCpu, fExtended);
end;

function TProcessorCache.Level2: ICpuCache;
begin
  if not fExtended then
    Result := TCacheByDescriptor.Create(fCpu, clLevel2)
  else
    Result := TCacheByExtendedCpuid.Create(fCpu, clLevel2);
end;

function TProcessorCache.Level3: ICpuCache;
begin
  if not fExtended then
    Result := TCacheByDescriptor.Create(fCpu, clLevel3)
  else
    Result := TCacheByExtendedCpuid.Create(fCpu, clLevel3);
end;

function TProcessorCache.Trace: ICpuCache;
begin
  if not fExtended then
    Result := TCacheByDescriptor.Create(fCpu, clTrace)
  else
    Result := TCacheByExtendedCpuid.Create(fCpu, clTrace);
end;

function CpuIsCacheAvailable(Cpu: byte; CacheLevel: TCacheLevel): boolean;
var
  Cache: ICpuCache;
begin
  if cxCpu[Cpu].Vendor.CacheDetect <> vcdExtended then
    Cache := TCacheByDescriptor.Create(Cpu, CacheLevel)
  else
    Cache := TCacheByExtendedCpuid.Create(Cpu, CacheLevel);

  Result := Cache.Available.AsBoolean;
end;

function CpuGetCacheAssociativity(Cpu: byte;
  CacheLevel: TCacheLevel): TCacheAssociativity;
var
  Cache: ICpuCache;
begin
  if cxCpu[Cpu].Vendor.CacheDetect <> vcdExtended then
    Cache := TCacheByDescriptor.Create(Cpu, CacheLevel)
  else
    Cache := TCacheByExtendedCpuid.Create(Cpu, CacheLevel);

  Result := TCacheAssociativity(Cache.Associativity.Value.AsNumber);
end;

function CpuGetCacheLineSize(Cpu: byte; CacheLevel: TCacheLevel): integer;
var
  Cache: ICpuCache;
begin
  if cxCpu[Cpu].Vendor.CacheDetect <> vcdExtended then
    Cache := TCacheByDescriptor.Create(Cpu, CacheLevel)
  else
    Cache := TCacheByExtendedCpuid.Create(Cpu, CacheLevel);

  Result := Cache.LineSize.AsNumber;
end;

function CpuGetCacheSize(Cpu: byte; CacheLevel: TCacheLevel): integer;
var
  Cache: ICpuCache;
begin
  if cxCpu[Cpu].Vendor.CacheDetect <> vcdExtended then
    Cache := TCacheByDescriptor.Create(Cpu, CacheLevel)
  else
    Cache := TCacheByExtendedCpuid.Create(Cpu, CacheLevel);

  Result := Cache.Size.AsNumber;
end;

{ TCpuSpeedThread }

constructor TCpuSpeedThread.Create;
begin
  inherited Create(False);
  Priority := tpTimeCritical;
end;

procedure TCpuSpeedThread.Execute;
begin
  fCpuSpeed := GetProcessorSpeed;
end;

function TCpuSpeedThread.GetCpuSpeed: longword;
begin
  Result := Trunc(fCpuSpeed);
end;

function TCpuSpeedThread.GetProcessorSpeed: double;
var
  C1, T1, C2, T2, F: int64;
  Tc: longword;
begin
    {$O-}
  C1 := RdTsc;
  QueryPerformanceCounter(T1);
  Tc := GetTickCount;
  while GetTickCount - Tc < 5 do ;
  C2 := Rdtsc;
  QueryPerformanceCounter(T2);
  QueryPerformanceFrequency(F);
    {$O+}
  Result := (C2 - C1) / ((T2 - T1) / F) / 1E6;
end;

function TCpuSpeedThread.RdTsc: int64;
asm
  rdtsc
end;

{ TProcessorSpeedInformation }

constructor TProcessorSpeedInformation.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
  GetCpuSpeed;
  fNormalisedSpeed := NormaliseSpeed(fRawSpeed);
end;

destructor TProcessorSpeedInformation.Destroy;
begin
  inherited;
end;

procedure TProcessorSpeedInformation.GetCpuSpeed;
begin
  with TCpuSpeedThread.Create do
    try
      WaitFor;
      fRawSpeed := CpuSpeed;
    finally
      Free;
    end;
end;

function TProcessorSpeedInformation.Mapping: string;
var
  i:  integer;
  ns: longword;
  l:  integer;
begin
  Result := '';
  if cxCpu[fCpu].Vendor.VendorType <> cvAmd then
    Exit;

  ns := Normalised.AsNumber;

  // Mapping group determined by size of L2 cache
  l := cxCpu[fCpu].Cache.Level2.Size.AsNumber div 1024;

  case l of
    256:
      for i := 0 to cMax256Mappings - 1 do
        if cAmd256Mappings[i].Frequency = integer(ns) then
        begin
          Result := cAmd256Mappings[i].Mapping;
          Break;
        end;
    512:
      for i := 0 to cMax512Mappings - 1 do
        if cAmd512Mappings[i].Frequency = integer(ns) then
        begin
          Result := cAmd512Mappings[i].Mapping;
          Break;
        end
        else
          Result := '';
  end;
end;

function TProcessorSpeedInformation.Normalised: ICpuNumber;
begin
  Result := TCpuNumber.Create(fNormalisedSpeed);
end;

function TProcessorSpeedInformation.NormaliseSpeed(Value: longword): longword;
var
  Freq, RF: integer;
  i:      byte;
  Hi, Lo: byte;
begin
  RF   := 0;
  Freq := Value mod 100;
  for i := 0 to cMaxFrequencies - 1 do
  begin
    if Freq < cCpuFrequencies[i] then
    begin
      Hi := i;
      Lo := i - 1;
      if (cCpuFrequencies[Hi] - Freq) > (Freq - cCpuFrequencies[Lo]) then
        RF := cCpuFrequencies[Lo] - Freq
      else
        RF := cCpuFrequencies[Hi] - Freq;
      Break;
    end;
  end;
  Result := integer(Value) + RF;
end;

function TProcessorSpeedInformation.RawSpeed: ICpuNumber;
begin
  Result := TCpuNumber.Create(fRawSpeed);
end;

function CpuGetRawSpeed(Cpu: byte): integer;
begin
  Result := cxCpu[Cpu].Speed.RawSpeed.AsNumber;
end;

function CpuGetNormalisedSpeed(Cpu: byte): integer;
begin
  Result := cxCpu[Cpu].Speed.Normalised.AsNumber;
end;

function CpuGetAmdMapping(Cpu: byte): string;
begin
  Result := cxCpu[Cpu].Speed.Mapping;
end;

{ TProcessorCount }

function TProcessorCount.Available: ICpuNumber;
var
  lpSysInfo: TSystemInfo;
begin
  GetSystemInfo(lpSysInfo);
  Result := TCpuNumber.Create(lpSysInfo.dwNumberOfProcessors);
end;

constructor TProcessorCount.Create;
begin
  inherited Create;
end;

destructor TProcessorCount.Destroy;
begin
  inherited;
end;

function TProcessorCount.Logical: ICpuNumber;
var
  i: byte;
  r: integer;
begin
  r := 0;
  for i := 1 to Available.AsNumber do
  begin
    r := r + LogicalProcessorCount(i);
  end;
  Result := TCpuNumber.Create(r);
end;

function TProcessorCount.LogicalProcessorCount(Cpu: byte): byte;
var
  LogicalResult: ICpuid;
begin
  if SupportsHyperThreading(Cpu) then
  begin
    LogicalResult := TCpuid.Create(Cpu, cStd_Signature);
    Result := LogicalResult.Ebx.HiWord.LoByte;
  end
  else
    Result := 1;
end;

function TProcessorCount.SupportsHyperThreading(Cpu: byte): boolean;
begin
  Result := cxCpu[Cpu].Features.Standard.ByIndex(cFeature_Htt).Available.AsBoolean;
end;

function CpuGetProcessorCount: byte;
begin
  Result := cxCpu.ProcessorCount.Available.AsNumber;
end;

function CpuGetVirtualCount: byte;
begin
  Result := cxCpu.ProcessorCount.Logical.AsNumber;
end;

{ TProcessorInformation }

function TProcessorInformation.Cache: IProcessorCache;
begin
  Result := TProcessorCache.Create(fCpu);
end;

function TProcessorInformation.Cpuid: IProcessorCpuid;
begin
  Result := TProcessorCpuid.Create(fCpu);
end;

constructor TProcessorInformation.Create(Cpu: byte);
begin
  inherited Create;

  fCpu := Cpu;
end;

destructor TProcessorInformation.Destroy;
begin
  inherited;
end;

function TProcessorInformation.Errata: IProcessorErrata;
begin
  Result := TProcessorErrata.Create(fCpu);
end;

function TProcessorInformation.Features: IProcessorFeatures;
begin
  Result := TProcessorFeatures.Create(fCpu);
end;

function TProcessorInformation.Name: IProcessorName;
begin
  Result := TProcessorName.Create(fCpu);
end;

function TProcessorInformation.Serial: IProcessorSerial;
begin
  Result := TProcessorSerial.Create(fCpu);
end;

function TProcessorInformation.Signature: IProcessorSignature;
begin
  Result := TProcessorSignature.Create(fCpu);
end;

function TProcessorInformation.Speed: IProcessorSpeed;
begin
  Result := TProcessorSpeedInformation.Create(fCpu);
end;

function TProcessorInformation.Vendor: IProcessorVendor;
begin
  Result := TProcessorVendor.Create(fCpu);
end;

{ TcxCpu }

constructor TcxCpu.Create;
begin
  inherited Create;

  fSmp := ProcessorCount.Available.AsNumber > 1;
end;

destructor TcxCpu.Destroy;
begin
  inherited;
end;

function TcxCpu.GetProcessor(Value: integer): IProcessorInformation;
begin
  Result := TProcessorInformation.Create(Value);
end;

function TcxCpu.ProcessorCount: IProcessorCount;
begin
  Result := TProcessorCount.Create;
end;

function TcxCpu.Version: ICpuNumber;
begin
  Result := TCpuNumber.Create(cToolkit_Version);
end;

procedure SetDynSetProcessAffinity;
var
  Kernel32: THandle;
begin
  Kernel32 := LoadLibrary(PChar(RsCpu_Library_Kernel));
  if Kernel32 <> 0 then
  begin
    DynSetProcessAffinity := GetProcAddress(Kernel32, PChar(RsCpu_Library_Function));
  end;
end;




function cxCpu: TcxCpu;
begin
  if fcxCpu = nil then
    fcxCpu := TcxCpu.Create;

  Result := fcxCpu;
end;

initialization
  SetDynSetProcessAffinity;

finalization
  fcxCpu.Free;

end.
