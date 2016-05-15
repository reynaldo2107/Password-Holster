
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

unit Encrypting;

interface
function EncryptStr2(const S :WideString; Key: Word): String;
function DecryptStr2(const S: String; Key: Word): String;
function Encrypt(const AText: WideString; const APassword: WideString): WideString; overload;
function Decrypt(const AText: WideString; const APassword: WideString): WideString; overload;
var
  import_going_out, import_delete_Data: boolean;
  DialogResult: integer;
implementation
uses System.sysutils,DECUtil, DECCipher, DECHash, DECFmt, fmx.Dialogs, fmx.forms, system.UITypes;
const CKEY1 = 53761;
      CKEY2 = 32618;

var
  ACipherClass: TDECCipherClass = TCipher_Rijndael;
  ACipherMode: TCipherMode = cmCBCx;
  AHashClass: TDECHashClass = THash_Whirlpool;
  ATextFormat: TDECFormatClass = TFormat_Mime64;
  AKDFIndex: LongWord = 1;
function Encrypt(const AText: WideString; const APassword: WideString): WideString; overload;
var
  ASalt: Binary;
  AData: Binary;
  APass: Binary;
begin
  with ValidCipher(ACipherClass).Create, Context do
  try
    ASalt := RandomBinary(16);
    APass := ValidHash(AHashClass).KDFx(APassword[1], Length(APassword) * SizeOf(APassword[1]), ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);
    Mode := ACipherMode;
    Init(APass);
    SetLength(AData, Length(AText) * SizeOf(AText[1]));
    Encode(AText[1], AData[1], Length(AData));
    Result := ValidFormat(ATextFormat).Encode(ASalt + AData + CalcMAC);
  finally
    Free;
    ProtectBinary(ASalt);
    ProtectBinary(AData);
    ProtectBinary(APass);
  end;
end;


function Decrypt(const AText: WideString; const APassword: WideString): WideString; overload;
var
  ASalt: Binary;
  AData: Binary;
  ACheck: Binary;
  APass: Binary;
  ALen: Integer;

begin
  import_going_out:= false;
  import_delete_Data:= false;
  with ValidCipher(ACipherClass).Create, Context do
  try
    ASalt := ValidFormat(ATextFormat).Decode(AText);
    ALen := Length(ASalt) - 16 - BufferSize;
    AData := System.Copy(ASalt, 17, ALen);
    ACheck := System.Copy(ASalt, ALen + 17, BufferSize);
    SetLength(ASalt, 16);
    APass := ValidHash(AHashClass).KDFx(APassword[1], Length(APassword) * SizeOf(APassword[1]), ASalt[1], Length(ASalt), KeySize, TFormat_Copy, AKDFIndex);
    Mode := ACipherMode;
    Init(APass);
    SetLength(Result, ALen div SizeOf(AText[1]));
    Decode(AData[1], Result[1], ALen);
    if ACheck <> CalcMAC then
   //   raise Exception.Create('Invalid data. You may be importing a file exported using a different key');
   case MessageDlg('Incorrect decryption. You may be importing a file exported using a different key. '#13#10 +
   'Press Yes to delete the imported data and change your password key.'#13#10 +
   'Press No to terminate the application.',
   TMsgDlgType.mtConfirmation, mbYesNo,0) of
   mrYes: import_delete_Data := true;
   mrNo: import_going_out:= true else
   import_going_out:= true;
   end;

  finally
    Free;
    ProtectBinary(ASalt);
    ProtectBinary(AData);
    ProtectBinary(ACheck);
    ProtectBinary(APass);
  end;
  if import_going_out then
  application.terminate;
end;

function EncryptStr2(const S :WideString; Key: Word): String;
var   i          :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
begin
  Result:= '';
  RStr:= UTF8Encode(S);
  for i := 0 to Length(RStr)-1 do begin
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (RStrB[i] + Key) * CKEY1 + CKEY2;
  end;
  for i := 0 to Length(RStr)-1 do begin
    Result:= Result + IntToHex(RStrB[i], 2);
  end;
end;

function DecryptStr2(const S: String; Key: Word): String;
var   i, tmpKey  :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
      tmpStr     :string;
begin
  tmpStr:= UpperCase(S);
  SetLength(RStr, Length(tmpStr) div 2);
  i:= 1;
  try
    while (i < Length(tmpStr)) do begin
      RStrB[i div 2]:= StrToInt('$' + tmpStr[i] + tmpStr[i+1]);
      Inc(i, 2);
    end;
  except
    Result:= '';
    Exit;
  end;
  for i := 0 to Length(RStr)-1 do begin
    tmpKey:= RStrB[i];
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (tmpKey + Key) * CKEY1 + CKEY2;
  end;
  Result:= UTF8Decode(RStr);
end;

end.
