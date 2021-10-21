This README file regards the Dryad distribution for:

Nowak, M.D., Haller, B.C., and Yoder, A.D. (2014). The founding of Mauritian endemic coffee trees by a synchronous long-distance dispersal event. Journal of Evolutionary Biology.

Corresponding author:

	Michael D. Nowak
	michaeldnowak@gmail.com

	Institute of Systematic Botany
	University of Zürich
	Zollikerstrasse 107
	8008 Zürich
	Switzerland

----------------------------------------------------------------------------

Three files are included in this distribution:

Filename				Description
------------------			--------------------
NHY2013_main_sims.csv			main simulation data (the basis of Fig. 3)
NHY2013_supp_sims.csv			supplemental simulation data (Suppl. Fig. S3)
README.txt				this file

----------------------------------------------------------------------------

  Each .csv (comma-separated values) file contains a number of rows (300,000 for the main simulations, 650,000 for the supplemental simulations) plus an initial header row.  Each row contains values for the following columns:

Name			Description
------------------	--------------------
gen			the generation (year) at the end of the simulation
N			the population size at the end of the simulation; if 0, extinction occurred
As			the number of S-alleles in the source population
Nf			the number of individuals in the founding population
b			the rate of population growth; more precisely, seedlings per adult tree
Af			the number of unique S-alleles in the founding population (year 0)
A			the number of unique S-alleles that survived to the end of the simulation
ybar			the mean age of the plants alive at the end of the simulation

  The main simulations vary As and Nf; the supplemental simulations vary b and Nf.  In both cases, the focal dependent variable is A, although gen, N, Af, and ybar are also dependent and might be of interest.

  See the paper for more information about these parameters and metrics.  Enjoy!