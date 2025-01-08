function count = cprintf(style,format,varargin) 

%    The possible pre-defined STYLE names are:
%
%       'Text'                 - default: black
%       'Keywords'             - default: blue
%       'Comments'             - default: green
%       'Strings'              - default: purple
%       'UnterminatedStrings'  - default: dark red
%       'SystemCommands'       - default: orange
%       'Errors'               - default: light red
%       'Hyperlinks'           - default: underlined blue
%
%       'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White'
%
%    STYLE beginning with '-' or '_' will be underlined. For example:
%          '-Blue' is underlined blue, like 'Hyperlinks';
%          '_Comments' is underlined green etc.
%
%    STYLE beginning with '*' will be bold (R2011b+ only). For example:
%          '*Blue' is bold blue;
%          '*Comments' is bold green etc.
%    Note: Matlab does not currently support both bold and underline,
%          only one of them can be used in a single cprintf command. But of
%          course bold and underline can be mixed by using separate commands.
%
%    STYLE colors can be specified in 3 variants:
%        [0.1, 0.7, 0.3] - standard Matlab RGB color format in the range 0.0-1.0
%        [26, 178, 76]   - numeric RGB values in the range 0-255
%        '#1ab34d'       - Hexadecimal format in the range '00'-'FF' (case insensitive)
%                          3-digit HTML RGB format also accepted: 'a5f'='aa55ff'
%
%    STYLE can be underlined by prefixing - :  -[0,1,1]  or '-#0FF' is underlined cyan
%    STYLE can be made bold  by prefixing * : '*[1,0,0]' or '*#F00' is bold red
%
%    STYLE is case-insensitive and accepts unique partial strings just
%    like handle property names.
%
%    CPRINTF by itself, without any input parameters, displays a demo
%
% Example:
%    cprintf;   % displays the demo
%    cprintf('text',   'regular black text');
%    cprintf('hyper',  'followed %s','by');

  persistent majorVersion minorVersion
  if isempty(majorVersion)
      
      v = sscanf(version, '%d.', 2);
      majorVersion = v(1); %str2double(versionIdStrs{1}{1});
      minorVersion = v(2); %str2double(versionIdStrs{1}{2});
  end

  if ~exist('el','var') || isempty(el),  el=handle([]);  end  %#ok mlint short-circuit error ("used before defined")
  if nargin<1, showDemo(majorVersion,minorVersion); return;  end
  if isempty(style),  return;  end
  if isa(style,'string'), style = char(style); end
  if all(ishandle(style)) && length(style)~=3
      dumpElement(style);
      return;
  end
  % Process the text string
  if nargin<2, format = style; style='text';  end
  if isa(format,'string'), format = char(format); end
  %error(nargchk(2, inf, nargin, 'struct'));
  %str = sprintf(format,varargin{:});
  % In compiled mode
  try useDesktop = usejava('desktop'); catch, useDesktop = false; end
  if isdeployed | ~useDesktop %#ok<OR2> - for Matlab 6 compatibility

      count1 = fprintf(format,varargin{:});
  else

      [underlineFlag, boldFlag, style, debugFlag] = processStyleInfo(style);
      % Set hyperlinking, if so requested
      if underlineFlag
          prefix = '<a href="">';
          %format = [prefix format '</a>'];  % this displayed incorrectly for embedded hyperlinks
          % Handle case of embedded hyperlinks with underline format 5/1/2020
          str = sprintf(format, varargin{:});
          str = regexprep(str,{'<a ','/a>','_@@@_'},{'_@@@_<a ',['/a>' prefix],'</a>'},'ignorecase');
          str = [prefix str '</a>'];
          format = '%s'; varargin = {str};

          if majorVersion < 7 || (majorVersion==7 && minorVersion <= 1)
              format(end+1) = ' ';
          end
      end
      % Set bold, if requested and supported (R2011b+)
      if boldFlag
          if (majorVersion > 7 || minorVersion >= 13)
              format = ['<strong>' format '</strong>'];
          else
              boldFlag = 0;
          end
      end
      % Get the current CW position
      cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
      lastPos = cmdWinDoc.getLength;
      % If not beginning of line
      bolFlag = 0;  %#ok

          if majorVersion<7 || (majorVersion==7 && minorVersion<13)
              if ~underlineFlag
                  fprintf('<a href=""> </a>');  %fprintf('<a href=""> </a>\b');
              elseif format(end)~=10  % if no newline at end
                  fprintf(' ');  %fprintf(' \b');
              end
          end
          %drawnow;
          bolFlag = 1;
      %end
      % Get a handle to the Command Window component
      mde = com.mathworks.mde.desk.MLDesktop.getInstance;
      cw = mde.getClient('Command Window');
      % Fix: if command window isn't defined yet (startup), use standard fprintf()
      if (isempty(cw))
         count1 = fprintf(format,varargin{:});
         if nargout
             count = count1;
         end
         return;
      end
      
      xCmdWndView = cw.getComponent(0).getViewport.getComponent(0);

      com.mathworks.services.Prefs.setColorPref('CW_BG_Color',xCmdWndView.getBackground);

      cmdWinLen = cmdWinDoc.getLength;
      cmdWinLenPrev = cmdWinLen;
      count1 = fprintf(2,format,varargin{:});
      % Repaint the command window (wait a bit for the async update to complete)
      iter = 0;
      while count1 > 0 && cmdWinLen <= cmdWinLenPrev && iter < 100
          %awtinvoke(cmdWinDoc,'remove',lastPos,1);   % TODO: find out how to remove the extra '_'
          drawnow;  % this is necessary for the following to work properly (refer to Evgeny Pr in FEX comment 16/1/2011)
          pause(0.01);
          xCmdWndView.repaint;
          %hListeners = cmdWinDoc.getDocumentListeners; for idx=1:numel(hListeners), try hListeners(idx).repaint; catch, end, end
          cmdWinLen = cmdWinDoc.getLength;
          iter = iter + 1;
      end
      docElement = cmdWinDoc.getParagraphElement(lastPos+1);
      if majorVersion<7 || (majorVersion==7 && minorVersion<13)
          if bolFlag && ~underlineFlag
              % Set the leading hyperlink space character ('_') to the bg color, effectively hiding it
              % Note: old Matlab versions have a bug in hyperlinks that need to be accounted for...
              %disp(' '); dumpElement(docElement)
              setElementStyle(docElement,'CW_BG_Color',1+underlineFlag,majorVersion,minorVersion); %+getUrlsFix(docElement));
              %disp(' '); dumpElement(docElement)
              el(end+1) = handle(docElement);  % #ok used in debug only
          end
          % Fix a problem with some hidden hyperlinks becoming unhidden...
          fixHyperlink(docElement);
          %dumpElement(docElement);
      end

      while docElement.getStartOffset <= cmdWinLen
          % Set the element style according to the current style
          if debugFlag, dumpElement(docElement); end
          specialFlag = underlineFlag | boldFlag;
          setElementStyle(docElement,style,specialFlag,majorVersion,minorVersion);
          if debugFlag, dumpElement(docElement); end
          docElement2 = cmdWinDoc.getParagraphElement(docElement.getEndOffset+1);
          if isequal(docElement,docElement2),  break;  end
          docElement = docElement2;
      end
      if debugFlag, dumpElement(docElement); end

      xCmdWndView.repaint;

      el(end+1) = handle(docElement);  %#ok used in debug only

  end
  if nargout
      count = count1;
  end
  return;  % debug breakpoint
