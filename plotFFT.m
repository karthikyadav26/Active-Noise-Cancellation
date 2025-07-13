function plotFFT_centered(x, Fs, plotTitle)
% plotFFT_centered  Plot the full two‐sided amplitude spectrum of a signal in dB,
%                   centered around 0 Hz (i.e., from -Fs/2 to Fs/2)
%
%   plotFFT_centered(x, Fs, plotTitle)
%     x         : time‐domain signal vector
%     Fs        : sampling frequency (Hz)
%     plotTitle : string, title for the plot

    % ensure column vector
    x = x(:);

    % length and zero‐pad to next power of two
    N    = length(x);
    NFFT = 2^nextpow2(N);

    % compute FFT and shift
    X = fftshift(fft(x, NFFT)) / N;

    % frequency vector from -Fs/2 to Fs/2
    f = (-NFFT/2:NFFT/2-1) * (Fs / NFFT);

    % magnitude in dB
    P = 20 * log10(abs(X) + eps);  % eps to avoid log(0)

    % plot
    figure;
    plot(f, P, 'LineWidth', 1.2);
    grid on;
    xlim([-Fs/2 Fs/2]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    title(plotTitle);
end
