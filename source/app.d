import std.stdio;
import std.string; 
void main(string[] args)
{
	char[] programm;
	if (args.length == 1)
	{
		version (Unittest)
		{
			writeln("Default output due to Unittest");
		}
		writeln("Usage:");
		writeln("\tbfd file.bfd");
		writeln("\tThats all there is to it");
		return;
	}
	auto file = File(args[1],"r");
	string rawfile;
	while (!file.eof())
	{
		rawfile ~= chomp(file.readln());
	}
	programm = rawfile.dup;
	uint[30_000] cells;
	parseBF(programm,cells);
}

void parseBF(char[] programm,ref uint[30000] cells)
{
	programm = chomp(programm).dup;
	long cptr = 0;
	long sptr = 0;
	bool skipping = false;
	long[] basebrackets;
	while (sptr < programm.length)
	{
		debug{writef("Parsing: %s ",programm[sptr]);}
		switch (programm[sptr])
		{
			case '+':
				cells[cptr]++;
				debug{writef("Raising value of %s to %s\n",cptr,cells[cptr]);}
			break;
			case '-':
				cells[cptr]--;
				debug{writef("Lowering value of %s to %s\n",cptr,cells[cptr]);}
			break;
			case '>':
				cptr++;
				debug{writef("Changin cell pointer to %s\n",cptr);}
			break;
			case '<':
				cptr--;
				debug{writef("Changin cell pointer to %s\n",cptr);}
			break;
			case '[':
				if (cells[cptr] == 0)
				{
					auto tptr = sptr+1;
					auto nestlvl = 1;
					while (nestlvl != 0)
					{
						if (programm[tptr] == '[')
						{
							nestlvl++;
							debug{writefln("Current Nestlevel %s",nestlvl);}
						}
						else if (programm[tptr] == ']')
						{
							nestlvl--;
							debug{writefln("Current Nestlevel %s",nestlvl);}
						}
						tptr++;
					}
					debug
					{
						debug{writefln("Expression is false, jumping to %s",tptr);}
						debug{writeln(programm);}
						for (int i = 0; i < tptr; i++)
						{
							debug{write(" ");}
						}
						debug{writeln("^");}
					}
					sptr = tptr;
					continue;
				}
				else
				{
					basebrackets ~= sptr;
					debug{writeln(basebrackets);}
				}
				debug{writeln("Expression is True");}
			break;
			case ']':
				debug{writeln("brackets ",basebrackets);}
				debug{writef("Jumping back to %s\n",basebrackets[$-1]);}
				sptr = basebrackets[$-1];
				if (basebrackets.length == 1)
				{
					debug{writeln("clearing basebrackets");}
					long[] empty;
					basebrackets = empty;
				}
				else
				{
					basebrackets = basebrackets[0..$-1];
				}
				continue;
			case '.':
				debug{writef("Printing ASCII Value of %s \n",cells[cptr]);}
				write(cast(char) cells[cptr]);
			break;
			case ',':
				debug{writef("Reading from STDIN");}
				char c;
				readf(" %s",&c);
				cells[cptr] = cast(int) c;
			break;
			case ' ','	':
			break;
			default:
				debug{writef("ERROR: Unexpected %s! Aborting\n",programm[sptr]);}
			break;
		}
		sptr++;
		debug{readln();}
	}
	writeln();
}

unittest
{
	uint[30_000] cells;
	parseBF("++++++[>++++++++++<-]>+++++.".dup,cells);
}
