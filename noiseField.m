function noise = noiseField(n, correlationLength, deformationStrength)
    % noiseField Function
    % Purpose: 
    % This function generates a 3D noise field using Gaussian distribution, which can be used for various deformation and simulation purposes.
    % It creates an isotropic Gaussian kernel, applies a Fourier transform to generate a frequency domain representation, and then combines it with white noise to produce the noise field.
    %
    % Inputs:
    % - n: The size of the grid on which the noise field is generated.
    % - correlationLength: Determines the spread of the Gaussian kernel, affecting the correlation of the noise field.
    % - deformationStrength: A scaling factor that controls the intensity of the noise deformation.
    %
    % Output:
    % - noise: The resulting 3D noise field, normalized and scaled as per the input parameters.
    %
    % The function operates by first establishing a 3D grid and computing a Gaussian kernel over this grid. 
    % The Gaussian kernel is then transformed into the frequency domain using the Fast Fourier Transform (FFT). 
    % Subsequently, FFT of random white noise is generated and multiplied with the kernel's FFT, 
    % followed by an inverse FFT to obtain the spatial noise field. 
    % Finally, the noise field is normalized and scaled according to the specified deformation strength.


    % Creating an isotropic Gaussian kernel
    [x, y, z] = ndgrid(linspace(-n/2, n/2, n+1), linspace(-n/2, n/2, n+1), linspace(-n/2, n/2, n+1));
    r = sqrt(x.^2 + y.^2 + z.^2);
    kernel = exp(-(r/correlationLength).^2);
    
    % Fourier transform of the kernel
    kernel_fft = fftn(kernel);
    
    % FFT of white noise
    noise_fft = fftn(randn(n+1, n+1, n+1));
    
    % Multiplication in the frequency domain
    noise = real(ifftn(noise_fft .* kernel_fft));
    
    % Normalization
    noise = noise - min(noise(:));
    noise = 2 * noise / max(noise(:)) - 1;
    noise = deformationStrength * noise;
end
