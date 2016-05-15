
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

unit groupName_newName;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects;

type
  TfmGroupName = class(TForm)
    Rectangle1: TRectangle;
    btnOk: TButton;
    btnCancel: TButton;
    Text3: TText;
    edtGroupName: TEdit;
    textError: TText;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure edtGroupNameTyping(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  function GroupExists: boolean;
    { Private declarations }
  public
  action: string;
    { Public declarations }
  end;

var
  fmGroupName: TfmGroupName;

implementation
uses mainUnit, FMX.Menus;
{$R *.fmx}
function TfmGroupName.GroupExists: boolean;
var i: integer;
begin
 Result:= false;
 for i := 0 to fmGetMypasswprds.MenuWindows.ItemsCount - 1  do
   if TMenuItem(fmGetMypasswprds.MenuWindows.Items[i]).Text = trim(edtGroupName.Text) then
    begin
      Result:= true;
      break;
    end;
end;

procedure TfmGroupName.btnCancelClick(Sender: TObject);
begin
ModalResult:= mrCancel;
end;

procedure TfmGroupName.btnOkClick(Sender: TObject);
begin
if GroupExists then
begin
  textError.Visible:=true;
  ModalResult:= mrNone;
  exit;
end;
if action = 'New' then
modalResult:= mrOk;
if action = 'Rename' then
modalResult:= mrContinue;
end;

procedure TfmGroupName.edtGroupNameTyping(Sender: TObject);
begin
btnOk.Enabled:= edtGroupName.Text <> '';
textError.Visible:= false;
end;

procedure TfmGroupName.FormShow(Sender: TObject);
begin
edtGroupName.SetFocus;
end;

end.
