function [geo,imgRGB] = genObj(params,meta)
    % genObj Function
    % Purpose: 
    % This function generates a 3D geometric object and its corresponding RGB image.
    % It uses parameters and metadata to create and deform a mesh, which is then used to render a graphical object.
    %
    % Inputs:
    % - params: A vector containing parameters for scaling and deformation.
    % - meta: Metadata that includes mesh resolutions and texture details.
    %
    % Outputs:
    % - geo: A struct containing the x, y, z coordinates of the deformed mesh and the deformation values.
    % - imgRGB: An RGB image of the rendered object.
    %
    % The function performs the following steps:
    % 1. Extracts visualization settings and mesh parameters from the inputs.
    % 2. Creates an ellipsoidal mesh based on the specified dimensions.
    % 3. Calculates the normals of the mesh for deformation.
    % 4. Applies Gaussian field-based deformations to the mesh using specified strengths and correlation lengths.
    % 5. Renders the deformed mesh as a 3D figure and captures it as an RGB image.
    %
    % Note: The function assumes specific formatting for the 'params' and 'meta' inputs.



    % Extraction des paramètres
    visible = 'on';
    n = meta(1);
    n_global = meta(2);
    n_texture = meta(3);
    scaleFactor = params(1);
    rx = 1;
    ry = params(2);
    rz = params(2);
    deformationStrength1 = params(3);
    longueurCorrelation1 = params(4);
    deformationStrength2 = params(5);
    longueurCorrelation2 = params(6);
    
    % Créer la sphère (ellipsoïde)
    [x, y, z] = sphere(n);
    x = rx * x;
    y = ry  * y;
    z = rz * z;
    
    % Calculer les normales
    normals = cat(3, x, y, z);
    normals = normals ./ sqrt(sum(normals.^2, 3));
    
    % Taille de la grille
    r_max = max([rx, ry, rz]);
    
    % Combinaison des deux champs gaussiens
    NF1 = noiseField(n_global, longueurCorrelation1, deformationStrength1);
    NF2 = noiseField(n_texture, longueurCorrelation2, deformationStrength2);
    deformations = generateGaussianField(n_global, r_max, x, y, z, NF1) ...
                 + generateGaussianField(n_texture, r_max, x, y, z, NF2);
    
    % Déformation selon les normales
    deformationNormals = bsxfun(@times, deformations, normals);
    x = x + deformationNormals(:,:,1);
    y = y + deformationNormals(:,:,2);
    z = z + deformationNormals(:,:,3);
    
    
    x = scaleFactor*x;
    y = scaleFactor*y;
    z = scaleFactor*z;
    
    geo.x = x;
    geo.y = y;
    geo.z = z;
    geo.deformations = deformations;
    
    
    f = figure('Position', [100, 100, 250, 250], 'Visible', visible);
    h = surf(x, y, z, deformations*100, 'EdgeColor', 'b');
    colormap(.2+.8*gray()); % jet, hot, bone
    shading interp
    lightangle(60,60)
    h.FaceLighting = 'gouraud';
    h.AmbientStrength = 0.324685;
    h.DiffuseStrength = 1.0;
    h.SpecularStrength = 0.215;
    h.SpecularExponent = 2.125;
    h.BackFaceLighting = 'unlit';
    axis equal;
    axis off
    hold on
    ax = gca;
    ax.Color = [0 0 0];
    
    frame = getframe(gcf);
    imgRGB = imresize(frame2im(frame),scaleFactor);
    
    % close(f)

end