% Process the requested style information
function [underlineFlag,boldFlag,style,debugFlag] = processStyleInfo(style)
  underlineFlag = 0;
  boldFlag = 0;
  debugFlag = 0;
  % First, strip out the underline/bold markers
  if ischar(style)

      underlineIdx = (style=='-') | (style=='_');
      if any(underlineIdx)
          underlineFlag = 1;
          %style = style(2:end);
          style = style(~underlineIdx);
      end
      % Check for bold style (only if not underlined)
      boldIdx = (style=='*');
      if any(boldIdx)
          boldFlag = 1;
          style = style(~boldIdx);
      end
      if underlineFlag && boldFlag
          warning('YMA:cprintf:BoldUnderline','Matlab does not support both bold & underline')
      end
      % Check for debug mode (style contains '!')
      debugIdx = (style=='!');
      if any(debugIdx)
          debugFlag = 1;
          style = style(~debugIdx);
      end

      if any(style==' ' | style==',' | style==';')
          style = str2num(style); %#ok<ST2NM>
      end
  end
  % Style = valid matlab RGB vector: [0.1,0.2,0.3] or [25,50,75]
  if isnumeric(style) && length(style)==3 && all(style<=255) && all(abs(style)>=0)
      if any(style<0)
          underlineFlag = 1;
          style = abs(style);
      end
      style = getColorStyle(style);
  elseif ~ischar(style)
      error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')
  % #RGB in hex mode (suggested by Andres Tönnesmann 26/3/21 https://mail.google.com/mail/u/0/#inbox/FMfcgxwLtGlbzftbfKJwWLNZKpSqzHhR)
  elseif style(1) == '#'
      hexCode = style(2:min(end,7));
      if length(hexCode)==3, hexCode = reshape([hexCode;hexCode],1,[]); end  % #a5f -> #aa55ff
      hexCode = sprintf('%06s',hexCode);  % pad with leading 00s
      hexCode = reshape(hexCode,2,3)';  % '1a2b3c' -> ['1a'; '2b'; '3c']
      rgb = hex2dec(hexCode);  % convert to [r,g,b] tripplet (0-255 values)
      style = getColorStyle(rgb);
  % Style name
  else
      % Try case-insensitive partial/full match with the accepted style names
      matlabStyles = {'Text','Keywords','Comments','Strings','UnterminatedStrings','SystemCommands','Errors'};
      validStyles  = [matlabStyles, ...
                      'Black','Cyan','Magenta','Blue','Green','Red','Yellow','White', ...
                      'Hyperlinks'];
      matches = find(strncmpi(style,validStyles,length(style)));
      % No match - error
      if isempty(matches)
          error('YMA:cprintf:InvalidStyle','Invalid style - see help section for a list of valid style values')
      % Too many matches (ambiguous) - error
      elseif length(matches) > 1
          error('YMA:cprintf:AmbigStyle','Ambiguous style name - supply extra characters for uniqueness')
      % Regular text
      elseif matches == 1
          style = 'ColorsText';  % fixed by Danilo, 29/8/2011
      % Highlight preference style name
      elseif matches <= length(matlabStyles)
          style = ['Colors_M_' validStyles{matches}];
      % Color name
      elseif matches < length(validStyles)
          colors = [0,0,0; 0,1,1; 1,0,1; 0,0,1; 0,1,0; 1,0,0; 1,1,0; 1,1,1];
          requestedColor = colors(matches-length(matlabStyles),:);
          style = getColorStyle(requestedColor);
      % Hyperlink
      else
          style = 'Colors_HTML_HTMLLinks';  % CWLink
          underlineFlag = 1;
      end
  end
