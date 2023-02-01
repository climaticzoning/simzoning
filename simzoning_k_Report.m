% This script generates a Report containing the main outputs of simzoning
% Loading imput variables
load ImputVariables.mat
% loading table with weather data
load weatherfilestable
% Formating table
weatherfilestable=Formattable(weatherfilestable);

%%Report settings
makeDOMCompilable()
import mlreportgen.report.*
import mlreportgen.dom.*

fprintf('Name of the report and the report output folder \n');

if interpolation_method==1 && Macrozones_divisions==1
    NameofReport=char(strcat(CaseStudy,'_ANN_MacrZ_Report'));
    CaseStudy_output_folder=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/',NameofReport,'.pdf'));
    CaseStudy_output_f=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/'));
elseif interpolation_method==1 && Macrozones_divisions==0
    NameofReport=char(strcat(CaseStudy,'_ANN_Report'));
    CaseStudy_output_folder=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/',NameofReport,'.pdf'));
    CaseStudy_output_f=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/'));
elseif interpolation_method==2 && Macrozones_divisions==1
    NameofReport=char(strcat(CaseStudy,'_AltLatLon_MacrZ_Report'));
    CaseStudy_output_folder=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/',NameofReport,'.pdf'));
    CaseStudy_output_f=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/'));
elseif interpolation_method==2 && Macrozones_divisions==0
    NameofReport=char(strcat(CaseStudy,'_AltLatLon_Report'));
    CaseStudy_output_folder=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/',NameofReport,'.pdf'));
    CaseStudy_output_f=char(strcat('./Outputs/',CaseStudy,'_CaseStudy/'));
end
nor=strcat(NameofReport,'\n');
fprintf(nor);

% Report name and format
rpt = Report(NameofReport,'pdf');
% output folder
rpt.OutputPath=CaseStudy_output_folder;

fprintf('Setting title page \n');
% title
titlepg = TitlePage;
titlepg.Title = 'Performance based Climatic zoning';
% Subtitle
titlepg. Subtitle=CaseStudy;
titlepg.Author = 'Automatically generated by Simzoning';
% Image of the first page
titlepg.Image='Figures\BoundaryConditions\portada.png';
add(rpt,titlepg);
add(rpt,TableOfContents);

%% %%  CHAPTER I Climatic zoning results
fprintf('- Setting climatic zoning results Chapter \n');
cd Figures/Clusters
ch1=Chapter;
% Title of this chapter
ch1.Title=Text('Climatic zoning results');
% Font settings
ch1.Title.FontFamilyName='Trebuchet';
ch1.Title.FontSize='12pt';
ch1.Title.Bold='True';
ch1.Title.Color='black';

sec1=Section;
sec1.Title = Text('Clustering results');
text = Text('This report presents a performance-based approach for climatic zoning relying on the intensive use of archetypes, building performance simulation, and GIS. The document was automatically generated by Simzoning, a MATLAB-Based Climatic Zoning Tool. Further details regarding the principles adopted in this study can be found in (Walsh, Cóstola, & Labaki, 2018)(Walsh, Cóstola, & Labaki, 2019). This chapter contains a graphical representation of climatic zoning results considering a set of zoning numbers defined by the user.');
% Font settings
text.Italic='true';
text.FontSize='10pt';
text.FontFamilyName='Trebuchet';
text.Style = {OuterMargin("0pt", "0pt","15pt","15pt")};
add(sec1,text)

fprintf('Reading and adding images of clustering results\n'); 
S=dir(fullfile('*.png '));
S=natsortfiles(S);
if numel(S)==0
    fprintf('No image found in the folder\n');
else
    for y=1:length(S)
        caption=S(y).name(1:end-4);
        add(sec1,FormalImage('Image',which(S(y).name),'Caption',caption));
        fignumber=char(strcat( 'Figure',{' '},num2str(y),'/',num2str(length(S)), {' '},'successfully added\n'));
        fprintf(fignumber);
    end
    fprintf('All clustering figures successfully added \n');
 end

cd (mainProjectFolder)

% adding section to chapter
add(ch1,sec1);
fprintf('Section 1 successfully added to Chapter 1 \n');
fprintf('Adding Chapter 1 to report \n');
append(rpt,ch1)

%% CHAPTER II Climatic zoning methods for comparison
if AlternativeMethod_for_comparison==1
    fprintf('- Setting Alternative methods for comparison Chapter\n');
    ch2=Chapter;
    ch2.Title=Text('Alternative methods for comparison');
    ch2.Title.FontFamilyName='Trebuchet';
    ch2.Title.FontSize='12pt';
    ch2.Title.Bold='True';
    ch2.Title.Color='black';
    sec1=Section;
    % Section title
    sec1.Title = Text('Alternative methods for comparison');
    cd Figures\CZ_Methods_Comparison\
    
    fprintf('Reading and adding figures of alternative methods for comparison\n');
    S=dir(fullfile('*.png '));
    S=natsortfiles(S);
  if numel(S)==0
    fprintf('No image found in the folder\n');
  else
     for y=1:length(S)
        caption=S(y).name(1:end-4);
        add(sec1,FormalImage('Image',which(S(y).name),'Caption',caption));
        fignumber=char(strcat( 'Figure',{' '},num2str(y),'/',num2str(length(S)), {' '},'successfully added\n'));
        fprintf(fignumber);
      end
       fprintf('All alternative methods for comparison figures successfully added \n');
   end
   
    cd (mainProjectFolder)
    %Adding section to chapter
    fprintf('Adding first section to Chapter 2 \n');
    add(ch2,sec1)
    fprintf('Adding Chapter 2 to report \n');
