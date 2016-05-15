
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

unit userPreferences;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TfmuserPreferences = class(TForm)
    Rectangle4Passwords: TRectangle;
    Text1: TText;
    Rectangle6: TRectangle;
    Button2: TButton;
    TrackBar1: TTrackBar;
    Text3: TText;
    tracking1Value: TText;
    TrackBar2: TTrackBar;
    tracking2Value: TText;
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Tracking(Sender: TObject);
    procedure TrackBar2Tracking(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
   x1, x2: integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmuserPreferences: TfmuserPreferences;

implementation
  uses shellapi, Winapi.Windows, mainUnit, registry, NT_utils;
{$R *.fmx}

procedure TfmuserPreferences.Button1Click(Sender: TObject);
begin
ModalResult:= mrOk;
end;

procedure TfmuserPreferences.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if max_counter2disableViewPasssword = 0  then
   max_counter2disableViewPasssword:= 1410065408;
    if max_counter2disable = 0 then
   max_counter2disable:= 1410065408;
SaveUserCFGValuesToRegistry;
glb_counter:=0;
glb_counter4ViewPassword :=0;
end;

procedure TfmuserPreferences.FormCreate(Sender: TObject);
begin
if max_counter2disable = 1410065408 then
 max_counter2disable:=0;
TrackBar1.Value:=  Round(fmGetMyPasswprds.timer2.interval * max_counter2disable / 60000 );
 if TrackBar1.Value = 0  then
  tracking1Value.Text:='Never';

  if max_counter2disableViewPasssword = 1410065408 then
   max_counter2disableViewPasssword:=0;
TrackBar2.Value:=  Round(fmGetMyPasswprds.timer2.interval * max_counter2disableViewPasssword / 60000 );
 if TrackBar2.Value = 0  then
  tracking2Value.Text:='Never';
end;

procedure TfmuserPreferences.TrackBar1Tracking(Sender: TObject);
begin
if TrackBar1.Value > 0 then
tracking1Value.Text:= floatToStr( TrackBar1.Value ) + ' minutes' else
tracking1Value.Text:='Never';
 if TrackBar1.Value = 0  then
  x1:= 0 else
  x1:= round(TrackBar1.Value * 60000 / fmGetMyPasswprds.timer2.interval) ;
  max_counter2disable:= x1;
  if max_counter2disable = 0 then
   max_counter2disable:= 1410065408;
end;

procedure TfmuserPreferences.TrackBar2Tracking(Sender: TObject);
begin
if TrackBar2.Value > 0 then
tracking2Value.Text:= floatToStr( TrackBar2.Value ) + ' minutes' else
tracking2Value.Text:='Never';
 if TrackBar2.Value = 0  then
  x2:= 0 else
  x2:= round(TrackBar2.Value * 60000 / fmGetMyPasswprds.timer2.interval) ;
  max_counter2disableViewPasssword:= x2;
  if max_counter2disableViewPasssword = 0  then
   max_counter2disableViewPasssword:= 1410065408;
end;


end.