% Convert a Matlab RGB vector into a known style name (e.g., '[255,37,0]')
function styleName = getColorStyle(rgb)
  if all(rgb<=1), rgb = rgb*255; end  % 0.5 -> 127
  intColor = int32(rgb);
  javaColor = java.awt.Color(intColor(1), intColor(2), intColor(3));
  styleName = sprintf('[%d,%d,%d]',intColor);
  com.mathworks.services.Prefs.setColorPref(styleName,javaColor);
% Fix a bug in some Matlab versions, where the number of URL segments
% is larger than the number of style segments in a doc element
function delta = getUrlsFix(docElement)  %currently unused
  tokens = docElement.getAttribute('SyntaxTokens');
  links  = docElement.getAttribute('LinkStartTokens');
  if length(links) > length(tokens(1))
      delta = length(links) > length(tokens(1));
  else
      delta = 0;
  end
% fprintf(2,str) causes all previous '_'s in the line to become red - fix this
function fixHyperlink(docElement)
  try
      tokens = docElement.getAttribute('SyntaxTokens');
      urls   = docElement.getAttribute('HtmlLink');
      urls   = urls(2);
      links  = docElement.getAttribute('LinkStartTokens');
      offsets = tokens(1);
      styles  = tokens(2);
      doc = docElement.getDocument;
      % Loop over all segments in this docElement
      for idx = 1 : length(offsets)-1
          % If this is a hyperlink with no URL target and starts with ' ' and is collored as an error (red)...
          if strcmp(styles(idx).char,'Colors_M_Errors')
              character = char(doc.getText(offsets(idx)+docElement.getStartOffset,1));
              if strcmp(character,' ')
                  if isempty(urls(idx)) && links(idx)==0
                      % Revert the style color to the CW background color (i.e., hide it!)
                      styles(idx) = java.lang.String('CW_BG_Color');
                  end
              end
          end
      end
  catch
      % never mind...
  end
