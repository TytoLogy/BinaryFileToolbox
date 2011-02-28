function status = writeStruct(fp, S, Sname)
%--------------------------------------------------------------------------
% status = writeStruct(fp, S, Sname)
%--------------------------------------------------------------------------
% BinaryFileToolbox
%--------------------------------------------------------------------------
%
% Writes structure S to binary data file, saving the struct name as Sname
% 
%--------------------------------------------------------------------------
% Input Arguments:
% 	
% 	fp		binary file identifier from fopen()
%
%	S		structure to write to file
%
% 	Sname	(optional)
%			string name for structure
%
% Output Arguments:
% 
% 	status	# of fields written to file
% 
%--------------------------------------------------------------------------
% Data Format:
%  
%  'S'				(uchar)		'S'tructure id character tag
%  '<n><Sname>'		(uchar)		name of structure (either from input
% 								Sname or from name of S passed 
% 								to writeStruct), written with writeVector
%  '<numfields>'	(uint32)	# of fields in structure
%
%	then, looping through 1:numfields:
% 
%  '<n><fieldname>'		(uchar)	string (writeVector) that is name of field
%  '<tag><fielddata>'	(var)	either Matrix, Cell, or Struct
%  
%--------------------------------------------------------------------------
% See Also: readStruct, writeMatrix, readMatrix, writeString,
%	 			writeCell, fopen, fwrite, BinaryFileToolbox
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	6 Feb 2009 (SJS): file created
%	2 Mar 2009 (SJS): finished write commands
%	3 Mar 2009 (SJS): 
%		-changed writing of data as vectors to writing as matrices.
%		 This is for simplicity - all vectors are matrices anyhow!
%		-modified help info to conform to BinaryFileToolbox format
%	19 June, 2009 (SJS): fixed call format to writeCell
%	6 November, 2009 (SJS):	added documentation
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some checks, balances and setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make sure S is a struct
if ~isstruct(S)
	status = -1;
	warning([mfilename ': input is not a structure!']);
	return
end

% If Sname is not given, get the structure name from the input variable
if nargin == 2
	Sname = inputname(2);
end

% get the names of the fields (F will be a cell array of strings)
F = fieldnames(S);

% check that we have some fields
numfields = length(F);
if numfields == 0
	status = -1;
	warning([mfilename ': empty structure ' Sname]);
	return
end

% get the values for each field as a cell array
V = struct2cell(S);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now, write structure to file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% write a character tag indicating a Structure
s = fwrite(fp, 'S', 'uchar');

% write structure name
s = writeVector(fp, Sname, 'uchar');

% write number of fields in structure
s = fwrite(fp, numfields, 'uint32');

% now loop through the fields 

for n = 1:numfields
	
	% write fieldname
	s = writeVector(fp, F{n}, 'uchar');
	
	% now check for data type, write all vectors as matrices for simplicity
	if isa(V{n}, 'char')
		s = writeMatrix(fp, V{n}, 'schar');
	elseif isa(V{n}, 'integer')
		s = writeMatrix(fp, V{n}, 'int64');
	elseif isa(V{n}, 'single')
		s = writeMatrix(fp, V{n}, 'single');
	elseif isa(V{n}, 'double')
		s = writeMatrix(fp, V{n}, 'double');
	elseif isa(V{n}, 'struct')
		s = writeStruct(fp, V{n}, F{n});
	elseif isa(V{n}, 'cell')
% 		s = writeCell(fp, V{n}, F{n});
		s = writeCell(fp, V{n});
	else
		disp([sprintf('%s', V{n}) ' is unknown type']);
		s = writeMatrix(fp, V{n}, 'schar');
	end
	
end

status = numfields;