append(rpt,ch2)
end

%% %%  CHAPTER III  results
fprintf('- Setting MPMA results Chapter\n');
ch3=Chapter;
% title of this chapter
ch3.Title=Text('MPMA results');
% Font settings
ch3.Title.FontFamilyName='Trebuchet';
ch3.Title.FontSize='12pt';
ch3.Title.Bold='True';
ch3.Title.Color='black';
% Section 1
sec1=Section;
sec1.Title = Text('MPMA results using centroids method');
cd Figures\MPMA\

fprintf('Reading and adding MPMA figures \n');
S=dir(fullfile('*.png '));
S=natsortfiles(S);
if numel(S)==0
    fprintf('No image found in the folder\n');
  else
     for y=1:length(S)
    caption=S(y).name(1:end-4);
    add(sec1,FormalImage('Image',which(S(y).name),'Caption',caption));
    fignumber=char(strcat( 'Figure',{' '},num2str(y),'/',num2str(length(S)), {' '},'successfully added\n'));
     fprintf(fignumber);
   end
    fprintf('All MPMA figures successfully added \n');
end
% If there MPMA using the centroid method is equal to zero, this expression
% would be displayed
if Calculate_MPMA==1 && sum(MPMA_centroides)==0
    text = Text('MPMA calculated with the centroid method = 0');
    fprintf('MPMA calculated with the centroid method = 0\n')
    text.Italic='true';
    text.FontSize='10pt';
    text.FontFamilyName='Trebuchet';
    text.Style = {OuterMargin("0pt", "0pt","15pt","15pt")};
    add(sec1,text)
    fprintf('MPMA text successfully added \n');
end

cd (mainProjectFolder)
fprintf('Adding first section to Chapter 3 \n');
add(ch3,sec1)
fprintf('Adding Chapter 3 to report \n');
append(rpt,ch3)

%% Chapter V Interpolation
if Interpolation==1
  fprintf('- Setting Interpolation Chapter \n');
    if interpolation_method==1
        InterpolationMethod=char(strcat('Interpolation using ANN method'))
    elseif interpolation_method==2
        InterpolationMethod=char(strcat('Interpolation using Weighted interpolation of nearby points'))
    end
    
    cd Figures/Interpolation
    ch4 = Chapter;
    ch4.Title=Text(InterpolationMethod);
    ch4.Title.FontFamilyName='Trebuchet';
    ch4.Title.FontSize='12pt';
    ch4.Title.Bold='True';
    ch4.Title.Color='black';
    sec1 = Section;
    sec1.Title = Text('Grid used for interpolation');
    sec1.Title.FontFamilyName='Trebuchet';
    sec1.Title.FontSize='12pt';
    sec1.Title.Bold='True';
    sec1.Title.Color='black';
    S=dir(fullfile('*Regular grid_elevation.png '));
    S=natsortfiles(S);
    fprintf('Reading and adding figures of grids used for interpolation \n');

   if numel(S)==0
      fprintf('No image found in the folder\n');
   else
     for y=1:length(S)
      caption=S(y).name(1:end-4);
      add(sec1,FormalImage('Image',which(S(y).name),'Caption',caption));
      fignumber=char(strcat( 'Figure',{' '},num2str(y),'/',num2str(length(S)), {' '},'successfully added\n'));
      fprintf(fignumber);
     end
    fprintf('All figures successfully added \n');
   end
    fprintf('Adding Section: Interpolated performance maps \n');
    sec2 = Section;
    sec2.Title = Text('Interpolated performance maps');
    sec2.Title.FontFamilyName='Trebuchet';
    sec2.Title.FontSize='12pt';
    sec2.Title.Bold='True';
    sec2.Title.Color='black';
       
    fprintf('Reading and adding Performance maps figures \n');
     S=dir(fullfile('*Perform*.png '));
     S=natsortfiles(S);
     if numel(S)==0
         fprintf('No image found in the folder\n');
     else
         for y=1:length(S)
             caption=S(y).name(1:end-4);
             add(sec2,FormalImage('Image',which(S(y).name),'Caption',caption));
             fignumber=char(strcat( 'Figure',{' '},num2str(y),'/',num2str(length(S)), {' '},'successfully added\n'));
             fprintf(fignumber);
         end
         fprintf('All Performance maps figures successfully added \n');
     end
     fprintf('Adding first section to Chapter 4 \n');
     add(ch4,sec1)
     fprintf('Adding second section to Chapter 4 \n');
     add(ch4,sec2)
     fprintf('Adding Chapter 4 to report \n');
     append(rpt,ch4)
  end

