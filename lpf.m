% --- 1. Define Component Values ---
% Stage 1: Sallen-Key LPF
% TUNING: Changed R1 from 8200 to 7650 to hit exactly -3.00dB
R1 = 7725;      % 7.65k Ohm (Tuned Value)
R2 = 800;       % 800 Ohm
C1 = 1e-9;      % 1nF
C2 = 1e-9;      % 1nF

% Stage 2: Passive RC + Non-Inverting Amp
R3 = 1000;      % 1k Ohm (Kept low to avoid double-filtering)
C3 = 1e-9;      % 1nF
RG1 = 1500;     % 1.5k
R4 = 2000;      % 2k

% --- 2. Define Transfer Functions ---
s = tf('s');

% Gain of Stage 2 (Amplifier)
Gain_Stage2 = 1 + (RG1 / R4); 
DC_Gain_dB = 20 * log10(Gain_Stage2);

% Transfer Function: Stage 1 Only (Green Line)
H1 = 1 / ( (s^2 * R1 * R2 * C1 * C2) + (s * C2 * (R1 + R2)) + 1 );

% Transfer Function: Total System (Red Line)
H2 = Gain_Stage2 / (s * R3 * C3 + 1);
H_total = H1 * H2;

% --- 3. Generate Data ---
f_vec = logspace(1, 5.3, 1000); % 10 Hz to 200 kHz
w_vec = 2 * pi * f_vec;

[mag1, ~] = bode(H1, w_vec);
[mag_total, ph_total] = bode(H_total, w_vec);

mag1 = squeeze(mag1);
mag_total = squeeze(mag_total);
ph_total = squeeze(ph_total);

% Normalize: Subtract DC Gain so graph starts at 0dB
mag1_db = 20 * log10(mag1); 
mag_total_db = 20 * log10(mag_total) - DC_Gain_dB; 

% --- 4. Plotting ---
figure('Color', 'k'); % Proteus Style Black Background

% === TOP SUBPLOT: FREQUENCY RESPONSE ===
subplot(2,1,1);
semilogx(f_vec, mag1_db, 'g', 'LineWidth', 1.5, 'DisplayName', 'U1 Output (Stage 1)');
hold on;
semilogx(f_vec, mag_total_db, 'r', 'LineWidth', 2, 'DisplayName', 'U2 Output (Total)');

% Styling
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w', 'MinorGridColor', 'w');
grid on;
title('FREQUENCY RESPONSE', 'Color', 'w');
ylabel('GAIN (dB)', 'Color', 'w');
xlim([10 200000]); 
ylim([-20 2]); 

% Check 20kHz point
idx = find(f_vec >= 20000, 1);
val_20k = mag_total_db(idx);
plot(f_vec(idx), val_20k, 'rx', 'MarkerSize', 12, 'LineWidth', 2);
text(20000, val_20k+3, sprintf('  20k: %.2fdB', val_20k), 'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold');

legend('Location', 'southwest', 'TextColor', 'w');

% === BOTTOM SUBPLOT: PHASE RESPONSE ===
subplot(2,1,2);
semilogx(f_vec, ph_total, 'y', 'LineWidth', 2);

% Styling
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w', 'MinorGridColor', 'w');
grid on;
title('PHASE RESPONSE', 'Color', 'w');
ylabel('PHASE (deg)', 'Color', 'w');
xlabel('FREQ (Hz)', 'Color', 'w');
xlim([10 200000]); 
ylim([-180 0]);

% Mark Phase at 20kHz
ph_20k = ph_total(idx);
hold on;
plot(f_vec(idx), ph_20k, 'rx', 'MarkerSize', 12, 'LineWidth', 2);
text(20000, ph_20k+20, sprintf('  Phase: %.1f deg', ph_20k), 'Color', 'y');
