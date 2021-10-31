
# Load config file
# TODO try/catch here, warn user to create config file
config <- ini::read.ini("config.ini")

# Set environment variables
Sys.setenv(GLASSNODE_API_KEY=config$auth$GLASSNODE_API_KEY)
Sys.setenv(NASDAQ_API_KEY=config$auth$NASDAQ_API_KEY)
Sys.setenv(FRED_API_KEY=config$auth$FRED_API_KEY)

rm(config)