%% Chapter VI Performance maps of ramdom models for Quality Control
cd ..
cd QualityControl
fprintf('- Setting Quality Control Chapter \n');
ch5 = Chapter;
ch5.Title=Text('Performance maps');
ch5.Title.FontFamilyName='Trebuchet';
ch5.Title.FontSize='12pt';
ch5.Title.Bold='True';
ch5.Title.Color='black';
sec1 = Section;
sec1.Title = Text('Performance maps for quality control');
sec1.Title.FontFamilyName='Trebuchet';
sec1.Title.FontSize='12pt';
sec1.Title.Bold='True';
sec1.Title.Color='black';
fprintf('Reading and adding Quality control figures \n');
S=dir(fullfile('*.png '));
S=natsortfiles(S);
if numel(S)==0
    fprintf('No image found in the folder\n');
else
    for y=1:length(S)
        caption=S(y).name(1:end-4);
        add(sec1,FormalImage('Image',which(S(y).name),'Caption',caption));
        fignumber=char(strcat( 'Figure',{' '},num2str(y),'/',num2str(length(S)), {' '},'successfully added\n'));
        fprintf(fignumber);
    end
    fprintf('All figures successfully added \n');
end
fprintf('Adding first section to Chapter 5 \n');
add(ch5,sec1)
fprintf('Adding Chapter 5 to report \n');
append(rpt,ch15)


%%  %%  CHAPTER VI Climatic boundary conditions
%
cd ..
cd(mainProjectFolder)
cd Figures\BoundaryConditions\
fprintf('- Setting Climatic boundary conditions Chapter \n');
ch6 = Chapter;
ch6.Title=Text('Synthesis of climatic boundary conditions');
ch6.Title.FontFamilyName='Trebuchet';
ch6.Title.FontSize='12pt';
ch6.Title.Bold='True';
ch6.Title.Color='black';
sec1 = Section;
sec1.Title = Text('Weather data used in this study');
sec1.Title.FontFamilyName='Trebuchet';
sec1.Title.FontSize='12pt';
sec1.Title.Bold='True';
sec1.Title.Color='black';

fprintf('Adding weather data figure to section \n');
figName=char(strcat(CaseStudy,{' '}, 'Selected weather files for simulation.png'));
add(sec1,'Weather data summary:');
add(sec1,FormalImage('Image',...
    which(figName),'Caption','Weather data included in this study','ScaleToFit',true));

fprintf('Adding text and tables contaning weather data files \n');
text = Text('This table contains a list of weather files used in this study. Data is displayed in alphabetical order');
text.Italic='true';
text.FontSize='10pt';
text.FontFamilyName='Trebuchet';
text.Style = {OuterMargin("0pt", "0pt","15pt","15pt")};
add(sec1,text)
% Adding table containing weather files list
format short
tbl = MATLABTable(weatherfilestable);
tbl.TableEntriesHAlign = "center";
tbl.TableEntriesStyle = {FontFamily('Calibri'), FontSize('11')};
tbl.Style = [tbl.Style
    {NumberFormat("%1.3f"),...
    Width("100%")}];
    fprintf('Table added to section \n');
add(sec1,tbl)
 fprintf('Section added to chapter \n');
add(ch6,sec1)
fprintf('Adding Chapter 6 to report \n');
append(rpt,ch6)
%%
cd (mainProjectFolder)
% Close the report (required)
close(rpt);
% Display the report (optional)
rptview(rpt);

