import std.stdio;
import std.string;
import std.file;

void main(string[] args)
{
	char[] programm;
	if (args.length == 1)
	{
		writeln("Usage:");
		writeln("\tbfd file.bfd");
		writeln("\tThats all there is to it");
		return;
	}
	uint[30_000] cells;
	long cptr = 0;
	long sptr = 0;
	bool skipping = false;
	long basebracket = 0;
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
					debug{writeln("Expression is false");}
					sptr = programm[sptr..$].indexOf(']') + sptr + 1;
					continue;
				}
				else
				{
					basebracket = sptr;
				}
				debug{writeln("Expression is True");}
			break;
			case ']':
				debug{writef("Jumping back to %s\n",basebracket);}
				sptr = basebracket;
				continue;
			case '.':
				debug{writef("Printing ASCII Value of %s \n",cells[cptr]);}
				write(cast(char) cells[cptr]);
			break;
			case ' ','	':
			break;
			default:
				debug{writef("ERROR: Unexpected %s! Aborting\n",programm[sptr]);}
			break;
		}
		sptr++;
	}
}