% Set an element to a particular style (color)
function setElementStyle(docElement,style,specialFlag, majorVersion,minorVersion)
  %global tokens links urls urlTargets  % for debug only
  global oldStyles %#ok<GVMIS>
  if nargin<3,  specialFlag=0;  end

  tokens = docElement.getAttribute('SyntaxTokens');
  try
      styles = tokens(2);
      oldStyles{end+1} = cell(styles);
      % Correct edge case problem
      extraInd = double(majorVersion>7 || (majorVersion==7 && minorVersion>=13));  % =0 for R2011a-, =1 for R2011b+
      %{
      if ~strcmp('CWLink',char(styles(end-hyperlinkFlag))) && ...
          strcmp('CWLink',char(styles(end-hyperlinkFlag-1)))
         extraInd = 0;%1;
      end
      hyperlinkFlag = ~isempty(strmatch('CWLink',tokens(2)));
      hyperlinkFlag = 0 + any(cellfun(@(c)(~isempty(c)&&strcmp(c,'CWLink')),cell(tokens(2))));
      %}
      jStyle = java.lang.String(style);
      if numel(styles)==4 && isempty(char(styles(2)))
          % Attempt to fix discoloration issues - NOT SURE THAT THIS IS OK! - 24/6/2015
          styles(1) = jStyle;
      end
      styles(end-extraInd) = java.lang.String('');
      styles(end-extraInd-specialFlag) = jStyle;  % #ok apparently unused but in reality used by Java
      if extraInd
          styles(end-specialFlag) = jStyle;
      end
      oldStyles{end} = [oldStyles{end} cell(styles)];
  catch
      % never mind for now
  end
  

  urls = docElement.getAttribute('HtmlLink');
  if ~isempty(urls)
      urlTargets = urls(2);
      for urlIdx = 1 : length(urlTargets)
          try
              if urlTargets(urlIdx).length < 1
                  urlTargets(urlIdx) = [];  % '' => []
              else  % fix for hyperlinks by T. Hosman 25/11/2019 (via email)
                  if urlIdx > 1
                      styles(urlIdx-1) = jStyle;
                  end
                  styles(urlIdx) = jStyle; %=java.lang.String('CWLink');
              end
          catch
              % never mind...
              a=1;  %#ok used for debug breakpoint...
          end
      end
  end
  

  return;  % debug breakpoint
