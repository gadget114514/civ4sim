
xlsx2csv:
	g++ -std=c++14 xlsx2csv.cpp -o xlsx2csv -I ./xlnt/include ./xlnt/build/source/libxlnt.a

fetch:
	git clone https://github.com/tfussell/xlnt.git
	mkdir xlnt/build
	cd xlnt/build
	echo "edit CMakefile.txt"

xx:
	cmake ..
	make
