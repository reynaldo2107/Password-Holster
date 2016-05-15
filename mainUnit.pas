
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

unit mainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.TabControl, FMX.Layouts, FMX.Memo, FMX.Objects, FMX.Edit, FMX.Menus,
  Winapi.Messages, Winapi.Windows;

type
  TfmGetMyPasswprds = class(TForm)
    StyleBook1: TStyleBook;
    SaveDialog1: TSaveDialog;
    tbButtons: TTabControl;
    tbPasswordButtons: TTabItem;
    scrollButtons: TScrollBox;
    Rectangle4Buttons: TRectangle;
    ImageCopied: TImage;
    Rectangle6: TRectangle;
    txtTableSpaceName: TText;
    tbSavedPasswords: TTabItem;
    ScrollPasswords: TScrollBox;
    Rectangle4Passwords: TRectangle;
    Text1: TText;
    Text2: TText;
    Text4: TText;
    Text5: TText;
    Text6: TText;
    Text7: TText;
    Rectangle1: TRectangle;
    Text3: TText;
    btnAdd: TButton;
    imageTBSDirty: TImage;
    btnSave: TButton;
    CheckBoxAll: TCheckBox;
    MainMenu1: TMainMenu;
    MenuFiles: TMenuItem;
    MenuHelp: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    OpenDialog1: TOpenDialog;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    Image1: TImage;
    Timer2: TTimer;
    MenuItem9: TMenuItem;
    Text8: TText;
    Text9: TText;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    InitialTipBox: TCalloutPanel;
    Text10: TText;
    StyleBook2: TStyleBook;
    Text12: TText;
    Text13: TText;
    MenuWindows: TMenuItem;
    MenuItemNewGroup: TMenuItem;
    MenuItemRenameGroup: TMenuItem;
    MenuItemDeleteGroup: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem12: TMenuItem;
    Edit1: TClearingEdit;
    Image135: TImage;
    Text11: TText;
    MenuItem13: TMenuItem;
    procedure OnClickToGetPassword (Sender: TObject);
    procedure OnEditControlChange (Sender: TObject);
    procedure OnLocalCheckBoxChange (Sender: TObject);
    procedure OnLocalCheckBoxClick (Sender: TObject);
    procedure OnGroupMenuClick (sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure CheckBoxAllChange(Sender: TObject);
    procedure TabMove (Sender: TObject; var Key: Word;   var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure CheckBoxAllClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure tbButtonsClick(Sender: TObject);
    procedure tbPasswordButtonsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItemNewGroupClick(Sender: TObject);
    procedure MenuItemRenameGroupClick(Sender: TObject);
    procedure MenuItemDeleteGroupClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Edit1Typing(Sender: TObject);
{$IFDEF MSWINDOWS}
  private
    NextInChain: HWND;
    clipBrdCounter:integer;
    noChnageToDo: boolean; //  to manage the check box "see all"
    has_exported, has_changed: boolean;
    currentGroup: string;
    procedure ClipboardUpdated;
    protected
    procedure CreateHandle; override;
    procedure DestroyHandle; override;
  {$ENDIF}
  var
  goingThruAllCheckBoxes: boolean;
//  b_local_checkBox_go: boolean;

  function  AllCheckBoxesAreChecked: boolean;
  procedure addpairOfButtons(order: integer; userName, passwordValue: string);
  function  maxpasswords: integer;
  procedure DeleteControlIfExists(controlname: string);
  function EnDeCrypt(const Value : String) : String;
  procedure ExportKey;
  procedure ImportKey;
  function RefershRegistryAfterImport: integer ;
  procedure SavePasswords;
  function GetPasswordforBox(k:integer): string;
  procedure initializeButtons1(aGroup: string; all: boolean);
  procedure ScanGroups;
  function  ScanGroupsS: TStringList;
  procedure changePasswordOnRegistryGroup (aGroup, prevousPassword: string);
  function  GetLastUsedGroup: string;
  procedure SetLastUsedGroup(aGroup: string);
  procedure DeleteButtons1;
  procedure DeleteButtons2;
  procedure ShowLoggingBox;
  procedure ShowPasswordForgotten;
  procedure UncheckAllViewedPasswords;
  procedure CheckMenuItem(menuItemName: string);
  function  AddUserName( Px ,serverName, apassword: string  ):boolean;
  function SaveNewGroup( aGroup: string): boolean;
  function GroupExists(aGroup: string): boolean;
  procedure AntiSearchButtonLabel (lookingFor: string);
    { Private declarations }
  public
  const
     constKey = 'Condition Initial to be replaced 3457@!';
     applicationCaption = 'Password Holster';

     // do not do  max_counter2disableViewPasssword   >  max_counter2disable
     { Public declarations }
  end;
const
registriconst:string = 'Software\gdbt\sweetkeeper';
var
  fmGetMyPasswprds: TfmGetMyPasswprds;
  personalKey: string;
  NextInChain : THandle;
  max_counter2disable: integer  ;
  max_counter2disableViewPasssword: integer  ;
    glb_counter, glb_counter4ViewPassword: integer;
implementation


{$R *.fmx}
uses
{$IFDEF MSWINDOWS}
  System.Win.Registry,  shellapi,
  Vcl.Clipbrd,
   CommCtrl
{$ENDIF}
, FMX.platform.Win, encrypting, PasswordForm, PasswordFormForgotPassword,
 about, PasswordChange , NT_utils, unitHelp, groupName_newName, userPreferences,
  Credits;
const MaximumAllowedPasswords = 40;



function DeleteDatabaseFromRegistry(adbName: string ):boolean;
var bKeyExist: boolean;
begin
 with TRegistry.Create do
 begin
  Result:= true;
  RootKey := HKEY_CURRENT_USER;
  bKeyExist:= OpenKey (registriconst + '\' + adbName, false);
   if bKeyExist then
    begin
     CloseKey;
       if  not DeleteKey(registriconst + '\' + adbName) then
        begin
          ShowMessage('The system could not delete the registry key');
          Result:= false;
        end;
    end;
    Free;
 end;
end;


function TfmGetMyPasswprds.GroupExists(aGroup: string): boolean;
var i: integer;
begin
 Result:= false;
 for i := 0 to fmGetMypasswprds.MenuWindows.ItemsCount - 1  do
   if TMenuItem(fmGetMypasswprds.MenuWindows.Items[i]).Text = trim(aGroup) then
    begin
      Result:= true;
      break;
    end;
end;


function  TfmGetMyPasswprds.AddUserName( Px ,serverName, apassword: string  ):boolean;


 begin
 with TRegistry.Create do
 begin
  Result:= true;
  RootKey := HKEY_CURRENT_USER;
  if OpenKey(registriconst + '\' + currentGroup + '\' + Px, True) then
  begin

     WriteString('Username', serverName );
     if (apassword <> '' )then
     begin
     WriteString('Password', apassword );
     end;
     closeKey;
  end else
    begin
     Result:= false;
     Free;
     exit;
    end;
   Free;
 end;
end;

/////////////////////////////////////////////////////////////////////////

procedure TfmGetMyPasswprds.DeleteControlIfExists(controlname: string);
var i:integer;
begin

  for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
  begin
  if (Rectangle4Passwords.Children[i] is TEdit) then
   if Tedit(Rectangle4Passwords.Children[i]).Name = controlname then
    Rectangle4Passwords.Children[i].Free;
  end;
end;
function TfmGetMyPasswprds.maxpasswords: integer;
var i: integer;
labValue: string;

begin
Result:=0;
  for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
  begin
  if (Rectangle4Passwords.Children[i] is TEdit) then
  labValue :=(Rectangle4Passwords.Children[i] as TEdit).Name;

    if (Rectangle4Passwords.Children[i] is TEdit)  and
    (Copy((Rectangle4Passwords.Children[i] as TEdit).Name, 1, 8) = 'edtLabel')
   then
    Inc(result);
  end;
end;

procedure TfmGetMyPasswprds.MenuItem10Click(Sender: TObject);
begin
 if fmHelp = nil then
 fmHelp:= Tfmhelp.Create(nil);
 try
 fmHelp.ShowModal;

 finally
  fmHelp.Free;
  fmHelp:= nil;
 end;
end;

procedure TfmGetMyPasswprds.MenuItem11Click(Sender: TObject);
begin
if fmCredits = nil then
  fmCredits:= TfmCredits.Create(self);
  fmCredits.showModal;
  fmCredits.Free;
  fmCredits:= nil;
end;

procedure TfmGetMyPasswprds.MenuItem1Click(Sender: TObject);
begin
 if fmuserPreferences = nil then
  fmuserPreferences:= TfmuserPreferences.create(self);
  fmuserPreferences.showModal;
  fmuserPreferences.free;
  fmuserPreferences:= nil;
end;

procedure TfmGetMyPasswprds.MenuItemNewGroupClick(Sender: TObject);
var T: TMenuItem;
x: string;
begin
 try
 fmGroupName:= TfmGroupName.Create(self);
 fmGroupName.action:= 'New';
  if fmGroupName.ShowModal = mrOk then
   begin
    x:= trim(fmGroupName.edtGroupName.Text);
     if not SaveNewGroup(x) then
       begin
         ShowMessage('The application could not create a new group ' + x + '.');
         exit;
       end;
     DeleteDatabaseFromRegistry(currentGroup);
     SavePasswords;
     DeleteButtons1;
     DeleteButtons2;
     tbButtons.ActiveTab:= tbSavedPasswords;
     InitialTipBox.Visible:= true;

     T:= TMenuItem.Create(nil);
     T.Name:= 'TMenuItemGroup_' + StringReplace(x, ' ' ,'', [rfReplaceAll, rfIgnoreCase]);
     T.Text:=x;
     T.OnClick:= OnGroupMenuClick;
     MenuWindows.AddObject(T);
     T.IsChecked:= true;
     currentGroup:= T.Text;
     checkMenuItem(currentGroup);
     self.Caption:= applicationCaption + ' [group: ' + x + ']';
   end;
 finally
  fmGroupName.free;
  fmGroupName:= nil;
 end;
end;
function TfmGetMyPasswprds.SaveNewGroup( aGroup: string): boolean;
begin
Result:= true;
  with TRegistry.Create do
   begin
   RootKey := HKEY_CURRENT_USER;
   if not OpenKey(registriconst + '\' + aGroup , True) then
      Result:= false;
   Free;
 end;

end;
procedure TfmGetMyPasswprds.MenuItem3Click(Sender: TObject);
begin
if glb_Counter >= max_counter2disable then
  begin
         try
          fmPassword:= TfmPassword.create(self);
           if fmPassword.showmodal = mrOk   then
            begin
             tbSavedPasswords.Enabled:= true;
//             tbButtons.ActiveTab:= tbSavedPasswords;
             glb_counter:= 0;
            end else exit;
         finally
           fmPassword.Free;
           fmPassword:= nil;
         end;
  end;

if has_changed then
  SavePasswords;
if not has_exported then
  if  MessageDlg('Importing a file will replace  existing group if it already exists.'#13#10 +
  'Do you want to continue?', TMsgDlgType.mtConfirmation, mbYesNo,0) <> mrYes then
   exit;
  ImportKey;
end;

procedure TfmGetMyPasswprds.MenuItem4Click(Sender: TObject);
begin  if glb_Counter >= max_counter2disable then
  begin
         try
          fmPassword:= TfmPassword.create(self);
           if fmPassword.showmodal = mrOk   then
            begin
             tbSavedPasswords.Enabled:= true;
//             tbButtons.ActiveTab:= tbSavedPasswords;
             glb_counter:= 0;
            end else exit;
         finally
           fmPassword.Free;
           fmPassword:= nil;
         end;
  end;

ExportKey;
end;

procedure TfmGetMyPasswprds.MenuItem6Click(Sender: TObject);
begin
Close;
end;


procedure TfmGetMyPasswprds.MenuItem7Click(Sender: TObject);
var
slGroups: TstringList;
i: integer;
prevousPassword: string;
begin
if glb_Counter >= max_counter2disable then
  begin
         try
          fmPassword:= TfmPassword.create(self);
           if fmPassword.showmodal = mrOk   then
            begin
             tbSavedPasswords.Enabled:= true;
//             tbButtons.ActiveTab:= tbSavedPasswords;
             glb_counter:= 0;
            end else exit;
         finally
           fmPassword.Free;
           fmPassword:= nil;
         end;
  end;

 prevousPassword:= personalKey;
 if fmPasswordChange = nil then
  fmPasswordChange:= TfmPasswordChange.Create(nil);
  if fmPasswordChange.ShowModal = mrOk  then
   begin
     slGroups:= ScanGroupsS;
      for i := 0 to slGroups.Count - 1 do
       begin
         if slGroups[i] <> 'validation' then
         begin
           changePasswordOnRegistryGroup(slGroups[i], prevousPassword);
         end;
       end;
//       DeleteButtons1;
//     initializeButtons1(currentGroup, false);
     ShowMessage('The password has been successfully changed for the existing ' + IntTostr(slGroups.Count -1) + ' data groups');
   end;
  slGroups.Free;
  fmPasswordChange.Free;
  fmPasswordChange:= nil;
end;
procedure TfmGetMypasswprds.changePasswordOnRegistryGroup(aGroup, prevousPassword: string);
var
Reg, Reg2: TRegistry;
S: tstringList;
i: integer;
x: string;
thispassword: string;
begin
  try
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(registriconst + '\' + aGroup+ '\', False) then
    begin
      S := TStringList.Create;
      try
        reg.GetKeyNames(S);

        for i := 0 to S.Count - 1 do
        begin
    //   x:= registriconst + '\data\'  + s[i];
         x:= registriconst + '\' + aGroup + '\'  + 'Px' + IntToStr(i);
         try
         Reg2 := TRegistry.Create;
         if Reg2.OpenKey( x, False) then
          begin
          thispassword:= Decrypt(Reg2.ReadString('Password'), prevousPassword );
          Reg2.WriteString('Password', Encrypt(thispassword,personalKey));
      //     Reg2.WriteString('password);

          end;   // not import_going_out and not import_delete_Data then
         finally
           Reg2.CloseKey;
           Reg2.Free;
         end;

        end;
      finally
        S.Free;
      end;
      Reg.CloseKey;
    end //if Reg.OpenKey(
  finally
    Reg.Free;
  end; // first try

end;

function TfmGetMypasswprds.ScanGroupsS: TStringList;
var
  Reg: TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(registriconst, False) then
    begin
      Result := TStringList.Create;
      try
        reg.GetKeyNames(Result);
      finally
       Reg.CloseKey;
       Reg.Free;
      end; // Reg.OpenKey(registriconst, False)
    end;
end;

procedure TfmGetMyPasswprds.MenuItem8Click(Sender: TObject);
begin
importKey;
end;

Function SetAccessPrivilege(Const PrivilegeStr : String; State : Integer):Integer;
Var
  hToken : THandle;
  aluid : TLargeInteger;
  cbPrevTP : DWORD;
  tp, fPrevTP : PTokenPrivileges;
Begin
  result := 0;
  If OpenProcessToken (GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES Or
      TOKEN_QUERY, hToken) Then
  Try
    LookupPrivilegeValue (Nil, PChar (PrivilegeStr), aluid);
    cbPrevTP := SizeOf (TTokenPrivileges) + sizeof (TLUIDAndAttributes);
    GetMem (tp, cbPrevTP);
    GetMem (fPrevTP, cbPrevTP);
    Try
      tp^.PrivilegeCount := 1;
      tp^.Privileges [0].Luid := aLuid;
      tp^.Privileges [0].Attributes := State;
      If Not AdjustTokenPrivileges (hToken, False, tp^, cbPrevTP, fPrevTP^, cbPrevTP) Then
        RaiseLastWin32Error;
      Result := fPrevTP^.Privileges [0].Attributes;
    Finally
      FreeMem (fPrevTP);
      FreeMem (tp);
    End
  Finally
   CloseHandle (hToken);
  End
End;

procedure TfmGetMyPasswprds.MenuItem9Click(Sender: TObject);
begin
if fmAbout = nil then
  fmAbout:= TfmAbout.create(self);
  fmAbout.showModal;
  fmAbout.free;
  fmAbout:= nil;
end;

procedure TfmGetMyPasswprds.MenuItemDeleteGroupClick(Sender: TObject);  var i: integer;
begin
 if MessageDlg('Deleting a Group will delete all its passwords.'#10#13 +
 'Are you sure you want to proceed deleting group ' + currentGroup + '?',  TMsgDlgType.mtConfirmation, mbYesNo,0) <> mrYes   then
 exit;
DeleteDatabaseFromRegistry(currentGroup);
           DeleteButtons2;
           DeleteButtons1;
if MenuWindows.ItemsCount > 0 then
 begin
   for i := 0 to MenuWindows.ItemsCount -1  do
     if TmenuItem(MenuWindows.items[i]).text = currentGroup then
     begin
      MenuWindows.RemoveObject(MenuWindows.items[i]);
      TmenuItem(MenuWindows.items[i]).Free;
      break;
     end;
       if MenuWindows.ItemsCount > 0 then
        begin
           currentGroup:= TmenuItem(MenuWindows.items[0]).text;
           DeleteButtons2;
           DeleteButtons1;
           initializeButtons1(currentGroup, true);
           Self.Caption:= applicationCaption + ' [group: ' + currentGroup + ']';
           tbButtons.ActiveTab:= tbPasswordButtons;
           glb_counter:= 0;
        end;
 end;
end;

procedure TfmGetMyPasswprds.MenuItemRenameGroupClick(Sender: TObject);
procedure RenameMenuItem(newName:string);
var i: integer;
begin
  for i := 0 to MenuWindows.ItemsCount -1 do
    if TmenuItem(MenuWindows.Items[i]).Text = currentGroup then
     begin
        TmenuItem(MenuWindows.Items[i]).Text := newName;
        break;
     end;
end;
var T: TMenuItem;
x: string;
begin
 try
 fmGroupName:= TfmGroupName.Create(self);
 fmGroupName.action:= 'Rename';
 fmGroupName.edtGroupName.Text:= currentGroup;
 fmGroupName.edtGroupName.SelectAll;
  if fmGroupName.ShowModal = mrContinue then
   begin
     DeleteDatabaseFromRegistry(currentGroup);
     x:= trim(fmGroupName.edtGroupName.Text);
     RenameMenuItem(x);
     currentGroup:= x;
     Self.Caption:= applicationCaption + ' [group: ' + currentGroup + ']';
     SavePasswords;
  //   checkMenuItem(currentGroup);
   end;
 finally
  fmGroupName.free;
  fmGroupName:= nil;
 end;
end;


procedure TfmGetMyPasswprds.btnAddClick(Sender: TObject);
begin
if maxpasswords <= MaximumAllowedPasswords - 1 then
 addpairOfButtons(maxpasswords, '','');
 InitialTipBox.Visible:= false;
end;

procedure TfmGetMyPasswprds.addpairOfButtons(order: integer; userName, passwordValue: string);
const
altura = 30;
posx1 =136;
posx2 =288;
posy1 =33;
posy2 =33;
Width1 =143;
width2 =114;
col1Posx1 = 32;
PosY = 30;
var
NewPosX, NewPosY: single;
xx, yy: single;
//MaxSoFar:integer;
name4theButton1, name4theButton2: string;
begin

   name4theButton1:='edtLabel' + IntToStr(order);
   name4theButton2:= 'edtPassword' + IntToStr(order);
               if (order <= 9) then
                begin
                xx:= col1Posx1;
                yY:= PosY + order * 45
                end  else  if (order > 9) and (order <= 19) then
                begin
                xx:= col1Posx1 + 350 * 1;
                yY:= PosY + (order -10) * 45;
                Text4.Visible:= true;
                Text5.visible:= true;
                end else  if (order > 19) and (order <= 29) then
                begin
                xx:= col1Posx1 + 350 * 2 ;
                yY:= PosY + (order -20) * 45;
                Text6.Visible:= true;
                Text7.visible:= true;
                end else  if (order > 29) and (order <= 39) then
                begin
                xx:= col1Posx1 + 350 * 3 ;
                yY:= PosY + (order -30) * 45 ;
                Text8.Visible:= true;
                Text9.visible:= true;
                end;
                 with TEdit.Create(Rectangle4Passwords) do begin
                 parent:= Rectangle4Passwords;
                 name:= name4theButton1;
                 Text:= userName;
                 Position.X:= xx;
                 Position.Y:= yy;
                 Width:= Width1;
                 Visible:= true;
               //  Height:= 30;

                 TabOrder:= order * 2;
                 OnKeyUp:= TabMove;
                 OnChange:= OnEditControlChange;
                 OnTyping:= OnEditControlChange;
                 setFocus;
               end;

               with TEdit.Create(Rectangle4Passwords) do begin
                 parent:= Rectangle4Passwords;
                 name:= name4theButton2;
                 Position.X:= xx + 150;
                 Password:=true;
                 Text:= passwordValue;
                 Position.Y:= yy;
                 Width:= Width2;
                 Visible:= true;
                 tabOrder:= order * 2 + 1;
                 OnKeyUp:= TabMove;
                 OnChange:= OnEditControlChange;
                 OnTyping:= OnEditControlChange;
               end;

              with TCheckBox.Create(Rectangle4Passwords) do begin
               parent:= Rectangle4Passwords;
               name:= name4theButton2 + 'chk';
               Position.X:= xx + Width1 + Width2 + 10;
               Text:= 'Show';
               Position.Y:= yy;
               Width:= 100;
               Visible:= true;
               OnChange := OnLocalCheckBoxChange;
               OnClick:= OnLocalCheckBoxClick;
             end;
 CheckBoxAll.OnChange:= nil;
 CheckBoxAll.IsChecked:= false;
  CheckBoxAll.OnChange:= CheckBoxAllChange;
end;

procedure TfmGetMyPasswprds.btnSaveClick(Sender: TObject);

begin
DeleteButtons1;
DeleteDatabaseFromRegistry(currentGroup);
SavePasswords;
initializeButtons1(currentGroup, false);
ShowMessage('Passwords have been saved for group ' + currentGroup + '. Go to tab "Get Psswords" to see the changes');
(sender as Tbutton).Enabled:= false;
end;
function TfmGetMyPasswprds.GetPasswordforBox(k:integer): string;
var i: integer;
begin
   for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
  begin
    if (Rectangle4Passwords.Children[i] is TEdit)  and
     (TEdit(Rectangle4Passwords.Children[i]).Name ='edtPassword' + IntToStr(k)) then
     result:= TEdit(Rectangle4Passwords.Children[i]).Text;
  end;
end;

procedure TfmGetMyPasswprds.SavePasswords;
var i, order: integer;
thisBoxNumber: integer;
passwordValue,passwordName: string;
begin
order:= -1;
  for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
  begin
    if (Rectangle4Passwords.Children[i] is TEdit)  and
    (Copy((Rectangle4Passwords.Children[i] as TEdit).Name, 1, 8) = 'edtLabel') and
    (Trim(TEdit(Rectangle4Passwords.Children[i]).Text) <> '') then
     begin
     inc(order);
       thisBoxNumber:= StrToInt(Copy((Rectangle4Passwords.Children[i] as TEdit).Name, 9,
       length(TEdit(Rectangle4Passwords.Children[i]).name))) ;
       passwordName:=TEdit(Rectangle4Passwords.Children[i]).Text;
       passwordValue:= GetPasswordforBox(thisBoxNumber);
   //    AddUserName( 'Px' + IntToStr(thisBoxNumber) ,
        AddUserName( 'Px' + IntToStr(order) ,
          passwordName, Encrypt(passwordValue,personalKey) );
     end;
  end;
  has_changed:= false;
  has_exported:= false;
end;

procedure TfmGetMyPasswprds.ExportKey;
var
RootKey,phKey: hKey;
 handle: Hwnd;
KeyName,sKeyFileName: String;
FileName: array [0..255] of char;
k: integer;
begin
  SaveDialog1.InitialDir:=  LocalAppDataPath;
  SaveDialog1.Title:= 'Save Password File';
  SaveDialog1.Filter:='SweetKeeper Files (*.spass)|*.spass';
  SaveDialog1.FileName:= currentGroup;
  if SaveDialog1.Execute then
     sKeyFileName:= SaveDialog1.FileName else
     exit;
  if FileExists(sKeyFileName) then
     DeleteFile(PChar(sKeyFileName));
  if not NTSetPrivilege('SeBackupPrivilege',true) then
  begin
   ShowMessage('To save Password information you must close this application and run it as Administrator.');
   exit;
  end;
  // save any change befor exporting

  ShellExecute(0,nil, 'regedit.exe', Pchar('/e "' + sKeyFileName + '" "HKEY_CURRENT_USER\software\gdbt\sweetkeeper\' + currentGroup + '" '),nil, sw_hide);
  NTSetPrivilege('SeBackupPrivilege',false);
  ShowMessage('Your password data have been saved in ' +  sKeyFileName + '. '#13#10 + #13#10 +
  'Remember: When importing this file back in, you must be logged in with the same password key used to export the file.');
  has_exported:= true;
  exit;

{
  SaveDialog1.InitialDir:= 'c:/temp'; // LocalAppDataPath;
  SaveDialog1.Title:= 'Open Password Files';
  SaveDialog1.Filter:='SweetKeeper Files (*.passw)|*.passw';
  if SaveDialog1.Execute then
     sKeyFileName:= SaveDialog1.FileName else
     exit;
  if FileExists(sKeyFileName) then
       DeleteFile(PChar(sKeyFileName));

   RootKey := HKEY_CURRENT_USER;
   sKeyFileName:= 'c:\temp\test';
   KeyName := registriconst + '\data';
   RegOpenKeyEx(RootKey, PChar(KeyName), 0, KEY_ALL_ACCESS, phKey);
   StrPCopy(FileName,sKeyFileName); //or use pchar
  if RegSaveKey(phKey, FileName, nil)= 0 then
  ShowMessage('Password information saved.')
  else
  begin
    if FileExists(sKeyFileName) then
       DeleteFile(PChar(sKeyFileName));
   ShowMessage('To save Password information you must close this program and run it as Administrator');
  end;
   RegCloseKey(phKey);
   NTSetPrivilege('SeBackupPrivilege',false)
   }
 { reg := TRegistry.Create;
  try
  reg.RootKey := HKEY_CURRENT_USER;

  if reg.OpenKey(registriconst,false) then
  begin
   if not reg.SaveKey(registriconst,'c:\temp\test') then
     if FileExists('c:\temp\test') then
       DeleteFile('c:\temp\test');
  end;

  finally
    reg.Free;
  end;
     }
  
end;
function TfmGetMyPasswprds.RefershRegistryAfterImport: integer;
var Reg:TRegistry;
S: TstringList;
i :integer;
begin
   try
    Result:=0;
    Reg:=TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(registriconst + '\' + currentgroup , False) then
    begin
      S := TStringList.Create;

        reg.GetKeyNames(S);

        for i := 0 to S.Count - 1 do
         inc(Result);
         S.Free;
     end;
    finally

    Reg.CloseKey;

    reg.Free;

   end;
end;


procedure TfmGetMyPasswprds.ImportKey;
var
RootKey,phKey: hKey;
handle: Hwnd;
KeyName,sKeyFileName, previousgroup: String;
FileName: array [0..255] of char;
Sless, SMore: TstringList; // used to find the name of the imported group
T: Tmenuitem;
begin
try
  SaveDialog1.InitialDir:=  LocalAppDataPath;
  SaveDialog1.Title:= 'Import Password File';
  SaveDialog1.Filter:='SweetKeeper Files (*.spass)|*.spass';
  if SaveDialog1.Execute then
     sKeyFileName:= SaveDialog1.FileName else
     exit;
 if not (NTSetPrivilege('SeRestorePrivilege',true)  and NTSetPrivilege('SeBackupPrivilege',true)) then
  begin
   ShowMessage('To Restore Password information you must close this program and run it as Administrator');
   exit;
  end;

//  DeleteDatabaseFromRegistry(currentGroup);
  sless:=ScanGroupsS;
  ShellExecute(0,nil, 'regedit.exe', Pchar('/s "' + sKeyFileName + '"   '),nil, sw_hide);
  NTSetPrivilege('SeRestorePrivilege',false) ;
  showMessage({intTostr(RefershRegistryAfterImport) +}
  'Passwords have been imported. Choose the desired group of passwords in the menu Groups');
  //close;
  smore:= ScanGroupsS;
  previousgroup:= currentGroup;
  currentGroup:= GetImportedGroupName(sless,smore);
  if currentGroup = '' then
   currentGroup:= previousgroup;
   if not GroupExists (currentGroup) then
    begin
     T:= TmenuItem.Create(nil);
     T.Name:= 'TMenuItemGroup_' + StringReplace(currentGroup, ' ' ,'', [rfReplaceAll, rfIgnoreCase]);
     T.Text:=currentGroup;
     T.OnClick:= OnGroupMenuClick;
     MenuWindows.AddObject(T);
    end;
     checkMenuItem(currentGroup);
     DeleteButtons2;
     DeleteButtons1;
     initializeButtons1(currentGroup, true);
     Self.Caption := applicationCaption + ' [group: ' + currentGroup + ']';
     tbButtons.ActiveTab:= tbPasswordButtons;
     glb_counter:= 0;
finally
   sless.Free;
   smore.Free;
end;
end;
//  showMessage(intTostr(RefershRegistryAfterImport));




 // DeleteButtons;
//  DeleteButtons2;                                                                                       '
//  initializeButtons1(true);

{
 if not NTSetPrivilege('SeRestorePrivilege',true) then
  begin
   ShowMessage('To Restore Password information you must close this program and run it as Administrator');
   exit;
  end;
  sKeyFileName := 'tempReg';
  SaveDialog1.InitialDir:= 'c:\temp';
  if SaveDialog1.Execute then
     sKeyFileName:= SaveDialog1.FileName else
     exit;
        DeleteDatabaseFromRegistry('data');
   RootKey := HKEY_CURRENT_USER;
   sKeyFileName:= 'c:\temp\test';
   KeyName := registriconst + '\data';
   RegOpenKeyEx(RootKey, PChar(KeyName), 0, KEY_ALL_ACCESS, phKey);
   StrPCopy(FileName,sKeyFileName); //or use pchar
   err:=  RegRestoreKey(phKey, FileName,0);
  if err = 0 then
  ShowMessage('Password information Restore.')
  else
  begin

   ShowMessage(SysErrorMessage(err) );
   ShowMessage('To Restore Password information you must close this program and run it as Administrator');
  end;
   RegCloseKey(phKey);
   NTSetPrivilege('SeRestorePrivilege',false) ;

 }

 {
   begin
   if not( NTSetPrivilege('SeRestorePrivilege',true) and NTSetPrivilege('SeBackupPrivilege',true)
   ) then
    begin
     ShowMessage('To Restore Password information you must close this program and run it as Administrator');
     exit;
    end;
  OpenDialog1.InitialDir:= 'c:\temp' ;// LocalAppDataPath;
  OpenDialog1.Title:= 'Open';
  OpenDialog1.Filter:='SweetKeeper Files (*.passw)|*.passw';
  if OpenDialog1.Execute then
     sKeyFileName:= OpenDialog1.FileName else
     exit;

  if not FileExists(sKeyFileName) then
  begin
    showmessage('file not existe');
    exit;
  end;

   reg := TRegistry.Create;
  try
  reg.RootKey := HKEY_CURRENT_USER;

  if reg.OpenKey(registriconst + '\data' ,false) then
  begin
  reg.CloseKey;
  if not reg.DeleteKey(registriconst + '\data') then
  ShowMessage('Error: ' + SysErrorMessage(reg.LastError));
  end;
  reg.Access:=KEY_ALL_ACCESS;
   if not reg.RestoreKey(registriconst + '\data', sKeyFileName) then
   begin
     case reg.LastError of
      0: ShowMessage('Password Information Restored Successfuly');
      5, 1314: ShowMessage('To Restore Password Information you must Run this Program as Administrator')
      else
      ShowMessage('Error: ' + SysErrorMessage(reg.LastError));
     end;

    end;

  finally
    reg.Free;
    NTSetPrivilege('SeRestorePrivilege',false) ; NTSetPrivilege('SeBackupPrivilege',false)
  end;

  end;  }

procedure TfmGetMyPasswprds.UncheckAllViewedPasswords;
var
  i: Integer;
begin
//if noChnageToDo then
//exit;
//glb_counter:=0;
 goingThruAllCheckBoxes:= true;
  for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
   if (Rectangle4Passwords.Children[i] is TCheckBox) then
    if TCheckBox(Rectangle4Passwords.Children[i]).IsChecked then
         TCheckBox(Rectangle4Passwords.Children[i]).IsChecked:= false;
end;

procedure TfmGetMyPasswprds.CheckBoxAllChange(Sender: TObject);
var
  i: Integer;
begin
if noChnageToDo then
exit;
//glb_counter:=0;
 goingThruAllCheckBoxes:= true;
  for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
   if (Rectangle4Passwords.Children[i] is TCheckBox) then
      TCheckBox(Rectangle4Passwords.Children[i]).IsChecked := TcheckBox(sender).IsChecked;
 goingThruAllCheckBoxes:= false;
end;

procedure TfmGetMyPasswprds.CheckBoxAllClick(Sender: TObject);
begin
  if not CheckBoxAll.IsChecked  then
    begin
    noChnageToDo:= false;
    glb_counter4ViewPassword:=0;
    glb_counter:=0;
    try
     fmPassword:= TfmPassword.create(self);
      if fmPassword.showmodal <> mrOk  then
       begin
        noChnageToDo:= true;
        CheckBoxAll.IsChecked := not CheckBoxAll.IsChecked;
       end;
    finally
      fmPassword.Free;
    end;
  end;
end;

procedure TfmGetMyPasswprds.TabMove (Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
  var no:string;
  i: integer;
begin
  if key  = 9 then
  begin
     if Copy(Tedit(sender).Name, 1 , length('edtlabel') ) = 'edtLabel'  then
    begin
     no:= Copy(Tedit(sender).Name, length('edtLabel') + 1, length(Tedit(sender).Name) - length('edtLabel'));
      for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
       begin 
         if (Rectangle4Passwords.Children[i] is Tedit) and (Tedit(Rectangle4Passwords.Children[i]).Name = 'edtPassword' + no) 
          then
          Tedit(Rectangle4Passwords.Children[i]).SetFocus;
       end;
    end;

     if Copy(Tedit(sender).Name, 1 , length('edtPassword') ) = 'edtPassword'  then
    begin
     no:= Copy(Tedit(sender).Name, length('edtPassword') + 1, length(Tedit(sender).Name) - length('edtPassword'));
      for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
       begin 
       if strToInt(no) = maxpasswords -1 then
            no:='-1';
         if (Rectangle4Passwords.Children[i] is Tedit) and (Tedit(Rectangle4Passwords.Children[i]).Name = 'edtLabel' + 
         IntToStr(StrToInt(no) + 1)) 
          then
          Tedit(Rectangle4Passwords.Children[i]).SetFocus;
       end;
    end;

  end;
end;
procedure TfmGetMyPasswprds.tbButtonsClick(Sender: TObject);
begin
 if glb_Counter >= max_counter2disable
  then
  begin
         try
          fmPassword:= TfmPassword.create(self);
           if fmPassword.showmodal = mrOk   then
            begin
             tbSavedPasswords.Enabled:= true;
             tbButtons.ActiveTab:= tbSavedPasswords;
             glb_counter:= 0;
             glb_counter4ViewPassword:= 0;
            end;
         finally
           fmPassword.Free;
           fmPassword:= nil;
         end;
  end;
end;

procedure TfmGetMyPasswprds.tbPasswordButtonsClick(Sender: TObject);
begin
 UncheckAllViewedPasswords;
end;

procedure TfmGetMyPasswprds.Timer1Timer(Sender: TObject);
begin
//b_local_checkBox_go:= false;
//timer1.Enabled:= false;
if CheckBoxAll.IsChecked then
CheckBoxAll.IsChecked := false else
CheckBoxAll.OnChange(self);
end;

procedure TfmGetMyPasswprds.Timer2Timer(Sender: TObject);
begin
Inc(glb_counter);
if glb_Counter >= max_counter2disable then
  begin
    tbSavedPasswords.Enabled:= false;
    tbButtons.ActiveTab:= tbPasswordButtons;
  end;
  inc(glb_counter4ViewPassword);
  if glb_counter4ViewPassword >= max_counter2disableViewPasssword then
    begin
     UncheckAllViewedPasswords;
     if CheckBoxAll.IsChecked then
       CheckBoxAll.IsChecked:= false;
    end;
end;
procedure TfmGetMyPasswprds.OnEditControlChange(Sender: TObject);
begin
  btnSave.enabled:= true;
  has_changed:= true;
  glb_counter:= 0;
end;
procedure TfmGetMyPasswprds.OnClickToGetPassword (Sender: TObject);
 var y: string;
 i: integer;

begin
 // ShowMessage('Copied password for " ' + (Sender as Tbutton).StyleName);

 if glb_Counter >= max_counter2disable then
  begin
         try
          fmPassword:= TfmPassword.create(self);
           if fmPassword.showmodal <> mrOk  then
            begin
             exit;
            end;
         finally
           fmPassword.Free;
           fmPassword:= nil;
         end;
  end;
  with Tmemo.Create(nil) do
   begin
     text:= (Sender as Tbutton).StyleName;
     selectall;
     CopyToClipboard;
     clipBrdCounter:= 0;
     ImageCopied.Opacity:= 1;
     free;
   end;
       ImageCopied.Position.X:= Tbutton(sender).Position.X + Tbutton(sender).Width ;
       ImageCopied.Position.Y:= Tbutton(sender).Position.Y + 5;
       ImageCopied.Visible:= true;
       glb_counter:= 0;
       glb_counter4ViewPassword:= 0;
       tbSavedPasswords.Enabled:= true;
end;
procedure TfmGetMyPasswprds.OnLocalCheckBoxClick (Sender: TObject);
begin

 if (glb_counter4ViewPassword >= max_counter2disableViewPasssword) and
   ( not Tcheckbox(Sender).IsChecked)    then
  begin
    try
     fmPassword:= TfmPassword.create(self);
      if fmPassword.showmodal <> mrOk  then
       begin
        Tcheckbox(Sender).IsChecked := not Tcheckbox(Sender).IsChecked;
        exit;
       end else
       begin
        glb_counter4ViewPassword:= 0;
        glb_counter:= 0;
       end;
    finally
      fmPassword.Free;
    end;
  end else
   begin
    glb_counter4ViewPassword:=0;
    glb_counter:= 0;
   end;
end;

procedure TfmGetMyPasswprds.OnLocalCheckBoxChange (Sender: TObject);
var i: integer;
passedtboxName: string;
begin
 passedtboxName:= Tcheckbox(Sender).Name;
 passedtboxName:= copy(passedtboxName, 1, length(passedtboxName) -3);

 for i := 0 to Rectangle4Passwords.ChildrenCount -1 do
  begin
    if (Rectangle4Passwords.Children[i] is TEdit)  and
     (TEdit(Rectangle4Passwords.Children[i]).Name =passedtboxName)   then
      TEdit(Rectangle4Passwords.Children[i]).Password:= not Tcheckbox(Sender).IsChecked;
  end;
  if not goingThruAllCheckBoxes then
    begin
      CheckBoxAll.OnChange:= nil;
      CheckBoxAll.IsChecked:=  AllCheckBoxesAreChecked;
      CheckBoxAll.OnChange:= CheckBoxAllChange;
    end;
end;

function TfmGetMyPasswprds.AllCheckBoxesAreChecked: boolean;
var i: integer;
begin
 Result:= true;
 for i := 0 to Rectangle4Passwords.ChildrenCount -1  do
  if (Rectangle4Passwords.Children[i] is TCheckBox) and not (TCheckBox(Rectangle4Passwords.Children[i]).IsChecked) then
    begin
      Result:= false;
      break;
    end;
end;
procedure TfmGetMyPasswprds.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
SetLastUsedGroup (currentGroup);
end;

procedure TfmGetMyPasswprds.FormCreate(Sender: TObject);
begin
tbButtons.ActiveTab:= tbPasswordButtons;
glb_counter:=0;
glb_counter4ViewPassword:=0;
Timer2.Enabled:= true;
goingThruAllCheckBoxes:= false;
has_exported:= true;
has_changed:= false;
NextInChain:=SetClipboardViewer(FmxHandleToHWND(Handle));
self.Width:= 1420;
InitialTipBox.Visible:= false;
GetUserCFGValuesToRegistry;
end;

procedure TfmGetMyPasswprds.FormDestroy(Sender: TObject);
begin
ChangeClipboardChain(FmxHandleToHWND(Handle), NextInChain);
end;
procedure TfmGetMyPasswprds.FormResize(Sender: TObject);
begin
//txtTableSpaceName.Text:= inttostr(self.Width);
end;

procedure TfmGetMyPasswprds.ShowPasswordForgotten;
var
dlgResult: integer;
begin
try
 fmPasswordForgotten:= TfmPasswordForgotten.create(self);
 dlgResult:= fmPasswordForgotten.showmodal;
  if dlgResult = mrOk then
  begin
   txtTableSpaceName.Visible:= true;
   tbButtons.ActiveTab:= tbPasswordButtons;
   initializeButtons1(currentGroup, true);
  end
   else
  close;

finally
  fmPasswordForgotten.Free;
end;

end;
procedure TfmGetMyPasswprds.ShowLoggingBox;
var
dlgResult: integer;
T: TMenuItem;
begin
try
 fmPassword:= TfmPassword.create(self);
 dlgResult:= fmPassword.showmodal;
 case dlgResult  of
  mrOk : begin
         txtTableSpaceName.Visible:= true;
         tbButtons.ActiveTab:= tbPasswordButtons;
         tbSavedPasswords.Enabled:= true;
         ScanGroups;
         if GetGroupCount > 0 then
          begin
           currentGroup:= GetLastUsedGroup;
           if trim(currentGroup) = '' then
            showMessage('The application could not get the last saved working group. Select one from the menu Groups');
          end else
          begin
           T:= TMenuItem.Create(nil);
           T.Name:= 'TmenuItemn_MyPasswords';
           T.Text:= 'My Passwords';
           T.Parent:= MenuWindows;
           T.OnClick:= OnGroupMenuClick;
           MenuWindows.AddObject(T);
           currentGroup:= 'My Passwords';
          end;
         self.Caption:= applicationCaption + ' [group: ' + currentGroup + ']';
         checkMenuItem(currentGroup);
         initializeButtons1(currentGroup, true);
         glb_counter:= 0;
        end;
  mrContinue:
        begin
               if MessageDlg('By Clicking Yes, all your password groups will be erased. Are you sure you want to continue?',
                              TMsgDlgType.mtConfirmation, mbYesNo,0) = mrYes then
               begin
               // arreglar para que lo haga por todos los grupos
                if not DeleteDatabaseFromRegistry('') then
                 begin
                    ShowMessage('Could not delete the existing data from the registry. Press Ok to close the application');
                    Close;
                 end;
                 ShowPasswordForgotten;
               end
          else close;
        end
     else
  close;
 end; // case

{  if dlgResult = mrOk then
  begin
   txtTableSpaceName.Visible:= true;
   tbButtons.ActiveTab:= tbPasswordButtons;
   initializeButtons1(true);
   glb_counter:= 0;
  end else
   if dlgResult = mrContinue then
  begin
    if MessageDlg('By Clicking Yes, your saved Paswords will be erased. Are you sure you want to continue?',
    TMsgDlgType.mtConfirmation, mbYesNo,0) = mrYes then
     begin
      if not DeleteDatabaseFromRegistry('') then
       begin
        ShowMessage('Could not delete the existing data from the registry. Press Ok to close the application');
        Close;
        exit;
       end else
        begin
          ShowPasswordForgotten;
        end;
      exit;
     end else
      Close;
  end else
  close;
}
finally
  fmPassword.Free;
end;

end;
procedure TfmGetMyPasswprds.FormShow(Sender: TObject);
begin
 ShowLoggingBox;
 timer2.Enabled:= true;
end;

procedure TfmGetMyPasswprds.Edit1Typing(Sender: TObject);
begin
 AntiSearchButtonLabel((sender as TClearingEdit).Text);
end;
procedure TfmGetMyPasswprds.AntiSearchButtonLabel (lookingFor: string);
var
i: integer;
myLabel:string;
begin
  if True then

   for i := 0 to Rectangle4Buttons.ChildrenCount -1 do
     if (Rectangle4Buttons.Children[i] is TButton)  then
     if (Trim(lookingFor) <> '') and (Pos(UpperCase(Trim(lookingFor)), Uppercase(Tbutton(Rectangle4Buttons.Children[i]).Text)) = 0) then
      Tbutton(Rectangle4Buttons.Children[i]).Opacity:= 0.1 else
      Tbutton(Rectangle4Buttons.Children[i]).Opacity:= 1;

end;
function TfmGetMyPasswprds.EnDeCrypt(const Value : String) : String;
var
  CharIndex : integer;
begin
  Result := Value;
  for CharIndex := 1 to Length(Value) do
    Result[CharIndex] := chr(not(ord(Value[CharIndex])));
end;
procedure TfmGetMypasswprds.DeleteButtons1;

begin
try
ImageCopied.Parent:= Rectangle4Passwords;
while rectangle4buttons.ChildrenCount > 0 do
  rectangle4buttons.children[0].Free;

finally
 ImageCopied.Parent:= Rectangle4Buttons;
 ImageCopied.Visible:= false;
end;
end;
procedure TfmGetMypasswprds.DeleteButtons2;

begin

// temporary move out the labels from Rectangle4Passwords
 try
  InitialTipBox.Parent:= nil;
  text1.Parent:= nil;
  text2.Parent:= nil;
  text5.Parent:= nil;
  text4.Parent:= nil;
  text7.Parent:= nil;
  text6.Parent:= nil;
  text9.Parent:= nil;
  text8.Parent:= nil;
while (Rectangle4Passwords.ChildrenCount > 0)  do
  Rectangle4Passwords.children[0].Free;
 finally
 InitialTipBox.Parent:= Rectangle4Passwords;
  text1.Parent:= Rectangle4Passwords;
  text2.Parent:= Rectangle4Passwords;
  text5.Parent:= Rectangle4Passwords;
  text4.Parent:= Rectangle4Passwords;
  text7.Parent:= Rectangle4Passwords;
  text6.Parent:= Rectangle4Passwords;
  text9.Parent:= Rectangle4Passwords;
  text8.Parent:= Rectangle4Passwords;
  text5.Visible:= false;
  text4.Visible:= false;
  text7.Visible:= false;
  text6.Visible:= false;
  text9.Visible:= false;
  text8.Visible:= false;
 end;


end;
function TfmGetMyPasswprds.GetLastUsedGroup: string;
var
Reg: TRegistry;
x: string;
begin;
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    try
     Reg.OpenKey(registriconst + '\validation\', False);
     x:= Reg.ReadString('lasusedgroup');
     if x = '' then
     result:= 'data' else
     Result:= x;
     finally
      Reg.CloseKey;
      reg.Free;
     end;
end;
procedure TfmGetMyPasswprds.SetLastUsedGroup(aGroup: string);
var
Reg: TRegistry;
x: string;
begin;
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    try
     Reg.OpenKey(registriconst + '\validation\', False);
     Reg.WriteString('lasusedgroup', aGroup);
     finally
      Reg.CloseKey;
      reg.Free;
     end;
end;

procedure TfmGetMypasswprds.ScanGroups;
var
  Reg: TRegistry;
  S : TStringList;
  i:integer;
  T: TMenuItem;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(registriconst, False) then
    begin
      S := TStringList.Create;
      try
        reg.GetKeyNames(S);
         for i := 0 to S.Count - 1 do
          begin
           if S[i] <> 'validation' then
            begin
              T:= TMenuItem.Create(nil);
              T.Name:= 'TMenuItemGroup_' + stringReplace(S[i], ' ' , '', [rfReplaceAll, rfIgnoreCase]);
              T.Text:=S[i];
              T.OnClick:= OnGroupMenuClick;
              MenuWindows.AddObject(T);
            end;
          end;
      finally
       S.Free;
       Reg.CloseKey;
       Reg.Free;
      end; // Reg.OpenKey(registriconst, False)
    end;
end;
procedure TfmGetMypasswprds.CheckMenuItem(menuItemName: string);
var i: integer;
begin
 for i := 0 to MenuWindows.ItemsCount - 1  do
   if TMenuItem(MenuWindows.Items[i]).Text = menuItemName then
     TMenuItem(MenuWindows.Items[i]).IsChecked:= True else
   TMenuItem(MenuWindows.Items[i]).IsChecked:= false;
end;
procedure TfmGetMypasswprds.OnGroupMenuClick (sender: TObject);
var
previousGroup: string;
begin
InitialTipBox.Visible:= false;
 previousGroup := currentGroup;
 currentGroup:= (sender as TMenuItem).Text;
 checkMenuItem(currentGroup);
 if previousGroup <> currentGroup then
  begin
   DeleteButtons2;
   DeleteButtons1;
   initializeButtons1(currentGroup, true);
   Self.Caption := applicationCaption + ' [group: ' + currentGroup + ']';
   tbButtons.ActiveTab:= tbPasswordButtons;
   glb_counter:= 0;
  end;
end;
procedure TfmGetMypasswprds.initializeButtons1(aGroup: string; all: boolean);
const
col1Posx1 = 50;
PosY = 20;

var   Reg, Reg2: TRegistry;
  S : TStringList;
  i,k:integer;
  x:string;
  xx,  yy:single;
  passwordValue: string;

begin
  try
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(registriconst + '\' + aGroup+ '\', False) then
    begin
      S := TStringList.Create;
      try
        reg.GetKeyNames(S);
      k:= -1;
        for i := 0 to S.Count - 1 do
        begin
    //   x:= registriconst + '\data\'  + s[i];
         x:= registriconst + '\' + aGroup + '\'  + 'Px' + IntToStr(i);
         try
         Reg2 := TRegistry.Create;
         if Reg2.OpenKey( x, False) then
          begin
           k:= k + 1;
           passwordValue:=  Decrypt(Reg2.ReadString('Password'), personalKey ) ;
           if not import_going_out and not import_delete_Data then
            begin
             with Tbutton.Create(self) do
              begin
                visible:=true;
                parent:= Rectangle4Buttons;
                      if (k <= 9)  then
                      begin
                      xx:= col1Posx1;
                      yY:= PosY + k * 45
                      end  else  if (k > 9) and (k <= 19) then
                      begin
                      xx:= col1Posx1 + 365 * 1;
                      yY:= PosY + (k -10) * 45;

                      end else  if (k > 19) and (k <= 29) then
                      begin
                        xx:= col1Posx1 + 365 * 2 ;
                        yY:= PosY + (k -20) * 45;

                      end   else  if (k > 29) and (k <= 39) then
                       begin
                        xx:= col1Posx1 + 365 * 3 ;
                        yY:= PosY + (k -30) * 45    ;
                       end ;

                        Position.Y:= yy;
                        position.X:= xx;
                        width:= 145;
                        height:= 35;
                        name:= 'buttonCopy' + intToStr(i);
                        Text:= IntToStr(k);
                        Text:= Reg2.ReadString('Username');
                        StyleName:= passwordValue;
                         if import_delete_Data or import_going_out then
                         free;
                        WordWrap:= true;
                   //     Trim(ttCharacter);
                        OnClick:= OnClickToGetPassword;

                      if all then
                    addpairOfButtons(k,Text, Decrypt(Reg2.ReadString('Password'),personalKey));
              end;
            end;   // not import_going_out and not import_delete_Data then

          end;
         finally
           Reg2.CloseKey;
           Reg2.Free;
         end;
          if import_delete_Data then
           begin
             break;
           end;
        end;
      finally
        S.Free;
      end;
      Reg.CloseKey;
    end //if Reg.OpenKey(

    else
    begin
      tbButtons.ActiveTab:= tbSavedPasswords;
      InitialTipBox.Visible:= true;
    end;
  finally
    Reg.Free;
  end; // first try


  if import_delete_Data then
   begin
   // arreglar para que sea todos los grupos
    DeleteDatabaseFromRegistry(currentGroup);
     if fmPasswordChange = nil then
        fmPasswordChange:= TfmPasswordChange.Create(nil);
        if fmPasswordChange.ShowModal = mrOk  then
         begin
         ShowMessage('The password has been successfuly changed. Import you file again');
//           DeleteButtons;
//           DeleteDatabaseFromRegistry('data');
//           SavePasswords;
//           initializeButtons1(false);
         end;
        fmPasswordChange.Free;
        fmPasswordChange:= nil;
   end;
end;
////////////////////////////////////////////////////
{$IFDEF MSWINDOWS}


function MySubclassProc(Wnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM;
uIdSubclass: UINT_PTR; dwRefData: DWORD_PTR): LRESULT; stdcall;
var
  Form: TfmGetMypasswprds;
begin
  Form := TfmGetMypasswprds(dwRefData);
  case uMsg of
    WM_CLIPBOARDUPDATE: begin
      Form.ClipboardUpdated;
    end;
    WM_DRAWCLIPBOARD: begin
      Form.ClipboardUpdated;
      if Form.NextInChain <> 0 then begin
        SendMessage(Form.NextInChain, WM_DRAWCLIPBOARD, 0, 0);
      end;
    end;
    WM_CHANGECBCHAIN:
    begin
      if Form.NextInChain = wParam then begin
        Form.NextInChain := lParam;
      end
      else if Form.NextInChain <> 0 then begin
        SendMessage(Form.NextInChain, WM_CHANGECBCHAIN, wParam, lParam);
      end;
    end;
  end;
  Result := DefSubclassProc(Wnd, uMsg, wParam, lParam);
end;

procedure TfmGetMypasswprds.CreateHandle;
var
  Wnd: HWND;
begin
  inherited;
  Wnd := FmxHandleToHWND(Handle);
  if SetWindowSubclass(Wnd, @MySubclassProc, 1, DWORD_PTR(Self)) then
  begin
    if CheckWin32Version(6) then
    begin
      AddClipboardFormatListener(Wnd);
    end else begin
      NextInChain := SetClipboardViewer(Wnd);
    end;
  end;
end;

procedure TfmGetMypasswprds.DestroyHandle;
var
  Wnd: HWND;
begin
  if Handle <> nil then
  begin
    Wnd := FmxHandleToHWND(Handle);
    if CheckWin32Version(6) then
    begin
      RemoveClipboardFormatListener(Wnd);
    end else
    begin
      ChangeClipboardChain(Wnd, NextInChain);
      NextInChain := 0;
    end;
    RemoveWindowSubclass(Wnd, @MySubclassProc, 1);
  end;
  inherited;
end;
procedure TfmGetMypasswprds.ClipboardUpdated;
begin
  Inc(clipBrdCounter);
  if clipBrdCounter > 1 then
  ImageCopied.Opacity:= 0.3;
  Text11.Text:= 'Counter = ' +  IntToStr(clipBrdCounter) +  ', Opacity = ' + FloatToStrF(ImageCopied.Opacity,
  ffNumber,7,1);
end;
{$ENDIF}


end.
