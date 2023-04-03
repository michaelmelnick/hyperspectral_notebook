# Start from a core stack version
# Datascience notebook should include Python and R, and this is the current latest version
FROM jupyter/datascience-notebook:2023-03-27

# Pieces from the original Jupyter notebook
ARG NB_UID="1000"
ARG NB_GID="100"
ARG NB_USER="jovyan"
ENV HOME="/home/${NB_USER}"
 
# Root user for installations with apt
USER root

# Install from the requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" 

# Apt installations as one layer
RUN apt-get update && apt-get install software-properties-common -y && \
    export CPLUS_INCLUDE_PATH=/usr/include/gdal && export C_INCLUDE_PATH=/usr/include/gdal && \
    apt-get install -y libicu-dev zlib1g-dev libgdal-dev gdal-bin libproj-dev libgeos-dev libsqlite3-dev

# R installations

# Crucial dependency via mamba
RUN mamba install --yes -c conda-forge r-terra
# Direct R installations
RUN R -q -e 'install.packages("rgdal", repos = "http://cran.us.r-project.org")' && \
    R -q -e 'install.packages("hsdar", repos = "http://cran.us.r-project.org")'

# Reset variables from original notebook container
WORKDIR ${HOME}
USER ${NB_UID}