fprintf('Moving all Figures and tables with simulation aggregated results to the output/CaseStudy folder \n');
movefile('*Zon*.csv',  CaseStudy_output_f,'f')
movefile('Simresults.csv',  CaseStudy_output_f,'f')
if exist('gridresults','file')
    movefile("gridresults\",CaseStudy_output_f,'f')
end
movefile("simresults\",CaseStudy_output_f,'f')
movefile("Figures\",CaseStudy_output_f,'f')

fprintf('Report finished \n');


%% Third party function used to sort data
function [Y,ndx,dbg] = natsort(X,rgx,varargin)
% Natural-order / alphanumeric sort strings or character vectors or categorical.
%
% (c) 2012-2021 Stephen Cobeldick
%
% Sorts text by character code and by number value. By default matches
% integer substrings and performs a case-insensitive ascending sort.
% Options select other number formats, sort order, case sensitivity, etc.
%
%%% Example:
% >> X = {'x2', 'x10', 'x1'};
% >> sort(X) % wrong number order
% ans =   'x1'  'x10'  'x2'
% >> natsort(X)
% ans =   'x1'  'x2'  'x10'
%
%%% Syntax:
%  Y = natsort(X)
%  Y = natsort(X,rgx)
%  Y = natsort(X,rgx,<options>)
% [Y,ndx,dbg] = natsort(X,...)
%
% To sort any file-names or folder-names use NATSORTFILES (File Exchange 47434)
% To sort the rows of a string/cell array use NATSORTROWS (File Exchange 47433)
%
%% Number Substrings %%
%
% By default consecutive digit characters are interpreted as an integer.
% Specifying the optional regular expression pattern allows the numbers to
% include a +/- sign, decimal digits, exponent E-notation, quantifiers,
% or look-around matching. For information on defining regular expressions:
% <http://www.mathworks.com/help/matlab/matlab_prog/regular-expressions.html>
%
% The number substrings are parsed by SSCANF into numeric values, using
% either the **default format '%f' or the user-supplied format specifier.
%
% This table shows examples of some regular expression patterns for common
% notations and ways of writing numbers, together with suitable SSCANF formats:
%
% Regular       | Number Substring | Number Substring              | SSCANF
% Expression:   | Match Examples:  | Match Description:            | Format Specifier:
% ==============|==================|===============================|==================
% **        \d+ | 0, 123, 4, 56789 | unsigned integer              | %f  %i  %u  %lu
% --------------|------------------|-------------------------------|------------------
%      [-+]?\d+ | +1, 23, -45, 678 | integer with optional +/- sign| %f  %i  %d  %ld
% --------------|------------------|-------------------------------|------------------
%     \d+\.?\d* | 012, 3.45, 678.9 | integer or decimal            | %f
% (\d+|Inf|NaN) | 123, 4, NaN, Inf | integer, Inf, or NaN          | %f
%  \d+\.\d+E\d+ | 0.123e4, 5.67e08 | exponential notation          | %f
% --------------|------------------|-------------------------------|------------------
%  0X[0-9A-F]+  | 0X0, 0X3E7, 0XFF | hexadecimal notation & prefix | %x  %i
%    [0-9A-F]+  |   0,   3E7,   FF | hexadecimal notation          | %x
% --------------|------------------|-------------------------------|------------------
%  0[0-7]+      | 012, 03456, 0700 | octal notation & prefix       | %o  %i
%   [0-7]+      |  12,  3456,  700 | octal notation                | %o
% --------------|------------------|-------------------------------|------------------
%  0B[01]+      | 0B1, 0B101, 0B10 | binary notation & prefix      | %b   (not SSCANF)
%    [01]+      |   1,   101,   10 | binary notation               | %b   (not SSCANF)
% --------------|------------------|-------------------------------|------------------
%
%% Debugging Output Array %%
%
% The third output is a cell array <dbg>, for checking the numbers
% matched by the regular expression <rgx> and converted to numeric
% by the SSCANF format. The rows of <dbg> are linearly indexed from <X>.
%
% >> [~,~,dbg] = natsort(X)
% dbg =
%    'x'    [ 2]
%    'x'    [10]
%    'x'    [ 1]
%
%% Examples %%
%
%%% Multiple integers (e.g. release version numbers):
% >> A = {'v10.6', 'v9.10', 'v9.5', 'v10.10', 'v9.10.20', 'v9.10.8'};
% >> sort(A)
% ans =   'v10.10'  'v10.6'  'v9.10'  'v9.10.20'  'v9.10.8'  'v9.5'
% >> natsort(A)
% ans =   'v9.5'  'v9.10'  'v9.10.8'  'v9.10.20'  'v10.6'  'v10.10'
%
%%% Integer, decimal, NaN, or Inf numbers, possibly with +/- signs:
% >> B = {'test+NaN', 'test11.5', 'test-1.4', 'test', 'test-Inf', 'test+0.3'};
% >> sort(B)
% ans =   'test' 'test+0.3' 'test+NaN' 'test-1.4' 'test-Inf' 'test11.5'
% >> natsort(B, '[-+]?(NaN|Inf|\d+\.?\d*)')
% ans =   'test' 'test-Inf' 'test-1.4' 'test+0.3' 'test11.5' 'test+NaN'
%
%%% Integer or decimal numbers, possibly with an exponent:
% >> C = {'0.56e007', '', '43E-2', '10000', '9.8'};
% >> sort(C)
% ans =   ''  '0.56e007'  '10000'  '43E-2'  '9.8'
% >> natsort(C, '\d+\.?\d*(E[-+]?\d+)?')
% ans =   ''  '43E-2'  '9.8'  '10000'  '0.56e007'
%
%%% Hexadecimal numbers (with '0X' prefix):
% >> D = {'a0X7C4z', 'a0X5z', 'a0X18z', 'a0XFz'};
% >> sort(D)
% ans =   'a0X18z'  'a0X5z'  'a0X7C4z'  'a0XFz'
% >> natsort(D, '0X[0-9A-F]+', '%i')
% ans =   'a0X5z'  'a0XFz'  'a0X18z'  'a0X7C4z'
%
%%% Binary numbers:
% >> E = {'a11111000100z', 'a101z', 'a000000000011000z', 'a1111z'};
% >> sort(E)
% ans =   'a000000000011000z'  'a101z'  'a11111000100z'  'a1111z'
% >> natsort(E, '[01]+', '%b')
% ans =   'a101z'  'a1111z'  'a000000000011000z'  'a11111000100z'
%
%%% Case sensitivity:
% >> F = {'a2', 'A20', 'A1', 'a10', 'A2', 'a1'};
% >> natsort(F, [], 'ignorecase') % default
% ans =   'A1'  'a1'  'a2'  'A2'  'a10'  'A20'
% >> natsort(F, [], 'matchcase')
% ans =   'A1'  'A2'  'A20'  'a1'  'a2'  'a10'
%
%%% Sort order:
% >> G = {'2', 'a', '', '3', 'B', '1'};
% >> natsort(G, [], 'ascend') % default
% ans =   ''   '1'  '2'  '3'  'a'  'B'
% >> natsort(G, [], 'descend')
% ans =   'B'  'a'  '3'  '2'  '1'  ''
% >> natsort(G, [], 'num<char') % default
% ans =   ''   '1'  '2'  '3'  'a'  'B'
% >> natsort(G, [], 'char<num')
% ans =   ''   'a'  'B'  '1'  '2'  '3'
%
%%% UINT64 numbers (with full precision):
% >> natsort({'a18446744073709551615z', 'a18446744073709551614z'}, [], '%lu')
% ans =       'a18446744073709551614z'  'a18446744073709551615z'
%
%% Input and Output Arguments %%
%
%%% Inputs (**=default):
% X   = Array to be sorted into alphanumeric order. Can be a string
%       array, or a cell array of character row vectors, or a categorical
%       array, or any other array type which can be converted by CELLSTR.
% rgx = Optional regular expression to match number substrings.
%     = [] uses the default regular expression '\d+'** to match integers.
% <options> can be entered in any order, as many as required:
%     = Sort direction: 'descend'/'ascend'**
%     = NaN/number order: 'NaN<num'/'num<NaN'**
%     = Character/number order: 'char<num'/'num<char'**
%     = Character case handling: 'matchcase'/'ignorecase'**
%     = SSCANF conversion format: '%x', '%li', '%b', '%f'**, etc.
%
%%% Outputs:
% Y   = Array <X> sorted into alphanumeric order. The same size as <X>.
% ndx = NumericArray, such that Y = X(ndx).       The same size as <X>.
% dbg = CellArray of the parsed characters and number values.
%       Each row corresponds to one input element, linear-indexed from <X>.
%
% See also SORT NATSORTFILES NATSORTROWS CELLSTR REGEXP IREGEXP SSCANF

%% Input Wrangling %%
%
fun = @(c)cellfun('isclass',c,'char') & cellfun('size',c,1)<2 & cellfun('ndims',c)<3;
%
if iscell(X)
    assert(all(fun(X(:))),...
        'SC:natsort:X:CellInvalidContent',...
        'First input <X> cell array must contain only character row vectors.')
    Y = X(:);
elseif ischar(X) % Convert char matrix:
    Y = cellstr(X);
else % Convert string, categorical, datetime, etc.:
    Y = cellstr(X(:));
end
%
if nargin<2 || isnumeric(rgx)&&isequal(rgx,[])
    rgx = '\d+';
elseif ischar(rgx)
    assert(ndims(rgx)<3 && size(rgx,1)==1,...
        'SC:natsort:rgx:NotCharVector',...
        'Second input <rgx> character row vector must have size 1xN.') %#ok<ISMAT>
    nsChkRgx(rgx)
else
    rgx = ns1s2c(rgx);
    assert(ischar(rgx),...
        'SC:natsort:rgx:InvalidType',...
        'Second input <rgx> must be a character row vector or a string scalar.')
    nsChkRgx(rgx)
end
%
varargin = cellfun(@ns1s2c, varargin, 'UniformOutput',false);
%
assert(all(fun(varargin)),...
    'SC:natsort:option:InvalidType',...
    'All optional arguments must be character row vectors or string scalars.')
%
% Character case:
ccm = strcmpi(varargin,'matchcase');
ccx = strcmpi(varargin,'ignorecase')|ccm;
% Sort direction:
sdd = strcmpi(varargin,'descend');
sdx = strcmpi(varargin,'ascend')|sdd;
% Char/num order:
orb = strcmpi(varargin,'char<num');
orx = strcmpi(varargin,'num<char')|orb;
% NaN/num order:
nab = strcmpi(varargin,'NaN<num');
nax = strcmpi(varargin,'num<NaN')|nab;
% SSCANF format:
sfx = ~cellfun('isempty',regexp(varargin,'^%([bdiuoxfeg]|l[diuox])$'));
%
nsAssert(varargin, ~(ccx|orx|nax|sdx|sfx))
nsAssert(varargin, ccx,  'CaseMatching', 'case sensitivity')
nsAssert(varargin, orx,  'CharNumOrder', 'char<->num')
nsAssert(varargin, nax,   'NanNumOrder',  'NaN<->num')
nsAssert(varargin, sdx, 'SortDirection', 'sort direction')
nsAssert(varargin, sfx,  'sscanfFormat', 'SSCANF format')
%
% SSCANF format:
if nnz(sfx)
    fmt = varargin{sfx};
else
    fmt = '%f';
end
%
%% Identify and Convert Numbers %%
%
[nbr,spl] = regexpi(Y(:),rgx, 'match','split', varargin{ccx});
%
if numel(nbr)
    tmp = [nbr{:}];
    if strcmp(fmt,'%b')
        tmp = regexprep(tmp,'^0[Bb]','');
        vec = cellfun(@(s)pow2(numel(s)-1:-1:0)*sscanf(s,'%1d'),tmp);
    else
        vec = sscanf(sprintf(' %s',tmp{:}),fmt);
    end
    assert(numel(vec)==numel(tmp),...
        'SC:natsort:sscanf:TooManyValues',...
        'The %s format must return one value for each input number.',fmt)
else
    vec = [];
end
%
%% Allocate Data %%
%
% Determine lengths:
nmx = numel(Y);
lnn = cellfun('length',nbr);
lns = cellfun('length',spl);
mxs = max(lns);
%
% Allocate data:
idn = logical(bsxfun(@le,1:mxs,lnn).'); % TRANSPOSE bug loses type (R2013b)
ids = logical(bsxfun(@le,1:mxs,lns).'); % TRANSPOSE bug loses type (R2013b)
arn = zeros(mxs,nmx,class(vec));
ars =  cell(mxs,nmx);
ars(:) = {''};
ars(ids) = [spl{:}];
arn(idn) = vec;
%
%% Debugging Array %%
%
if nargout>2
    mxw = 0;
    for k = 1:nmx
        mxw = max(mxw,numel(nbr{k})+nnz(~cellfun('isempty',spl{k})));
    end
    dbg = cell(nmx,mxw);
    for k = 1:nmx
        tmp = spl{k};
        tmp(2,1:end-1) = num2cell(arn(idn(:,k),k));
        tmp(cellfun('isempty',tmp)) = [];
        dbg(k,1:numel(tmp)) = tmp;
    end
end
%
%% Sort Columns %%
%
if ~any(ccm) % ignorecase
    ars = lower(ars);
end
%
if any(orb) % char<num
    % Determine max character code:
    mxc = 'X';
    tmp = warning('off','all');
    mxc(1) = Inf;
    warning(tmp)
    mxc(mxc==0) = 255; % Octave
    % Append max character code to the split text:
    for k = reshape(find(idn),1,[])
        ars{k}(1,end+1) = mxc;
    end
end
%
idn(isnan(arn)) = ~any(nab); % NaN<num
%
if any(sdd)
    [~,ndx] = sort(nsGroup(ars(mxs,:)),'descend');
    for k = mxs-1:-1:1
        [~,idx] = sort(arn(k,ndx),'descend');
        ndx = ndx(idx);
        [~,idx] = sort(idn(k,ndx),'descend');
        ndx = ndx(idx);
        [~,idx] = sort(nsGroup(ars(k,ndx)),'descend');
        ndx = ndx(idx);
    end
else
    [~,ndx] = sort(ars(mxs,:)); % ascend
    for k = mxs-1:-1:1
        [~,idx] = sort(arn(k,ndx),'ascend');
        ndx = ndx(idx);
        [~,idx] = sort(idn(k,ndx),'ascend');
        ndx = ndx(idx);
        [~,idx] = sort(ars(k,ndx)); % ascend
        ndx = ndx(idx);
    end
end
%
%% Outputs %%
%
if ischar(X)
    ndx = ndx(:);
    Y = X(ndx,:);
else
    ndx = reshape(ndx,size(X));
    Y = X(ndx);
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%natsort
function nsChkRgx(rgx)
tmp = '^((match|ignore)case|(de|a)scend|(char|nan|num)[<>](char|nan|num)|%[a-z]+)$';
assert(isempty(regexpi(rgx,tmp,'once')),'SC:natsort:rgx:OptionMixUp',...
    ['Second input <rgx> must be a regular expression that matches numbers.',...
    '\nThe provided input "%s" is one of the optional arguments (inputs 3+).'],rgx)
if isempty(regexpi('0',rgx,'once'))
    warning('SC:natsort:rgx:SanityCheck',...
        ['Second input <rgx> must be a regular expression that matches numbers.',...
        '\nThe provided regular expression does not match the digit "0", which\n',...
        'may be acceptable (e.g. if literals, quantifiers, or lookarounds are used).'...
        '\nThe provided regular expression: "%s"'],rgx)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nsChkRgx
function arr = ns1s2c(arr)
% If scalar string then extract the character vector, otherwise data is unchanged.
if isa(arr,'string') && isscalar(arr)
    arr = arr{1};
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ns1s2c
function nsAssert(vin,vix,ids,txt)
% Throw an error if an option is overspecified or unsupported.
tmp = sprintf('The provided inputs:%s',sprintf(' "%s"',vin{vix}));
if nargin>2
    assert(nnz(vix)<2,...
        sprintf('SC:natsort:option:%sOverspecified',ids),...
        'The %s option may only be specified once.\n%s',txt,tmp)
else
    assert(~any(vix),...
        'SC:natsort:option:InvalidOptions',...
        'Invalid options provided.\n%s',tmp)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nsAssert
function grp = nsGroup(vec)
% Groups in a cell array of char vectors, equivalent to [~,~,grp]=unique(vec);
[vec,idx] = sort(vec);
grp = cumsum([true,~strcmp(vec(1:end-1),vec(2:end))]);
grp(idx) = grp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nsGroup


function [Y,ndx,dbg] = natsortfiles(X,rgx,varargin)
% Natural-order / alphanumeric sort of filenames or foldernames.
%
% (c) 2014-2021 Stephen Cobeldick
%
% Sorts text by character code and by number value. File/folder names, file
% extensions, and path directories (if supplied) are sorted separately to
% ensure that shorter names sort before longer names. For names without
% file extensions (i.e. foldernames, or filenames without extensions) use
% the 'noext' option. Use the 'xpath' option to ignore any filepath. Use
% the 'rmdot' option to remove the folder names "." and ".." from the array.
%
%%% Example:
% P = 'C:\SomeDir\SubDir';
% S = dir(fullfile(P,'*.txt'));
% S = natsortfiles(S);
% for k = 1:numel(S)
%     F = fullfile(P,S(k).name)
% end
%
%%% Syntax:
%  Y = natsortfiles(X)
%  Y = natsortfiles(X,rgx)
%  Y = natsortfiles(X,rgx,<options>)
% [Y,ndx,dbg] = natsortfiles(X,...)
%
% To sort the elements of a string/cell array use NATSORT (File Exchange 34464)
% To sort the rows of a string/cell array use NATSORTROWS (File Exchange 47433)
%
%% File Dependency %%
%
% NATSORTFILES requires the function NATSORT (File Exchange 34464). Extra
% optional arguments are passed directly to NATSORT. See NATSORT for case-
% sensitivity, sort direction, number substring matching, and other options.
%
%% Explanation %%
%
% Using SORT on filenames will sort any of char(0:45), including the
% printing characters ' !"#$%&''()*+,-', before the file extension
% separator character '.'. Therefore NATSORTFILES splits the file-name
% from the file-extension and sorts them separately. This ensures that
% shorter names come before longer names (just like a dictionary):
%
% >> F = {'test_new.m'; 'test-old.m'; 'test.m'};
% >> sort(F) % Note '-' sorts before '.':
% ans =
%     'test-old.m'
%     'test.m'
%     'test_new.m'
% >> natsortfiles(F) % Shorter names before longer:
% ans =
%     'test.m'
%     'test-old.m'
%     'test_new.m'
%
% Similarly the path separator character within filepaths can cause longer
% directory names to sort before shorter ones, as char(0:46)<'/' and
% char(0:91)<'\'. This example on a PC demonstrates why this matters:
%
% >> D = {'A1\B', 'A+/B', 'A/B1', 'A=/B', 'A\B0'};
% >> sort(D)
% ans =   'A+/B'  'A/B1'  'A1\B'  'A=/B'  'A\B0'
% >> natsortfiles(D)
% ans =   'A\B0'  'A/B1'  'A1\B'  'A+/B'  'A=/B'
%
% NATSORTFILES splits filepaths at each path separator character and sorts
% every level of the directory hierarchy separately, ensuring that shorter
% directory names sort before longer, regardless of the characters in the names.
% On a PC separators are '/' and '\' characters, on Mac and Linux '/' only.
%
%% Examples %%
%
% >> A = {'a2.txt', 'a10.txt', 'a1.txt'}
% >> sort(A)
% ans = 'a1.txt'  'a10.txt'  'a2.txt'
% >> natsortfiles(A)
% ans = 'a1.txt'  'a2.txt'  'a10.txt'
%
% >> B = {'test2.m'; 'test10-old.m'; 'test.m'; 'test10.m'; 'test1.m'};
% >> sort(B) % Wrong number order:
% ans =
%    'test.m'
%    'test1.m'
%    'test10-old.m'
%    'test10.m'
%    'test2.m'
% >> natsortfiles(B) % Shorter names before longer:
% ans =
%    'test.m'
%    'test1.m'
%    'test2.m'
%    'test10.m'
%    'test10-old.m'
%
%%% Directory Names:
% >> C = {'A2-old\test.m';'A10\test.m';'A2\test.m';'A1\test.m';'A1-archive.zip'};
% >> sort(C) % Wrong number order, and '-' sorts before '\':
% ans =
%    'A1-archive.zip'
%    'A10\test.m'
%    'A1\test.m'
%    'A2-old\test.m'
%    'A2\test.m'
% >> natsortfiles(C) % Shorter names before longer:
% ans =
%    'A1\test.m'
%    'A1-archive.zip'
%    'A2\test.m'
%    'A2-old\test.m'
%    'A10\test.m'
%
%% Input and Output Arguments %%
%
%%% Inputs (**=default):
% X   = Array of filenames or foldernames to be sorted. Can be the struct
%       returned by DIR, a string array, or a cell array of char row vectors.
% rgx = Optional regular expression to match number substrings.
%     = [] uses the default regular expression '\d+'** to match integers.
% <options> can be supplied in any order:
%     = 'rmdot' removes the names "." and ".." from the output array.
%     = 'noext' for foldernames, or filenames without extensions.
%     = 'xpath' sorts by name only, excluding any preceding path.
%     = all remaining options are passed directly to NATSORT.
%
%%% Outputs:
% Y   = Array <X> sorted into alphanumeric order.
% ndx = NumericMatrix, indices such that Y = X(ndx). The same size as <Y>.
% dbg = CellVectorOfCellArrays, each cell contains the debug cell array of
%       one level of the path heirarchy directory names, or filenames, or
%       file extensions. Helps debug the regular expression (see NATSORT).
%
% See also SORT NATSORT NATSORTROWS DIR FILEPARTS FULLFILE NEXTNAME CELLSTR REGEXP IREGEXP SSCANF

%% Input Wrangling %%
%
fun = @(c)cellfun('isclass',c,'char') & cellfun('size',c,1)<2 & cellfun('ndims',c)<3;
%
if isstruct(X)
    assert(isfield(X,'name'),...
        'SC:natsortfiles:X:StructMissingNameField',...
        'If first input <X> is a struct then it must have field <name>.')
    nmx = {X.name};
    assert(all(fun(nmx)),...
        'SC:natsortfiles:X:NameFieldInvalidType',...
        'First input <X> field <name> must contain only character row vectors.')
    [fpt,fnm,fxt] = cellfun(@fileparts, nmx, 'UniformOutput',false);
    if isfield(X,'folder')
        fpt = {X.folder};
        assert(all(fun(fpt)),...
            'SC:natsortfiles:X:FolderFieldInvalidType',...
            'First input <X> field <folder> must contain only character row vectors.')
    end
elseif iscell(X)
    assert(all(fun(X(:))),...
        'SC:natsortfiles:X:CellContentInvalidType',...
        'First input <X> cell array must contain only character row vectors.')
    [fpt,fnm,fxt] = cellfun(@fileparts, X(:), 'UniformOutput',false);
    nmx = strcat(fnm,fxt);
elseif ischar(X)
    [fpt,fnm,fxt] = cellfun(@fileparts, cellstr(X), 'UniformOutput',false);
    nmx = strcat(fnm,fxt);
else
    assert(isa(X,'string'),...
        'SC:natsortfiles:X:InvalidType',...
        'First input <X> must be a structure, a cell array, or a string array.');
    [fpt,fnm,fxt] = cellfun(@fileparts, cellstr(X(:)), 'UniformOutput',false);
    nmx = strcat(fnm,fxt);
end
%
varargin = cellfun(@nsf1s2c, varargin, 'UniformOutput',false);
%
assert(all(fun(varargin)),...
    'SC:natsortfiles:option:InvalidType',...
    'All optional arguments must be character row vectors or string scalars.')
%
idd = strcmpi(varargin,'rmdot');
assert(nnz(idd)<2,...
    'SC:natsortfiles:rmdot:Overspecified',...
    'The "." and ".." folder handling is overspecified.')
varargin(idd) = [];
%
ide = strcmpi(varargin,'noext');
assert(nnz(ide)<2,...
    'SC:natsortfiles:noext:Overspecified',...
    'The file-extension handling is overspecified.')
varargin(ide) = [];
%
idp = strcmpi(varargin,'xpath');
assert(nnz(idp)<2,...
    'SC:natsortfiles:xpath:Overspecified',...
    'The file-path handling is overspecified.')
varargin(idp) = [];
%
if nargin>1
    varargin = [{rgx},varargin];
end
%
%% Path and Extension %%
%
% Path separator regular expression:
if ispc()
    psr = '[^/\\]+';
else % Mac & Linux
    psr = '[^/]+';
end
%
if any(idd) % Remove "." and ".." folder names
    ddx = strcmp(nmx,'.')|strcmp(nmx,'..');
    fxt(ddx) = [];
    fnm(ddx) = [];
    fpt(ddx) = [];
    nmx(ddx) = [];
end
%
if any(ide) % No file-extension
    fnm = nmx;
    fxt = [];
end
%
if any(idp) % No file-path
    mat = reshape(fnm,1,[]);
else
    % Split path into {dir,subdir,subsubdir,...}:
    spl = regexp(fpt(:),psr,'match');
    nmn = 1+cellfun('length',spl(:));
    mxn = max(nmn);
    vec = 1:mxn;
    mat = cell(mxn,numel(nmn));
    mat(:) = {''};
    %mat(mxn,:) = fnm(:); % old behavior
    mat(logical(bsxfun(@eq,vec,nmn).')) =  fnm(:);  % TRANSPOSE bug loses type (R2013b)
    mat(logical(bsxfun(@lt,vec,nmn).')) = [spl{:}]; % TRANSPOSE bug loses type (R2013b)
end
%
if numel(fxt) % File-extension
    mat(end+1,:) = fxt(:);
end
%
%% Sort File Extensions, Names, and Paths %%
%
nmr = size(mat,1)*all(size(mat));
dbg = cell(1,nmr);
ndx = 1:numel(fnm);
%
for k = nmr:-1:1
    if nargout<3 % faster:
        [~,ids] = natsort(mat(k,ndx),varargin{:});
    else % for debugging:
        [~,ids,tmp] = natsort(mat(k,ndx),varargin{:});
        [~,idb] = sort(ndx);
        dbg{k} = tmp(idb,:);
    end
    ndx = ndx(ids);
end
%
% Return the sorted input array and corresponding indices:
%
if any(idd)
    tmp = find(~ddx);
    ndx = tmp(ndx);
end
%
ndx = ndx(:);
%
if ischar(X)
    Y = X(ndx,:);
elseif any(idd)
    xsz = size(X);
    nsd = xsz~=1;
    if nnz(nsd)==1 % vector
        xsz(nsd) = numel(ndx);
        ndx = reshape(ndx,xsz);
    end
    Y = X(ndx);
else
    ndx = reshape(ndx,size(X));
    Y = X(ndx);
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%natsortfiles
function arr = nsf1s2c(arr)
% If scalar string then extract the character vector, otherwise data is unchanged.
if isa(arr,'string') && isscalar(arr)
    arr = arr{1};
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%nsf1s2c
