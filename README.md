# Huntington’s Disease Mini Project

##  How to use this repository?

choose your desired folder and clone the project:

```bash
cd /path/to/your/desired/folder
git clone https://github.com/dewei-lin/mini-HD-project.git
```

Then, you would only need to go to the folder that you store the project and enter the following code 

```bash
cd /path/to/your/desired/folder/mini-HD-project
bash start.sh
```

This will help build up the docker container for you. You then visit http://localhost:8787 via a browser on your machine to access the machine and development environment. The username and the password is: rstudio; 611isfun

To clean the existing outputs:

```bash
make clean
```

To generate the reports with Makefile:

```bash
make report.html
```

To run the Shiny app:

```bash
make run-shiny
```

And visit in your local computer at http://localhost:3838/ . Or directly visit the R shiny app in web browser without running the script: https://dewei-lin.shinyapps.io/survival_compare/ 


