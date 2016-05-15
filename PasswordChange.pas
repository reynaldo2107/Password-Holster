
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

unit PasswordChange;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Menus;

type
  TfmPasswordChange = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    Text1: TText;
    Edit1: TEdit;
    Edit2: TEdit;
    Text2: TText;
    textError: TText;
    Rectangle1: TRectangle;
    Edit3: TEdit;
    Text3: TText;
    ImageOldPass: TImage;
    Image1: TImage;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Typing(Sender: TObject);
    procedure Edit2KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Edit3Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
  var glbFirstTime: boolean ;
  function ValidateKey(key: string): boolean;
  function verifyKeyExist: boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPasswordChange: TfmPasswordChange;

implementation
 uses mainunit, registry, Winapi.Windows, Encrypting;
{$R *.fmx}

procedure TfmPasswordChange.btnCancelClick(Sender: TObject);
begin
ModalResult:= mrCancel;
end;

procedure TfmPasswordChange.btnOkClick(Sender: TObject);
var
isOk: boolean;
function RegiterMainKey(apassword: string): boolean;
begin
with TRegistry.Create do
 begin
  Result:= false;
  RootKey := HKEY_CURRENT_USER;
  if OpenKey(registriconst + '\' + 'validation', true) then
  begin
   if apassword <> '' then
    writeString('software' , encrypt(apassword, fmGetMyPasswprds.constkey));
    Result:= true;
    closeKey;
  end;
   Free;
 end;
end;

begin
if ((Edit1.Text = Edit2.Text) and (system.SysUtils.trim(Edit1.Text) <> ''))  then
begin
if RegiterMainKey (Edit1.Text) then
   personalKey:= Edit1.Text ;
   ModalResult:= mrOk;
 end else
 textError.Text:= 'The New Password Keys do not match';
end;

procedure TfmPasswordChange.Edit1Typing(Sender: TObject);
begin
textError.Text:='';
end;

procedure TfmPasswordChange.Edit2Change(Sender: TObject);
begin
textError.Text:='';
if Edit2.Text = Edit1.Text then
begin
Image1.Visible:= true;
//btnOk.SetFocus;
end
 else
  Image1.Visible:= false;
end;

procedure TfmPasswordChange.Edit2KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
if (Key= 13)
//and (edit1.Text = edit2.Text)
then
 btnOkClick (self);
end;

procedure TfmPasswordChange.Edit3Change(Sender: TObject);
begin
if Edit3.Text = personalKey then
begin
ImageOldPass.Visible:= true;
edit1.Enabled:= true;
edit2.Enabled:= true;
edit1.SetFocus;
end
 else
 begin
  ImageOldPass.Visible:= false;
  edit1.Enabled:= false;
  edit2.Enabled:= false;
 end;
end;

procedure TfmPasswordChange.FormCreate(Sender: TObject);
begin
self.Height:= 267;
//glbFirstTime:= not verifyKeyExist;
textError.Text:= '';
 edit3.SetFocus;
end;

function TfmPasswordChange.verifyKeyExist: boolean;
begin
 with TRegistry.Create do
 begin
  Result:= false;
  RootKey := HKEY_CURRENT_USER;
  if OpenKey(registriconst + '\' + 'validation', false) then
  begin
    Result:= true;
    closeKey;
  end;
   Free;
 end;
end;

function TfmPasswordChange.ValidateKey(key: string): boolean;
var
encryKey, decryKey:string;
begin
 with TRegistry.Create do
 begin
  Result:= false;
  RootKey := HKEY_CURRENT_USER;
  if OpenKey(registriconst + '\' + 'validation', false) then
  begin
    encryKey:= readstring('software');
    decryKey:= Decrypt(encryKey,fmGetMyPasswprds.constKey);
    Result:= key = decryKey;
    closeKey;
  end;
   Free;
 end;
end;

end.
