function r_estimated = my_chradiiphcode(varargin)
%CHRADIIPHCODE Estimate circle radius for Circular Hough Transform using the Phase-Coding method
%   R_ESTIMATED = CHRADIIPHCODE(CENTERS, H, R) takes a two-column array CENTERS,
%   which contains the x (first column) and y (second column) coordinates
%   of the center locations, as input. It returns a vector R_ESTIMATED, which
%   contains the estimated radius value for each center and is the same
%   length as the number of rows in CENTERS. H is the complex accumulator
%   array (computed using CHACCUM) used for estimating the radius
%   values. If H is real, a warning is generated by the function and
%   the output radius vector R_ESTIMATED contains all zeros.
% 
%   The Phase-Coding method estimates radius by decoding the phase
%   information in the complex accumulator array. CHRADIIPHCODE expects the
%   accumulator array H to be computed by Phase Coding method in CHACCUM or
%   any similar method. For details on Phase-Coding, see [1].
% 
% See also CHACCUM, CHCENTERS, CHRADII, IMFINDCIRCLES, VISCIRCLES.

%   Copyright 2011 The MathWorks, Inc.
 
%   References: 
%   -----------
%   [1] T. J. Atherton, D. J. Kerbyson, "Size invariant circle detection,"
%       Image and Vision Computing, Volume 17, Number 11, 1999, pp. 795-803.

parsedInputs = parse_inputs(varargin{:});

centers            = parsedInputs.Centers;
accumMatrix        = parsedInputs.AccumArray; 
radiusRange        = parsedInputs.RadiusRange;

%% Check if accumulator array is complex
if (isreal(accumMatrix))
    warning(message('images:imfindcircles:realAccumArrayForPhaseCode'));
end

%% Decode the phase to get the radius estimate
cenPhase = angle(accumMatrix(sub2ind(size(accumMatrix),round(centers(:,2)),round(centers(:,1)))));
lnR = log(radiusRange);
r_estimated = exp(((cenPhase + pi)/(2*pi)*(lnR(end) - lnR(1))) + lnR(1)); % Inverse of modified form of Log-coding from Eqn. 8 in [1]

end

function parsedInputs = parse_inputs(varargin)

narginchk(3,3);

persistent parser;

if(isempty(parser))
    parser = inputParser();

    parser.addRequired('Centers',@checkCenters);
    parser.addRequired('AccumArray',@checkAccumArray);
    parser.addRequired('RadiusRange',@checkRadiusRange);
end

% Parse input
parser.parse(varargin{:});
parsedInputs = parser.Results;

validateCenters();

parsedInputs.RadiusRange = double(parsedInputs.RadiusRange);

    function tf = checkCenters(centers)
        validateattributes(centers,{'numeric'},{'nonsparse','real','positive', ...
            'nonempty','ncols',2}, mfilename,'centers',1);        
        tf = true;
    end

    function tf = checkAccumArray(accumMatrix)
        validateattributes(accumMatrix,{'numeric'},{'nonempty',...
            'nonsparse','2d'},mfilename,'H',2);
        tf = true;
    end

    function tf = checkRadiusRange(radiusRange) % Radius range has to be a 2-element vector with r(2) > r(1)
        validateattributes(radiusRange,{'numeric'},{'nonnan','nonsparse',...
            'integer','positive','finite','vector','numel',2},...
            mfilename,'R',3);
        if (length(radiusRange) > 2)
            error(message('images:imfindcircles:unrecognizedRadiusRange'));
        end
        if (radiusRange(1) >= radiusRange(2))
            error(message('images:imfindcircles:invalidRadiusRange'));
        end
        tf = true;
    end

    function validateCenters
        if (~(all(parsedInputs.Centers(:,1) <= size(parsedInputs.AccumArray,2)) && ...
              all(parsedInputs.Centers(:,2) <= size(parsedInputs.AccumArray,1))))
            error(message('images:imfindcircles:outOfBoundCenters'));
        end
    end
    
end