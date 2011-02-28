function status = writeMatrix(fp, M, fmt)
%--------------------------------------------------------------------------
% status = writeMatrix(fp, M, fmt)
%--------------------------------------------------------------------------
% BinaryFileToolbox
%--------------------------------------------------------------------------
%
% Writes matrix <M> to binary file stream <fp> in format <fmt>
%
%--------------------------------------------------------------------------
% Input Arguments:
% 	
% 	fp		binary file identifier from fopen()
%
%	M		numerical matrix (array) to write to file
%
% 	fmt		binary file format
%			same as writeVector, see also fopen for details.
%
% Output Arguments:
% 
% 	status	[1X4] array of fwrite() status outputs (diagnostic)
% 
%--------------------------------------------------------------------------
% Data Format:
%  
%  'M'				(uchar)		'M'atrix id character tag
%  '<n><fmt>'		(schar)		n-element long character string fmt 
% 								indicating data precision (written 
% 								with writeString)
%  '<nrows>'		(uint32)	# of rows in matrix
%  '<ncols>'		(uint32)	# of columns in matrix
%  <B>				(fmt)		nrowsXncolumns long matrix M, 
% 								in precision fmt
% 
%--------------------------------------------------------------------------
% See Also: readMatrix, writeVector, readVector, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	28 Feb 2009 (SJS): file created, adapted from writeVector
%	2 Mar 2009 (SJS):
% 		-added in code to write format of data, to match writeVector
%		-modified help info to conform to BinaryFileToolbox format
%	6 November, 2009 (SJS):	added documentation
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize status vector
status = [0 0 0 0 0];

% get size of matrix
[nRows, nCols] = size(M);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% write a character tag indicating a Matrix
status(1) = fwrite(fp, 'M', 'uchar');

% write the data precision string
status(2) = writeString(fp, fmt);

% write number of rows
status(3) = fwrite(fp, nRows, 'uint32');

% write number of columns
status(4) = fwrite(fp, nCols, 'uint32');

% write the matrix
status(5) = fwrite(fp, M, fmt);



