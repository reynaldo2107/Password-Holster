

// Copyright 2014 Reynaldo Mola

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//    http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


unit NT_utils;


interface
uses system.Classes;
   const
   SE_CREATE_TOKEN_NAME = 'SeCreateTokenPrivilege';
   SE_ASSIGNPRIMARYTOKEN_NAME = 'SeAssignPrimaryTokenPrivilege';
   SE_LOCK_MEMORY_NAME = 'SeLockMemoryPrivilege';
   SE_INCREASE_QUOTA_NAME = 'SeIncreaseQuotaPrivilege';
   SE_UNSOLICITED_INPUT_NAME = 'SeUnsolicitedInputPrivilege';
   SE_MACHINE_ACCOUNT_NAME = 'SeMachineAccountPrivilege';
   SE_TCB_NAME = 'SeTcbPrivilege';
   SE_SECURITY_NAME = 'SeSecurityPrivilege';
   SE_TAKE_OWNERSHIP_NAME = 'SeTakeOwnershipPrivilege';
   SE_LOAD_DRIVER_NAME = 'SeLoadDriverPrivilege';
   SE_SYSTEM_PROFILE_NAME = 'SeSystemProfilePrivilege';
   SE_SYSTEMTIME_NAME = 'SeSystemtimePrivilege';
   SE_PROF_SINGLE_PROCESS_NAME = 'SeProfileSingleProcessPrivilege';
   SE_INC_BASE_PRIORITY_NAME = 'SeIncreaseBasePriorityPrivilege';
   SE_CREATE_PAGEFILE_NAME = 'SeCreatePagefilePrivilege';
   SE_CREATE_PERMANENT_NAME = 'SeCreatePermanentPrivilege';
   SE_BACKUP_NAME =  'SeBackupPrivilege';
   SE_RESTORE_NAME = 'SeRestorePrivilege';
   SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
   SE_DEBUG_NAME = 'SeDebugPrivilege';
   SE_AUDIT_NAME = 'SeAuditPrivilege';
   SE_SYSTEM_ENVIRONMENT_NAME = 'SeSystemEnvironmentPrivilege';
   SE_CHANGE_NOTIFY_NAME = 'SeChangeNotifyPrivilege';
   SE_REMOTE_SHUTDOWN_NAME = 'SeRemoteShutdownPrivilege';
   SE_UNDOCK_NAME = 'SeUndockPrivilege';
   SE_SYNC_AGENT_NAME = 'SeSyncAgentPrivilege';
   SE_ENABLE_DELEGATION_NAME = 'SeEnableDelegationPrivilege';
   SE_MANAGE_VOLUME_NAME = 'SeManageVolumePrivilege';
  function NTSetPrivilege_old(sPrivilege: string; bEnabled: Boolean): Boolean;
  procedure setBackupPriviledge;
  function LocalAppDataPath : string;
   function NTSetPrivilege(sPrivilege: string; bEnabled: Boolean): Boolean;
   function GetImportedGroupName(Sless, Smore: TstringList): string;
   function GetImportedGroupName2(afileName: string): string;
   function GetGroupCount: integer;
   function SaveUserCFGValuesToRegistry : boolean;
   function GetUserCFGValuesToRegistry : boolean;
implementation
uses winapi.windows, system.SysUtils, shFolder, registry, mainUnit;


// Enables or disables privileges debending on the bEnabled
 // Aktiviert oder deaktiviert Privilegien, abhängig von bEnabled
