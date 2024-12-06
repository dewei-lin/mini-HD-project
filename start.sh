#!/bin/bash
docker build -t hd .
docker run   -v $(pwd):/home/rstudio/mini-hd-project\
  	     -p 8787:8787 -p 3838:3838\
	       -e PASSWORD=611isfun\
         -it hd