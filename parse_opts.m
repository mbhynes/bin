% 
% parse_opts.m
%
% Parse command-line arguments for octave scripts in
% the style of getopts.
%
% 
% Users must specify the following global (cell) variables:
%		global OPT_VAR_NAMES; --- {'varname1' 'varname2' ... }
%		global OPT_VAR_FLAGS; --- {'x' 'v' 'f' ...}
%		global OPT_VAR_DEFAULTS;  --- {'var1_default_val' ...}
%		global OPT_FLAG_HASARGS; {'x' 'v'} if these flags require args
%
% Then, in the main script, one may call parse_opts as a script:
% 	parse_opts
% The variables named in OPT_VAR_NAMES will then be created 
% in the main function scope.
%
% The variables [OPTFLAGS OPTARGS OPTFILES] are also created;
% these contain the flags read, the args for the flags, and any
% non-flag parameters given (assumed to be files)
%
% Example: >> testfunc -f -x x_arg file1 -v v_arg file2 file3 
% 	OPTFLAGS = {'f' 'x' 'v'} 
% 	OPTARGS = {'x_arg' 'v_arg'} 
%		OPTFILES = {'file1' 'file2' 'file3'} 
%
% Each variable is initialized to either the default value, or the supplied
% value from the commandline, which is evaluated using an eval() statement.
%
% Flags in OPT_FLAG_HASARGS are like "x:v:" in a getopts OPTSTRING. 
%
% Messages are written to stderr about *all* flags read, warnings, etc.
%
% The function mat = read_mat_stdin() reads a matrix from the stdin.
%
% =================================================
% Author: Michael B Hynes, mbhynes@uwaterloo.ca
% License: GPL 3
% Creation Date: Wed 21 Jan 2015 06:25:47 PM EST
% Last Modified: Wed 15 Apr 2015 09:47:24 AM EDT
% =================================================

global OPT_VAR_NAMES;
global OPT_VAR_FLAGS;
global OPT_VAR_DEFAULTS;
global OPT_FLAG_HASARGS;
global OPTFLAGS;
global OPTARGS;
global OPTFILES;
global STDIN='-';

%==================================================
% UTILITY FUNCTIONS 
%==================================================
function write_stdout(str);
	fprintf(1, "%s: %s\n", program_name(), str);
end
function write_stderr(str);
	fprintf(2, "%s: %s\n", program_name(), str);
end
function log_error(str);
	write_stderr(["ERROR: " str]);
end
function log_warn(str);
	write_stderr(["WARNING: " str]);
end
function log_info(str);
	write_stderr(str);
end

% read matrix from stdin
function mat = read_mat_stdin()
	mat = dlmread(stdin,'');
end

% return v' if v is a row vector 
function V = make_col_vec(v)
	[n,m] = size(v);
	V = v;
	if (m > n)
		V = v';
	end
end

function bool = help_flag_specified(help_flag)
	global OPTFLAGS;
	if ~nargin
		help_flag="h";
	end
	bool = ismember(help_flag,OPTFLAGS);
end

function display_opts()
	global OPT_VAR_NAMES;
	global OPT_VAR_FLAGS;
	global OPT_VAR_DEFAULTS;
	global OPT_FLAG_HASARGS;

	write_stdout("");
	write_stdout("Option flags:");
	for k = 1:length(OPT_VAR_FLAGS)
		v = OPT_VAR_FLAGS{k};
		name = OPT_VAR_NAMES{k};
		default_val = OPT_VAR_DEFAULTS{k};

		if flag_has_arg(v);
			str = ['-' v ' [' name ']; default=' default_val ];
		else
			str = ['-' v ' #boolean_flag; ' name '=true; default=' default_val ];
		end
		write_stdout(str);
	end
end
%==================================================
% COMMANDLINE PARSING FUNCTIONS
%==================================================
function index = get_val_index(list,value)
	index = find(strcmp(list,value));
end

%==================================================
function bool = flag_has_arg(str)
	global OPT_FLAG_HASARGS;
	bool = ismember(str, OPT_FLAG_HASARGS);
end

%==================================================
function flag = strip_hyphen(param);
	flag = param(param != '-');
end

%==================================================
function bool = is_flag(str)
	bool = (str(1) == '-') && (length(str) > 1);
end

%==================================================
function bool = is_stdin(str)
	bool = (str(1) == '-') && (length(str) == 1);
end


%==================================================
function bool = is_flag_expected(str)
	global OPT_VAR_FLAGS; 
	bool = ~isempty(get_val_index(OPT_VAR_FLAGS,str));
end

%==================================================
% return cell arrays of:
% 	[flags] = {'k_1' 'k_2' ... } for all {'k_i'} in OPT_VAR_FLAGS
% 	[args] = {'var_1' 'var_2' ... } supplied params for all {'k_i'} in OPT_FLAG_HASARGS
%		[files] = {'file1' 'file2' ... } any non-flag string in list
function [flags args files] = get_opts(list)
	len = length(list);

	% k = index of @param list
	% arg_num = index of @param arg
	% file_num = index of @param files
	[flags,args,files] = deal({});
	[k,arg_num,file_num] = deal(1);

	while (k <= len)
		param = list{k};

		if is_flag(param)

			flag = strip_hyphen(param);

			if is_flag_expected(flag)
				flags{arg_num} = flag;

				if flag_has_arg(flag) && (k+1 <= len)
					arg = list{k+1};
					args{arg_num} = arg;

					% check that the argument is a non-flag value
					if is_flag(arg)
						log_error(["argument to " param " expected, but found flag: " arg]);
					% else
					% 	log_info(["Read flag: " param " with argument: " args{arg_num}]);
					end

					k += 2;
				else
					args{arg_num} = "1";
					% log_info(["Read non-argument flag: " param]);
					k++;
				end

			else
				log_warn(["Read unexpected flag: " param ]);
				k++;
			end

			arg_num++;

		else
			% if is_stdin(param)
			% 	log_info(["- specified on commandline; Reading from stdin."]);
			% else
			% 	log_info(["Read non-flag argument: " param]);
			% end

			files{file_num} = list{k};
			file_num++;
			k++;
		end

	end
end 

%==================================================
function cmd = make_init_commands(flags,args)

	global OPT_VAR_DEFAULTS;
	global OPT_VAR_NAMES; 
	global OPT_VAR_FLAGS;

	len = length(OPT_VAR_NAMES);
	cmd = cell(1,len);

	% loop over all OPT_VAR_NAMES and set defaults
	for k = 1 : len 

		% get index of var_flag in the flags read
		j = get_val_index(flags, OPT_VAR_FLAGS{k});

		if isempty(j) 
			% use default expression
			expr = OPT_VAR_DEFAULTS{k};
		else
			% use specified argument expression
			expr = args{j};
		end

		% generate a string to initialize var_name
		cmd{k} = [OPT_VAR_NAMES{k} "=" expr ";"];
	end
end

%==================================================
% MAIN SCRIPT
%==================================================

% parse the command line arguments;
[OPTFLAGS OPTARGS OPTFILES] = get_opts(argv());

% make executable string commands for each argument
commands = make_init_commands(OPTFLAGS,OPTARGS);

% evaluate each command
for k = 1 : length(commands)
	eval(commands{k});
end
