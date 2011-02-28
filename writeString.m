function status = writeString(fp, T)
%--------------------------------------------------------------------------
% status = writeString(fp, T)
%--------------------------------------------------------------------------
% BinaryFileToolbox
%--------------------------------------------------------------------------
%
% Writes string <T> to binary file stream <fp>
% 
% Uses schar format:
% 			  MATLAB    C or Fortran     Description
% 			  'schar'   'signed char'    signed character,  8 bits. 					
% 
%--------------------------------------------------------------------------
% Input Arguments:
% 	
% 	fp			binary file identifier from fopen(), opened as 'w'
% 
% 	T			String to write to file
% 
% 
% Output Arguments:
% 
% 	status		status output (diagnostic)
% 
%--------------------------------------------------------------------------
% Data Format:
%  
%  'T'				(uchar)		s'T'ring id character tag
%  '<n>'			(uint8)		length of string
%  <T>				(schar)		n characters-long string T, as schar
% 
%--------------------------------------------------------------------------
% See Also: readString, writeVector, readVector, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	2 Mar 2009 (SJS): file created
%	3 Mar 2009 (SJS):
%		-added tag 'T' to data format for consistency with toolbox
%		-modified help info to conform to BinaryFileToolbox format
%--------------------------------------------------------------------------
% TO DO:
%--------------------------------------------------------------------------

status = 0;

% write a character tag indicating a sTring
status = fwrite(fp, 'T', 'uchar');

% write the character string, first giving the length of the string
status = fwrite(fp, length(T), 'uint8');
status = status + fwrite(fp, T, 'schar');
