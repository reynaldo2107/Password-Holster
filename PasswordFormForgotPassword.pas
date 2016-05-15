
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

unit PasswordFormForgotPassword;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Menus;

type
  TfmPasswordForgotten = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    Text1: TText;
    Edit1: TEdit;
    Edit2: TEdit;
    Text2: TText;
    TextFirstlogging: TText;
    textError: TText;
    Rectangle1: TRectangle;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Typing(Sender: TObject);
    procedure Edit2KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
  var glbFirstTime: boolean ;
  wrongKeyCounter: integer ;
  maxFaultedAttempts: integer;
  maxAttempsBeforeShowingForgotPassword: integer;
  function ValidateKey(key: string): boolean;
  function verifyKeyExist: boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPasswordForgotten: TfmPasswordForgotten;

implementation
 uses mainunit, registry, Winapi.Windows, Encrypting;
{$R *.fmx}

procedure TfmPasswordForgotten.btnCancelClick(Sender: TObject);
begin
ModalResult:= mrCancel;
end;

procedure TfmPasswordForgotten.btnOkClick(Sender: TObject);
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
if  glbFirstTime then
 begin
  isOk:= (Edit1.Text <> '') and (Edit1.Text =  Edit2.Text);
  if (Edit1.Text <>  Edit2.Text) then
   textError.Text:= 'Password Keys don''t match';
  if trim(Edit1.Text) = '' then
   textError.Text:= 'Password Keys can''t be blank';
  if isOk then
  begin
  Edit1.Text:= Trim(Edit1.Text);
   if RegiterMainKey (Edit1.Text) then
   personalKey:= Edit1.Text ;
   ModalResult:= mrOk;
  end;
 end else  //if  glbFirstTime then
  if ValidateKey(Edit1.text) then
   begin
    personalKey:=Edit1.text;
    ModalResult:= mrOk;
   end else
   begin
   wrongKeyCounter:= wrongKeyCounter + 1;
    textError.Text:='Wrong Password Key';
    //txtForgot.Visible:= wrongKeyCounter >= maxAttempsBeforeShowingForgotPassword;
   end;
end;

procedure TfmPasswordForgotten.Edit1KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
 if Key = 13 then
   btnOkClick (self);
end;

procedure TfmPasswordForgotten.Edit1Typing(Sender: TObject);
begin
textError.Text:='';
end;

procedure TfmPasswordForgotten.Edit2KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
if KeyChar = #13 then
 btnOkClick (self);
end;

procedure TfmPasswordForgotten.FormCreate(Sender: TObject);
begin
wrongKeyCounter:=0;
maxFaultedAttempts:=10;
maxAttempsBeforeShowingForgotPassword:= 3;
self.Height:= 200;
glbFirstTime:= not verifyKeyExist;
textError.Text:= '';
  if   glbFirstTime then
  begin
    TextFirstlogging.Visible:= true;
    Text2.Visible:= true;
    edit2.visible:= true;
    glbFirstTime:= true;
    self.Height:= 248;
    textError.Position.y:= 152;
  end;
  edit1.SetFocus;
end;

function TfmPasswordForgotten.verifyKeyExist: boolean;
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

function TfmPasswordForgotten.ValidateKey(key: string): boolean;
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
