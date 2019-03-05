from string import Template
import toml

with open("config.toml") as config_file:
    config = toml.load(config_file)

files = config.settings.files

profiles = {"__default__": {}}

for key in config["profile"].keys():
    if isinstance(config[key], dict):
        profiles[key] = config[key]
    else:
        profiles["__default__"][key] = config[key]


