function gaussianField = generateGaussianField(gridSize, r_max, x, y, z, noiseField)
    % generateGaussianField Function
    % Purpose: 
    % This function generates a Gaussian field on a 3D grid, based on a provided noise field.
    % It interpolates the noise field over a 3D grid to create a smooth, continuous Gaussian field.
    %
    % Inputs:
    % - gridSize: The size of the grid on which the Gaussian field is to be generated.
    % - r_max: The maximum radius for the grid dimensions, used to define the interpolation range.
    % - x, y, z: Coordinates of the mesh points where the Gaussian field is to be evaluated.
    % - noiseField: The pre-generated noise field, used as the base for generating the Gaussian field.
    %
    % Output:
    % - gaussianField: The resulting 3D Gaussian field interpolated over the specified grid.
    %
    % The function uses cubic spline interpolation to create a smooth Gaussian field from the discrete noise field values.
    % It maps the noise field onto the 3D coordinates (x, y, z) within the specified grid range.
    %
    % Note: The 'spline' interpolation method is used for smoothness, with extrapolation values set to 0.

    gaussianField = interp3(linspace(-r_max, r_max, gridSize+1), ...
                           linspace(-r_max, r_max, gridSize+1), ...
                           linspace(-r_max, r_max, gridSize+1), ...
                           noiseField, ...
                           x, y, z, 'spline', 0);
end