
// Copyright 2014 Reynaldo Mola

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//    http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.unit about;
unit about;
interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Memo;

type
  TfmAbout = class(TForm)
    Image1: TImage;
    Rectangle4Passwords: TRectangle;
    Button1: TButton;
    Text1: TText;
    Text3: TText;
    Text4: TText;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Text4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAbout: TfmAbout;

implementation
  uses shellapi, Winapi.Windows;
{$R *.fmx}

procedure TfmAbout.Button1Click(Sender: TObject);
begin
ModalResult:= mrOk;
end;

procedure TfmAbout.Text4Click(Sender: TObject);
begin
ShellExecute(0, 'OPEN', PChar(Text4.Text), '', '', SW_SHOWNORMAL);
end;

end.