function SaveUserCFGValuesToRegistry : boolean;
begin
with TRegistry.Create do
 begin
  Result:= false;
  RootKey := HKEY_CURRENT_USER;
  if OpenKey(registriconst + '\' + 'validation', true) then
  begin
    WriteInteger('minutes to disable' , max_counter2disable);
    WriteInteger('minutes to disable show password' , max_counter2disableViewPasssword);
    Result:= true;
    closeKey;
  end;
   Free;
 end;
end;

function GetUserCFGValuesToRegistry : boolean;
begin
with TRegistry.Create do
 begin
  Result:= false;
    max_counter2disable:= 60;
     max_counter2disableViewPasssword:= 60;
  RootKey := HKEY_CURRENT_USER;
  if OpenKey(registriconst + '\' + 'validation', false) then
  begin
    if ValueExists('minutes to disable') then
    max_counter2disable:= ReadInteger('minutes to disable' ) else
    max_counter2disable:= 60;

    if ValueExists('minutes to disable show password') then
    max_counter2disableViewPasssword:= readInteger('minutes to disable show password') else
    max_counter2disableViewPasssword:= 60;

    Result:= true;
    closeKey;
  end;
   Free;
 end;
end;

function GetImportedGroupName(Sless, Smore: TstringList): string;
var
  i:integer;

begin
  if sless.Count > 1 then
  sless.Delete(sless.IndexOf('validation'));
  if smore.Count > 1 then
  smore.Delete(smore.IndexOf('validation'));
  smore.Sorted:=true;
  Sless.Sorted:=true;
  Result:= smore[smore.Count - 1];
  for i := 0 to smore.Count - 2 do
    if smore[i] <> sless[i] then
     begin
      Result:= sMore[i];
      break;
     end;
end;

function GetGroupCount: integer;
const registriconst:string = 'Software\gdbt\sweetkeeper';
var
  Reg: TRegistry;
  S: TstringList;
begin
    Result:= 0;
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(registriconst, False) then
    begin
      S := TStringList.Create;
      try
        reg.GetKeyNames(S);
        if S.Count > 0 then
         S.Delete(S.IndexOf('validation'));
         Result:= S.Count;
      finally
       S.Free;
       Reg.CloseKey;
       Reg.Free;
      end; // Reg.OpenKey(registriconst, False)
    end;
end;

function GetImportedGroupName2(afileName: string): string;
const
regentry: string = '[HKEY_CURRENT_USER\software\gdbt\sweetkeeper\';
var
t: TextFile;
a: string;
begin
 AssignFile(T, afileName);
 try
   reset(T);
    while not eof(t) do
     begin
      Read(T, a);

      if Pos(regentry ,a) <> 0 then
      begin
       Result:= copy(a, length(regentry) + 1 , length(a) - length(regentry));
       break;
      end;
     end;
 finally
    CloseFile(T);
 end;
end;

function NTSetPrivilege(sPrivilege: string; bEnabled: Boolean): Boolean;
var
hToken: THandle;
TokenPriv: TOKEN_PRIVILEGES;
PrevTokenPriv: TOKEN_PRIVILEGES;
ReturnLength: Cardinal;
errval:Cardinal;
begin
Result := True;
errval:=0;
// Only for Windows NT/2000/XP and later.
if not (Win32Platform = VER_PLATFORM_WIN32_NT) then Exit;
Result := False;

// obtain the processes token
if OpenProcessToken(GetCurrentProcess(),
TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
begin
try
// Get the locally unique identifier (LUID) .
if LookupPrivilegeValue(nil, PChar(sPrivilege),TokenPriv.Privileges[0].Luid) then
begin
TokenPriv.PrivilegeCount := 1; // one privilege to set

case bEnabled of
True: TokenPriv.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
False: TokenPriv.Privileges[0].Attributes := 0;
end;

ReturnLength := 0; // replaces a var parameter
PrevTokenPriv := TokenPriv;

// enable or disable the privilege

 if AdjustTokenPrivileges(hToken, False, TokenPriv, SizeOf(PrevTokenPriv),PrevTokenPriv, ReturnLength) then
 Result := True
 else
 begin
 errval:= GetLastError;
 Result := errval = 0;
 end;
end;
finally
CloseHandle(hToken);
end;
end;
// test the return value of AdjustTokenPrivileges.
//Result := GetLastError = ERROR_SUCCESS;
if not Result then
raise Exception.Create(SysErrorMessage(errval));
end;
////////////////////////////////////////////////////////////////////////////

function NTSetPrivilege_old(sPrivilege: string; bEnabled: Boolean): Boolean;
var
   hToken: THandle;
   TokenPriv: TOKEN_PRIVILEGES;
   PrevTokenPriv: TOKEN_PRIVILEGES;
   ReturnLength: Cardinal;
begin
   Result := True;
   // Only for Windows NT/2000/XP and later.
   if not (Win32Platform = VER_PLATFORM_WIN32_NT) then Exit;
   Result := False;

   // obtain the processes token
   if OpenProcessToken(GetCurrentProcess(),
     TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
   begin
     try
       // Get the locally unique identifier (LUID) .
       if LookupPrivilegeValue(nil, PChar(sPrivilege),TokenPriv.Privileges[0].Luid) then
       begin
         TokenPriv.PrivilegeCount := 1; // one privilege to set

         case bEnabled of
           True: TokenPriv.Privileges[0].Attributes  := SE_PRIVILEGE_ENABLED;
           False: TokenPriv.Privileges[0].Attributes := 0;
         end;

         ReturnLength := 0; // replaces a var parameter
         PrevTokenPriv := TokenPriv;

         // enable or disable the privilege

         AdjustTokenPrivileges(hToken, False, TokenPriv, SizeOf(PrevTokenPriv),
           PrevTokenPriv, ReturnLength);
       end;
     finally
       CloseHandle(hToken);
     end;
   end;
   // test the return value of AdjustTokenPrivileges.
   Result := GetLastError = ERROR_SUCCESS;
   if not Result then
     raise Exception.Create(SysErrorMessage(GetLastError));
end;

Procedure setBackupPriviledge;
const
  SE_BACKUP_NAME = 'SeBackupPrivilege';
  SE_RESTORE_NAME = 'SeRestorePrivilege';
var
  MainKey: HKey;
  TP, Prev: TTokenPrivileges;
  RetLength: DWORD;
  Token: THandle;
  LUID: TLargeInteger;
  Error: Cardinal;

begin
  // enable restore privilege, must be done before trying to open a registry key with backup/restore option
  if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, Token) then
  begin
  if LookupPrivilegeValue(nil, SE_BACKUP_NAME, LUID) then
  begin
  TP.PrivilegeCount := 1;
  TP.Privileges[0].Luid := LUID;
  TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
  if not AdjustTokenPrivileges(Token, False, TP, SizeOf(TTokenPrivileges), Prev, RetLength) then
   RaiseLastWin32Error;

  // Revoke all privileges this process holds (including backup)
  AdjustTokenPrivileges(Token, True, TP, 0, Prev, RetLength);

  // close handle to process token
  CloseHandle(Token);
  end;
  end;
end;
  function LocalAppDataPath : string;

 const
    SHGFP_TYPE_CURRENT = 0;
 var
    path: array [0..234] of char;
 begin
    SHGetFolderPath(0,CSIDL_PERSONAL,0,SHGFP_TYPE_CURRENT,@path[0]) ;
    Result := path;
 end;
end.
