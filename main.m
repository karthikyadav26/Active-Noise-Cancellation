w = load('Golla Karthik Yadav - external_noise.txt');     
y = load('Golla Karthik Yadav - noisy_speech.txt');        
s_clean = load('Golla Karthik Yadav - clean_speech.txt'); %will be used for SNR calculations

%Please dont choose M > batch_size
%The ones chosen below are for the NLMS algorithm
%M = 2;        %gives best snr for given files (trials and error)     
%batch_size = 1200; 
%mu = 0.005;         

%The ones chosen below are for the RLS algorithm
%%M = 5, lamnda = 1, delta = 0.001 gave best results - 33.23dB
%M = 8, lambda = 0.99999, delta = 1e5.
M = 5;
lambda = 0.99999999;
delta = 0.001;

M_p = 5;
lambda_p = 0.99999999;
delta_p = 0.001;
%[s_hat, mse_error] = NLMS(w, y, M, batch_size, mu, 1);
s_hat = Full_Supp(w, y, lambda, delta, M);
%s_hat = VFFRLS(w, y, delta, M, K_alpha, K_beta);
compute_snr = @(clean, noisy) 10 * log10(mean(clean.^2) / mean((noisy - clean).^2));

%any(isnan(s_hat))

snr_unfiltered = compute_snr(s_clean, y);  
snr_filtered  = compute_snr(s_clean, s_hat); 

fprintf('SNR before noise cancellation: %.2f dB\n', snr_unfiltered);
fprintf('SNR after noise cancellation (Full Supression): %.2f dB\n', snr_filtered);

%disp('Playing the estimated clean speech...');
%sound(s_hat,44100);
disp('Writing Full Supression data');
audiowrite('Full_Supression.wav', s_hat, 44100);
 s_hat2 = Partial_Supp(w, y, lambda_p, delta_p, M_p);
% %[s_hat2, mse_error2] = NLMS(w, y, M, batch_size, mu, 0);
% compute_snr = @(clean, noisy) 10 * log10(sum(clean.^2) / sum((noisy - clean).^2));
% 
% %any(isnan(s_hat))
% 
snr_unfiltered_2 = compute_snr(s_clean, y);  
snr_filtered_2  = compute_snr(s_clean, s_hat2); 
% 
fprintf('SNR before noise cancellation: %.2f dB\n', snr_unfiltered_2);
fprintf('SNR after noise cancellation (Partial Supression): %.2f dB\n', snr_filtered_2);
% 
disp('Writing Partial Supression Data');
audiowrite('Partial_Supression.wav', s_hat2, 44100);
audiowrite('Noisy_Speech.wav', y, 44100);
 plotFFT(s_hat, 44100, 'Full Suppression');
 plotFFT(s_hat2, 44100, 'Partial Supression');
 plotFFT(y, 44100, 'Noisy Speech');
