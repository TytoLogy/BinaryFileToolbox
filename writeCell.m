function status = writeCell(fp, C)
% status = writeCell(fp, C)
%
% BinaryFileToolbox
%
% Writes cell (vector or array) C to binary data file
% 
% Input Arguments:
% 	
% 	fp		binary file identifier from fopen()
%
%	C		nXm cell array to write to file
%
% Output Arguments:
% 
% 	status	1X4 array (diagnostic)
% 
% Data Format:
%  
%  'C'				(uchar)		'C'ell id character tag
%  '<nrows>'		(uint32)	# of rows in cell array
%  '<ncols>'		(uint32)	# of columns in cell array
%
%	then, looping through 1:nrows*ncols:
% 
%  '<n><fieldname>'		(uchar)	string (writeVector) that is name of field
%  '<tag><fielddata>'	(var)	either Matrix, Cell, or Struct
% 
% See Also: readCell, writeMatrix, readMatrix, writeStruct, readStruct,
%			readVector, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	2 Mar 2009 (SJS): function created
%		- this is a combination of writeMatrix and writeStruct. mostly.
%	3 Mar 2009 (SJS):
%		- fixed problem of writing matrix vs. vector. hopefully!
%		  solution: just write matrices.
%		-modified help info to conform to BinaryFileToolbox format
%--------------------------------------------------------------------------
% TO DO:
%--------------------------------------------------------------------------

% make sure C is a cell
if ~iscell(C)
	status = -1;
	warning([mfilename ': input is not a cell array!']);
	return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize status vector
status = [0 0 0 0];
% get size of cell array
[nRows, nCols] = size(C);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% write a character tag indicating a Cell
status(1) = fwrite(fp, 'C', 'uchar');

% write number of rows
status(2) = fwrite(fp, nRows, 'uint32');

% write number of columns
status(3) = fwrite(fp, nCols, 'uint32');

nCells = nRows * nCols;

% write the cells
for cellIndex = 1:nCells
	
	% Check type of datum and write accordingly!

	if isempty(C{cellIndex})
		s = writeVector(fp, C{cellIndex}, 'uchar');
		status(4) = status(4) + 1;

	% Structure
	elseif isa(C{cellIndex}, 'struct')
		s = writeStruct(fp, C{cellIndex});
		status(4) = status(4) + 1;

	% Cell
	elseif isa(C{cellIndex}, 'cell')
		s = writeCell(fp, C{cellIndex});
		status(4) = status(4) + 1;
		
	% Matrix or Vector - for simplicity, write all as matrix
	elseif isvector(C{cellIndex}) | min(size(C{cellIndex})) > 1
		% check for data type
		if isa(C{cellIndex}, 'char')
			outFmt = 'schar';
		elseif isa(C{cellIndex}, 'integer')
			outFmt = 'int64';
		elseif isa(C{cellIndex}, 'single')
			outFmt = 'single';
		elseif isa(C{cellIndex}, 'double')
			outFmt = 'double';
		else
			disp([mfilename ': ' sprintf('C{%s}', cellIndex) ' is unknown data format']);
			disp('Using schar format...');
			outFmt = 'schar';
		end
		s = writeMatrix(fp, C{cellIndex}, outFmt);
		status(4) = status(4) + 1;
		
	% error, unsupported type
	else
		error([mfilename ': ' sprintf('C{%d}', cellIndex) ' is unknown type!!!']);
	end

end


