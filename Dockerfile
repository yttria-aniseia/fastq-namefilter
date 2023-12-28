FROM busybox

LABEL base_image="busybox"
LABEL version="2"
LABEL software="fastq-namefilter"
LABEL software.version="0.2.8"
LABEL about.summary="quickly filter fastq sequences by name"
LABEL about.home="https://github.com/yttria-aniseia/fastq-namefilter"

COPY bin/x86_64/fastq-namefilter /usr/local/bin/fastq-namefilter
CMD ["fastq-namefilter" "name.list" "in.fastq"]
