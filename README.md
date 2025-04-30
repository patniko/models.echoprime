# EchoPrime: A Multi-Video View-Informed Vision-Language Model for Comprehensive Echocardiography Interpretation

This repository contains the official inference code for the following paper:

**EchoPrime: A Multi-Video View-Informed Vision-Language Model for Comprehensive Echocardiography Interpretation**  
*Milos Vukadinovic, Xiu Tang, Neal Yuan, Paul Cheng, Debiao Li, Susan Cheng, Bryan He\*, David Ouyang\**  
[Read the paper on arXiv](https://arxiv.org/abs/2410.09704), 
[See the demo](https://x.com/i/status/1846321746900558097)

![EchoPrime Demo](demo_image.png)

## How To Use

### Using Makefile (Easiest)
1) Clone the repository and navigate to the EchoPrime directory
2) Install Poetry (if not already installed)
   ```bash
   curl -sSL https://install.python-poetry.org | python3 -
   ```
3) Use the provided Makefile for a one-command setup and run:
   ```bash
   make setup-and-run
   ```
   This will:
   - Install all dependencies using Poetry
   - Download model data and embeddings
   - Start Jupyter notebook

   Then open EchoPrimeDemo.ipynb

   **Note:** You can also run individual commands:
   - `make setup` - Install dependencies with Poetry
   - `make download-data` - Download model data and embeddings
   - `make jupyter` - Start Jupyter notebook
   - `make help` - Show all available commands

### Using Poetry (Manual)
1) Clone the repository and navigate to the EchoPrime directory
2) Install Poetry (if not already installed)
   ```bash
   curl -sSL https://install.python-poetry.org | python3 -
   ```
3) Install dependencies with Poetry
   ```bash
   poetry install
   ```
   
   **Note:** This project is compatible with Python 3.8 to 3.12. Some dependencies may have issues with Python 3.13+.
   
   If you encounter an error about "No file/folder found for package echoprime", the project is configured with `package-mode = false` in pyproject.toml to address this.
4) Download model data 
    * `wget https://github.com/echonet/EchoPrime/releases/download/v1.0.0/model_data.zip`
    * `wget https://github.com/echonet/EchoPrime/releases/download/v1.0.0/candidate_embeddings_p1.pt`
    * `wget https://github.com/echonet/EchoPrime/releases/download/v1.0.0/candidate_embeddings_p2.pt`
    * `unzip model_data.zip`
    * `mv candidate_embeddings_p1.pt model_data/candidates_data/`
    * `mv candidate_embeddings_p2.pt model_data/candidates_data/`
5) Run the Jupyter notebook
   ```bash
   poetry run jupyter notebook
   ```
   Then open EchoPrimeDemo.ipynb

### Using requirements.txt (Legacy)
1) Clone the repository and navigate to the EchoPrime directory
2) Download model data 
    * `wget https://github.com/echonet/EchoPrime/releases/download/v1.0.0/model_data.zip`
    * `wget https://github.com/echonet/EchoPrime/releases/download/v1.0.0/candidate_embeddings_p1.pt`
    * `wget https://github.com/echonet/EchoPrime/releases/download/v1.0.0/candidate_embeddings_p2.pt`
    * `unzip model_data.zip`
    * `mv candidate_embeddings_p1.pt model_data/candidates_data/`
    * `mv candidate_embeddings_p2.pt model_data/candidates_data/`
3) Install dependencies from requirements.txt
    ```bash
    pip install -r requirements.txt
    ```
4) Follow EchoPrimeDemo.ipynb notebook

## Licence
This project is licensed under the terms of the MIT license.


## FAQ:

### After processing the images they appear green-tinted.
Make sure that you have the correct libraries installed. Use Poetry or requirements.txt to install the dependencies.


## How to run the code in docker?

```
docker build -t echo-prime .
```

```
docker run -d --name echoprime-container --gpus all echo-prime tail -f /dev/null
```
Then you can attach to this container and run the notebook located at 
`/workspace/EchoPrime/EchoPrimeDemo.ipynb`.
