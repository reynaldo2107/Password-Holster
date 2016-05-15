
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

unit unitHelp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TfmHelp = class(TForm)
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Button1: TButton;
    CalloutPanel1: TCalloutPanel;
    Text5: TText;
    Text1: TText;
    StyleBook1: TStyleBook;
    Text2: TText;
    CalloutPanel2: TCalloutPanel;
    Text3: TText;
    Text4: TText;
    Text6: TText;
    CalloutPanel3: TCalloutPanel;
    Text7: TText;
    Text8: TText;
    Text9: TText;
    Text10: TText;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmHelp: TfmHelp;

implementation

{$R *.fmx}

procedure TfmHelp.Button1Click(Sender: TObject);
begin
close;
end;

end.
