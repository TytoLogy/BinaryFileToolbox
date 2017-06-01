function [V, dataFmt] = readVector(fp, fmt)
% [V, dataFmt] = readVector(fp, fmt)
%
% BinaryFileToolbox
%
% Reads alphanumeric vector from binary data file in format fmt (optional)
% that was written to file using writeVector.
%
% Returns data precision in dataFmt (if fmt was not specified)
% 
% Input Arguments:
% 	
% 	fp		binary file identifier from fopen(), opened in 'r' mode
% 
% 	fmt		binary file format
% 			Optional!  writeVector automatically writes a data format
% 			tag in the binary file when it writes data.  Use this option
% 			at your own risk!  See fopen for help on data formats, and 
%			writeVector for structure of binary data
%
% Output Arguments:
% 
% 	V		vector of alphanumeric data
% 
%	dataFmt	data format read from binary file (or user-provided 
%			data format)
% 
% See Also: writeVector, writeArray, readArray, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbhag@neomed.edu
%--------------------------------------------------------------------------
% Revision History
%	5 Feb 2009 (SJS): file created
%	28 Feb 2009 (SJS): 
% 		-made changes to account for changes is data format
%		 in writeVector()
%	2 Mar 2009 (SJS):
% 		-added in code to read format of data, to match writeVector
%	3 Mar 2009 (SJS):
%		-added dataFmt return parameter
%		-modified help info to conform to BinaryFileToolbox format
%	11 Jul 016 (SJS):
%		- updated email address
%	1 Jun 2017 (SJS): added check for eof
%--------------------------------------------------------------------------
% TO DO:
%--------------------------------------------------------------------------

% check for eof
if feof(fp)
	warning([mfilename ': end of file!']);
	V = [];
	dataFmt = [];
	return
end

% read in the data id
id = fread(fp, 1, 'uchar=>char');

if strcmp(id, 'V')
	% read in the data precision format string
	tmpfmt = readString(fp);
	% if the user didn't provide a format string, use the one from the file
	if ~exist('fmt')
		fmt = tmpfmt;
	end
	% read # of points to read in
	npts = fread(fp, 1, 'uint32');
	V = fread(fp, npts, fmt);
	dataFmt = fmt;
else
	warning([mfilename ': invalid vector id ' id]);
	V = [];
	dataFmt = [];
end




