# Introduction
`fastq-namefilter` is a simple utility for quickly filtering a FASTQ file
by sequence names, given a list of sequence names to keep.
only the part of the sequence name before the first space character is considered.

`fastq-numfilter` is a utility for quickly filtering a FASTQ file
by (0-indexed) read indices, given a list of sequence numbers to keep.

# Build
```sh
git clone git@github.com:yttria-aniseia/fastq-namefilter.git
cd fastq-namefilter
make
```

# Usage
```
fastq-namefilter namelist.txt [in.fastq]
```
fastq output to stdout.

```
fastq-numfilter numlist.txt <max_reads> [in.fastq]
```
fastq output to stdout.  `max_reads` should be the total number of input reads.

```
echo "@ERR1888452.1 0:N:  00
CCCATGTACTCTGCGTTGATACCACTGCTTCCCATGTACTCTGCGTTGATACCACTGCTTCCCATGTACTCTGCGTTGATACCACTGCTTCCCATGTACTCTGCGTTGATACCACTGCTTCCCAT
+
3>BBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGFEGGGDGGGGE1FDG>GDEDFGG0EFEGGC@F/EF>8FGG08FGFG@FC8FD8
@ERR1888452.2 0:N:  00
NGGAAGCAGTGGTATCAACGCAGAGTACATGGAAGCAGTGGTATCAACGCAGAGTACATGGAAGCAGTGGTATCAACGCAGAGTACATGGAAGCAGTGGTATCAACGCAGAGTACATGGAAGCAG
+
#3<>BGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBGGGGGGGFGGEGGFGGGGFGEGGG0FGGGCGDGGGGGGGGGGGGGG.
@ERR1888452.3 0:N:  00
NTACATGGAAGCAGTGGTATCAACGCAGAGTACATGGAAGCAGTGGTATCAACGCAGAGTACATGGAAGCAGTGGTATCAACGCAGAGTACATGGAAGCAGTGGTATCAACGCAGAGTACATGGA
+
#<=@BGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGEGGGGGGG>GBGGGGGG0@F@>>GGGE0FDCGGGD" > in.fq

printf "0\n2\n" > nums.txt

fastq-numfilter nums.txt 3 in.fq
