clear all;
clc;

% Codebook Type enumerations:
% codebookType
% 0 - Type I - Single Panel
% 1 - Type I - Multi Panel
% 2 - Type II
% 3 - Type II - Port Selection

% Ng - Number of panel
% N1 - Number of horizontal antenna element (azimuth)
% N2 - Number of vertical antenna element (elevation)
% O1 - Oversampling of horizontal antenna element (azimuth)
% O2 - Oversampling of vertical antenna element (elevation)

% L - Number of layer

% codebookMode - codebook Mode
% codebookType - codebook Type

% i11 - Steer beams in horizontal
% i12 - Steer beams in vertical

% Configurations

c = 3e8;        % propagation speed
fc = 3.5e9;     % carrier frequency
lambda = c/fc;	% wavelength

Ng = 1; % Number of sub-array
N1 = 2; % Number of vertical horizontal antenna elements
N2 = 2; % Number of horizontal antenna elements
O1 = 4; % Number of horizontal oversampling factor
O2 = 1; % Number of vertical oversampling factor
   
L = 1;

codebookMode = 1;
codebookType = 0;   % Type I - Single Panel

i11 = 0;
i12 = 0;
i13 = 0;
i2 = 1;
i3 = 0;
i141 = 1;
i141 = 1;
i142 = 1;
i143= 1;
i20 = 1;
i21 = 1;
i22 = 1;

plot = 1;

% w = codebook(codebookType, L, codebookMode, i11, i12, i13, i2, N1, N2, O1, O2);

%% Set up beam
antennaElement = phased.CrossedDipoleAntennaElement; % dinh nghia phan cuc 
% generate crossed-dipole antenna
% generate circularly polarized field: left and right
%antennaElement = phased.IsotropicAntennaElement;
if N2 ~= 1
    txarray = phased.URA('Size',[ N2*O2  N1*O1],'ElementSpacing',[lambda/2 lambda/2],...
        'Element',antennaElement);
    % N2 ~= 1 -> [array]
    % antenna array size [N1*O1 N2*O2]; 
     
elseif N2 == 1
    txarray = phased.ULA('NumElements',N1*N2*O1*O2,'ElementSpacing',lambda/2,...
        'Element',antennaElement); 
    % Uniforn Linear Array: antenna in a line with uniform spacing
end
%txarray.Element.BackBaffled = true;
pos = getElementPosition(txarray);

if plot == 1

 
    for i11 = 1:N1*O1-1
%     for i11 = 1
                w = codebook(codebookType, L, codebookMode, i11, i12, i13,i141, i142, i143, i2, i20,i21,i22,Ng, N1,...
    N2, O1, O2)

                w1 = w(1:numel(w)/2); % cac phan tu cua chan tu 1
                w2 = w(numel(w)/2+1:end); % cac phan tu cua chan tu 2

                w1_s = reshape(w1, N2,N1).'; % dua lai ve size [N1xN2]
                w1_s = kron(w1_s,ones(O1,O2)); % coppy cho tung mang tuong ung [O1,O2]
                wt1 = reshape(w1_s.',[],1); % dua ve cot

                w2_s = reshape(w2, N2,N1).'; % tuong tu voi chan tu 2
                w2_s = kron(w2_s,ones(O1,O2));
                wt2 = reshape(w2_s.',[],1);

                hFig = figure(1);
                set(gcf,'color','w');

                subplot(L,2,1); % phan chia [Lx2] tai o thu 1
                pattern(txarray,fc,[-180:180],[-90:90],...
                    'PropagationSpeed',c,...
                    'CoordinateSystem','polar',...
                    'Type','powerdB',...
                    'Weights',wt1);
                tStr = sprintf('i_{11} = %d, i_{12} = %d, i_2 = %d',i11,i12,i2);
                title(tStr);

                subplot(L,2,2); % o thu 2
                pattern(txarray,fc,[-180:180],[-90:90],...  %[-180:180],[-90,90]: ground size?
                    'PropagationSpeed',c,...
                    'CoordinateSystem','polar',...
                    'Type','powerdB',...
                    'Weights',wt2);
                tStr = sprintf('i_{11} = %d, i_{12} = %d, i_2 = %d',i11,i12,i2);
                title(tStr);
                
                hFig = figure(2);
                
                AzRange = -90:1:90;
                ElRange = -90:1:90;
                
              
                % Plot Array Factor - Azimuth
                subplot(2,2,1);
                pattern(txarray,fc,AzRange,0,...
                    'PropagationSpeed',c,...
                    'CoordinateSystem','polar',...
                    'Type','powerdB',...
                    'Weights',wt1);
                
                az = pattern(txarray,fc,AzRange,0,...
                    'PropagationSpeed',c,...
                    'CoordinateSystem','polar',...
                    'Type','powerdB',...
                    'Weights',wt1);
                
                subplot(2,2,2);
                clear plot
                plot(AzRange,az);
                axis ([-100 100 -20 0]);
                grid on;
                

                % Plot Array Factor - Elevation
                subplot(2,2,3);
                pattern(txarray,fc,0,ElRange,...
                    'PropagationSpeed',c,...
                    'CoordinateSystem','polar',...
                    'Type','powerdB',...
                    'Weights',wt1);
                
                el = pattern(txarray,fc,0,ElRange,...
                    'PropagationSpeed',c,...
                    'CoordinateSystem','polar',...
                    'Type','powerdB',...
                    'Weights',wt1);
                
                subplot(2,2,4);
                plot(ElRange,el);
                axis ([-100 100 -20 0]);
                grid on;
                
%                 % Plot 3D graph
%                 hFig = figure(3);
%                 
%                 subplot(2,2,[1 3]); 
%                 pattern(txarray,fc,[-180:180],[-90:90],...
%                     'PropagationSpeed',c,...
%                     'CoordinateSystem','polar',...
%                     'Type','powerdB',...
%                     'Weights',wt1);
%                 tStr = sprintf('i_{11} = %d, i_{12} = %d, i_2 = %d',i11,i12,i2);
%                 title(tStr);

                pause(1);

    end

end
%         
            
 
