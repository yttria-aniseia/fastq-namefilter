#include <fstream>
#include <iostream>
//#include <iterator>
#include <limits>
//#include <sstream>
#include <string>
#include <unordered_set>

int main(int argc, char* argv[]) {
	if (argc != 2 && argc != 3) {
		(void) fprintf(stderr, "usage: %s namelist.txt [fastq.fq]\n", argv[0]);
		exit(1);
	}
	const char* name_fname = argv[1];
	const char* fastq_fname = argc == 3 ? argv[2] : "-"; // omit = from stdin

	std::ifstream name_file(name_fname, std::ios::in);
	std::string line;
	
	std::unordered_set<std::string> names_ht;
	names_ht.reserve(419858);
	while (std::getline(name_file, line))
		names_ht.insert(line);
	name_file.close();

	std::ifstream fq_in(fastq_fname, std::ifstream::in);
	std::istream &fastq = fastq_fname[0] == '-' ? std::cin : fq_in;
	std::ios_base::sync_with_stdio(false);
	
	while (std::getline(fastq, line)) {
		if (line[0] != '@') {
			(void) fprintf(stderr, "unexpected @ in fastq\n");
			exit(1);
		}
		std::string::size_type delim_pos;
		delim_pos = line.find(' ', 2);
		if (names_ht.count(line.substr(1, delim_pos - 1)) > 0) {
			std::cout << line << "\n";
			std::getline(fastq, line); std::cout << line << "\n";
			std::getline(fastq, line); std::cout << line << "\n";
			std::getline(fastq, line); std::cout << line << "\n";
		} else {
			(void) fastq.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
			(void) fastq.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
			(void) fastq.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		}
	}
	exit(0);
}