Blockchain Unified Explorer
============

TLDR; Try this: [https://explorer.bitquery.io]()

Bitquery Explorer is built by [Bitquery.io](https://bitquery.io) using 
[Bitquery Widgets](https://github.com/bitquery/widgets) as user interface
components. The backend is supplied by the GraphQL interface.

## Features

- Supports multiple blockchains. The full list available on the Search button and counting
- Unified extensible user interface. You can use [Bitquery Widgets](https://github.com/bitquery/widgets) 
with arbitrary queries to data, thus making custom interfaces and explorers
- Analytical view of data. Shows many types of data aggregations, slices and relations, which 
typical blockchain explorers do not
- Free to use, extend, deploy and customize according to [MIT License](https://github.com/bitquery/explorer/blob/master/LICENSE)

## Installation

Explorer is a typical [Ruby on Rails](https://rubyonrails.org/) project.
There is a minimum server-side logic used, mostly this is a set of pages with 
javascript loading [Bitquery Widgets](https://github.com/bitquery/widgets).


Requirements are:

- Ruby v.2.6.3
- Rails v.6.0.1

Refer to the [Rails Installation Guide](https://guides.rubyonrails.org/) how to setup environment and run the project.

No database or backend is required, this is pure set of front-end UI.


## Deployment

For server deployment we use [Capistrano](https://github.com/capistrano/capistrano).

To pre-configure the server, the following may be needed:

####  Ruby installation

```
sudo apt-get install ruby-all-dev git gcc zlib1g-dev make mysql-client default-libmysqlclient-dev g++ puma libssl1.0-dev


see https://github.com/postmodern/ruby-install#readme

wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
tar -xzvf ruby-install-0.7.0.tar.gz
cd ruby-install-0.7.0/

sudo make install
sudo ruby-install --system ruby 2.6.3
sudo gem install bundler
```

re-login:
```
> ruby --version
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]
```

####  Capistrano installation

```
sudo adduser deploy
sudo passwd -l deploy

sudo mkdir /var/www
sudo mkdir /var/www/explorer
sudo chown -R deploy:deploy /var/www/explorer
```

### Nodejs installation

```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn
```

### Build widgets

```
yarn upgrade widgets
yarn install --check-files
```

### Run capistrano

Setup local name bitquery in your /etc/hosts file before running:

```
cap production deploy
```

### Puma run as service

Look [scripts/explorer.service](explorer.service) for details

Replace `<PUT YOUR SECRET HERE>` with the secret for service.

```
sudo vim /etc/systemd/system/explorer.service
sudo systemctl enable explorer
```

## License
>You can check out the full license [here](https://github.com/bitquery/explorer/blob/master/LICENSE)

This project is licensed under the terms of the **MIT** license.

You are encouraged to build your ownb explorers, data analytical web sites, embed part of this project on your web site
and more!