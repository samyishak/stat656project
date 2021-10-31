# STAT 656 Project

## Data Connections

### Setting up your authentication

Create a `config.ini` file in the root directory and paste the following into it, replacing with your own API keys. This config file should be listed in the `.gitignore` so your API keys will not be tracked by Git.

```
[auth]

GLASSNODE_API_KEY = <your key>
NASDAQ_API_KEY = <your key>
FRED_API_KEY = <your key>
```

### Data API documentation

Here's a list of data resources used in this project, where you can to go to sign up for API keys and read documentation. All resources are "basic" or "free" tier accounts.

* [Glassnode](https://docs.glassnode.com/basic-api/)
* [Quandl/NASDAQ](https://docs.data.nasdaq.com/)
* [FRED](https://fred.stlouisfed.org/docs/api/fred/)
