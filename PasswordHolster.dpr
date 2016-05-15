program PasswordHolster;

uses
  FMX.Forms,
  mainUnit in 'mainUnit.pas' {fmGetMyPasswprds},
  Encrypting in 'Encrypting.pas',
  ASN1 in 'ASN1.pas',
  CPU in 'CPU.pas',
  CRC in 'CRC.pas',
  DECCipher in 'DECCipher.pas',
  DECData in 'DECData.pas',
  DECFmt in 'DECFmt.pas',
  DECHash in 'DECHash.pas',
  DECUtil in 'DECUtil.pas',
  DECRandom in 'DECRandom.pas',
  TypInfoEx in 'TypInfoEx.pas',
  PasswordForm in 'PasswordForm.pas' {fmPassword},
  NT_utils in 'NT_utils.pas',
  PasswordChange in 'PasswordChange.pas' {fmPasswordChange},
  PasswordFormForgotPassword in 'PasswordFormForgotPassword.pas' {fmPasswordForgotten},
  about in 'about.pas' {fmAbout},
  Credits in 'Credits.pas' {fmCredits},
  {$IFDEF MSWINDOWS}
  CommCtrl
  {$ENDIF},
  unitHelp in 'unitHelp.pas' {fmHelp},
  groupName_newName in 'groupName_newName.pas' {fmGroupName},
  userPreferences in 'userPreferences.pas' {fmuserPreferences};

{$R *.res}
{$IFDEF MSWINDOWS}
 var
  Init : TInitCommonControlsEx;
 {$ENDIF}
begin
{$IFDEF MSWINDOWS}
 Init.dwSize := SizeOf(TInitCommonControlsEx);
        Init.dwICC := ICC_LISTVIEW_CLASSES OR // $00000001; // listview, header
                      ICC_TREEVIEW_CLASSES OR // $00000002; // treeview, tooltips
                      ICC_BAR_CLASSES      OR // $00000004; // toolbar, statusbar,
                                                            // trackbar, tooltips
                      ICC_TAB_CLASSES      OR // $00000008; // tab, tooltips
                      ICC_UPDOWN_CLASS     OR // $00000010; // updown
                      ICC_PROGRESS_CLASS   OR // $00000020; // progress
                      ICC_HOTKEY_CLASS     OR // $00000040; // hotkey
                      ICC_ANIMATE_CLASS    OR // $00000080; // animate
                      ICC_WIN95_CLASSES    OR // $000000FF;
                      ICC_DATE_CLASSES     OR // $00000100; // month picker, date picker,
                                                            //time picker, updown
                      ICC_USEREX_CLASSES   OR // $00000200; // comboex
                      ICC_COOL_CLASSES;

  InitCommonControlsEx(Init);
 // ReportMemoryLeaksOnShutdown := DebugHook <> 0;
 {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TfmGetMyPasswprds, fmGetMyPasswprds);
  Application.CreateForm(TfmCredits, fmCredits);
  Application.Run;
end.
