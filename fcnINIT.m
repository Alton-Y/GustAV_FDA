function [ handles ] = fcnINIT( handles )
%Initialize the figure setup
%   Detailed explanation goes here

handles.text2.String = 'READY';
handles.CurrentIdx = 1;

handles.hTOP  = fcnSETFIG([0.00 0.90 1.00 0.10]);
handles.hPFD  = fcnSETFIG([0.50 0.45 0.25 0.45]);
handles.hATT  = fcnSETFIG([0.55 0.53 0.15 0.27]);
handles.hSPD  = fcnSETFIG([0.45 0.53 0.10 0.27]);
handles.hALT  = fcnSETFIG([0.70 0.53 0.10 0.27]);
handles.hPFD2  = fcnSETFIG([0.50 0.45 0.25 0.45]);
handles.hPFD2.Visible = 'off';
handles.hSTAT = fcnSETFIG([0.75 0.45 0.25 0.45]);
handles.hFCTL = fcnSETFIG([0.00 0.00 0.25 0.45]);
handles.hNAV  = fcnSETFIG([0.50 0.00 0.25 0.45]);
handles.hENG  = fcnSETFIG([0.25 0.30 0.25 0.15]);
handles.hELEC = fcnSETFIG([0.25 0.00 0.25 0.30]);
handles.hGPS  = fcnSETFIG([0.75 0.00 0.25 0.45]);
handles.hVID  = fcnSETFIG([0.00 0.45 0.50 0.45]);

% handles.tGPS  = PlotGPS(handles.hGPS,handles.SYNCFMT);
% handles.tGPS.FLTPATH.Color = [1 1 1 0.2];

handles.tTOP  = PlotTOP(handles.hTOP);
handles.tELEC = PlotELEC(handles.hELEC);
handles.tFCTL = PlotFCTL(handles.hFCTL);
handles.tPFD  = PlotPFD(handles.hPFD);
handles.tPFD2  = PlotPFD2(handles.hPFD2);

handles.tENG  = PlotENG(handles.hENG);
handles.tSPD = PlotSPD(handles.hSPD);
handles.tALT = PlotALT(handles.hALT);
handles.tATT = PlotATT(handles.hATT);

fcnTITLE( handles.hFCTL, 'FCTL' )
fcnTITLE( handles.hENG, 'ENG' )
fcnTITLE( handles.hELEC, 'ELEC' )

[handles] = GuiMSG(handles,'READY');

    
end

