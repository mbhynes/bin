% 
% parse_opts.m
%
% Parse command-line arguments for octave scripts in
% the style of getopts.
%
% 
% Users must specify the following global (cell) variables:
%		global var_names; --- {'varname1' 'varname2' ... }
%		global var_flags; --- {'x' 'v' 'f' ...}
%		global var_defaults;  --- {'var1_default_val' ...}
%		global flag_expects_arg; {'x' 'v'} if these flags require args
%
% Then, in the main script, one may call parse_opts as a script:
% 	parse_opts
% The variables named in var_names will then be created 
% in the main function scope.
%
% Each variable is initialized to either the default value, or the supplied
% value from the commandline, which is evaluated using an eval() statement.
%
% Flags in flag_expects_arg are like "x:v:" in a getopts OPTSTRING. 
%
% Messages are written to stderr about all flags read.
%
% The function mat = read_mat_stdin() reads a matrix from the stdin.
%
% =================================================
% Author: Michael B Hynes, mbhynes@uwaterloo.ca
% License: GPL 3
% Creation Date: Wed 21 Jan 2015 06:25:47 PM EST
% Last Modified: Wed 21 Jan 2015 08:35:37 PM EST
% =================================================

global var_names;
global var_flags;
global var_defaults;
global flag_expects_arg;

%==================================================
% UTILITY FUNCTIONS 
%==================================================
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
function mat = read_mat_stdin()
	mat = dlmread(stdin,'');
end

%==================================================
% COMMANDLINE PARSING FUNCTIONS
%==================================================
function index = get_val_index(list,value)
	index = find(strcmp(list,value));
end

%==================================================
function cmd = make_init_commands(flags,args)

	global var_defaults;
	global var_names; 
	global var_flags;

	len = length(var_names);
	cmd = cell(1,len);

	% loop over all var_names and set defaults
	for k = 1 : len 

		% get index of var_flag in the flags read
		j = get_val_index(flags, var_flags{k});

		if isempty(j) 
			% use default expression
			expr = var_defaults{k};
		else
			% use specified argument expression
			expr = args{j};
		end

		% generate a string to initialize var_name
		cmd{k} = [var_names{k} "=" expr ";"];
	end
end

%==================================================
function bool = flag_has_arg(str)
	global flag_expects_arg;
	bool = ismember(str, flag_expects_arg);
end

%==================================================
function flag = strip_hyphen(param);
	flag = param(param != '-');
end

%==================================================
function bool = is_flag(str)
	bool = (str(1) == '-');
end

%==================================================
function bool = is_flag_expected(str)
	global var_flags; 
	bool = ~isempty(get_val_index(var_flags,str));
end

%==================================================
function [flags args files] = get_opts(list)
	len = length(list);
	k = 1;
	arg_num = 1;
	n_file = 1;

	[flags,args,files] = deal({});

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
					else
						log_info(["Read flag: " param " with argument: " args{arg_num}]);
					end

					k += 2;
				else
					args{arg_num} = "1";
					log_info(["Read non-argument flag: " param]);
					k++;
				end

			else
				log_warn(["Read unexpected flag: " param ]);
				k++;
			end

			arg_num++;

		else
			log_info(["Read non-flag argument: " param]);

			files{n_file} = list{k};
			n_file++;
			k++;
		end

	end
end 

%==================================================
% MAIN SCRIPT
%==================================================

% parse the command line arguments;
[flags args files] = get_opts(argv());

% make executable string commands for each argument
commands = make_init_commands(flags,args);

% evaluate each command
for k = 1 : length(commands)
	eval(commands{k});
end
