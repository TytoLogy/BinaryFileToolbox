function [C, dataType] = readCell(fp)
% [C, dataType] = readCell(fp)
%
% BinaryFileToolbox
%
% Reads cell matrix C from binary data file associated with fid fp
%
% Input Arguments:
% 
% 	fp			binary file identifier from fopen(), opened in 'r' mode
%
% Output Arguments:
% 
% 	C			cell array read from file, [] if error
% 
%	dataType	cell array that stores the data types (precision) 
% 				read from the file.  
% 				For vectors & matrices, this will be equivalent to 
% 				the dataFmt returned by readVector and readMatrix.
% 				For structs and cells, it will be, respectively, 
% 				'struct' and 'cell'.
%
% See Also: writeCell, writeMatrix, readMatrix, readStruct, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	2 Mar 2009 (SJS): file created
%	3 Mar 2009 (SJS):
%		-added dataType return variable
%		-modified help info to conform to BinaryFileToolbox format
%--------------------------------------------------------------------------
% TO DO:
%--------------------------------------------------------------------------


id = fread(fp, 1, 'uchar=>char');

if strcmp(id, 'C')
	
	% read number of rows
	nRows = fread(fp, 1, 'uint32');

	% write number of columns
	nCols = fread(fp, 1, 'uint32');

	nCells = nRows * nCols;
	
	C = cell(nCells, 1);
	dataType = C;
		
	% now loop through the number of cells
	
	for n = 1:nCells
		
		% get the position in the file
		datum_location = ftell(fp);
		
		% read in the datum type
		datum_id = fread(fp, 1, 'uchar=>char');

		% go back to previous position - this is so that we
		% can use the read****() functions that expect to be able
		% read in the datum type
		fseek(fp, datum_location, 'bof');
				
		% invoke the proper read function for the data type
		switch datum_id
			case 'V'
				[C{n}, dataType{n}] = readVector(fp);
			case 'M'
				[C{n}, dataType{n}] = readMatrix(fp);
			case 'S'
				C{n} = readStruct(fp);
				dataType{n} = 'struct';
			case 'C'
				C{n} = readCell(fp);
				dataType{n} = 'cell';
			case 'T'
				C{n} = readString(fp);
				dataType{n} = 'schar';
			otherwise
				error([mfilename ': bad datum type ' datum_id]);
		end
		
	end
	
	% reshape the cell matrix into rows and columns
 	C = reshape(C, nRows, nCols);

	return
else
	% warn user if tag mismatch
	warning([mfilename ': invalid Cell id ' id]);
	C = [];
	dataType = [];
end
