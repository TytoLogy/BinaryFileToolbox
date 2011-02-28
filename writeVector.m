function status = writeVector(fp, V, fmt)
%--------------------------------------------------------------------------
% status = writeVector(fp, V, fmt)
%--------------------------------------------------------------------------
% BinaryFileToolbox
%--------------------------------------------------------------------------
%
% Writes vector <V> to binary file stream <fp> in format <fmt>
%
% Note that write/readMatrix may also be used, but that readMatrix
% CANNOT read in vectors.
%
%--------------------------------------------------------------------------
% Input Arguments:
% 	
% 	fp			binary file identifier from fopen()
% 
% 	V			numerical vector to write to file
% 				note that writeVector does not care if the vector is 
% 				row or column format and does not check if the vector is a
% 				matrix - calling writeVector with an NXM vector V will lead
% 				to unpredictable results; in this situation, you should use
%				writeMatrix.
% 
% 	fmt			binary file format
% 
% 		from FREAD():
% 
% 		Any of the following strings, either the MATLAB version, or 
% 		 their C or Fortran equivalent, may be used.  If not specified, 
% 		 the default precision is 'uchar'.
% 			  MATLAB    C or Fortran     Description
% 			  'uchar'   'unsigned char'  unsigned character,  8 bits.
% 			  'schar'   'signed char'    signed character,  8 bits.
% 			  'int8'    'integer*1'      integer, 8 bits.
% 			  'int16'   'integer*2'      integer, 16 bits.
% 			  'int32'   'integer*4'      integer, 32 bits.
% 			  'int64'   'integer*8'      integer, 64 bits.
% 			  'uint8'   'integer*1'      unsigned integer, 8 bits.
% 			  'uint16'  'integer*2'      unsigned integer, 16 bits.
% 			  'uint32'  'integer*4'      unsigned integer, 32 bits.
% 			  'uint64'  'integer*8'      unsigned integer, 64 bits.
% 			  'single'  'real*4'         floating point, 32 bits.
% 			  'float32' 'real*4'         floating point, 32 bits.
% 			  'double'  'real*8'         floating point, 64 bits.
% 			  'float64' 'real*8'         floating point, 64 bits.
% 
% 		 The following platform dependent formats are also supported but
% 		 they are not guaranteed to be the same size on all platforms.
% 
% 			  MATLAB    C or Fortran     Description
% 			  'char'    'char*1'         character,  8 bits (signed or unsigned).
% 			  'short'   'short'          integer,  16 bits.
% 			  'int'     'int'            integer,  32 bits.
% 			  'long'    'long'           integer,  32 or 64 bits.
% 			  'ushort'  'unsigned short' unsigned integer,  16 bits.
% 			  'uint'    'unsigned int'   unsigned integer,  32 bits.
% 			  'ulong'   'unsigned long'  unsigned integer,  32 bits or 64 bits.
% 			  'float'   'float'          floating point, 32 bits.					
% 					
% 
% Output Arguments:
% 
% 	status		[1X3] array of fwrite() status outputs (diagnostic)
% 
%--------------------------------------------------------------------------
% Data Format:
%  
%  'V'				(uchar)		'V'ector id character tag
%  '<n><fmt>'		(schar)		n-element long character string indicating data precision
%  '<nelements>'	(uint32)	# of elements in vector
%  <V>				(fmt)		nelements long vector V, in precision fmt
% 
%--------------------------------------------------------------------------
% See Also: readVector, writeMatrix, readMatrix, fopen, fwrite
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
%	5 Feb 2009 (SJS): file created
%	28 Feb 2009 (SJS): 
% 		-added info to help
% 		-added character tag 'V' to precede vector to indicate data format
%	2 Mar 2009 (SJS): 
%		-added writing of data format string to file
%	3 Mar 2009 (SJS):
%		-changed handling of empty vectors or non-vectors (error)
%		-modified help info to conform to BinaryFileToolbox format
%	6 November, 2009 (SJS):	added documentation
%--------------------------------------------------------------------------

status = [0 0 0 0];	

% check to see if variable is a vector, if so write to disk
if isvector(V)
	% write a character tag indicating a vector
	status(1) = fwrite(fp, 'V', 'uchar');
	% write the data precision string
	status(2) = writeString(fp, fmt);
	% Write the data, giving the # of points first
	status(3) = fwrite(fp, length(V), 'uint32');
	status(4) = fwrite(fp, V, fmt);
	return
	
% check if empty value
elseif isempty(V)
	% write a character tag indicating a vector
	status(1) = fwrite(fp, 'V', 'uchar');
	% write the data precision string
	status(2) = writeString(fp, fmt);
	% Write the data, giving the # of points first
	status(3) = fwrite(fp, length(V), 'uint32');
	status(4) = fwrite(fp, V, fmt);
	return
	
else
	% dimensions are not 1XN or NX1 so return an error
	error([mfilename ': datum to write is not NX1 or 1XN !']);
end

