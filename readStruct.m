function [S, Sname, V, F] = readStruct(fp)
%--------------------------------------------------------------------------
% [S, Sname, V, F] = readStruct(fp)
%--------------------------------------------------------------------------
% BinaryFileToolbox
%--------------------------------------------------------------------------
%
% Reads structure S from binary data file associated with fid fp
% 
%--------------------------------------------------------------------------
% Input Arguments:
% 	fp		binary file identifier from fopen(), opened in 'r' mode
%
% Output Arguments:
% 	S			structure read from file, [] if error
% 
% 	Sname		structure name read from file, [] if error
% 
% 	V			cell array of structure field values read from file
% 	F			cell array of structure field names
%
%--------------------------------------------------------------------------
% See Also: writeStruct, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	2 Mar 2009 (SJS): file created
%	3 Mar 2009 (SJS):
%		-modified help info to conform to BinaryFileToolbox format
%	4 December, 2009 (SJS): updated format of help/documentation
%--------------------------------------------------------------------------
% TO DO:
%--------------------------------------------------------------------------


id = fread(fp, 1, 'uchar=>char');

if strcmp(id, 'S')
	
	% read the structure name
	Sname = readVector(fp, 'uchar=>char')';
	
	% read number of fields in structure
	numFields = fread(fp, 1, 'uint32');
	
	% allocate fields (F) and values (V) cell vectors.  
	% these will be used to create the structure using cell2struct
	F = cell(numFields, 1);
	V = F;
	
	% now loop through the number of fields
	for n = 1:numFields

		% read the fieldname
		F{n} = readVector(fp, 'uchar=>char')';
		
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
				V{n} = readVector(fp);
			case 'M'
				V{n} = readMatrix(fp);
			case 'S'
				V{n} = readStruct(fp);
			case 'C'
				V{n} = readCell(fp);
			case 'T'
				V{n} = readString(fp);
			otherwise
				error([mfilename ': bad datum type ' datum_id]);
		end
		
	end
	
	S = cell2struct(V, F);

	return
else
	% warn user if tag mismatch
	warning([mfilename ': invalid Structure id ' id]);
	S = [];
	Sname = [];
	V = [];
	F = []
end
