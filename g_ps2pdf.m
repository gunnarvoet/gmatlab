function g_ps2pdf(d,DirPath)

% input: output structure of dir command and path to directory

% will convert all files in the input structure

n = length(d);

for i = 1:n
  
  % name without extension
  FileName = d(i).name;
  ii = strfind(FileName,'.');
  FileExtension = FileName(ii+1:end);
  FileName = FileName(1:ii-1);
  
  fprintf(1,'\n Working on %s \n',FileName);
  
  
  % if file is ps, convert to eps first
  if strcmp(FileExtension,'ps') && ~exist(fullfile(DirPath,[FileName,'.eps']),'file')
    system(sprintf('ps2eps %s',fullfile(DirPath,d(i).name)));
  end
  
   system(sprintf('ps2pdf  -dEPSCrop %s',fullfile(DirPath,[FileName,'.eps'])));
end