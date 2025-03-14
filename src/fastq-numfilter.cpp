#include <fstream>
#include <iostream>
#include <limits>
#include <string>
#include <cstdint>

int main(int argc, char* argv[]) {
	if (argc != 3 && argc != 4) {
		(void) fprintf(stderr, "usage: %s numlist.txt [readmax(400000000)] [fastq.fq]\n", argv[0]);
		exit(1);
	}
	const char* nums_fname = argv[1];
	const long  read_max = argc >= 3 ? std::stol(argv[2]) : 400000000;
	const char* fastq_fname = argc == 4 ? argv[3] : "-"; // omit = from stdin

	std::ifstream nums_file(nums_fname, std::ios::in);
	long n;

	uint32_t num_set[(read_max >> 5) + 1]{0};
	while (nums_file >> n)
		num_set[n >> 5] |= 1 << (n & (32-1));
	nums_file.close();
	
	std::ifstream fq_in(fastq_fname, std::ifstream::in);
	std::istream &fastq = fastq_fname[0] == '-' ? std::cin : fq_in;
	std::ios_base::sync_with_stdio(false);

	long i = 0;
	std::string line = "";
	while (std::getline(fastq, line)) {
		if (line[0] != '@') {
			(void) fprintf(stderr, "expected @ in fastq\n");
			exit(1);
		}
		if ( i > read_max || !(num_set[i >> 5] & (1 << (i & (32-1)))) ) {
			std::cout << line << "\n";
			std::getline(fastq, line); std::cout << line << "\n";
			std::getline(fastq, line); std::cout << line << "\n";
			std::getline(fastq, line); std::cout << line << "\n";
		} else {
			(void) fastq.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
			(void) fastq.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
			(void) fastq.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		}
		++i;
	}
	exit(0);
}
