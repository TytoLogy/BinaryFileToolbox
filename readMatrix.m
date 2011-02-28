function [M, dataFmt] = readMatrix(fp, fmt)
% [M, dataFmt] = readMatrix(fp, fmt)
%
% BinaryFileToolbox
%
% Reads alphanumeric matrix from binary data file in format fmt (optional)
% that was written using writeMatrix.
% 
% Returns data precision in dataFmt
%
% Input Arguments:
% 	
% 	fp		binary file identifier from fopen(), opened in 'r' mode
% 
% 	fmt		binary file format
% 			Optional!  writeMatrix automatically writes a data format
% 			tag in the binary file when it writes data.  Use this option
% 			at your own risk!  See fopen for help on data formats, and 
%			writeMatrix for structure of binary matrix data
%
% Output Arguments:
% 
% 	M		vector of alphanumeric data
% 
%	dataFmt	data format read from binary file (or user-provided 
%			data format)
% 
% 
% See Also: writeMatrix, writeVector, readVector, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	28 Feb 2009 (SJS): file created, adapted from readVector
%	2 Mar 2009 (SJS):
% 		-added in code to read format of data, to match writeMatrix
%	3 Mar 2009 (SJS):
%		-added dataFmt return parameter
%		-modified help info to conform to BinaryFileToolbox format
%--------------------------------------------------------------------------
% TO DO:
%--------------------------------------------------------------------------

% read # of points to read in
id = fread(fp, 1, 'uchar=>char');

if strcmp(id, 'M')
	% read in the data precision format string
	tmpfmt = readString(fp);
	
	% if the user didn't provide a format string, use the one from the file
	if ~exist('fmt')
		fmt = tmpfmt;
	end

	% read # rows and columns from file
	nRows = fread(fp, 1, 'uint32');
	nCols = fread(fp, 1, 'uint32');
	
	% read in the matrix in "linear" fashion (vectorized);
	% 	# of elements will be nRows*nCols
	M = fread(fp, nRows*nCols, fmt);
	
	% reshape the matrix into rows and columns
	M = reshape(M, nRows, nCols);
	dataFmt = fmt;
else
	% warn user if tag mismatch
	warning([mfilename ': invalid matrix id ' id]);
	M = [];
	dataType = [];
end