% Display information about element(s)
function dumpElement(docElements)
  %return;
  disp(' ');
  numElements = length(docElements);
  cmdWinDoc = docElements(1).getDocument;
  for elementIdx = 1 : numElements
      if numElements > 1,  fprintf('Element #%d:\n',elementIdx);  end
      docElement = docElements(elementIdx);
      if ~isjava(docElement),  docElement = docElement.java;  end
      %docElement.dump(java.lang.System.out,1)
      disp(strtrim(char(docElement)))
      txt = {};
      try
          tokens = docElement.getAttribute('SyntaxTokens');
          %if isempty(tokens),  continue;  end
          links = docElement.getAttribute('LinkStartTokens');
          urls  = docElement.getAttribute('HtmlLink');
          try bolds = docElement.getAttribute('BoldStartTokens'); catch, bolds = []; end
          tokenLengths = tokens(1);
          for tokenIdx = 1 : length(tokenLengths)-1
              tokenLength = diff(tokenLengths(tokenIdx+[0,1]));
              if (tokenLength < 0)
                  tokenLength = docElement.getEndOffset - docElement.getStartOffset - tokenLengths(tokenIdx);
              end
              txt{tokenIdx} = cmdWinDoc.getText(docElement.getStartOffset+tokenLengths(tokenIdx),tokenLength).char;  %#ok
          end
      catch
          tokenLengths = 0;
      end
      lastTokenStartOffset = docElement.getStartOffset + tokenLengths(end);
      try
          txt{end+1} = cmdWinDoc.getText(lastTokenStartOffset, docElement.getEndOffset-lastTokenStartOffset).char; %#ok
      catch
          txt{end+1} = ''; %#ok<AGROW>
      end
      txt = strrep(txt',sprintf('\n'),'\n'); %#ok<SPRINTFN>
      try
          data = [cell(tokens(2)) m2c(tokens(1)) m2c(links) m2c(urls(1)) cell(urls(2)) m2c(bolds) txt];
          if elementIdx==1
              disp('    SyntaxTokens(2,1) - LinkStartTokens - HtmlLink(1,2) - BoldStartTokens - txt');
              disp('    ==============================================================================');
          end
      catch
          try
              data = [cell(tokens(2)) m2c(tokens(1)) m2c(links) txt];
          catch
              try
                  disp([cell(tokens(2)) m2c(tokens(1)) txt]);
                  data = [m2c(links) m2c(urls(1)) cell(urls(2))];
              catch
                  % Matlab 7.1 only has urls(1)...
                  try
                      data = [m2c(links) cell(urls)];
                  catch  % no tokens
                      data = txt;
                  end
              end
          end
      end
      disp(data)
  end
% Utility function to convert matrix => cell
function cells = m2c(data)
  %datasize = size(data);  cells = mat2cell(data,ones(1,datasize(1)),ones(1,datasize(2)));
  cells = num2cell(data);
% Display the help and demo
function showDemo(majorVersion,minorVersion)
  fprintf('cprintf displays formatted text in the Command Window.\n\n');
  fprintf('Syntax: count = cprintf(style,format,...);  click <a href="matlab:help cprintf">here</a> for details.\n\n');
  url = 'http://UndocumentedMatlab.com/articles/cprintf';
  fprintf(['Technical description: <a href="' url '">' url '</a>\n\n']);
  fprintf('Demo:\n\n');
  boldFlag = majorVersion>7 || (majorVersion==7 && minorVersion>=13);
  s = ['cprintf(''text'',    ''regular black text'');' 10 ...
       'cprintf(''hyper'',   ''followed %s'',''by'');' 10 ...
       'cprintf(''key'',     ''%d colored'',' num2str(4+boldFlag) ');' 10 ...
       'cprintf(''-comment'',''& underlined'');' 10 ...
       'cprintf(''err'',     ''elements:\n'');' 10 ...
       'cprintf(''cyan'',    ''cyan'');' 10 ...
       'cprintf(''_green'',  ''underlined green'');' 10 ...
       'cprintf(-[1,0,1],  ''underlined magenta'');' 10 ...
       'cprintf([1,0.5,0], ''and multi-\nline orange\n'');' 10];
   if boldFlag
       s = [s 'cprintf(''*blue'',   ''and *bold* (R2011b+ only)\n'');' 10];
       s = strrep(s, ''')',' '')');
       s = strrep(s, ''',5)',' '',5)');
       s = strrep(s, '\n ','\n');
   end
   disp(s);
   eval(s);
