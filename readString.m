function T = readString(fp)
% T = readString(fp, fmt)
%
% BinaryFileToolbox
%
% Reads schar vector from binary data file, written by writeString
% 
% Input Arguments:
% 	
% 	fp		binary file identifier from fopen(), opened as 'r' 
% 
% Output Arguments:
% 
% 	T		schar string read from file, empty if error
% 
% See Also: writeString, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	2 Mar 2009 (SJS): file created
%	3 Mar 2009 (SJS):
%		-added code to read tag 'T' for consistency with toolbox
%		-modified help info to conform to BinaryFileToolbox format
%--------------------------------------------------------------------------
% TO DO:
%--------------------------------------------------------------------------

% read in the data id
id = fread(fp, 1, 'uchar=>char');

if strcmp(id, 'T')
	% read # of points to read in
	npts = fread(fp, 1, 'uint8');
	T = fread(fp, npts, 'schar=>char')';
else
	warning([mfilename ': invalid string id ' id]);
	T = [];
end
