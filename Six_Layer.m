function w = Six_Layer(i11, i12, i2, N1, N2, O1, O2)

% case 6 layers 

%% Set values for parameters l, m, n
if (N2 > 1)
    l = i11;
    l_1 = i11 + O1;
    l_2 = i11 + O1;
    m = i12;
    m_1 = i12;
    m_2 = i12 + O2;
    n = i2;
elseif ((N1 >2) && (N2 == 1))
    l = i11;
    l_1 = i11 + O1;
    l_2 = i11 + 2*O1;
    m = 0;
    m_1 = 0;
    m_2 = 0;
    n = i2;
else
    disp('Error in parameter');
end

%% phi_n, u_m, v_l_m, number of antenna port
phi_n = func_phi_n(n);
u_m = func_u_m(m, N2, O2);
v_l_m = func_v_l_m(u_m, l, N1, O1);
u_m_1 = func_u_m(m_1, N2, O2);
v_l_m_1 = func_v_l_m(u_m_1, l_1, N1, O1);
u_m_2 = func_u_m(m_2, N2, O2);
v_l_m_2 = func_v_l_m(u_m_2, l_2, N1, O1);

% Number of CSI-RS antenna port
P_CSI_RS = 2*N1*N2;

% Calculate W
w = (1/(sqrt(6*P_CSI_RS)))*([   v_l_m           v_l_m           v_l_m_1         v_l_m_1             v_l_m_2    v_l_m_2	;
                                phi_n*v_l_m     -1*phi_n*v_l_m  phi_n*v_l_m_1	-1*phi_n*v_l_m_1    v_l_m_2    -1*v_l_m_2	]);
                            
end